package backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import objects.Background;
import objects.ButtonGroup;
import objects.CameraObject;

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

	public function fadeObject(object:FlxSprite, fadeIn:Bool = true)
	{
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

	public function fadeObjects(fadeIn:Bool = true)
	{
		for (object in members)
		{
			if (object is FlxSprite)
			{
				var object:FlxSprite = cast object;
				fadeObject(object, fadeIn);
			}
			else if (object is FlxGroup && !(object is Background))
			{
				var group:FlxGroup = cast object;
				
				for (item in group.members)
				{
					if (item is FlxSprite)
					{
						var object:FlxSprite = cast item;
						fadeObject(object, fadeIn);
					}
				}
			}
		}
	}

	public function stateSwitching(nextState:FlxState)
	{
		// In case if you want something to happen when the state switches
	}

	public static function doSwitch(nextState:FlxState)
	{
		if (FlxG.state != nextState)
			FlxG.switchState(nextState);
		else
			FlxG.resetState();
	}

	public static function switchState(nextState:FlxState)
	{
		if (FlxG.state is FlappyState)
		{
			var currentState:FlappyState = cast FlxG.state;

			currentState.stateSwitching(nextState);

			if (currentState.doFadeOutTransition)
			{
				currentState.fadeObjects(false);

				currentState.persistentUpdate = false;
				new FlxTimer().start(currentState.fadeDuration + 0.15, function(_){
					doSwitch(nextState);
				});
			}
			else
			{
				doSwitch(nextState);
			}
		}
		else
		{
			doSwitch(nextState);
		}
	}
}
