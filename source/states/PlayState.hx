package states;

import backend.FlappyButton;
import backend.FlappySettings;
import backend.FlappyState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import objects.Background;
import objects.Bird;
import objects.CameraObject;
import objects.Pipe;
import substates.GameOverSubstate;
import substates.PauseSubstate;

class PlayState extends FlappyState
{
	var bg:Background;
	var bird:Bird;

	var grpObjects:FlxTypedGroup<FlxSprite>;
	var grpPipes:FlxTypedGroup<Pipe>;

	var camFollow:CameraObject;
	var pauseButton:FlappyButton;

	public static var editorMode:Bool = false;
	
	override function create()
	{
		bg = new Background();
        add(bg);

		grpObjects = new FlxTypedGroup<FlxSprite>();
		bg.backObjects.add(grpObjects);

		grpPipes = new FlxTypedGroup<Pipe>();

		bird = new Bird(50, 50);
		bird.scrollFactor.set();
		bg.backObjects.add(bird);

		pauseButton = new FlappyButton(0, 0, 'pause');

		pauseButton.setGraphicSize(13, 14);
		pauseButton.updateHitbox();

		pauseButton.setGraphicSize(Std.int(pauseButton.width * 2));
		pauseButton.updateHitbox();
		pauseButton.x = pauseButton.width / 2;
		pauseButton.y = pauseButton.height / 2;

		pauseButton.onClicked = pause;
		
		if (!editorMode)
			add(pauseButton);

		camFollow = new CameraObject();
        camFollow.screenCenter();
		camFollow.x = MenuState.camPosX;
		camFollow.y -= 12;

		super.create();
	}

	function die(playHitSound:Bool = true)
	{
		bird.killBird(playHitSound);
		remove(pauseButton, true);
		
		for (pipe in grpPipes.members)
		{
			pipe.velocity.x = 0;
		}
	}

	function checkDeath()
	{
		var grounded:Bool = bird.overlaps(bg.ground);

		if (bird.y < 0 - bird.height && !bird.isDead)
		{
			die(true);
		}

		if (grounded && !bird.isSinking)
		{
			die(false);
			bird.sink();
		}
	}

	function pause()
	{
		pauseButton.visible = false;
		openSubState(new PauseSubstate());

		persistentUpdate = false;
	}

	override function update(elapsed:Float)
	{
		if (!bird.isDead)
		{
			camFollow.x += FlappySettings.scrollSpeed;

			if (keys.FLAP || (FlxG.mouse.justPressed && !pauseButton.mouseOver))
			{
				bird.flap();
			}

			if (keys.PAUSE)
				pause();
		}

		checkDeath();

		super.update(elapsed);

		if (bird.isDead && bird.isSinking && bird.y > FlxG.height - bg.ground.height + 15)
		{
			persistentUpdate = false;
			openSubState(new GameOverSubstate());
		}
	}

	override function closeSubState()
	{
		super.closeSubState();

		persistentUpdate = true;
		pauseButton.visible = true;
	}
}
