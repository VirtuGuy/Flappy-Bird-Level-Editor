package options;

import objects.FlappyButton;
import flixel.FlxSprite;
import backend.FlappyText;
import flixel.group.FlxGroup;
import Type.ValueType;
import backend.FlappyData;

class FlappyOption extends FlxGroup
{
    public var name:String;
    public var variable:String;
    public var metadata:Array<Dynamic>;

    override public function new(x:Float = 0, y:Float = 0, name:String, variable:String, ?metadata:Array<Dynamic>)
    {
        super();
        this.name = name;
        this.variable = variable;
        this.metadata = metadata;

        // Adds the label
        var label:FlappyText = new FlappyText(x, y + 8, 0, name, 24);
        add(label);

        switch (getType())
        {
            case TBool:
                var checkbox:FlappyCheckbox = new FlappyCheckbox(x, y, getValue());
                add(checkbox);
                label.x = x + checkbox.width + 4;

                checkbox.onClicked = function(){
                    checkbox.value = !checkbox.value;
                    setValue(checkbox.value);
                }
            default:
                var leftButton:FlappyButton = new FlappyButton(x, y, 'arrow');
                add(leftButton);

                var valueTxt:FlappyText = new FlappyText(x, label.y, 0,
                    getValue(), 24);
                add(valueTxt);

                var rightButton:FlappyButton = new FlappyButton(x, y, 'arrow');
                rightButton.flipX = true;
                add(rightButton);

                // Button functionality
                var callback:(Int)->Void = function(change:Int){
                    if (metadata != null && metadata.length > 0)
                    {
                        var i:Int = metadata.indexOf(getValue()) + change;
                        if (i < 0)
                            i = metadata.length - 1;
                        else if (i >= metadata.length)
                            i = 0;
                        valueTxt.text = metadata[i];

                        valueTxt.x = leftButton.x + leftButton.width + 4;
                        rightButton.x = valueTxt.x + valueTxt.width + 2;
                        label.x = rightButton.x + rightButton.width + 4;
                        if (change != 0)
                            setValue(metadata[i]);
                    }
                }
                callback(0);

                leftButton.onClicked = function(){
                    callback(-1);
                }
                rightButton.onClicked = function(){
                    callback(1);
                }
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