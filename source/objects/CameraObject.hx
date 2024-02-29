package objects;

import flixel.FlxG;
import flixel.FlxObject;
import states.MenuState;

class CameraObject extends FlxObject
{
    override public function new(posToMenuPos:Bool = true)
    {
        super(0, 0, 50, 50);

        // Positions the camera
        screenCenter();
        if (posToMenuPos)
            x = MenuState.camPosX;
        y -= 12;

        FlxG.camera.follow(this, LOCKON, 1);
    }
}