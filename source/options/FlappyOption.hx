package options;

import Type.ValueType;
import backend.FlappyData;

class FlappyOption
{
    public var name:String;
    public var variable:String;

    public function new(name:String, variable:String)
    {
        this.name = name;
        this.variable = variable;
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