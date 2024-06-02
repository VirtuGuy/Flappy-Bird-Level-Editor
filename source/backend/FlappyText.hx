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
    public var selected:Bool = false;

    override public function new(x:Float = 0, y:Float = 0, fieldWidth:Float = 0, text:String,
        size:Int = 16, alignment:FlxTextAlign = LEFT)
    {
        super(x, y, fieldWidth, text, size);
        set_text(this.text);
        defaultX = this.x;

        setFormat(Paths.fontFile(Paths.getFont('default')), size, FlxColor.WHITE, alignment,
            OUTLINE, FlxColor.BLACK);
        borderSize = 2;
        scrollFactor.set();
    }

    public function deselect()
    {
        selected = false;
        
        FlxTween.cancelTweensOf(this);
        FlxTween.tween(this, {x: defaultX}, selectDuration, {ease: FlxEase.quadOut});
        alpha = 0.7;
    }

    public function select()
    {
        if (!selected)
        {
            defaultX = x;
            selected = true;
        }

        FlxTween.cancelTweensOf(this);
        FlxTween.tween(this, {x: defaultX + 15}, selectDuration, {ease: FlxEase.quadOut});
        alpha = 1;
    }

    // Lowercase F gets replaced because it looks bad
    override private function set_text(value:String):String
    {
        return super.set_text(value.replace('f', 'F'));
    }
}