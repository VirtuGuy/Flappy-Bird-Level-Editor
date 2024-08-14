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
import states.PlayState;

class PauseSubstate extends FlappySubstate
{
    var grpButtons:ButtonGroup;
    var buttons:Array<String> = [
        'resume',
        'restart',
        'menu'
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

        grpButtons = new ButtonGroup(buttons, Vertical, 0);
        grpButtons.members[0].onClicked = function(){
            close();
        }
        grpButtons.members[1].onClicked = function(){
            FlappyState.resetState();
        }
        grpButtons.members[2].onClicked = function(){
            PlayState.infiniteMode = false;
            FlappyState.switchState(new MenuState());
        }

        add(grpButtons);
        grpButtons.setButtonClickSFX(0, false);

        FlxTween.tween(bg, {alpha: 0.65}, 0.4, {ease: FlxEase.quadInOut});
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}