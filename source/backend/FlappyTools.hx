package backend;

import flixel.FlxG;
import haxe.Json;

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

    public static function loadJSON(path:String):Dynamic
    {
        var json:Dynamic = null;

        if (Paths.fileExists(path))
        {
            var content:String = Paths.getText(path);
            json = Json.parse(content);
        }

        return json;
    }
}