package substates;

import backend.FlappyState;
import backend.FlappySubstate;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import objects.ButtonGroup;
import states.MenuState;

class GameOverSubstate extends FlappySubstate
{
    var grpButtons:ButtonGroup;

    var buttons:Array<String> = [
        'restart',
        'menu'
    ];

    var buttonCallbacks:Array<Void->Void> = [
        function(){
            FlappyState.switchState(FlxG.state);
        },
        function(){
            FlappyState.switchState(new MenuState());
        }
    ];

    override public function new()
    {
        super();

        var bg:FlxSprite = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.screenCenter();
        bg.scrollFactor.set();
        add(bg);

        var gameoverText:FlxSprite = new FlxSprite();
        gameoverText.loadGraphic(Paths.imageFile('gameover'));
        gameoverText.setGraphicSize(Std.int(gameoverText.width * 3));
        gameoverText.updateHitbox();
        gameoverText.screenCenter();
        gameoverText.y -= 120;
        gameoverText.scrollFactor.set();
        add(gameoverText);

        grpButtons = new ButtonGroup(buttons, 1, buttonCallbacks);
        add(grpButtons);

        bg.alpha = 0;
        gameoverText.alpha = 0;

        FlxTween.tween(bg, {alpha: 0.65}, 0.4, {ease: FlxEase.quadInOut});
        FlxTween.tween(gameoverText, {alpha: 1}, 0.4, {startDelay: 0.5, ease: FlxEase.quadInOut});
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}