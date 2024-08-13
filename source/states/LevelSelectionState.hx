package states;

import flixel.util.FlxColor;
import backend.FlappyButton;
import backend.FlappyData;
import backend.FlappySettings;
import backend.FlappyState;
import backend.FlappyText;
import backend.FlappyTools;
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
    var grpLevelBoxes:FlxTypedGroup<FlxSprite>;
    var targetFolder:String = 'default';
    var curSelected:Int = 0;

    override public function new()
    {
        super(true, true);
    }
    
    override function create()
    {
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

        // Level selection boxes group
        grpLevelBoxes = new FlxTypedGroup<FlxSprite>();
        add(grpLevelBoxes);

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
            FlappySettings.levelJson = null;
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
                var levelText:FlappyText = new FlappyText(0, 0, 0, item, 24);
                levelText.selectionItem = true;
                levelText.selectionIndex = i;

                var selectionBox:FlxSprite = new FlxSprite();
                var sw:Int = Std.int(levelText.width + 250);
                var sh:Int = Std.int(levelText.height);
                selectionBox.makeGraphic(sw, sh, FlxColor.BLACK);
                selectionBox.alpha = 0.9;
                selectionBox.scrollFactor.set();
                levelText.selectionBox = selectionBox;
                grpLevelBoxes.add(selectionBox);

                levelText.posSelectionItem();

                grpLevels.add(levelText);
                levels.push(item);
                i++;
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
            toggleSprite(grpLevelButtons);
            fadeGroup(grpLevelButtons);
            changeSelection();
        }
    }

    function unloadLevels()
    {
        fadeObject(highscoreTxt);
        fadeGroup(grpButtons);
        fadeGroup(grpLevelButtons, false);

        // Fades and removes the level group members to help save memory
        fadeGroup(grpLevels, false, function(){
            FlappyTools.clearGroup(grpLevels);
        });
        fadeGroup(grpLevelBoxes, false, function(){
            FlappyTools.clearGroup(grpLevelBoxes);
        });
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

            var i:Int = 0;
            for (item in grpLevels.members)
            {
                item.selectionIndex = i - curSelected;
                item.alpha = (1 / Math.abs(item.selectionIndex) / 1.65) - 0.2;
                item.posSelectionItem();
                i++;
            }
        }
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
        super.destroy();
    }
}