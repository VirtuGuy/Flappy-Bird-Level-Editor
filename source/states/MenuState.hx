package states;

import backend.FlappySettings;
import backend.FlappyState;
import backend.FlappyTools;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import objects.Background;
import objects.ButtonGroup;
import objects.CameraObject;

class MenuState extends FlappyState
{
    var bg:Background;

    var messageBox:FlxSprite;
    var messageText:FlxText;

    var camFollow:CameraObject;
    var grpButtons:ButtonGroup;

    var buttons:Array<String> = [
        'start',
        'editor',
        'options',
        #if desktop
        'exit'
        #end
    ];

    var buttonCallbacks:Array<Void->Void> = [
        function() {
            FlappyState.switchState(new PlayState());
        },
        function() {
            FlappyState.switchState(new EditorState());
        },
        function() {
            FlappyState.switchState(new OptionsState());
        },
        #if desktop
        function() {
            FlappyState.switchState(new ExitState());
        }
        #end
    ];

    public static var camPosX:Float = 0;

    override public function new()
    {
        super(true, true);
    }

    override function create()
    {
        PlayState.editorMode = false;

        FlappySettings.levelJson = FlappyTools.loadJSON(Paths.levelFile('custom', 'testlevel'));

        bg = new Background();
        add(bg);

        var title:FlxSprite = new FlxSprite();
        title.loadGraphic(Paths.imageFile('title'));
        title.setGraphicSize(Std.int(title.width * 3));
        title.updateHitbox();
        title.screenCenter(X);
        title.y = title.height - 30;
        title.scrollFactor.set();
        add(title);

        var levelEditorTxt:FlxText = new FlxText(0, 0, 0, 'Level Editor', 32);
        levelEditorTxt.setFormat(Paths.fontFile(Paths.fonts.get('default')), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        levelEditorTxt.borderSize = 2;
        levelEditorTxt.screenCenter(X);
        levelEditorTxt.y = title.y + (title.height / 2) + levelEditorTxt.height;
        levelEditorTxt.scrollFactor.set();
        add(levelEditorTxt);

        var versionTxt:FlxText = new FlxText(2, 0, 0, '', 18);

        versionTxt.text = 'Made by AbsurdCoolMan'
        + '\nFlappy Bird by Dong Nguyen'
        + '\n' + Init.curVersion;

        versionTxt.y = FlxG.height - (versionTxt.height - 16);

        versionTxt.setFormat(Paths.fontFile(Paths.fonts.get('default')), 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        versionTxt.borderSize = 1.2;
        versionTxt.scrollFactor.set();
        add(versionTxt);

        messageBox = new FlxSprite();
        messageBox.makeGraphic(FlxG.width, 25, FlxColor.fromRGBFloat(0, 0, 0, 0.8));
        messageBox.screenCenter(X);
        messageBox.scrollFactor.set();

        var message:String = FlxG.random.getObject(Init.messages);

        messageText = new FlxText(0, messageBox.y, 0, message, 24);
        messageText.setFormat(Paths.fontFile(Paths.fonts.get('default')), 24, FlxColor.WHITE, RIGHT);
        messageText.scrollFactor.set();
        messageText.x = (FlxG.width + (messageText.width / 4));

        if (message != '')
        {
            add(messageBox);
            add(messageText);
        }

        camFollow = new CameraObject();
        camFollow.screenCenter();
        camFollow.x = camPosX;
        camFollow.y -= 12;

        super.create();

        grpButtons = new ButtonGroup(buttons, Vertical, 0.5, buttonCallbacks);
        add(grpButtons);
    }

    override function update(elapsed:Float)
    {
        if (messageText.text != '')
        {
            messageText.x -= 2;
            if (messageText.x < -(FlxG.width + (messageText.width / 4)))
                messageText.x = -messageText.x;
        }

        camFollow.x += FlappySettings.menuScrollSpeed;
        camPosX = camFollow.x;

        super.update(elapsed);
    }
}