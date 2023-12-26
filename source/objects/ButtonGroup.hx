package objects;

import backend.FlappyButton;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;

class ButtonGroup extends FlxTypedGroup<FlappyButton>
{
    public var buttons:Array<String> = [];
    public var fadeInDelay:Float = -1;

    public var clickCallbacks:Array<Void->Void> = [];
    public var releaseCallbacks:Array<Void->Void> = [];
    public var hoverCallbacks:Array<Void->Void> = [];

    function sortStuff(obj1:FlappyButton, obj2:FlappyButton):Int
    {
        return FlxSort.byY(FlxSort.ASCENDING, obj1, obj2);
    }

    override public function new(buttons:Array<String>, fadeInDelay:Float = -1, ?clickCallbacks:Array<Void->Void>,
        ?releaseCallbacks:Array<Void->Void>, ?hoverCallbacks:Array<Void->Void>)
    {
        super();

        this.buttons = buttons;
        this.fadeInDelay = fadeInDelay;
        this.clickCallbacks = clickCallbacks;
        this.releaseCallbacks = releaseCallbacks;
        this.hoverCallbacks = hoverCallbacks;

        var spacing:Float = 47;
		var top:Float = (FlxG.height - (spacing * (buttons.length))) / 2;

        for (i in 0...buttons.length)
        {
            var button:FlappyButton = new FlappyButton(0, top + spacing * i, buttons[i]);
            button.ID = i;
            button.screenCenter(X);
            button.clickSound = true;

            if (clickCallbacks != null && clickCallbacks[i] != null)
                button.onClicked = clickCallbacks[i];

            if (releaseCallbacks != null && releaseCallbacks[i] != null)
                button.onReleased = releaseCallbacks[i];

            if (hoverCallbacks != null && hoverCallbacks[i] != null)
                button.onHover = hoverCallbacks[i];

            add(button);
        }

        if (fadeInDelay > -1)
        {
            for (i in 0...members.length)
            {
                var button:FlappyButton = members[i];
                var delay:Float = fadeInDelay + (0.25 * i);

                button.y -= 10;
                button.alpha = 0;

                FlxTween.tween(button, {alpha: 1, y: button.y + 10}, 0.5, {startDelay: delay, ease: FlxEase.quadInOut});
            }
        }
    }

    public function setButtonClickSFX(buttonId:Int = 0, toggle:Bool)
    {
        if (members[buttonId] != null && members[buttonId] is FlappyButton)
        {
            var button:FlappyButton = cast members[buttonId];
            button.clickSound = toggle;
        }
    }
}