package states;

import backend.FlappyButton;
import backend.FlappySettings;
import backend.FlappyState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import objects.Background;
import objects.CameraObject;

class LevelSelectionState extends FlappyState
{
    var bg:Background;
    var camFollow:CameraObject;

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

        var titleText:FlxText = new FlxText(0, 0, 0, 'Level Selection', 24);
        titleText.setFormat(Paths.fontFile(Paths.fonts.get('default')), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        titleText.borderSize = 2;
        titleText.scrollFactor.set();
        titleText.screenCenter(X);
        titleText.y = titleText.height - 20;
        add(titleText);

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
        camFollow.x += FlappySettings.menuScrollSpeed;
        MenuState.camPosX = camFollow.x;

        super.update(elapsed);
    }
}