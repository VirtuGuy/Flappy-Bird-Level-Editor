package states;

import backend.FlappyData;
import backend.FlappySettings;
import backend.FlappyState;
import backend.FlappyText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import objects.ButtonGroup;

class MenuState extends FlappyState
{
    static public var camPosX:Float = 0;

    var messageBox:FlxSprite;
    var messageText:FlappyText;
    var grpButtons:ButtonGroup;

    var buttons:Array<String> = [
        'start',
        'editor',
        // 'options',
        #if desktop
        'exit'
        #end
    ];

    var eraseDataTime:Float = 0;

    override public function new()
    {
        super(true, true);
    }

    override function create()
    {
        PlayState.editorMode = false;

        var title:FlxSprite = new FlxSprite();
        title.loadGraphic(Paths.imageFile('title'));
        title.setGraphicSize(Std.int(title.width * 3));
        title.updateHitbox();
        title.screenCenter(X);
        title.y = title.height - 30;
        title.scrollFactor.set();
        add(title);

        var levelEditorTxt:FlappyText = new FlappyText(0, 0, 0, 'Level Editor', 32, CENTER);
        levelEditorTxt.screenCenter(X);
        levelEditorTxt.y = title.y + (title.height / 2) + levelEditorTxt.height;
        add(levelEditorTxt);

        var versionTxt:FlappyText = new FlappyText(2, 0, 0, '', 18);
        versionTxt.borderSize = 1.2;
        versionTxt.text = 'Made by VirtuGuy'
        + '\nFlappy Bird by Dong Nguyen'
        + '\n${Init.curVersion}';
        versionTxt.y = FlxG.height - versionTxt.height;
        add(versionTxt);

        var eraseDataTxt:FlappyText = new FlappyText(0, 0, 0, 'Hold ESC to erase data!', 18, RIGHT);
        eraseDataTxt.borderSize = 1.2;
        eraseDataTxt.x = FlxG.width - eraseDataTxt.width;
        eraseDataTxt.y = FlxG.height - eraseDataTxt.height;
        add(eraseDataTxt);

        #if MESSAGES
        messageBox = new FlxSprite();
        messageBox.makeGraphic(FlxG.width, 25, FlxColor.fromRGBFloat(0, 0, 0, 0.8));
        messageBox.screenCenter(X);
        messageBox.scrollFactor.set();

        var message:Null<String> = FlxG.random.getObject(Init.messages);
        messageText = new FlappyText(0, messageBox.y, 0, message, 24);
        messageText.borderColor = FlxColor.TRANSPARENT;
        messageText.x = (FlxG.width + (messageText.width / 4));

        if (message != null && message != '')
        {
            add(messageBox);
            add(messageText);
        }
        #end

        super.create();

        grpButtons = new ButtonGroup(buttons, Vertical, 0.5);
        grpButtons.members[0].onClicked = function(){
            FlappyState.switchState(new LevelSelectionState());
        }
        grpButtons.members[1].onClicked = function(){
            FlappyState.switchState(new EditorState());
        }
        /*
        grpButtons.members[2].onClicked = function(){
            FlappyState.switchState(new OptionsState());
        }
        */
        #if desktop
        grpButtons.members[2].onClicked = function(){
            FlappyState.switchState(new ExitState());
        }
        #end

        add(grpButtons);
    }

    override function update(elapsed:Float)
    {
        if (messageText.text != '')
        {
            messageText.x -= 2 * elapsed * 60;
            if (messageText.x < -(FlxG.width + messageText.width))
                messageText.x = -messageText.x;
        }

        camFollow.x += FlappySettings.menuScrollSpeed * elapsed * 60;

        // Erase data
        if (FlxG.keys.pressed.ESCAPE)
        {
            eraseDataTime += elapsed;
            if (eraseDataTime > 1)
            {
                FlxG.resetState();
                FlappyData.eraseData();
            }
        }
        else
            eraseDataTime = 0;

        super.update(elapsed);
    }
}