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
    inline static public function openURL(url:String = '')
    {
        #if !linux
        FlxG.openURL(url);
        #else
        Sys.command('/usr/bin/xdg-open', [url, "&"]);
        #end
    }

    inline static public function loadJSON(path:String):Dynamic
    {
        var json:Dynamic = null;

        if (Paths.pathExists(path))
        {
            var content:String = Paths.getText(path);
            json = Json.parse(content);
        }

        return json;
    }

    inline static public function httpRequest(url:String, onData:(data:String)->Void,
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
    inline static public function takeScreenshot()
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

    inline static public function getClassName(o:Dynamic):String
    {
        return Type.getClassName(Type.getClass(o));
    }
}