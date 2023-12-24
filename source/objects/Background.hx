package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;

class Background extends FlxGroup
{
    public var sky:FlxBackdrop;
    public var ground:FlxBackdrop;
    public var posX:Float = 0;

    public var backSprites:FlxTypedGroup<FlxSprite>;

    override public function new()
    {
        super();

        sky = new FlxBackdrop(Paths.imageFile('background/Sky'), X, 0, 0);
        sky.setGraphicSize(Std.int(sky.width * 2));
        sky.updateHitbox();
        sky.scrollFactor.set(0.45, 0.45);
        add(sky);

        backSprites = new FlxTypedGroup<FlxSprite>();
        add(backSprites);

        ground = new FlxBackdrop(Paths.imageFile('background/Ground'), X, 0, 0);
        ground.setGraphicSize(Std.int(ground.width * 2));
        ground.updateHitbox();
        ground.scrollFactor.set(0.8, 0.8);
        add(ground);

        sky.y = FlxG.height - sky.height;
        ground.y = FlxG.height - ground.height;
    }

    public function setPosX(x:Float)
    {
        posX = x;

        sky.x = posX;
        ground.x = posX;

        sky.x *= sky.scrollFactor.x;
        ground.x *= ground.scrollFactor.x;
    }

    public function scroll(scrollX:Float)
    {
        setPosX(posX + scrollX);
    }
}