package states;

import backend.FlappyButton;
import backend.FlappySettings;
import backend.FlappyState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import objects.Background;
import objects.Bird;
import objects.CameraObject;
import objects.Object;
import states.EditorState.LevelData;
import substates.GameOverSubstate;
import substates.PauseSubstate;

class PlayState extends FlappyState
{
	var bg:Background;
	var bird:Bird;

	var grpObjects:FlxTypedGroup<Object>;

	var camFollow:CameraObject;
	var pauseButton:FlappyButton;
	var pointsTxt:FlxText;

	var scrollSpeed:Float = 4;
	var points:Int = 0;
	var startCamPosX:Float = 0;

	public static var editorMode:Bool = false;
	public static var levelData:LevelData;

	public var started:Bool = false;
	
	override function create()
	{
		if (editorMode)
			MenuState.camPosX = 0;

		startCamPosX = MenuState.camPosX;

		bg = new Background();
        add(bg);

		grpObjects = new FlxTypedGroup<Object>();
		bg.backObjects.add(grpObjects);

		loadLevel();

		bird = new Bird(50, 50);
		bird.scrollFactor.set();
		bg.backObjects.add(bird);

		var buttonName:String = 'pause';
		if (editorMode)
			buttonName = 'exit';

		var testButton:FlappyButton = new FlappyButton(0, 0, 'pause');

		pauseButton = new FlappyButton(0, 0, buttonName);
		pauseButton.scale.set(2, 2);
		pauseButton.updateHitbox();
		pauseButton.x = testButton.width / 2;
		pauseButton.y = testButton.height / 2;
		if (editorMode)
			pauseButton.onClicked = editor;
		else
			pauseButton.onClicked = pause;
		pauseButton.visible = false;
		pauseButton.active = false;
		add(pauseButton);

		pointsTxt = new FlxText(pauseButton.x, pauseButton.y + 32, 0, '', 24);
		pointsTxt.setFormat(Paths.fontFile(Paths.fonts.get('default')), 24, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		pointsTxt.borderSize = 2;
		pointsTxt.scrollFactor.set();
		pointsTxt.visible = false;
		pointsTxt.active = false;
		add(pointsTxt);

		camFollow = new CameraObject();
		camFollow.screenCenter();
        camFollow.x = MenuState.camPosX;
		camFollow.y -= 12;

		new FlxTimer().start(1, function(_){
			var getReady:FlxSprite = new FlxSprite();
			getReady.loadGraphic(Paths.imageFile('getReady'));
			getReady.setGraphicSize(Std.int(getReady.width * 3));
			getReady.scrollFactor.set();
			getReady.screenCenter();
			add(getReady);

			fadeObject(getReady, true);

			new FlxTimer().start(2, function(_){
				fadeObject(getReady, false);
				start();
			});
		});

		super.create();
	}

	function loadLevel()
	{
		levelData = FlappySettings.levelJson;

		while (grpObjects.length > 0)
		{
			grpObjects.remove(grpObjects.members[0], true);
		}

		if (levelData == null) return;

		scrollSpeed = levelData.scrollSpeed;

		for (item in levelData.objects)
		{
			var add:Float = 0;

			if (levelData != null)
			{
				add = 225 * levelData.scrollSpeed;
			}

			add += startCamPosX;

			var object:Object = new Object(item.x + add, item.y, item.name);
			object.scaleMulti = item.scale;
			object.flipped = item.flipped;
			object.variables = item.variables;
			grpObjects.add(object);
		}
	}

	function die(playHitSound:Bool = true)
	{
		if (editorMode)
		{
			editor();
			return;
		}

		bird.killBird(playHitSound);
		remove(pauseButton, true);
		remove(pointsTxt, true);
	}

	function point(amount:Int = 1)
	{
		points += amount;
		FlxG.sound.play(Paths.soundFile(Paths.sounds.get('point')));
	}

	function start()
	{
		pointsTxt.active = true;
		pointsTxt.visible = true;

		pauseButton.active = true;
		pauseButton.visible = true;

		bird.startMoving = true;

		started = true;
	}

	function checkDeath()
	{
		var grounded:Bool = bird.overlaps(bg.ground);

		if (!bird.isDead)
		{
			if (bird.y < 0 - bird.height)
			{
				die(true);
			}

			for (object in grpObjects.members)
			{
				if (object.canCollide)
				{
					if (FlxCollision.pixelPerfectCheck(object, bird, 0))
					{
						die(true);
						break;
					}
				}
			}
		}

		if (grounded && !bird.isSinking)
		{
			die(false);
			bird.sink();
		}
	}

	function checkSpecialObjects()
	{
		var removeList:Array<Object> = [];

		for (object in grpObjects.members)
		{
			if (object.getScreenPosition().x < 0 - (object.width / 2))
			{
				removeList.push(object);
			}

			if (bird.x > object.getScreenPosition().x - (bird.width / 2))
			{
				if (object.variables.length > 0)
				{
					for (i in 0...object.variables.length)
					{	
						var varr:Array<Dynamic> = object.variables[i];

						switch (varr[0])
						{
							case 'points':
								point(Std.int(varr[1]));
						}
					}
				}

				switch (object.objectName)
				{
					case 'point':
						removeList.push(object);
				}
			}
		}

		for (object in removeList)
			grpObjects.remove(object, true);
	}

	function pause()
	{
		pauseButton.visible = false;
		pointsTxt.visible = false;
		openSubState(new PauseSubstate());

		persistentUpdate = false;
	}

	function editor()
	{
		FlappyState.switchState(new EditorState(levelData));
	}

	override function update(elapsed:Float)
	{
		if (!bird.isDead)
		{
			camFollow.x += scrollSpeed;
			MenuState.camPosX = camFollow.x;

			if (started)
			{
				if (keys.FLAP || (FlxG.mouse.justPressed && !pauseButton.mouseOver))
				{
					bird.flap();
				}
	
				if (keys.PAUSE && !editorMode)
					pause();
	
				if (keys.BACK && editorMode)
					editor();
			}
		}

		checkDeath();
		checkSpecialObjects();

		pointsTxt.text = Std.string(points);

		super.update(elapsed);

		if (bird.isDead && bird.isSinking && bird.y > FlxG.height - bg.ground.height + 15)
		{
			persistentUpdate = false;
			openSubState(new GameOverSubstate(points));
		}
	}

	override function closeSubState()
	{
		super.closeSubState();

		persistentUpdate = true;
		pauseButton.visible = true;
		pointsTxt.visible = true;
	}
}
