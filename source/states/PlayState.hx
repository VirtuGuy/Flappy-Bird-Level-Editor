package states;

import backend.FlappyState;
import flixel.FlxG;
import objects.Background;
import objects.Bird;

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

		if (keys.UI_ACCEPT || FlxG.mouse.justPressed)
		{
			bird.flap();
		}

		super.update(elapsed);
	}
}
