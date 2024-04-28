package backend;

import flixel.FlxG;
import flixel.util.FlxSave;
import haxe.Http;
import haxe.Json;
import lime.app.Application;

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

    @:access(flixel.util.FlxSave.validate)
    public static function savePath():String
    {
        var path:String = '';

        var company:String = Application.current.meta.get('company');
        var file:String = Application.current.meta.get('file');

        path = '$company/${FlxSave.validate(file)}';

        return path;
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