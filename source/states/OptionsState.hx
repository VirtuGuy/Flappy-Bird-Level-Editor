package states;

import backend.FlappyButton;
import backend.FlappySettings;
import backend.FlappyState;
import backend.FlappyText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class OptionsState extends FlappyState
{
    var grpButtons:FlxTypedGroup<FlappyButton>;

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

        grpButtons = new FlxTypedGroup<FlappyButton>();
        add(grpButtons);

        var backButton:FlappyButton = new FlappyButton(0, 0, 'back');
        backButton.clickSound = true;
        backButton.screenCenter(X);
        backButton.y = FlxG.height - (backButton.height + 10);
        add(backButton);

        backButton.onClicked = function(){
            FlappyState.switchState(new MenuState());
        }

        super.create();
    }

    override function update(elapsed:Float)
    {
        camFollow.x += FlappySettings.menuScrollSpeed;
        MenuState.camPosX = camFollow.x;

        super.update(elapsed);
    }
}