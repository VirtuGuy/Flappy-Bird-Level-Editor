package backend;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class FadeHandler
{
    public var target:FlxSprite;
    public var y:Float = 0;
    public var alpha:Float = 0;
    public var callback:(Bool)->Void;

    public function new(target:FlxSprite, callback:(Bool)->Void)
    {
        var info:Array<Float> = [target.y, target.alpha];
        FlxTween.completeTweensOf(target);
        FlxTween.globalManager.update(0);

        this.target = target;
        this.y = target.y;
        this.alpha = target.alpha;
        this.callback = callback;

        target.y = info[0];
        target.alpha = info[1];
    }

    public function start(fadeIn:Bool = true, fadeDuration:Float = 0.5)
    {
        if (!fadeIn)
            FlxTween.cancelTweensOf(target);
        else
        {
            target.y = y;
            target.alpha = alpha;
        }

        if (target is FlappyButton)
        {
            var button:FlappyButton = cast target;
            button.active = fadeIn;
        }

        var posY:Float = y;
        var posAlpha:Float = alpha;

        if (fadeIn)
        {
            target.y -= 20;
            target.alpha = 0;
        }
        else
        {
            posY -= 20;
            posAlpha = 0;
        }

        FlxTween.tween(target, {alpha: posAlpha}, fadeDuration, {ease: FlxEase.quadInOut});
        FlxTween.tween(target, {y: posY}, fadeDuration, {ease: FlxEase.quadOut,
            onComplete: function(_){
                if (callback != null)
                    callback(fadeIn);
        }});
    }
}