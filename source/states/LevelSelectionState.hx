package states;

import backend.FlappyButton;
import backend.FlappySettings;
import backend.FlappyState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
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

    var boxBG:FlxSprite;
    var backButton:FlappyButton;

    var buttons:Array<String> = [
        'levels',
        'custom'
    ];

    var grpButtons:ButtonGroup;
    var grpTexts:FlxTypedGroup<FlxText>;

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

        boxBG = new FlxSprite();
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

        grpButtons = new ButtonGroup(buttons, Vertical, -1);
        grpButtons.members[0].onClicked = function(){
            regenLevels(true);
        }

        add(grpButtons);

        grpTexts = new FlxTypedGroup<FlxText>();
        add(grpTexts);

        #if sys
        for (folder in FileSystem.readDirectory(Paths.levelsFolder('default')))
        {
            if (Paths.fileExists(Paths.levelFile('default', folder)))
            {
                defaultLevels.push(folder);
            }
        }

        for (folder in FileSystem.readDirectory(Paths.levelsFolder('custom')))
        {
            if (Paths.fileExists(Paths.levelFile('custom', folder)))
            {
                customLevels.push(folder);
            }
        }
        #end

        defaultLevels = [
            'example-level',
            'swag',
            'cool',
            'amazing',
            'swag',
            'cool',
            'amazing',
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
            FlxG.sound.play(Paths.soundFile(Paths.sounds.get('swooshing')));

            if (grpTexts != null && grpTexts.length > 0)
            {
                degenLevels();
            }
            else
            {
                FlappyState.switchState(new MenuState());
            }
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

    function regenLevels(isDefault:Bool = true)
    {
        var levels:Array<String> = customLevels.copy();
        if (isDefault)
            levels = defaultLevels.copy();

        fadeObject(boxBG, false);
        fadeGroup(grpButtons, false);

        while (grpTexts.length > 0)
        {
            grpTexts.remove(grpTexts.members[0], true);
        }

        for (i in 0...levels.length)
        {
            var text:FlxText = new FlxText(0, 0, 0, levels[i], 24);
            text.setFormat(Paths.fontFile(Paths.fonts.get('default')), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
            text.screenCenter(X);
            text.scrollFactor.set();
            text.y = (i * 25) + 95;
            grpTexts.add(text);
        }
    }

    function degenLevels()
    {
        while (grpTexts.length > 0)
        {
            grpTexts.remove(grpTexts.members[0], true);
        }

        fadeObject(boxBG);
        fadeGroup(grpButtons);
    }
}