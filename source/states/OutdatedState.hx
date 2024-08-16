package states;

import backend.FlappySettings;
import backend.FlappyState;
import objects.FlappyText;
import backend.FlappyTools;
import flixel.FlxG;

class OutdatedState extends FlappyState
{
    override public function new()
    {
        super(false, true, false, false);
    }

    override function create()
    {
        var text:FlappyText = new FlappyText(0, 0, FlxG.width - 50, '', 24, CENTER);
        text.text = 'This version of the game is outdated!'
        + '\n\nYou are using version ${Init.curVersion}'
        + ', while the latest is ${Init.latestVersion}'
        + '\n\nPress SPACE to open the game\'s Itch.io page, or press ESCAPE to continue';
        text.screenCenter();
        add(text);

        super.create();
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.SPACE)
            FlappyTools.openURL(FlappySettings.gameLink);
        else if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.sound.play(Paths.soundFile(Paths.getSound('swooshing')));
            FlappyState.switchState(new IntroState());
        }

        super.update(elapsed);
    }
}