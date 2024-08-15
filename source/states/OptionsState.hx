package states;

import backend.FlappyTools;
import options.FlappyCheckbox;
import options.FlappyOption;
import objects.FlappyButton;
import backend.FlappySettings;
import backend.FlappyState;
import backend.FlappyText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class OptionsState extends FlappyState
{
    var grpLabels:FlxTypedGroup<FlappyText>;
    var grpCheckboxes:FlxTypedGroup<FlappyCheckbox>;

    var curCategory:String = 'gameplay';
    var options:Map<String, Array<FlappyOption>> = [
        'gameplay' => [
            new FlappyOption('classic mode', 'classic'),
        ]
    ];

    override public function new()
    {
        super(true, true);
    }
    
    override function create()
    {
        var titleText:FlappyText = new FlappyText(0, 0, 0, 'Options', 32, CENTER);
        titleText.screenCenter(X);
        titleText.y = titleText.height - 20;
        add(titleText);

        var backButton:FlappyButton = new FlappyButton(0, 0, 'back');
        backButton.clickSound = true;
        backButton.screenCenter(X);
        backButton.y = FlxG.height - (backButton.height + 10);
        add(backButton);

        backButton.onClicked = function(){
            FlappyState.switchState(new MenuState());
        }

        // Options
        grpLabels = new FlxTypedGroup<FlappyText>();
        add(grpLabels);
        grpCheckboxes = new FlxTypedGroup<FlappyCheckbox>();
        add(grpCheckboxes);
        reloadOptions();

        super.create();
    }

    override function update(elapsed:Float)
    {
        camFollow.x += FlappySettings.menuScrollSpeed * elapsed * 60;
        super.update(elapsed);
    }

    function reloadOptions()
    {
        FlappyTools.clearGroup(grpCheckboxes);
        FlappyTools.clearGroup(grpLabels);

        for (i in 0...options.get(curCategory).length)
        {
            var option:FlappyOption = options.get(curCategory)[i];
            var labelX:Float = 30;
            var labelY:Float = 80 + (45 * i);

            switch (option.getType())
            {
                case TBool:
                    var checkbox:FlappyCheckbox = new FlappyCheckbox(
                        labelX,
                        labelY - 8,
                        option.getValue()
                    );
                    checkbox.onClicked = function(){
                        checkbox.value = !checkbox.value;
                        option.setValue(checkbox.value);
                    }
                    labelX = checkbox.x + checkbox.width + 4;
                    grpCheckboxes.add(checkbox);
                default:
                    // absolutely nothing lmfao
            }

            var label:FlappyText = new FlappyText(labelX, labelY, 0, option.name, 24);
            grpLabels.add(label);
        }
    }
}