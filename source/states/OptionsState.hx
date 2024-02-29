package states;

import backend.FlappyButton;
import backend.FlappySettings;
import backend.FlappyState;
import backend.FlappyText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import objects.Background;
import objects.CameraObject;

class OptionsState extends FlappyState
{
    var bg:Background;
    var camFollow:CameraObject;

    var grpButtons:FlxTypedGroup<FlappyButton>;

    override public function new()
    {
        super(true, true);
    }
    
    override function create()
    {
        bg = new Background();
        add(bg);

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
            FlxG.sound.play(Paths.soundFile(Paths.getSound('swooshing')));
            FlappyState.switchState(new MenuState());
        }

        camFollow = new CameraObject();

        super.create();
    }

    override function update(elapsed:Float)
    {
        camFollow.x += FlappySettings.menuScrollSpeed;
        MenuState.camPosX = camFollow.x;

        super.update(elapsed);
    }
}