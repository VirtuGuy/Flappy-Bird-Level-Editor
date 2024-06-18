package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	static public var fpsCounter:FPS;
	static private var framerate:Int = 144;

	public function new()
	{
		super();

		// Web cannot run at an fps higher than 60
		#if web
		framerate = 60;
		#end

		addChild(new FlxGame(0, 0, Init, framerate, framerate, true, false));

		fpsCounter = new FPS(5, 5, 0xFFFFFF);
		#if (SHOW_FPS && !mobile)
		addChild(fpsCounter);
		#end
	}
}
