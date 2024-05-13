package objects;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;

class Background extends FlxGroup
{
    public var sky:FlxBackdrop;
    public var ground:FlxBackdrop;
    public var backObjects:FlxTypedGroup<FlxBasic>;

    override public function new()
    {
        super();

        sky = new FlxBackdrop(Paths.imageFile('background/Sky'), X, 0, 0);
        sky.setGraphicSize(Std.int(sky.width * 2));
        sky.updateHitbox();
        sky.scrollFactor.set(0.3, 0);
        add(sky);

        backObjects = new FlxTypedGroup<FlxBasic>();
        add(backObjects);

        ground = new FlxBackdrop(Paths.imageFile('background/Ground'), X, 0, 0);
        ground.setGraphicSize(Std.int(ground.width * 2));
        ground.updateHitbox();
        ground.scrollFactor.set(0.7, 0);
        add(ground);

        sky.y = FlxG.height - sky.height;
        ground.y = FlxG.height - ground.height;
    }
}