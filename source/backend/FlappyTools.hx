package backend;

import flixel.FlxG;
import haxe.Http;
import haxe.Json;

class FlappyTools
{
    public static function openURL(url:String = '')
    {
        #if !linux
        FlxG.openURL(url);
        #else
        Sys.command('/usr/bin/xdg-open', [url, "&"]);
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

    public static function httpRequest(url:String, onData:(data:String)->Void,
        ?onError:(error:String)->Void)
    {
        var http:Http = new Http(url);
        http.onData = onData;
        http.onError = function(error:String){
            trace('HTTP request error ($error)!');
            if (onError != null)
                onError(error);
        }
        http.request();
    }
}