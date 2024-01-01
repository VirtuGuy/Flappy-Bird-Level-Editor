package states;

import backend.FlappyButton;
import backend.FlappySettings;
import backend.FlappyState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
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

        var optionBox:FlxSprite = new FlxSprite();
        optionBox.loadGraphic(Paths.imageFile('uiBox'));
        optionBox.setGraphicSize(Std.int(optionBox.width * 3));
        optionBox.updateHitbox();
        optionBox.scrollFactor.set();
        optionBox.screenCenter();
        add(optionBox);

        grpButtons = new FlxTypedGroup<FlappyButton>();
        add(grpButtons);

        var backButton:FlappyButton = new FlappyButton(0, 0, 'back');
        backButton.clickSound = true;
        backButton.screenCenter(X);
        backButton.y = FlxG.height - (backButton.height + 10);
        add(backButton);

        backButton.onClicked = function(){
            FlxG.sound.play(Paths.soundFile(Paths.sounds.get('swooshing')));
            FlappyState.switchState(new MenuState());
        }

        camFollow = new CameraObject();
        camFollow.screenCenter();
        camFollow.x = MenuState.camPosX;
        camFollow.y -= 12;

        super.create();
    }

    override function update(elapsed:Float)
    {
        if (keys.BACK)
        {
            FlxG.sound.play(Paths.soundFile(Paths.sounds.get('swooshing')));
            FlappyState.switchState(new MenuState());
        }

        camFollow.x += FlappySettings.menuScrollSpeed;
        MenuState.camPosX = camFollow.x;

        super.update(elapsed);
    }
}