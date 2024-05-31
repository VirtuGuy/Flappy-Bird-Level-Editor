package objects;

import backend.FlappySettings;
import flixel.FlxG;
import flixel.FlxSprite;

class Bird extends FlxSprite
{
    public var gravity:Float = 20;
    public var flapHeight:Float = 300;
    public var sinkSpeed:Float = 12;
    public var isDead:Bool = false;
    public var isSinking:Bool = false;
    public var startMoving(default, set):Bool = true;
    public var playerSkin(default, set):String = '';

    private var playerSkinDir:String = 'playerSkins';

    override public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        this.playerSkin = FlappySettings.playerSkin;
        this.startMoving = false;

        scrollFactor.set();

        animation.add('idle', [0], 8);
        animation.add('flap', [1, 0, 2], 8, false);
        animation.play('flap');
    }

    override function update(elapsed:Float)
    {
        if (!isSinking && startMoving)
            velocity.y += gravity;

        if (animation.curAnim != null)
        {
            if (animation.curAnim.name == 'flap' && animation.curAnim.finished)
            {
                if (startMoving)
                    animation.play('idle');
                else
                    animation.play('flap', true);
            }
        }

        if (startMoving)
        {
            if (!isSinking)
                angle = (velocity.y / 100) * 5;
            else
                angle += sinkSpeed / 20;
        }

        super.update(elapsed);
    }

    public function flap()
    {
        if (!isDead)
        {
            animation.play('flap', true);
            velocity.y = -flapHeight;
            
            FlxG.sound.play(Paths.soundFile(Paths.getSound('wing'), false));
        }
    }

    public function killBird(playHitSound:Bool = true)
    {
        if (playHitSound && !isDead)
            FlxG.sound.play(Paths.soundFile(Paths.getSound('hit'), false));
        isDead = true;
    }

    public function sink()
    {
        if (!isSinking)
        {
            FlxG.sound.play(Paths.soundFile(Paths.getSound('die'), false));
            velocity.y = sinkSpeed;

            isSinking = true;
        }
    }

    private function set_playerSkin(value:String):String
    {
        this.playerSkin = value;

        loadGraphic(Paths.imageFile('$playerSkinDir/$value'), true, 17, 12);
        setGraphicSize(Std.int(width * 2));
        updateHitbox();

        return value;
    }

    private function set_startMoving(value:Bool):Bool
    {
        this.startMoving = value;

        if (value)
            animation.play('idle');
        else
        {
            animation.play('flap', true);
            velocity.y = 0;
        }

        return value;
    }
}