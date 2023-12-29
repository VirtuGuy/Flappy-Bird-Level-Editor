package objects;

import flixel.FlxSprite;

class Object extends FlxSprite
{
    public var objectName(default, set):String = '';
    public var selected(default, set):Bool = false;
    public var flipped(default, set):Bool = false;

    public var editorObject:Bool = false;

    override public function new(x:Float = 0, y:Float = 0, objectName:String = 'pipe')
    {
        super(x, y);

        this.objectName = objectName;
    }

    override function update(elapsed:Float)
    {
        if (objectName.toLowerCase() == 'pipe')
            flipX = flipped == true;

        super.update(elapsed);
    }

    private function set_objectName(value:String):String
    {
        this.objectName = value;
        loadGraphic(Paths.imageFile('objects/' + value));

        scale.set(2, 2);
        updateHitbox();

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
}