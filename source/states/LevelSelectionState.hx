package states;

import backend.FlappyButton;
import backend.FlappyData;
import backend.FlappySettings;
import backend.FlappyState;
import backend.FlappyText;
import flixel.FlxG;
import objects.Background;
import objects.ButtonGroup;
import objects.CameraObject;

using StringTools;
#if sys
import sys.FileSystem;
#end

class LevelSelectionState extends FlappyState
{
    var bg:Background;
    var camFollow:CameraObject;
    var titleText:FlappyText;
    var backButton:FlappyButton;

    var buttons:Array<String> = [
        'levels',
        'custom',
        'infinite'
    ];
    var grpButtons:ButtonGroup;

    override public function new()
    {
        super(true, true);
    }
    
    override function create()
    {
        bg = new Background();
        add(bg);

        camFollow = new CameraObject();

        titleText = new FlappyText(0, 0, 0, 'Level Selection', 32, CENTER);
        titleText.screenCenter(X);
        titleText.y = titleText.height - 20;
        add(titleText);

        backButton = new FlappyButton(0, 0, 'back');
        backButton.clickSound = true;
        backButton.screenCenter(X);
        backButton.y = FlxG.height - (backButton.height + 10);
        add(backButton);

        backButton.onClicked = function(){
            FlappyState.switchState(new MenuState());
        }

        var highscoreTxt:FlappyText = new FlappyText(0, 0, 0, '', 24, CENTER);
        highscoreTxt.text = 'Infinite Mode Score: ${FlappyData.getData('infiniteScore')}';
        highscoreTxt.screenCenter(X);
        highscoreTxt.y = FlxG.height - (highscoreTxt.height + 70);
        add(highscoreTxt);

        super.create();

        grpButtons = new ButtonGroup(buttons, Vertical, 0.5);
        grpButtons.members[2].onClicked = function(){
            PlayState.infiniteMode = true;
            FlappyState.switchState(new PlayState());
        }
        add(grpButtons);
    }

    override function update(elapsed:Float)
    {
        camFollow.x += FlappySettings.menuScrollSpeed;
        MenuState.camPosX = camFollow.x;

        super.update(elapsed);
    }
}