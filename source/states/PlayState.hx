package states;

import backend.FlappySettings;
import backend.FlappyState;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import objects.Background;
import objects.Bird;
import objects.Pipe;
import substates.PauseSubstate;

class PlayState extends FlappyState
{
	var bg:Background;
	var bird:Bird;

	var grpPipes:FlxTypedGroup<Pipe>;
	
	override function create()
	{
		bg = new Background();
        bg.setPosX(MenuState.bgPosX);
        add(bg);

		grpPipes = new FlxTypedGroup<Pipe>();
		bg.backObjects.add(grpPipes);

		bird = new Bird(50, 50);
		bird.scrollFactor.set();
		bg.backObjects.add(bird);

		super.create();
	}

	function die()
	{
		bird.killBird();
		
		for (pipe in grpPipes.members)
		{
			pipe.speed.x = 0;
		}
	}

	function checkDeath()
	{
		if (bird.y < 0 - bird.height)
		{
			die();
		}
	}

	override function update(elapsed:Float)
	{
		if (!bird.isDead)
		{
			bg.scroll(-FlappySettings.scrollSpeed);

			if (keys.GAME_FLAP || FlxG.mouse.justPressed)
			{
				bird.flap();
			}

			if (keys.UI_BACK)
			{
				persistentUpdate = false;
				openSubState(new PauseSubstate());
			}

			checkDeath();
		}

		super.update(elapsed);
	}

	override function closeSubState()
	{
		super.closeSubState();

		persistentUpdate = true;
	}
}
