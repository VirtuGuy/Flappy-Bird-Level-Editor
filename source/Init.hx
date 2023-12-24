package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import states.MenuState;

class Init extends FlxState
{
    var loadedFiles:Int = 0;
    var totalFiles:Int = 0;

    override function create()
    {
        FlxG.mouse.useSystemCursor = true;

        var text:FlxText = new FlxText(0, 0, 0, 'Loading...', 32);
        text.alignment = CENTER;
        text.screenCenter();
        add(text);

        startCaching();

        super.create();
    }

    function startCaching()
    {
        Paths.dumpCache();

        // BG
        loadImage('background/Sky');
        loadImage('background/Ground');

        // Player skins
        loadImage('playerSkins/default');

        // Buttons
        loadImage('buttons/start');

        // Other
        loadImage('title');

        // Sounds
        loadSound('sfx_wing', false);
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
        FlxG.switchState(new MenuState());
    }
}