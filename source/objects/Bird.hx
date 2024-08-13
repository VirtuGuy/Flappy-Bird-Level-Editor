package objects;

import flixel.sound.FlxSound;
import backend.FlappySettings;
import flixel.FlxG;
import flixel.FlxSprite;

class Bird extends FlxSprite
{
    public var gravity:Float = 20;
    public var flapHeight:Float = 300;
    public var isDead:Bool = false;
    public var startMoving(default, set):Bool = true;
    public var playerSkin(default, set):String = '';

    private var playerSkinDir:String = 'playerSkins';
    private var playedDieSound:Bool = false;
    private var dieSound:FlxSound;

    override public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        this.playerSkin = FlappySettings.playerSkin;
        this.startMoving = false;

        animation.add('idle', [0], 8);
        animation.add('flap', [1, 0, 2], 8, false);
        animation.play('flap');

        dieSound = new FlxSound().loadEmbedded(Paths.soundFile(Paths.getSound('die')));
        dieSound.looped = false;
        FlxG.sound.list.add(dieSound);
    }

    override function update(elapsed:Float)
    {
        if (startMoving)
            velocity.y += gravity * elapsed * 60;

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
            if (!isDead)
                angle = (velocity.y / 100) * 5;
            else
                angle = (velocity.y / 35) * 5;
        }

        if (isDead && velocity.y > gravity * 50 && !playedDieSound)
        {
            playedDieSound = true;
            dieSound.play();
        }

        super.update(elapsed);
    }

    public function flap()
    {
        if (!isDead)
        {
            FlxG.sound.play(Paths.soundFile(Paths.getSound('wing'), false));
            animation.play('flap', true);
            velocity.y = -flapHeight;
        }
    }

    public function killBird()
    {
        if (!isDead)
        {
            FlxG.sound.play(Paths.soundFile(Paths.getSound('hit'), false));
            gravity /= 2.5;
            velocity.y = -flapHeight / 1.5;
            isDead = true;
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