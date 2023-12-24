package states;

import backend.FlappyButton;
import backend.FlappyState;
import flixel.FlxSprite;
import objects.Background;

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

        var startButton:FlappyButton = new FlappyButton(0, 0, 'start');
        startButton.screenCenter();
        startButton.onClicked = function(){
            switchState(new PlayState());
        }
        add(startButton);

        super.create();
    }

    override function update(elapsed:Float)
    {
        bg.scroll(-2);
        bgPosX = bg.posX;

        super.update(elapsed);
    }
}