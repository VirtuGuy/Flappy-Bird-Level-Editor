package states;

import backend.FlappySettings;
import backend.FlappyState;
import backend.FlappyTools;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import haxe.Json;
import objects.Background;
import objects.CameraObject;
import objects.Object;

using StringTools;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

typedef LevelData = {
    scrollSpeed:Float,
    objects:Array<LevelObjectData>
}

typedef LevelObjectData = {
    name:String,
    x:Float,
    y:Float,
    flipped:Bool
}

class EditorState extends FlappyState
{
    var bg:Background;
    var camFollow:CameraObject;
    var hudCamera:FlxCamera;

    var grpObjects:FlxTypedGroup<Object>;
    var tabMenu:FlxUITabMenu;

    // Other things
    var tabs:Array<{name:String, label:String}> = [
        {name: 'editor', label: 'Editor'},
        {name: 'level', label: 'Level'},
        {name: 'object', label: 'Object'}
    ];

    var inputTexts:Array<FlxUIInputText> = [];
    var numericSteppers:Array<FlxUINumericStepper> = [];

    var editObject:Object;
    var editCursor:FlxSprite;
    var gridSize:Int = FlappySettings.editorGridSize;

    var selectedObject:Object = null;

    // Editor properties
    var levelData:LevelData = {
        scrollSpeed: 4,
        objects: []
    }

    var levelName:String = 'example-level';
    var loadLevelName:String = '';
    var saveToDefault:Bool = false;
    
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
        // Positioning
        editCursor.x = FlxG.mouse.x;
        editCursor.y = FlxG.mouse.y;
        editObject.x = Math.floor(editCursor.x / gridSize) * gridSize;
        editObject.y = Math.floor(editCursor.y / gridSize) * gridSize;

        // Focus check
        var canDoStuff:Bool = true;

        for (input in inputTexts)
        {
            if (input.hasFocus)
            {
                canDoStuff = false;
                break;
            }
        }

        for (stepper in numericSteppers)
        {
            @:privateAccess
            var input:FlxUIInputText = cast stepper.text_field;

            if (input.hasFocus)
            {
                canDoStuff = false;
                break;
            }
        }

