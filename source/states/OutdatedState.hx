package states;

import backend.FlappySettings;
import backend.FlappyState;
import backend.FlappyTools;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OutdatedState extends FlappyState
{
    override public function new()
    {
        super(false, true);
    }

    override function create()
    {
        var text:FlxText = new FlxText(0, 0, FlxG.width - 50, '', 24);
        text.setFormat(Paths.fontFile(Paths.fonts.get('default')), 24, FlxColor.WHITE, CENTER);

        text.text = 'This version of the game is outdated!'
        + '\n\nYou are using version ' + Init.curVersion
        + ', while the latest is ' + Init.latestVersion
        + '\n\nPress SPACE to open GitHub, or press ESCAPE to continue';

        text.screenCenter();
        add(text);

        super.create();
    }

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.SPACE)
            FlappyTools.openURL(FlappySettings.githubLink);
        else if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.sound.play(Paths.soundFile(Paths.sounds.get('swooshing')));
            FlappyState.switchState(new IntroState());
        }

        super.update(elapsed);
    }
}