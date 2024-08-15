package options;

import flixel.FlxSprite;
import backend.FlappyText;
import flixel.group.FlxGroup;
import Type.ValueType;
import backend.FlappyData;

class FlappyOption extends FlxGroup
{
    public var name:String;
    public var variable:String;

    public var label:FlappyText;
    public var spr:FlxSprite;

    override public function new(x:Float = 0, y:Float = 0, name:String, variable:String)
    {
        super();
        this.name = name;
        this.variable = variable;

        // Adds the label
        label = new FlappyText(x, y + 8, 0, name, 24);
        add(label);

        switch (getType())
        {
            case TBool:
                spr = new FlappyCheckbox(x, y, getValue());
                add(spr);
                label.x = spr.x + spr.width + 4;

                var checkbox:FlappyCheckbox = cast spr;
                checkbox.onClicked = function(){
                    checkbox.value = !checkbox.value;
                    setValue(checkbox.value);
                }
            default:
                // nothing lmfao
        }
    }

    public function getValue():Dynamic
    {
        return FlappyData.getOption(variable);
    }

    public function setValue(value:Dynamic)
    {
        FlappyData.setOption(variable, value);
    }

    public function getType():ValueType
    {
        return Type.typeof(getValue());
    }
}