package backend;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

using StringTools;

class FlappyText extends FlxText
{
    public var selectionItem:Bool = false;
    public var selectionIndex:Int = 0;
    public var selectionBox:FlxSprite;

    override public function new(x:Float = 0, y:Float = 0, fieldWidth:Float = 0, text:String,
        size:Int = 16, alignment:FlxTextAlign = LEFT)
    {
        super(x, y, fieldWidth, text, size);
        set_text(this.text);

        setFormat(Paths.fontFile(Paths.getFont('default')), size, FlxColor.WHITE, alignment,
            OUTLINE, FlxColor.BLACK);
        borderSize = 2;
        scrollFactor.set();
    }

    public function posSelectionItem()
    {
        if (selectionItem)
        {
            x = 30 + (selectionIndex * (width / 5));
            y = FlxG.height / 2.5 + (selectionIndex * height + 10);
            if (selectionBox != null)
            {
                selectionBox.setPosition(x - 250, y);
                selectionBox.visible = selectionIndex == 0;
            }
        }
    }

    override function update(elapsed:Float)
    {
        // Helps make the game run faster
        visible = isOnScreen();
        
        super.update(elapsed);
    }

    // Lowercase F gets replaced because it looks bad
    override private function set_text(value:String):String
    {
        return super.set_text(value.replace('f', 'F'));
    }
}