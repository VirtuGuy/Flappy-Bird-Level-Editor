package backend;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import objects.Background;
import objects.CameraObject;
import states.ExitState;
import states.IntroState;
import states.MenuState;
import states.OutdatedState;

class FlappyState extends FlxUIState
{
	public var doFadeInTransition:Bool = false;
	public var doFadeOutTransition:Bool = false;
	public var includeBG:Bool = true;
	public var globalCameraPos:Bool = true;
	public var fadeDuration:Float = 0.5;

	private var bg:Background;
	private var camFollow:CameraObject;
	private var keys:Keys;
	
	private var fadeMap:Map<FlxSprite, FadeHandler> = new Map<FlxSprite, FadeHandler>();
	private var fadeBlacklist:Array<Class<Dynamic>> = [
		Background
	];

	#if SCREENSHOTS
	private var screenshotBlacklist:Array<Class<FlappyState>> = [
		IntroState,
		OutdatedState,
		ExitState
	];
	#end

	override public function new(doFadeInTransition:Bool = false, doFadeOutTransition:Bool = false,
		includeBG:Bool = true, globalCameraPos:Bool = true)
	{
		super();
		this.doFadeInTransition = doFadeInTransition;
		this.doFadeOutTransition = doFadeOutTransition;
		this.includeBG = includeBG;
		this.globalCameraPos = globalCameraPos;

		keys = new Keys();

		bg = new Background();
		if (includeBG)
        	add(bg);
	}

	override public function create()
	{
		camFollow = new CameraObject(globalCameraPos);

		super.create();

		if (this.doFadeInTransition)
			fadeObjects(true);
	}

	override public function update(elapsed:Float)
	{
		#if SCREENSHOTS
		var state:FlappyState = cast FlxG.state;
		if (keys.SCREENSHOT && !screenshotBlacklist.contains(Type.getClass(state)))
			FlappyTools.takeScreenshot();
		#end

		super.update(elapsed);

		MenuState.camPosX = camFollow.x;
	}

	// Fade functions
	public function fadeObject(object:FlxSprite, fadeIn:Bool = true, ?callback:()->Void)
	{
		if (object is FlxSprite)
		{
			if (!fadeMap.exists(object))
			{
				var fadeHandler:FadeHandler = new FadeHandler(object, function(fadeIn:Bool){
					if (fadeIn)
						fadeMap.remove(object);
					if (callback != null)
						callback();
				});
				fadeMap.set(object, fadeHandler);
			}
			fadeMap.get(object).start(fadeIn, fadeDuration);
		}
	}

	public function fadeGroup(group:Dynamic, fadeIn:Bool = true, ?callback:()->Void)
	{
		if (group is FlxGroup)
		{
			var group:FlxGroup = cast group;

			for (item in group.members)
			{
				if (item is FlxSprite)
				{
					var object:FlxSprite = cast item;
					fadeObject(object, fadeIn, callback);
				}
			}
		}
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
			else if (object is FlxGroup && !fadeBlacklist.contains(Type.getClass(object)))
			{
				var group:FlxGroup = cast object;
				fadeGroup(group, fadeIn);
			}
		}
	}

	// Sprite toggling
	public function toggleSprite(sprite:FlxBasic, toggle:Bool = true, keepVisibility:Bool = false)
	{
		if (!keepVisibility)
			sprite.visible = toggle;
		sprite.active = toggle;
	}

	public function toggleSprites(sprites:Array<FlxBasic>, toggle:Bool = true,
		keepVisibility:Bool = false)
	{
		for (sprite in sprites)
			toggleSprite(sprite, toggle, keepVisibility);
	}

	public function stateSwitching(nextState:FlxState)
	{
		// In case if you want something to happen when the state switches
	}

	public static function doSwitch(nextState:FlxState)
	{
		FlappySettings.lastState = FlxG.state;
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
				doSwitch(nextState);
		}
		else
			doSwitch(nextState);
	}
}
