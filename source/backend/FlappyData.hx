package backend;

import flixel.FlxG;

class FlappyData
{
    public static function init()
    {
        FlxG.save.bind('fble', FlappyTools.savePath());
    }

    public static function save()
    {
        FlxG.save.flush();
    }

    public static function load()
    {
        
    }

    public static function erase()
    {
        FlxG.save.erase();
    }
}