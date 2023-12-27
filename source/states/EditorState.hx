package states;

import backend.FlappySettings;
import backend.FlappyState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUITabMenu;
import flixel.group.FlxGroup.FlxTypedGroup;
import objects.Background;
import objects.CameraObject;

class EditorState extends FlappyState
{
    var bg:Background;
    var camFollow:CameraObject;

    var grpObjects:FlxTypedGroup<FlxSprite>;
    var tabMenu:FlxUITabMenu;

    var tabs:Array<{name:String, label:String}> = [
        {name: 'editor', label: 'Editor'},
        {name: 'level', label: 'Level'}
    ];
    
    override function create()
    {
        PlayState.editorMode = true;

        bg = new Background();
        add(bg);

        grpObjects = new FlxTypedGroup<FlxSprite>();
		bg.backObjects.add(grpObjects);

        tabMenu = new FlxUITabMenu(null, tabs, true);
        tabMenu.resize(250, 250);
        tabMenu.setPosition(FlxG.width - tabMenu.width, 0);
        tabMenu.scrollFactor.set();
        add(tabMenu);

        addEditorTab();
        addLevelTab();

        camFollow = new CameraObject();
        camFollow.screenCenter();
		camFollow.y -= 12;

        super.create();
    }

    override function update(elapsed:Float)
    {
        if (keys.LEFT || keys.RIGHT)
        {
            var posAdd:Int = keys.LEFT ? -1 : 1;
            var speed:Float = FlappySettings.editorScrollSpeed;

            if (FlxG.keys.pressed.SHIFT)
                speed *= 1.5;

            camFollow.x += posAdd * speed;
        }

        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlappyState.switchState(new MenuState());
        }

        if (FlxG.mouse.wheel != 0)
        {
            camFollow.x += -(FlxG.mouse.wheel * FlappySettings.editorScrollSpeed * 2 * 10);
        }

        super.update(elapsed);

        if (camFollow.x < FlxG.width / 2)
            camFollow.x = FlxG.width / 2;
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
}