package objects;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;

enum ButtonLayout
{
    Horizontal;
    Vertical;
}

class ButtonGroup extends FlxTypedGroup<FlappyButton>
{
    public var buttons:Array<String> = [];
    public var buttonLayout:ButtonLayout = Vertical;
    public var fadeInDelay:Float = -1;
    public var buttonScale:Float = 1;
    public var xOffset:Float = 0;
    public var yOffset:Float = 0;

    function sortStuff(obj1:FlappyButton, obj2:FlappyButton):Int
    {
        return FlxSort.byY(FlxSort.ASCENDING, obj1, obj2);
    }

    override public function new(buttons:Array<String>, buttonLayout:ButtonLayout = Vertical,
        fadeInDelay:Float = -1, buttonScale:Float = 1, xOffset:Float = 0, yOffset:Float = 0)
    {
        super();
        this.buttons = buttons;
        this.buttonLayout = buttonLayout;
        this.fadeInDelay = fadeInDelay;
        this.buttonScale = buttonScale;
        this.xOffset = xOffset;
        this.yOffset = yOffset;

        var spacingX:Float = 124 * buttonScale;
        var spacingY:Float = 47 * buttonScale;
        var right:Float = (FlxG.width - (spacingX * (buttons.length))) / 2;
		var top:Float = (FlxG.height - (spacingY * (buttons.length))) / 2;

        for (i in 0...buttons.length)
        {
            var x:Null<Float> = null;
            var y:Null<Float> = null;

            switch (buttonLayout)
            {
                case Vertical:
                    x = null;
                    y = top + spacingY * i;
                case Horizontal:
                    x = right + spacingX * i;
                    y = null;
            }

            var realX:Float = 0;
            var realY:Float = 0;

            if (x != null)
                realX = x;
            if (y != null)
                realY = y;

            var button:FlappyButton = new FlappyButton(realX, realY, buttons[i]);
            button.setGraphicSize(Std.int(button.width * buttonScale));
            button.updateHitbox();
            button.ID = i;
            if (x == null)
                button.screenCenter(X);
            if (y == null)
                button.screenCenter(Y);
            button.x += xOffset;
            button.y += yOffset;
            button.clickSound = true;

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

                FlxTween.tween(button, {alpha: 1, y: button.y + 10}, 0.5, {startDelay: delay,
                    ease: FlxEase.quadInOut});
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

    public function addPosition(x:Float = 0, y:Float = 0)
    {
        for (item in members)
        {
            item.x += x;
            item.y += y;
        }
    }
}