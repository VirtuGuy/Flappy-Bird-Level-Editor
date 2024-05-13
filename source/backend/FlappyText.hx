package backend;

import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

using StringTools;

class FlappyText extends FlxText
{
    public var defaultX:Float = 0;
    public var selectDuration:Float = 0.2;

    override public function new(x:Float = 0, y:Float = 0, fieldWidth:Float = 0, text:String,
        size:Int = 16, alignment:FlxTextAlign = LEFT)
    {
        super(x, y, fieldWidth, text, size);
        defaultX = this.x;

        // Lowercase F looks bad in the font
        text = text.replace('f', 'F');

        setFormat(Paths.fontFile(Paths.getFont('default')), size, FlxColor.WHITE, alignment, OUTLINE,
            FlxColor.BLACK);
        borderSize = 2;
        scrollFactor.set();
    }

    public function deselect()
    {
        FlxTween.cancelTweensOf(this);
        FlxTween.tween(this, {x: defaultX}, selectDuration, {ease: FlxEase.quadOut});
        alpha = 0.7;
    }

    public function select()
    {
        defaultX = x;

        FlxTween.cancelTweensOf(this);
        FlxTween.tween(this, {x: defaultX + 15}, selectDuration, {ease: FlxEase.quadOut});
        alpha = 1;
    }
}