package states;

import backend.FlappyTools;
import options.FlappyCheckbox;
import options.FlappyOption;
import objects.FlappyButton;
import backend.FlappySettings;
import backend.FlappyState;
import backend.FlappyText;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class OptionsState extends FlappyState
{
    var grpOptions:FlxTypedGroup<FlappyOption>;

    var curCategory:String = 'gameplay';
    var options:Array<Array<String>> = [
        ['classic mode', 'classic'],
        ['mute sfx', 'muteSFX']
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
        grpOptions = new FlxTypedGroup<FlappyOption>();
        add(grpOptions);
        
        for (i in 0...options.length)
        {
            var option:Array<String> = options[i];
            grpOptions.add(new FlappyOption(30, 80 + (45 * i), option[0], option[1]));
        }

        super.create();
    }

    override function update(elapsed:Float)
    {
        camFollow.x += FlappySettings.menuScrollSpeed * elapsed * 60;
        super.update(elapsed);
    }
}