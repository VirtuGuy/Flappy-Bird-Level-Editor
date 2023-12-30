package states;

import backend.FlappySettings;
import backend.FlappyState;
import backend.FlappyTools;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
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
    var dropdowns:Array<FlxUIDropDownMenu> = [];

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

    var objectNames:Array<String> = [];
    
    override function create()
    {
        PlayState.editorMode = true;

        hudCamera = new FlxCamera();
        hudCamera.bgColor.alpha = 0;
        FlxG.cameras.add(hudCamera, false);

        var objectsPath:String = Paths.textFile('data', 'objectsList');
        if (Paths.fileExists(objectsPath))
        {
            var content:String = Paths.getText(objectsPath);
            var texts:Array<String> = content.split('\n');
            for (text in texts)
            {
                objectNames.push(text.trim());
            }
        }

        bg = new Background();
        add(bg);

        grpObjects = new FlxTypedGroup<Object>();
		bg.backObjects.add(grpObjects);

        editCursor = new FlxSprite();
        editCursor.makeGraphic(1, 1, FlxColor.fromRGB(255, 255, 255, 0));
        add(editCursor);

        editObject = new Object(0, 0, 'pipe', true);
        editObject.alpha = 0.5;
        @:privateAccess
        editObject._lastAlpha = editObject.alpha;
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

        for (dropdown in dropdowns)
        {
            if (dropdown.hasFocus)
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
                if (editObject.canBeFlipped)
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
            var object:Object = new Object(item.x, item.y, item.name, true);
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

        if (object != null)
            object.selected = select;
        
        if (select)
        {
            selectedObject = object;
            updateObjectTab();
            
            tabMenu.selected_tab = 2;
        }
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

        var objectNameItems = FlxUIDropDownMenu.makeStrIdLabelArray(objectNames);
        var objectNameDropdown:FlxUIDropDownMenu = new FlxUIDropDownMenu(15, 60, objectNameItems, function(objectName:String){
            editObject.objectName = objectName;
        });
        objectNameDropdown.selectedLabel = editObject.objectName;
        dropdowns.push(objectNameDropdown);

        var objectNameText:FlxText = new FlxText(140, 64, 0, 'Object Name');

        var saveToDefaultCheckbox:FlxUICheckBox = new FlxUICheckBox(15, 85, null, null, 'Save to Default (DEBUG)');
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
        group.add(objectNameDropdown);
        group.add(objectNameText);

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

    var objectPosXStepper:FlxUINumericStepper;
    var objectPosYStepper:FlxUINumericStepper;
    var objectNameDropdown:FlxUIDropDownMenu;
    var objectFlippedCheckbox:FlxUICheckBox;

    private function addObjectTab()
    {
        var group:FlxUI = new FlxUI(null, tabMenu);
        group.name = 'object';

        objectPosXStepper  = new FlxUINumericStepper(15, 10, 5, 0, 0, 999999);
        objectPosXStepper.name = 'objectPosXStepper';
        numericSteppers.push(objectPosXStepper);

        objectPosYStepper = new FlxUINumericStepper(15, 25, 5, 0, 0, 999999);
        objectPosYStepper.name = 'objectPosYStepper';
        numericSteppers.push(objectPosYStepper);

        var objectPosText:FlxText = new FlxText(77, 17.5, 0, 'Position X/Y');

        var objectNameItems = FlxUIDropDownMenu.makeStrIdLabelArray(objectNames);
        objectNameDropdown = new FlxUIDropDownMenu(15, 45, objectNameItems, function(objectName:String){
            if (selectedObject != null)
            {
                for (item in levelData.objects)
                {
                    if (item.x == selectedObject.x && item.y == selectedObject.y && item.flipped == selectedObject.flipped
                        && item.name == selectedObject.objectName)
                    {
                        item.name = objectName;
                        selectedObject.objectName = objectName;
                        updateObjectTab();
                    }
                }
            }
        });
        objectNameDropdown.selectedLabel = '';
        dropdowns.push(objectNameDropdown);

        var objectNameText:FlxText = new FlxText(140, 49, 0, 'Object Name');

        objectFlippedCheckbox = new FlxUICheckBox(15, 70, null, null, 'Flipped?');
        objectFlippedCheckbox.callback = function(){
            if (selectedObject != null)
                selectedObject.flipped = objectFlippedCheckbox.checked;
        }

        group.add(objectPosXStepper);
        group.add(objectPosYStepper);
        group.add(objectPosText);
        group.add(objectFlippedCheckbox);
        group.add(objectNameDropdown);
        group.add(objectNameText);
        
        tabMenu.addGroup(group);
    }

    private function updateObjectTab()
    {
        if (selectedObject != null)
        {
            objectPosXStepper.value = selectedObject.x;
            objectPosYStepper.value = selectedObject.y;
            objectNameDropdown.selectedLabel = selectedObject.objectName;
            objectFlippedCheckbox.checked = selectedObject.flipped;

            if (selectedObject.canBeFlipped)
                objectFlippedCheckbox.visible = true;
            else
                objectFlippedCheckbox.visible = false;
        }
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
                case 'objectPosXStepper' | 'objectPosYStepper':
                    if (selectedObject != null)
                    {
                        for (item in levelData.objects)
                        {
                            if (item.x == selectedObject.x && item.y == selectedObject.y && item.flipped == selectedObject.flipped
                                && item.name == selectedObject.objectName)
                            {
                                if (name == 'objectPosXStepper')
                                {
                                    item.x = stepper.value;
                                    selectedObject.x = item.x;
                                }
                                else
                                {
                                    item.y = stepper.value;
                                    selectedObject.y = item.y;
                                }
                            }
                        }
                    }
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

        var path:String = 'custom';
        if (saveToDefault)
            path = 'default';

        #if sys
        if (!Paths.fileExists(Paths.levelsFolder(path, levelName)))
            FileSystem.createDirectory(Paths.levelsFolder(path, levelName));

        File.saveContent(Paths.levelFile(path, levelName), jsonString);
        #end
    }

    private function loadLevel(levelName:String)
    {
        #if sys
        var json:LevelData = FlappyTools.loadJSON(Paths.levelFile('custom', levelName));
        if (json != null)
            levelData = json;

        var json:LevelData = FlappyTools.loadJSON(Paths.levelFile('default', levelName));
        if (json != null)
            levelData = json;
        #end

        setObjectSelection(selectedObject, false);
        updateObjects();
    }
}