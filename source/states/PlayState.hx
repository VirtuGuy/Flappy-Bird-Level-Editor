package states;

import backend.FlappyTools;
import objects.Background;
import backend.FlappyButton;
import backend.FlappySettings;
import backend.FlappyState;
import backend.FlappyText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.util.FlxTimer;
import objects.Bird;
import objects.Object;
import states.EditorState.LevelData;
import substates.CompleteSubstate;
import substates.GameOverSubstate;
import substates.PauseSubstate;

class PlayState extends FlappyState
{
	static public var editorMode:Bool = false;
	static public var infiniteMode:Bool = false;
	static public var levelData:LevelData;

	public var started:Bool = false;
	public var ending:Bool = false;
	public var birdSpeedUp:Bool = false;

	var bird:Bird;
	var grpObjects:FlxTypedGroup<Object>;
	var objects:Array<Object> = [];
	var pauseButton:FlappyButton;
	var pointsTxt:FlappyText;
	var points:Int = 0;
	var scrollSpeed:Float = 4;
	var startCamPosX:Float = 0;
	var infiniteLevelX:Float = 0;
	
	override function create()
	{
		if (editorMode)
			MenuState.camPosX = 0;
		startCamPosX = MenuState.camPosX;

		grpObjects = new FlxTypedGroup<Object>();
		bg.backObjects.add(grpObjects);

		bird = new Bird(75, 75);
		bird.scrollFactor.set();
		add(bird);

		if (!infiniteMode)
			loadLevel();
		else
			generateInfiniteSection();
		addUI();
		getReady();

		super.create();
	}

	function getReady()
	{
		new FlxTimer().start(1, function(_){
			var getReady:FlxSprite = new FlxSprite();
			getReady.loadGraphic(Paths.imageFile('getReady'));
			getReady.setGraphicSize(Std.int(getReady.width * 3));
			getReady.screenCenter();
			getReady.scrollFactor.set();
			add(getReady);

			fadeObject(getReady, true);
			new FlxTimer().start(2, function(_){
				fadeObject(getReady, false);
				start();
			});
		});
	}

	function addUI()
	{
		var buttonName:String = 'pause';
		if (editorMode)
			buttonName = 'exit';

		var posButton:FlappyButton = new FlappyButton(0, 0, 'pause');
		pauseButton = new FlappyButton(0, 0, buttonName);
		pauseButton.x = posButton.width / 2;
		pauseButton.y = posButton.height / 2;
		pauseButton.scale.set(2, 2);
		pauseButton.updateHitbox();
		if (editorMode)
			pauseButton.onClicked = editor;
		else
			pauseButton.onClicked = pause;
		add(pauseButton);

		pointsTxt = new FlappyText(pauseButton.x, pauseButton.y + 32, 0, '', 24);
		add(pointsTxt);

		toggleSprites([pauseButton, pointsTxt], false);
	}

	function loadLevel()
	{
		levelData = FlappySettings.levelJson;
		bg.backgroundName = levelData.backgroundName;
		startFakeBG();

		while (grpObjects.length > 0)
			grpObjects.remove(grpObjects.members[0], true);

		if (levelData != null)
		{
			scrollSpeed = levelData.scrollSpeed;
			for (item in levelData.objects)
			{
				var add:Float = 225 * scrollSpeed + startCamPosX;
				var object:Object = new Object(item.x + add, item.y, item.name);
				object.scaleMulti = item.scale;
				object.flipped = item.flipped;
				object.variables = item.variables;
				objects.push(object);
			}
		}
	}

	function startFakeBG()
	{
		var oldClassName:String = FlappyTools.getClassName(FlappySettings.lastState);
		var curClassName:String = FlappyTools.getClassName(FlxG.state);
		if (bg.backgroundName == 'default' || oldClassName == curClassName || editorMode) return;

		var fakeBG:Background = new Background();
		add(fakeBG);
		for (member in fakeBG.elements)
			FlxTween.tween(member, {alpha: 0}, 0.5, {ease: FlxEase.quadInOut, onComplete: function(_){
				remove(fakeBG, true);
				fakeBG.destroy();
			}});
	}

	function generateInfiniteSection(size:Int = 3)
	{
		for (_ in 0...size)
		{
			infiniteLevelX += 250;
			var y:Float = 0;
			for (i in 0...3)
			{
				var objectName:String = 'pipe';
				var flipped:Bool = false;
				switch (i)
				{
					case 0:
						y = FlxG.random.int(100, 200);
						flipped = true;
					case 1:
						objectName = 'point';
						y += 50;
					case 2:
						y += FlxG.random.int(50, 100);
				}

				var add:Float = 255 * scrollSpeed + startCamPosX;
				var object:Object = new Object(infiniteLevelX + add, y, objectName);
				object.flipped = flipped;
				if (i == 1)
					object.variables.push(['points', 1]);
				objects.push(object);
			}
		}
	}

