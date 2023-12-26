package objects;

import flixel.FlxG;
import flixel.FlxObject;

class CameraObject extends FlxObject
{
    override public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y, 50, 50);

        FlxG.camera.follow(this, LOCKON, 1);
    }
}