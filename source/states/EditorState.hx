package states;

import backend.FlappySettings;
import backend.FlappyState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import objects.Background;
import objects.CameraObject;

class EditorState extends FlappyState
{
    var bg:Background;
    var camFollow:CameraObject;

    var grpObjects:FlxTypedGroup<FlxSprite>;
    
    override function create()
    {
        bg = new Background();
        add(bg);

        grpObjects = new FlxTypedGroup<FlxSprite>();
		bg.backObjects.add(grpObjects);

        camFollow = new CameraObject();
        camFollow.screenCenter();
		camFollow.x = MenuState.camPosX;
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

        super.update(elapsed);
    }
}