	function die()
	{
		if (editorMode)
			editor();
		else
		{
			if (!bird.isDead)
				FlxG.camera.shake(0.02, 0.02);
			bird.killBird();
			toggleSprites([pauseButton, pointsTxt], false);
		}
	}

	function point(amount:Int = 1)
	{
		points += amount;
		FlxG.sound.play(Paths.soundFile(Paths.getSound('point')));
	}

	function start()
	{
		toggleSprites([pauseButton, pointsTxt]);

		bird.startMoving = true;
		started = true;
	}

	function end()
	{
		if (editorMode)
			editor();
		else
		{
			toggleSprites([pauseButton, pointsTxt], false);

			bird.startMoving = false;
			ending = true;

			FlxTween.tween(bird, {y: (FlxG.height / 2) - (bird.height * 2), angle: 0}, 0.4, {ease: FlxEase.quadInOut});
			for (object in grpObjects.members)
			{
				FlxTween.tween(object, {alpha: 0}, 0.2, {ease: FlxEase.quadInOut, onComplete: function(_){
					toggleSprite(object, false, true);
				}});
			}

			new FlxTimer().start(2, function(_){
				birdSpeedUp = true;
			});
		}
	}

	function pause()
	{
		toggleSprites([pauseButton, pointsTxt], false);
		openSubState(new PauseSubstate());
	}

	function editor()
	{
		FlappyState.switchState(new EditorState(levelData));
	}

	function checkDeath()
	{
		if (started && !ending)
		{
			if (!bird.isDead)
				if (bird.y < 0 - bird.height)
					die();

			var grounded:Bool = bird.overlaps(bg.ground);
			if (grounded && !bird.isDead)
				die();
		}
	}

	function triggerObject(obj:Object)
	{
		if (!obj.alreadyTriggered)
		{
			obj.alreadyTriggered = true;

			for (varr in obj.variables)
			{
				var name:String = varr[0];
				var value:String = varr[1];

				switch (name.toLowerCase())
				{
					case 'points':
						point(Std.parseInt(value));
				}
			}

			switch (obj.objectName)
			{
				case 'pipe':
					die();
				case 'end':
					end();
			}
		}
	}

	function updateObjects()
	{
		// Object list check
		var removedObjects:Array<Object> = [];
		for (obj in objects)
		{
			if (obj.isOnScreen())
			{
				grpObjects.add(obj);
				removedObjects.push(obj);
			}
		}

		// On-screen object check
		if (started && !ending)
		{
			grpObjects.forEach(function(obj:Object){
				// Despawn the object if it goes off-screen again
				if (!obj.isOnScreen())
				{
					removedObjects.push(obj);
					if (infiniteMode)
						generateInfiniteSection(1);
				}

				// Triggers the object with the different trigger modes
				switch (obj.triggerMode)
				{
					case 1:
						if (FlxCollision.pixelPerfectCheck(obj, bird, 0))
							triggerObject(obj);
					default:
						if (bird.x > obj.getScreenPosition().x - (bird.width / 2))
							triggerObject(obj);
				}
			});
		}

		// Removes objects that need to be removed
		for (obj in removedObjects)
		{
			if (objects.contains(obj))
				objects.remove(obj);
			else if (grpObjects.members.contains(obj))
				grpObjects.remove(obj, true);
		}
	}

	override function update(elapsed:Float)
	{
		if (!bird.isDead && !ending && !birdSpeedUp)
		{
			camFollow.x += scrollSpeed * elapsed * 60;

			if (started && !ending)
			{
				if (keys.FLAP || (FlxG.mouse.justPressed && !pauseButton.mouseOver))
					bird.flap();
	
				if (keys.PAUSE && !editorMode)
					pause();
	
				if (keys.BACK && editorMode)
					editor();
			}
		}

		if (birdSpeedUp && ending)
			bird.velocity.x += 25 * elapsed * 35;

		updateObjects();
		checkDeath();

		// UI update
		pointsTxt.text = Std.string(points);

		super.update(elapsed);

		// Substates
		if (bird.isDead && bird.y > FlxG.height + bird.height)
			openSubState(new GameOverSubstate(points));
		if (ending && bird.x > FlxG.width + bird.width)
			openSubState(new CompleteSubstate(points));
	}

	override function openSubState(SubState:FlxSubState)
	{
		super.openSubState(SubState);
		persistentUpdate = false;
	}

	override function closeSubState()
	{
		super.closeSubState();

		persistentUpdate = true;
		toggleSprites([pauseButton, pointsTxt]);
	}
}
