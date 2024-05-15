package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	static public var fpsCounter:FPS;

	public function new()
	{
		super();

		addChild(new FlxGame(640, 480, Init, 60, 60, true, false));

		fpsCounter = new FPS(5, 5, 0xFFFFFF);
		#if (SHOW_FPS && !mobile)
		addChild(fpsCounter);
		#end
	}
}
