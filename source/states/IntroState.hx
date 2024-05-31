package states;

import backend.FlappyState;
import backend.FlappyText;
import flixel.FlxG;
import flixel.util.FlxTimer;

class IntroState extends FlappyState
{
    var canSkip:Bool = false;

    override public function new()
    {
        super(false, true, false, false);
    }

    override function create()
    {
        var introTxt:FlappyText = new FlappyText(0, 0, 0, 'VirtuGuy\nMade with HaxeFlixel', 32, CENTER);
        introTxt.screenCenter();
        add(introTxt);

        FlxG.sound.play(Paths.soundFile(Paths.getSound('point'), false));

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

        FlxG.sound.play(Paths.soundFile(Paths.getSound('swooshing'), false));
        FlappyState.switchState(new MenuState());
    }
}