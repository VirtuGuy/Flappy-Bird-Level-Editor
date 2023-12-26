package objects;

import backend.FlappySettings;
import flixel.FlxG;
import flixel.FlxSprite;

class Bird extends FlxSprite
{
    public var gravity:Float = 20;
    public var flapHeight:Float = 300;
    public var sinkSpeed:Float = 10;

    public var playerSkin(default, set):String = '';

    private var playerSkinDir:String = 'playerSkins';

    public var isDead:Bool = false;
    public var isSinking:Bool = false;

    override public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        this.playerSkin = FlappySettings.playerSkin;

        animation.add('idle', [0], 8);
        animation.add('flap', [1, 0, 2], 8, false);
        animation.play('idle');
    }

    override function update(elapsed:Float)
    {
        if (!isSinking)
            velocity.y += gravity;

        if (animation.curAnim != null)
        {
            if (animation.curAnim.name == 'flap' && animation.curAnim.finished)
            {
                animation.play('idle');
            }
        }

        if (!isSinking)
            angle = (velocity.y / 100) * 5;
        else
            angle += sinkSpeed / 20;

        super.update(elapsed);
    }

    public function flap()
    {
        if (isDead) return;

        animation.play('flap', true);
        velocity.y = -flapHeight;
        
        FlxG.sound.play(Paths.soundFile(Paths.sounds.get('wing'), false));
    }

    public function killBird(playHitSound:Bool = true)
    {
        if (playHitSound && !isDead)
            FlxG.sound.play(Paths.soundFile(Paths.sounds.get('hit'), false));

        isDead = true;
    }

    public function sink()
    {
        if (isSinking) return;

        FlxG.sound.play(Paths.soundFile(Paths.sounds.get('die'), false));
        velocity.y = sinkSpeed;

        isSinking = true;
    }

    private function set_playerSkin(value:String):String
    {
        loadGraphic(Paths.imageFile('$playerSkinDir/$value'), true, 17, 12);
        setGraphicSize(Std.int(width * 2));
        updateHitbox();

        return value;
    }
}