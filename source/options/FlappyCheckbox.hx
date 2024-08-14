package options;

import objects.FlappyButton;

class FlappyCheckbox extends FlappyButton
{
    public var value(default, set):Bool = false;

    override public function new(x:Float = 0, y:Float = 0, value:Bool = false)
    {
        super(x, y);
        set_value(value);
    }

    private function set_value(value:Bool):Bool
    {
        this.value = value;
        if (value)
            buttonName = 'checkboxOn';
        else
            buttonName = 'checkboxOff';
        return value;
    }
}