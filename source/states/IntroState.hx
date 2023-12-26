package states;

import backend.FlappyState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class IntroState extends FlappyState
{
    var canSkip:Bool = false;

    override public function new()
    {
        super(false, true);
    }

    override function create()
    {
        var introTxt:FlxText = new FlxText(0, 0, 0, 'AbsurdCoolMan\nMade with HaxeFlixel', 32);
        introTxt.setFormat(Paths.fontFile(Paths.fonts.get('default')), 32, FlxColor.WHITE, CENTER);
        introTxt.scrollFactor.set();
        introTxt.screenCenter();
        add(introTxt);

        FlxG.sound.play(Paths.soundFile(Paths.sounds.get('point'), false));

        new FlxTimer().start(0.1, function(_){
            canSkip = true;
        });

        new FlxTimer().start(2, transition);

        super.create();
    }

    override function update(elapsed:Float)
    {
        if ((FlxG.keys.justPressed.ANY || FlxG.mouse.justPressed) && canSkip)
            transition();

        super.update(elapsed);
    }

    function transition(?_)
    {
        if (!canSkip) return;

        canSkip = false;

        FlxG.sound.play(Paths.soundFile(Paths.sounds.get('swooshing'), false));
        FlappyState.switchState(new MenuState());
    }
}