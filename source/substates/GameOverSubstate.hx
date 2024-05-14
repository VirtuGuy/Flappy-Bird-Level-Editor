package substates;

import backend.FlappyData;
import backend.FlappyState;
import backend.FlappySubstate;
import backend.FlappyText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import objects.ButtonGroup;
import states.MenuState;
import states.PlayState;

class GameOverSubstate extends FlappySubstate
{
    var grpButtons:ButtonGroup;
    var buttons:Array<String> = [
        'restart',
        'menu'
    ];

    override public function new(points:Int)
    {
        super();

        // Saves the highscore for infinite mode
        if (PlayState.infiniteMode)
            FlappyData.setScore('infiniteScore', points, true);

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

        grpButtons = new ButtonGroup(buttons, Vertical, 1.5);
        grpButtons.members[0].onClicked = function(){
            FlappyState.switchState(FlxG.state);
        }
        grpButtons.members[1].onClicked = function(){
            PlayState.infiniteMode = false;
            FlappyState.switchState(new MenuState());
        }

        add(grpButtons);

        var finalScoreText:FlappyText = new FlappyText(0, 0, 0, 'Final Score: $points', 32, CENTER);
        finalScoreText.screenCenter(X);
        finalScoreText.y = FlxG.height - (finalScoreText.height + 35);
        add(finalScoreText);

        bg.alpha = 0;
        gameoverText.alpha = 0;
        finalScoreText.alpha = 0;

        FlxTween.tween(bg, {alpha: 0.65}, 0.4, {ease: FlxEase.quadInOut});
        FlxTween.tween(gameoverText, {alpha: 1}, 0.4, {startDelay: 0.5, ease: FlxEase.quadInOut});
        FlxTween.tween(finalScoreText, {alpha: 1}, 0.4, {startDelay: 1, ease: FlxEase.quadInOut});
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}