package states;

import backend.FlappyButton;
import backend.FlappyData;
import backend.FlappySettings;
import backend.FlappyState;
import backend.FlappyText;
import backend.FlappyTools;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import objects.ButtonGroup;

using StringTools;
#if sys
import sys.FileSystem;
#end

class LevelSelectionState extends FlappyState
{
    private var levels:Array<String> = [];
    private var levelsCamera:FlxCamera;
    private var levelsCamFollow:FlxObject;
    private var buttons:Array<String> = [
        'levels',
        'custom',
        'infinite'
    ];

    var titleText:FlappyText;
    var backButton:FlappyButton;
    var grpButtons:ButtonGroup;
    var highscoreTxt:FlappyText;

    var grpLevels:FlxTypedGroup<FlappyText>;
    var grpLevelButtons:ButtonGroup;
    var selectionArrow:FlxSprite;
    var targetFolder:String = 'default';
    var curSelected:Int = 0;

    override public function new()
    {
        super(true, true);
    }
    
    override function create()
    {
        // Camera
        levelsCamera = new FlxCamera();
        levelsCamera.bgColor.alpha = 0;
        FlxG.cameras.add(levelsCamera, false);

        levelsCamFollow = new FlxObject(0, 0, 50, 50);
        levelsCamFollow.screenCenter();

        levelsCamera.follow(levelsCamFollow, LOCKON);

        // Main screen
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
            if (grpLevels.length > 0)
                unloadLevels();
            else
                FlappyState.switchState(new MenuState());
        }

        // Level group
        grpLevels = new FlxTypedGroup<FlappyText>();
        add(grpLevels);

        // Highscore text
        highscoreTxt = new FlappyText(0, 0, 0, '', 24, CENTER);
        highscoreTxt.text = 'Infinite Mode Score: ${FlappyData.getData('infiniteScore')}';
        highscoreTxt.screenCenter(X);
        highscoreTxt.y = FlxG.height - (highscoreTxt.height + 70);
        add(highscoreTxt);

        super.create();

        grpButtons = new ButtonGroup(buttons, Vertical, 0.5);
        grpButtons.members[0].onClicked = function(){
            loadLevels();
        }
        grpButtons.members[1].onClicked = function(){
            loadLevels('custom');
        }
        grpButtons.members[2].onClicked = function(){
            PlayState.infiniteMode = true;
            FlappyState.switchState(new PlayState());
        }
        add(grpButtons);

        // Level selection screen
        grpLevelButtons = new ButtonGroup(['start', 'editor'], Vertical, -1, 1.5);
        grpLevelButtons.addPosition(200);
        grpLevelButtons.members[0].onClicked = function(){
            loadLevelAndSwitchState(false);
        }
        grpLevelButtons.members[1].onClicked = function(){
            loadLevelAndSwitchState(true);
        }
        toggleSprite(grpLevelButtons, false);
        add(grpLevelButtons);

        selectionArrow = new FlxSprite();
        selectionArrow.loadGraphic(Paths.imageFile('arrow'));
        selectionArrow.setGraphicSize(Std.int(selectionArrow.width * 2));
        selectionArrow.updateHitbox();
        toggleSprite(selectionArrow, false);
        add(selectionArrow);

        // Camera assignment
        grpLevels.cameras = [levelsCamera];
        selectionArrow.cameras = [levelsCamera];
    }

    function loadLevels(folder:String = 'default')
    {
        levels = [];
        targetFolder = folder;
        curSelected = 0;

        fadeObject(highscoreTxt, false);
        fadeGroup(grpButtons, false);

        #if sys
        var i:Int = 0;
        for (item in FileSystem.readDirectory(Paths.levelsFolder(folder)))
        {
            if (FileSystem.exists(Paths.levelFile(folder, item)))
            {
                var levelText:FlappyText = new FlappyText(40, (i * 60) + 60, 0, item, 24);
                levelText.scrollFactor.set(1, 1);
                levelText.ID = i++;
                grpLevels.add(levelText);
                levels.push(item);
            }
        }
        #end

        if (levels.length <= 0)
        {
            var noLevelsText:FlappyText = new FlappyText(0, 0, 0, 'No Levels!!', 32, CENTER);
            noLevelsText.screenCenter();
            grpLevels.add(noLevelsText);
        }
        else
        {
            toggleSprites([selectionArrow, grpLevelButtons]);
            updateSelectionArrowPos();
            fadeGroup(grpLevelButtons);
            changeSelection();
        }
    }

    function unloadLevels()
    {
        fadeObject(highscoreTxt);
        fadeGroup(grpButtons);
        fadeGroup(grpLevelButtons, false);
        toggleSprite(selectionArrow, false);
        grpLevels.clear();
    }

    function changeSelection(change:Int = 0)
    {
        if (levels.length > 0)
        {
            curSelected += change;
            if (curSelected < 0)
                curSelected = 0;
            else if (curSelected >= grpLevels.length)
                curSelected = grpLevels.length - 1;

            for (item in grpLevels.members)
            {
                if (item == getSelectedText())
                {
                    item.select();
                    levelsCamFollow.y = item.y;
                }
                else
                {
                    item.deselect();
                    item.alpha /= (Math.abs(item.ID - curSelected)) / 1.65;
                    item.alpha -= 0.2;
                }
            }
        }
    }

    function getSelectedText():FlappyText
    {
        for (item in grpLevels.members)
        {
            if (item.ID == curSelected)
                return item;
        }
        return null;
    }

    function updateSelectionArrowPos()
    {
        var item:FlappyText = getSelectedText();
        selectionArrow.setPosition(item.x + item.width + 5, item.y);
    }

    override function update(elapsed:Float)
    {
        camFollow.x += FlappySettings.menuScrollSpeed * elapsed * 60;

        if (grpLevels.length > 0 && levels.length > 0)
        {
            if (keys.UP_P || keys.DOWN_P)
                changeSelection(keys.UP_P ? -1 : 1);
            if (FlxG.mouse.wheel != 0)
                changeSelection(-FlxG.mouse.wheel);
            updateSelectionArrowPos();
        }

        super.update(elapsed);
    }

    function loadLevelAndSwitchState(isEditor:Bool = true)
    {
        if (grpLevels.length > 0 && levels.length > 0)
        {
            FlappySettings.levelJson = FlappyTools.loadJSON(Paths.levelFile(targetFolder,
                levels[curSelected]));
            if (!isEditor)
                FlappyState.switchState(new PlayState());
            else
                FlappyState.switchState(new EditorState(FlappySettings.levelJson));
        }
    }

    override function destroy()
    {
        FlxG.cameras.reset();
        super.destroy();
    }
}