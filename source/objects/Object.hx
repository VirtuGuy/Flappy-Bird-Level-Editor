package objects;

import backend.FlappyTools;
import flixel.FlxSprite;

typedef ObjectData = {
    canBeFlipped:Null<Bool>,
    canCollide:Null<Bool>,
    invisible:Null<Bool>,
    canBeScaled:Null<Bool>,
    triggerMode:Null<Int>,
    max:Null<Int>,
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
    public var triggerMode:Int = 0;
    public var max:Int = 0;
    public var variables:Array<Array<Dynamic>> = [];
    public var scaleMulti(default, set):Float = -1;
    public var alreadyTriggered:Bool = false;

    private var _lastAlpha:Float = 1;

    override public function new(x:Float = 0, y:Float = 0, objectName:String = 'pipe',
        ?editorObject:Bool = false)
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
        visible = isOnScreen();

        super.update(elapsed);
    }

    private function set_objectName(value:String):String
    {
        this.objectName = value;

        if (Paths.pathExists(Paths.objectJson(objectName)))
        {
            var json:ObjectData = FlappyTools.loadJSON(Paths.objectJson(objectName));

            canBeFlipped = json.canBeFlipped ?? true;
            canCollide = json.canCollide ?? true;
            invisible = json.invisible ?? false;
            canBeScaled = json.canBeScaled ?? true;
            triggerMode = json.triggerMode ?? 0;
            max = json.max ?? 0;
        }

        loadGraphic(Paths.imageFile('objects/$value'));
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