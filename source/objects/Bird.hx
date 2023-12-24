package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Bird extends FlxSprite
{
    public var speed(default, null):FlxPoint;
    public var gravity:Float = 0.3;
    public var flapHeight:Float = 5;

    public var playerSkin(default, set):String = '';

    private var playerSkinDir:String = 'playerSkins';

    override public function new(x:Float = 0, y:Float = 0, playerSkin:String = 'default')
    {
        speed = new FlxPoint();

        super(x, y);

        this.playerSkin = playerSkin;

        animation.add('idle', [0], 8);
        animation.add('flap', [1, 0, 2], 8, false);
        animation.play('idle');
    }

    override function update(elapsed:Float)
    {
        speed.y += gravity;

        x += speed.x;
        y += speed.y;

        if (animation.curAnim != null)
        {
            if (animation.curAnim.name == 'flap' && animation.curAnim.finished)
            {
                animation.play('idle');
            }
        }

        angle = speed.y * 2;

        super.update(elapsed);
    }

    public function flap()
    {
        animation.play('flap', true);
        speed.y = -flapHeight;
        
        FlxG.sound.play(Paths.soundFile('sfx_wing', false));
    }

    private function set_playerSkin(value:String):String
    {
        loadGraphic(Paths.imageFile('$playerSkinDir/$value'), true, 17, 12);
        setGraphicSize(Std.int(width * 2));
        updateHitbox();

        return value;
    }
}