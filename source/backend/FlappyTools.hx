package backend;

import flixel.FlxG;
import flixel.util.FlxColor;
import haxe.Http;
import haxe.Json;
import lime.graphics.Image;

using StringTools;
#if sys
import sys.io.File;
#end

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

        if (Paths.pathExists(path))
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

    #if SCREENSHOTS
    public static function takeScreenshot()
    {
        FlxG.sound.play(Paths.soundFile('sfx_screenshot'));

        var date:String = Date.now().toString();
        date = date.replace(' ', '-').replace(':', '-');

        var screenshotName:String = 'Screenshot ($date)';
        var windowPixels:Image = FlxG.stage.window.readPixels();
        File.saveBytes(Paths.screenshotFile(screenshotName, false), windowPixels.encode());

        // Does the flash after (just in case)
        FlxG.camera.flash(FlxColor.WHITE, 0.2);
    }
    #end
}