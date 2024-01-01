package substates;

import backend.FlappyState;
import backend.FlappySubstate;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import objects.ButtonGroup;
import states.MenuState;

class CompleteSubstate extends FlappySubstate
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
    
    override public function new(points:Int)
    {
        super();

        var bg:FlxSprite = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.screenCenter();
        bg.scrollFactor.set();
        add(bg);

        grpButtons = new ButtonGroup(buttons, Vertical, 1.5, buttonCallbacks);
        add(grpButtons);

        var gameCompleteText:FlxSprite = new FlxSprite();
        gameCompleteText.loadGraphic(Paths.imageFile('gameComplete'));
        gameCompleteText.setGraphicSize(Std.int(gameCompleteText.width * 1.5));
        gameCompleteText.updateHitbox();
        gameCompleteText.screenCenter();
        gameCompleteText.y -= 120;
        gameCompleteText.scrollFactor.set();
        add(gameCompleteText);

        var finalScoreText:FlxText = new FlxText(0, 0, 0, 'Final Score: $points', 32);
        finalScoreText.setFormat(Paths.fontFile(Paths.fonts.get('default')), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        finalScoreText.borderSize = 2;
        finalScoreText.screenCenter(X);
        finalScoreText.y = FlxG.height - (finalScoreText.height + 35);
        finalScoreText.scrollFactor.set();
        add(finalScoreText);

        bg.alpha = 0;
        gameCompleteText.alpha = 0;
        finalScoreText.alpha = 0;

        FlxTween.tween(bg, {alpha: 0.65}, 0.4, {ease: FlxEase.quadInOut});
        FlxTween.tween(gameCompleteText, {alpha: 1}, 0.4, {startDelay: 0.5, ease: FlxEase.quadInOut});
        FlxTween.tween(finalScoreText, {alpha: 1}, 0.4, {startDelay: 1, ease: FlxEase.quadInOut});
    }
}