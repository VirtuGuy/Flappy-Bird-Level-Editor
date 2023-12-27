package objects;

import flixel.FlxSprite;

class Object extends FlxSprite
{
    public var objectName(default, set):String = '';
    public var selected(default, set):Bool = false;
    public var editorObject:Bool = false;

    override public function new(x:Float = 0, y:Float = 0, objectName:String = 'pipe')
    {
        super(x, y);

        this.objectName = objectName;

        scale.set(2, 2);
        updateHitbox();

        setRotation(angle);
    }

    override function update(elapsed:Float)
    {
        if (objectName.toLowerCase() == 'pipe')
        {
            if (angle % 360 > 45)
                flipX = true;
            else
                flipX = false;
        }

        super.update(elapsed);
    }

    private function set_objectName(value:String):String
    {
        this.objectName = value;
        loadGraphic(Paths.imageFile('objects/' + value));
        setRotation(angle);

        return value;
    }

    private function set_selected(value:Bool):Bool
    {
        this.selected = value;

        if (selected && editorObject)
            alpha = 0.8;
        else
            alpha = 1;

        return value;
    }

    public function setRotation(angle:Float)
    {
        this.angle = angle;
        updateHitbox();

        // Rotation stuff
        origin.y = 0;
        offset.copyFrom(origin);
    }
}