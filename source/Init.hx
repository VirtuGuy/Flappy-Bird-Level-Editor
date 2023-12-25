package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import states.IntroState;

class Init extends FlxState
{
    var loadedFiles:Int = 0;
    var totalFiles:Int = 0;

    override function create()
    {
        FlxG.mouse.useSystemCursor = true;

        var text:FlxText = new FlxText(0, 0, 0, 'Loading...', 32);
        text.setFormat(Paths.fontFile(Paths.textures.get('font')), 32, FlxColor.WHITE, CENTER);
        text.screenCenter();
        add(text);

        startCaching();

        super.create();
    }

    function startCaching()
    {
        Paths.dumpCache();

        // BG
        loadImage(Paths.textures.get('bgSky'));
        loadImage(Paths.textures.get('bgGround'));

        // Player skins
        loadImage('playerSkins/default');

        // Buttons
        loadImage('buttons/start');

        // Objects
        loadImage(Paths.textures.get('pipe'));

        // Other
        loadImage('title');

        // Sounds
        loadSound(Paths.sounds.get('wing'), false);
        loadSound(Paths.sounds.get('hit'), false);
        loadSound(Paths.sounds.get('point'), false);
        loadSound(Paths.sounds.get('swooshing'), false);
    }

    function loadImage(key:String)
    {
        totalFiles++;

        var path:String = Paths.imagePath(key);
        Paths.imageFile(key);

        var loaded:Bool = false;

        while (!loaded)
        {
            if (Paths.imageCache.exists(path))
            {
                loaded = true;
                loadedFiles++;
            }
        }
    }

    function loadSound(key:String, isMusic:Bool = false)
    {
        totalFiles++;

        var path:String = Paths.soundPath(key, isMusic);
        Paths.soundFile(key, isMusic);

        var loaded:Bool = false;

        while (!loaded)
        {
            if (Paths.soundCache.exists(path))
            {
                loaded = true;
                loadedFiles++;
            }
        }
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (loadedFiles >= totalFiles)
        {
            boot();
        }
    }

    function boot()
    {
        FlxG.switchState(new IntroState());
    }
}