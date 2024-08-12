package objects;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class LineObject extends FlxSprite
{
    override public function new(x:Float)
    {
        super(x, 0);
        makeGraphic(2, FlxG.height + 50, FlxColor.WHITE);
        screenCenter(Y);
    }

    override function update(elapsed:Float)
    {
        visible = isOnScreen();
        super.update(elapsed);
    }
}