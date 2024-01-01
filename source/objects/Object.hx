package objects;

import backend.FlappyTools;
import flixel.FlxSprite;

typedef ObjectData = {
    canBeFlipped:Null<Bool>,
    canCollide:Null<Bool>,
    invisible:Null<Bool>,
    canBeScaled:Null<Bool>,
    variables:Null<Array<Array<Dynamic>>>
}

class Object extends FlxSprite
{
    public var objectName(default, set):String = '';
    public var selected(default, set):Bool = false;
    public var flipped(default, set):Bool = false;

    public var editorObject:Bool = false;

    public var canBeFlipped:Bool = true;
    public var canCollide:Bool = true;
    public var invisible(default, set):Bool = false;
    public var canBeScaled:Bool = true;

    private var _lastAlpha:Float = 1;

    public var scaleMulti(default, set):Float = -1;
    public var variables:Array<Array<Dynamic>> = [];

    override public function new(x:Float = 0, y:Float = 0, objectName:String = 'pipe', ?editorObject:Bool = false)
    {
        super(x, y);

        this.editorObject = editorObject;
        this.objectName = objectName;
        this.scaleMulti = 1;
    }

    override function update(elapsed:Float)
    {
        if (canBeFlipped)
            flipX = flipped == true;
        else
            flipX = false;

        super.update(elapsed);
    }

    private function set_objectName(value:String):String
    {
        this.objectName = value;

        if (Paths.fileExists(Paths.objectJson(objectName)))
        {
            var json:ObjectData = FlappyTools.loadJSON(Paths.objectJson(objectName));
            
            if (json.canBeFlipped != null)
                canBeFlipped = json.canBeFlipped;
            else
                canBeFlipped = true;

            if (json.canCollide != null)
                canCollide = json.canCollide;
            else
                canCollide = true;

            if (json.invisible != null)
                invisible = json.invisible;
            else
                invisible = false;

            if (json.canBeScaled != null)
                canBeScaled = json.canBeScaled;
            else
                canBeScaled = true;
        }

        loadGraphic(Paths.imageFile('objects/' + value));
        updateHitbox();

        if (flipped && !canBeFlipped)
            flipped = false;
        
        if (scaleMulti != 1 && !canBeScaled)
            scaleMulti = 1;

        origin.y = 0;
        offset.copyFrom(origin);

        return value;
    }

    private function set_selected(value:Bool):Bool
    {
        this.selected = value;

        if (selected && editorObject)
            alpha = 0.5;
        else
            alpha = 1;

        _lastAlpha = alpha;

        return value;
    }

    private function set_scaleMulti(value:Float):Float
    {
        this.scaleMulti = value;

        scale.set(2 * value, 2 * value);
        updateHitbox();

        origin.y = 0;
        offset.copyFrom(origin);

        return value;
    }

    private function set_flipped(value:Bool):Bool
    {
        this.flipped = value;

        if (this.flipped)
            angle = 180;
        else
            angle = 0;

        return value;
    }

    private function set_invisible(value:Bool):Bool
    {
        this.invisible = value;

        if (this.invisible && !this.editorObject)
            alpha = 0;
        else
            alpha = _lastAlpha;

        return value;
    }
}