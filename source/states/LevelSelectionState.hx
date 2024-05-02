package states;

import backend.FlappyButton;
import backend.FlappySettings;
import backend.FlappyState;
import backend.FlappyText;
import flixel.FlxG;
import objects.Background;
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

    var defaultLevels:Array<String> = [];
    var customLevels:Array<String> = [];

    override public function new()
    {
        super(true, true);
    }
    
    override function create()
    {
        bg = new Background();
        add(bg);

        titleText = new FlappyText(0, 0, 0, 'Level Selection', 32, CENTER);
        titleText.screenCenter(X);
        titleText.y = titleText.height - 20;
        add(titleText);

        #if sys
        for (folder in FileSystem.readDirectory(Paths.levelsFolder('default')))
        {
            if (Paths.pathExists(Paths.levelFile('default', folder)))
            {
                defaultLevels.push(folder);
            }
        }

        for (folder in FileSystem.readDirectory(Paths.levelsFolder('custom')))
        {
            if (Paths.pathExists(Paths.levelFile('custom', folder)))
            {
                customLevels.push(folder);
            }
        }
        #end

        defaultLevels = [
            'example-level',
            'swag',
            'cool',
            'amazing'
        ];

        backButton = new FlappyButton(0, 0, 'back');
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