        if (!canDoStuff)
        {  
            keys.toggleVolumeKeys(false);
        }
        else
        {
            keys.toggleVolumeKeys(true);
            
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
            if (keys.FLIP)
            {
                editObject.flipped = !editObject.flipped;
            }

            // Keys
            var selectKey:Bool = (FlxG.mouse.justPressed && FlxG.keys.pressed.CONTROL);
            var addKey:Bool = FlxG.mouse.justPressed;
            var deleteKey:Bool = FlxG.mouse.justPressedRight;

            if ((selectKey || addKey || deleteKey) && !FlxG.mouse.overlaps(tabMenu, hudCamera))
            {
                if (deleteKey || selectKey)
                {
                    for (object in grpObjects.members)
                    {
                        if (FlxCollision.pixelPerfectCheck(editCursor, object, 0))
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
                    placeObject(editObject.x, editObject.y, editObject.objectName, editObject.flipped);
            }
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
            object.flipped = item.flipped;
            grpObjects.add(object);
        }
    }

    function placeObject(x:Float = 0, y:Float = 0, name:String, flipped:Bool)
    {
        var canPlace:Bool = true;

        for (item in levelData.objects)
        {
            if (item.x == x && item.y == y && item.name == name && item.flipped == flipped)
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
                flipped: flipped
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

        var saveButton:FlxButton = new FlxButton(15, 10, 'Save Level', function(){
            saveLevel();
        });

        var loadButton:FlxButton = new FlxButton(15, 35, 'Load Level', function(){
            loadLevel(loadLevelName);
        });
        
        var loadLevelNameInput:FlxUIInputText = new FlxUIInputText(102, 38, 100, loadLevelName);
        loadLevelNameInput.name = 'loadLevelInput';
        inputTexts.push(loadLevelNameInput);

        var loadLevelNameText:FlxText = new FlxText(109, 23, 0, 'Load Level Name');

        var saveToDefaultCheckbox:FlxUICheckBox = new FlxUICheckBox(15, 60, null, null, 'Save to Default (DEBUG)');
        saveToDefaultCheckbox.name = 'saveToDefaultCheckbox';
        saveToDefaultCheckbox.callback = function(){
            saveToDefault = saveToDefaultCheckbox.checked;
        }

        group.add(saveButton);
        group.add(loadButton);
        group.add(loadLevelNameInput);
        group.add(loadLevelNameText);
        #if debug
        group.add(saveToDefaultCheckbox);
        #end

        tabMenu.addGroup(group);
    }

    private function addLevelTab()
    {
        var group:FlxUI = new FlxUI(null, tabMenu);
        group.name = 'level';

        var levelNameInput:FlxUIInputText = new FlxUIInputText(15, 13, 100, levelName);
        levelNameInput.name = 'levelNameInput';
        inputTexts.push(levelNameInput);

        var levelNameText:FlxText = new FlxText(120, 14, 0, 'Level Name');

        var scrollSpeedStepper:FlxUINumericStepper = new FlxUINumericStepper(15, 35, 1, levelData.scrollSpeed, 1);
        scrollSpeedStepper.name = 'scrollSpeedStepper';
        numericSteppers.push(scrollSpeedStepper);

        var scrollSpeedText:FlxText = new FlxText(77, 36, 0, 'Scroll Speed');

        group.add(levelNameInput);
        group.add(levelNameText);
        group.add(scrollSpeedStepper);
        group.add(scrollSpeedText);
        
        tabMenu.addGroup(group);
    }

    private function addObjectTab()
    {
        var group:FlxUI = new FlxUI(null, tabMenu);
        group.name = 'object';
        
        tabMenu.addGroup(group);
    }

    override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
    {
        if (id == FlxUIInputText.CHANGE_EVENT && (sender is FlxUIInputText))
        {
            var input:FlxUIInputText = cast sender;
            var name:String = input.name;

            switch (name)
            {
                case 'loadLevelInput':
                    loadLevelName = input.text;
                case 'levelName':
                    levelName = input.text;
            }
        }
        else if (id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper))
        {
            var stepper:FlxUINumericStepper = cast sender;
            var name:String = stepper.name;

            switch (name)
            {
                case 'scrollSpeedStepper':
                    levelData.scrollSpeed = stepper.value;
            }
        }
    }

    override function destroy()
    {
        super.destroy();

        FlxG.cameras.remove(hudCamera, true);
        FlxG.camera.zoom = 1;
    }

    // Save and load stuff
    private function saveLevel()
    {
        var jsonString:String = Json.stringify(levelData, '\t');

        var path:String = Paths.folder('levels/custom');
        if (saveToDefault)
            path = Paths.folder('levels/default');

        var fileFolderPath:String = '$path/$levelName';

        #if sys
        if (!Paths.fileExists(path))
            FileSystem.createDirectory(path);
        if (!Paths.fileExists(fileFolderPath))
            FileSystem.createDirectory(fileFolderPath);

        File.saveContent('$fileFolderPath/level.json', jsonString);
        #end
    }

    private function loadLevel(levelName:String)
    {
        var path:String = Paths.folder('levels/custom');
        var levelsPath:String = Paths.folder('levels/default');

        var filePath:String = '$path/$levelName/level.json';
        var fileLevelsPath:String = '$levelsPath/$levelName/level.json';

        #if sys
        var foundPath:String = null;

        if (Paths.fileExists(filePath))
            foundPath = filePath;

        if (Paths.fileExists(fileLevelsPath))
            foundPath = fileLevelsPath;

        if (foundPath != null)
        {
            var content:String = Paths.getText(foundPath);
            levelData = Json.parse(content);
        }
        #end

        updateObjects();
    }
}