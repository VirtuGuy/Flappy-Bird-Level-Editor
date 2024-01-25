package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var fpsCounter:FPS;

	public function new()
	{
		super();

		addChild(new FlxGame(640, 480, Init, 60, 60, true, false));

		fpsCounter = new FPS(5, 5, 0xFFFFFF);
		#if SHOW_FPS
		addChild(fpsCounter);
		#end
	}
}
