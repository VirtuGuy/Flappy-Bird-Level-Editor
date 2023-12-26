package backend;

import flixel.FlxG;

class FlappyTools
{
    public static function openURL(url:String = '')
    {
        #if linux
        Sys.command('/usr/bin/xdg-open', [
            url,
            "&"
        ]);
        #else
        FlxG.openURL(url);
        #end
    }
}