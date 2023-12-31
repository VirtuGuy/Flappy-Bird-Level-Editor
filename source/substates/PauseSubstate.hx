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

class PauseSubstate extends FlappySubstate
{
    var grpButtons:ButtonGroup;

    var buttons:Array<String> = [
        'resume',
        'restart',
        'menu'
    ];

    var buttonCallbacks:Array<Void->Void> = [
        function() {
            FlappyState.switchState(FlxG.state);
        },
        function() {
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
        bg.alpha = 0;
        add(bg);

        // Had to insert it cuz it was getting errors
        buttonCallbacks.insert(0, function(){
            close();
        });

        grpButtons = new ButtonGroup(buttons, Vertical, 0, buttonCallbacks);
        add(grpButtons);

        grpButtons.setButtonClickSFX(0, false);

        FlxTween.tween(bg, {alpha: 0.65}, 0.4, {ease: FlxEase.quadInOut});
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}