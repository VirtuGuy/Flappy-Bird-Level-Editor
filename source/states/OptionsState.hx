package states;

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

    var options:Array<FlappyOption> = [
        new FlappyOption('classic mode', 'classic'),
    ];

    override public function new()
    {
        super(true, true);
    }
    
    override function create()
    {
        var boxBG:FlxSprite = new FlxSprite();
        boxBG.loadGraphic(Paths.imageFile('uiBox'));
        boxBG.setGraphicSize(Std.int(boxBG.width * 3));
        boxBG.updateHitbox();
        boxBG.scrollFactor.set();
        boxBG.screenCenter();
        add(boxBG);

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

        for (i in 0...options.length)
        {
            var option:FlappyOption = options[i];
            var labelX:Float = boxBG.x + 20;
            var labelY:Float = boxBG.y + 30 + (45 * i);

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

        super.create();
    }

    override function update(elapsed:Float)
    {
        camFollow.x += FlappySettings.menuScrollSpeed * elapsed * 60;
        super.update(elapsed);
    }
}