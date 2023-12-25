package objects;

import backend.FlappySettings;
import flixel.FlxSprite;

class Pipe extends FlxSprite
{
    override public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        velocity.x = -FlappySettings.scrollSpeed;

        loadGraphic(Paths.imageFile(Paths.textures.get('pipe')));
        setGraphicSize(Std.int(width * 2));
        scrollFactor.set(1, 1);
        updateHitbox();
    }

    override function update(elapsed:Float)
    {
        if (Math.abs(angle) > 90)
            flipX = true;
        else
            flipX = false;

        super.update(elapsed);
    }
}