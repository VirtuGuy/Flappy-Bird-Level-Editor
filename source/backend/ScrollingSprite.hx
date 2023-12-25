package backend;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

class ScrollingSprite extends FlxSprite
{
    public var speed(default, null):FlxPoint;

    override public function new(x:Float = 0, y:Float = 0)
    {
        speed = new FlxPoint();

        super(x, y);
    }

    override public function update(elapsed:Float)
    {
        x += speed.x * scrollFactor.x;
        y += speed.y * scrollFactor.y;

        super.update(elapsed);
    }
}