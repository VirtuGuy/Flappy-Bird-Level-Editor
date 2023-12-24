package backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class FlappyState extends FlxUIState
{
	private var keys:Keys;

	public var doFadeTransition:Bool = false;

	override public function new(doFadeTransition:Bool = false)
	{
		keys = new Keys();

		super();

		this.doFadeTransition = doFadeTransition;
	}

	override public function create()
	{
		super.create();
	}

	public function switchState(nextState:FlappyState)
	{
		var duration:Float = 0.385;

		if (doFadeTransition)
		{
			var objectCount:Int = 0;

			for (object in members)
			{
				if (object is FlxSprite)
				{
					objectCount++;

					var object:FlxSprite = cast object;
					FlxTween.tween(object, {alpha: 0, y: object.y - 20}, duration);
				}
			}

			if (objectCount > 0)
			{
				persistentUpdate = false;
				new FlxTimer().start(duration, function(_){
					FlxG.switchState(nextState);
				});
			}
			else
				FlxG.switchState(nextState);
		}
		else
		{
			FlxG.switchState(nextState);
		}
	}
}
