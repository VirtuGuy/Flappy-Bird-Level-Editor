package backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class FlappyState extends FlxUIState
{
	private var keys:Keys;

	public var doFadeInTransition:Bool = false;
	public var doFadeOutTransition:Bool = false;
	public var fadeDuration:Float = 0.5;

	override public function new(doFadeInTransition:Bool = false, doFadeOutTransition:Bool = false)
	{
		keys = new Keys();

		super();

		this.doFadeInTransition = doFadeInTransition;
		this.doFadeOutTransition = doFadeOutTransition;
	}

	override public function create()
	{
		super.create();

		if (this.doFadeInTransition)
			fadeObjects(true);
	}

	public function fadeObjects(fadeIn:Bool = true)
	{
		for (object in members)
		{
			if (object is FlxSprite)
			{
				var object:FlxSprite = cast object;

				var pos:Float = object.y - 20;
				var alpha:Float = 0;

				if (fadeIn)
				{
					pos += 20;
					alpha = 1;

					object.y -= 20;
					object.alpha = 0;
				}

				FlxTween.tween(object, {alpha: alpha}, fadeDuration, {ease: FlxEase.quadInOut});
				FlxTween.tween(object, {y: pos}, fadeDuration, {ease: FlxEase.quadOut});
			}
		}
	}

	public static function switchState(nextState:FlappyState)
	{
		var currentState:FlappyState = cast FlxG.state;

		if (nextState == currentState)
		{
			FlxG.resetState();
			return;
		}

		if (currentState.doFadeOutTransition)
		{
			currentState.fadeObjects(false);

			currentState.persistentUpdate = false;
			new FlxTimer().start(currentState.fadeDuration + 0.15, function(_){
				FlxG.switchState(nextState);
			});
		}
		else
		{
			FlxG.switchState(nextState);
		}
	}
}
