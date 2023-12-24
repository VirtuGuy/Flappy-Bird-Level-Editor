package substates;

import backend.FlappyState;
import backend.FlappySubstate;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import states.MenuState;

class PauseSubstate extends FlappySubstate
{
    override public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.screenCenter();
        bg.scrollFactor.set();
        bg.alpha = 0;
        add(bg);

        FlxTween.tween(bg, {alpha: 0.65}, 0.2);
    }

    override function update(elapsed:Float)
    {
        if (keys.UI_ACCEPT)
        {
            close();
        }
        else if (keys.UI_BACK)
        {
            FlappyState.switchState(new MenuState());
        }

        super.update(elapsed);
    }
}