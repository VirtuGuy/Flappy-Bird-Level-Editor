package states;

import backend.FlappyState;
import flixel.FlxG;
import objects.Background;
import objects.Bird;
import substates.PauseSubstate;

class PlayState extends FlappyState
{
	var bg:Background;
	var bird:Bird;
	
	override function create()
	{
		bg = new Background();
        bg.setPosX(MenuState.bgPosX);
        add(bg);

		bird = new Bird(50, 50, 'default');
		bird.scrollFactor.set();
		bg.backSprites.add(bird);

		super.create();
	}

	override function update(elapsed:Float)
	{
		bg.scroll(-2);

		if (keys.GAME_FLAP || FlxG.mouse.justPressed)
		{
			bird.flap();
		}

		if (keys.UI_BACK)
		{
			persistentUpdate = false;
			openSubState(new PauseSubstate());
		}

		super.update(elapsed);
	}

	override function closeSubState()
	{
		super.closeSubState();

		persistentUpdate = true;
	}
}
