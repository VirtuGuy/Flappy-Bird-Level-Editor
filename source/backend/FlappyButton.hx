package backend;

import flixel.addons.display.FlxExtendedMouseSprite;
import flixel.util.FlxColor;

class FlappyButton extends FlxExtendedMouseSprite
{
    public var buttonName:String = '';
    public var justClicked:Bool = false;

    // Callbacks
    public var onClicked:Void->Void;
    public var onReleased:Void->Void;
    public var onHover:Void->Void;

    // Brightnesses
    public var hoverBrightness:Float = 0.9;
    public var clickBrightness:Float = 0.6;

    override public function new(x:Float = 0, y:Float = 0, buttonName:String = '')
    {
        super(x, y);

        this.buttonName = buttonName;

        loadGraphic(Paths.imageFile('buttons/$buttonName'));
        setGraphicSize(Std.int(width * 3));
        updateHitbox();

        scrollFactor.set();
    }

    override function update(elapsed:Float)
    {
        if (isPressed)
            clicked();
        else
        {
            if (mouseOver)
                hover();
            else
                released();
        }

        super.update(elapsed);
    }

    private function clicked()
    {
        setBrightness(clickBrightness);

        if (onClicked != null && !justClicked)
            onClicked();

        justClicked = true;
    }

    private function released()
    {
        justClicked = false;

        setBrightness(1);

        if (onReleased != null)
            onReleased();
    }

    private function hover()
    {
        setBrightness(hoverBrightness);

        if (onHover != null)
            onHover();
    }

    public function setBrightness(brightness:Float)
    {
        color = FlxColor.fromHSB(color.hue, color.saturation, brightness);
    }
}