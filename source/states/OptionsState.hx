package states;

import backend.FlappyTools;
import options.FlappyCheckbox;
import options.FlappyOption;
import objects.FlappyButton;
import backend.FlappySettings;
import backend.FlappyState;
import objects.FlappyText;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class OptionsState extends FlappyState
{
    var grpOptions:FlxTypedGroup<FlappyOption>;

    var curCategory:String = 'gameplay';
    var options:Array<Dynamic> = [
        ['classic mode', 'classic'],
        ['mute sfx', 'muteSFX'],
        ['bird skin', 'birdSkin', FlappyTools.getTextAsArray(Paths.textFile('data/skinsList'))],
        ['debug features', 'debug']
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
            var option:Array<Dynamic> = options[i];
            var metadata:Array<Dynamic> = option[2] ?? [];
            grpOptions.add(new FlappyOption(30, 80 + (45 * i), option[0], option[1], metadata));
        }

        super.create();
    }

    override function update(elapsed:Float)
    {
        camFollow.x += FlappySettings.menuScrollSpeed * elapsed * 60;
        super.update(elapsed);
    }
}