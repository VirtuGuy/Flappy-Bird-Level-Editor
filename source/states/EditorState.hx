package states;

import backend.FlappySettings;
import backend.FlappyState;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUITabMenu;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import objects.Background;
import objects.CameraObject;
import objects.Object;

typedef LevelData = {
    name:String,
    scrollSpeed:Float,
    objects:Array<LevelObjectData>
}

typedef LevelObjectData = {
    name:String,
    x:Float,
    y:Float,
    angle:Float
}

class EditorState extends FlappyState
{
    var bg:Background;
    var camFollow:CameraObject;
    var hudCamera:FlxCamera;

    var grpObjects:FlxTypedGroup<Object>;
    var tabMenu:FlxUITabMenu;

    var tabs:Array<{name:String, label:String}> = [
        {name: 'editor', label: 'Editor'},
        {name: 'level', label: 'Level'},
        {name: 'object', label: 'Object'}
    ];

    var levelData:LevelData = {
        name: 'Example Level',
        scrollSpeed: 4,
        objects: []
    }

    var placeholderObjData:LevelObjectData = {
        name: 'Pipe',
        x: 0,
        y: 0,
        angle: 0
    }

    var editObject:Object;
    var editCursor:FlxSprite;
    var gridSize:Int = FlappySettings.editorGridSize;

    var selectedObject:Object = null;
    
    override function create()
    {
        PlayState.editorMode = true;

        hudCamera = new FlxCamera();
        hudCamera.bgColor.alpha = 0;
        FlxG.cameras.add(hudCamera, false);

        bg = new Background();
        add(bg);

        grpObjects = new FlxTypedGroup<Object>();
		bg.backObjects.add(grpObjects);

        editCursor = new FlxSprite();
        editCursor.makeGraphic(1, 1, FlxColor.fromRGB(255, 255, 255, 0));
        add(editCursor);

        editObject = new Object(0, 0, 'pipe');
        editObject.alpha = 0.5;
        add(editObject);

        tabMenu = new FlxUITabMenu(null, tabs, true);
        tabMenu.resize(250, 250);
        tabMenu.setPosition(FlxG.width - tabMenu.width, FlxG.height - tabMenu.height);
        tabMenu.scrollFactor.set();
        add(tabMenu);

        addEditorTab();
        addLevelTab();
        addObjectTab();

        camFollow = new CameraObject();
        camFollow.screenCenter();
		camFollow.y -= 12;

        tabMenu.cameras = [hudCamera];

        super.create();
    }

    override function update(elapsed:Float)
    {
        // Move
        if (keys.LEFT || keys.RIGHT)
        {
            var posAdd:Int = keys.LEFT ? -1 : 1;
            var speed:Float = FlappySettings.editorScrollSpeed;

            if (FlxG.keys.pressed.SHIFT)
                speed *= 1.5;

            camFollow.x += posAdd * speed;
        }

        // Back
        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlappyState.switchState(new MenuState());
        }

        // Scroll
        if (FlxG.mouse.wheel != 0)
        {
            camFollow.x += -(FlxG.mouse.wheel * FlappySettings.editorScrollSpeed * 2 * 10);
        }

        // Rotation
        if (keys.ROTATE)
        {
            var angle:Float = 45;
            if (FlxG.keys.pressed.SHIFT)
                angle = 15;

            editObject.setRotation(editObject.angle + angle);
        }

        // Positioning
        editCursor.x = FlxG.mouse.x;
        editCursor.y = FlxG.mouse.y;
        editObject.x = Math.floor(editCursor.x / gridSize) * gridSize;
        editObject.y = Math.floor(editCursor.y / gridSize) * gridSize;

        // Keys
        var selectKey:Bool = (FlxG.mouse.justPressed && FlxG.keys.pressed.CONTROL);
        var addKey:Bool = FlxG.mouse.justPressed;
        var deleteKey:Bool = FlxG.mouse.justPressedRight;

        if (selectKey || addKey || deleteKey)
        {
            if (deleteKey || selectKey)
            {
                for (object in grpObjects.members)
                {
                    if (FlxCollision.pixelPerfectCheck(object, editCursor, 0))
                    {
                        if (selectKey)
                            setObjectSelection(object);
                        else
                            removeObject(object.x, object.y, object.objectName);
                        break;
                    }
                }
            }
            else
                placeObject(editObject.x, editObject.y, editObject.objectName, editObject.angle);
        }

        super.update(elapsed);

        if (camFollow.x < FlxG.width / 2)
            camFollow.x = FlxG.width / 2;
    }

    // Object stuff
    function updateObjects()
    {
        while (grpObjects.length > 0)
        {
            grpObjects.remove(grpObjects.members[0], true);
        }

        for (item in levelData.objects)
        {
            var object:Object = new Object(item.x, item.y, item.name);
            object.editorObject = true;
            object.setRotation(item.angle);
            grpObjects.add(object);
        }
    }

    function placeObject(x:Float = 0, y:Float = 0, name:String, angle:Float = 0)
    {
        var canPlace:Bool = true;

        for (item in levelData.objects)
        {
            if (item.x == x && item.y == y && item.name == name && item.angle == angle)
            {
                canPlace = false;
                break;
            }
        }

        if (canPlace)
        {
            if (selectedObject != null)
                setObjectSelection(selectedObject, false);

            levelData.objects.push({
                name: name,
                x: x,
                y: y,
                angle: angle
            });
        }

        updateObjects();
    }

    function removeObject(x:Float = 0, y:Float = 0, name:String)
    {
        for (item in levelData.objects)
        {
            if (item.x == x && item.y == y && item.name == name)
            {
                if (selectedObject != null)
                    setObjectSelection(selectedObject, false);

                levelData.objects.remove(item);
                break;
            }
        }

        updateObjects();
    }

    function setObjectSelection(object:Object, select:Bool = true)
    {
        for (obj in grpObjects.members)
        {
            if (obj.selected)
            {
                obj.selected = false;
                break;
            }
        }

        object.selected = select;
        if (select)
            selectedObject = object;
        else
            selectedObject = null;
    }

    // Editor tabs
    private function addEditorTab()
    {
        var group:FlxUI = new FlxUI(null, tabMenu);
        group.name = 'editor';

        tabMenu.addGroup(group);
    }

    private function addLevelTab()
    {
        var group:FlxUI = new FlxUI(null, tabMenu);
        group.name = 'level';
        
        tabMenu.addGroup(group);
    }

    private function addObjectTab()
    {
        var group:FlxUI = new FlxUI(null, tabMenu);
        group.name = 'object';
        
        tabMenu.addGroup(group);
    }

    override function destroy()
    {
        super.destroy();

        FlxG.cameras.remove(hudCamera, true);
        FlxG.camera.zoom = 1;
    }
}