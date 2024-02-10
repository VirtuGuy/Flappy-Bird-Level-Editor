package backend;

import flixel.text.FlxText;
import flixel.util.FlxColor;

class FlappyText extends FlxText
{
    override public function new(x:Float = 0, y:Float = 0, fieldWidth:Float = 0, text:String, size:Int = 16,
        alignment:FlxTextAlign = LEFT)
    {
        super(x, y, fieldWidth, text, size);

        setFormat(Paths.fontFile(Paths.getFont('default')), size, FlxColor.WHITE, alignment, OUTLINE, FlxColor.BLACK);
        borderSize = 2;
        scrollFactor.set();
    }
}