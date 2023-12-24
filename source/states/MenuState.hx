package states;

import backend.FlappyButton;
import backend.FlappyState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import objects.Background;
import openfl.Lib;

class MenuState extends FlappyState
{
    public static var bgPosX:Float = 0;
    var bg:Background;

    override public function new()
    {
        super(true);
    }

    override function create()
    {
        bgPosX = 0;

        bg = new Background();
        bg.setPosX(bgPosX);
        add(bg);

        var title:FlxSprite = new FlxSprite();
        title.loadGraphic(Paths.imageFile('title'));
        title.setGraphicSize(Std.int(title.width * 3));
        title.updateHitbox();
        title.screenCenter(X);
        title.y = title.height - 30;
        title.scrollFactor.set();
        add(title);

        var levelEditorTxt:FlxText = new FlxText(0, 0, 0, 'LEVEL EDITOR', 32);
        levelEditorTxt.setFormat(Paths.fontFile('04B.TTF'), 32, FlxColor.LIME, CENTER, OUTLINE, FlxColor.BLACK);
        levelEditorTxt.borderSize = 2;
        levelEditorTxt.screenCenter(X);
        levelEditorTxt.y = title.y + (title.height / 2) + levelEditorTxt.height;
        add(levelEditorTxt);

        var startButton:FlappyButton = new FlappyButton(0, 0, 'start');
        startButton.screenCenter();
        startButton.onClicked = function(){
            FlappyState.switchState(new PlayState());
        }
        add(startButton);

        var versionTxt:FlxText = new FlxText(2, FlxG.height - 20, 0, 'v' + Application.current.meta.get('version'), 18);
        versionTxt.setFormat(Paths.fontFile('04B.TTF'), 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        add(versionTxt);

        super.create();
    }

    override function update(elapsed:Float)
    {
        bg.scroll(-2);
        bgPosX = bg.posX;

        super.update(elapsed);
    }
}