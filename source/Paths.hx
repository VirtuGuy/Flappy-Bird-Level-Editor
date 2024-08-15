package;

import flash.media.Sound;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.utils.Assets as OpenFlAssets;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class Paths
{
    inline static public var imageExt:String = 'png';
    inline static public var soundExt:String = #if html5 'mp3'; #else 'ogg'; #end

    // For caching images and sounds, which makes assets load faster
    static public var imageCache:Map<String, FlxGraphic> = [];
    static public var soundCache:Map<String, Sound> = [];

    // Textures and sounds (in case if the paths have multiple uses)
    static public var textures:Map<String, String> = [];
    static public var sounds:Map<String, String> = [
        "wing" => 'sfx_wing',
        "hit" => 'sfx_hit',
        "point" => 'sfx_point',
        "swooshing" => 'sfx_swooshing',
        "die" => 'sfx_die'
    ];
    static public var fonts:Map<String, String> = [
        "default" => '04B.TTF',
    ];

    // Paths
    inline static public function imagePath(key:String)
    {
        return 'assets/images/$key.$imageExt';
    }

    inline static public function soundPath(key:String, isMusic:Bool = false)
    {
        var folder:String = 'sounds';
        if (isMusic)
            folder = 'music';
        return 'assets/$folder/$key.$soundExt';
    }

    // Files
    inline static public function imageFile(key:String):FlxGraphic
    {
        return image(imagePath(key));
    }

    inline static public function soundFile(key:String, isMusic:Bool = false):Sound
    {
        return sound(soundPath(key, isMusic));
    }

    inline static public function image(path:String):FlxGraphic
    {
        var graphic:FlxGraphic = null;
        if (imageCache.exists(path))
        {
            graphic = imageCache.get(path);
        }
        else
        {
            #if sys
            var bitmap:BitmapData = BitmapData.fromFile(path);
            #else
            var bitmap:BitmapData = OpenFlAssets.getBitmapData(path);
            #end

            graphic = FlxGraphic.fromBitmapData(bitmap, false, path);
            graphic.persist = true;
            graphic.destroyOnNoUse = true;

            imageCache.set(path, graphic);
        }
        return graphic;
    }

    inline static public function sound(path:String):Sound
    {
        var sound:Sound = null;
        if (soundCache.exists(path))
        {
            sound = soundCache.get(path);
        }
        else
        {
            #if sys
            sound = Sound.fromFile(path);
            #else
            sound = OpenFlAssets.getSound(path);
            #end

            soundCache.set(path, sound);
        }
        return sound;
    }

    inline static public function fontFile(key:String)
    {
        return 'assets/fonts/$key';
    }

    inline static public function levelsFolder(levelFolder:String = 'default', ?levelName:String)
    {
        var additionalPath:String = '';
        if (levelName != null)
            additionalPath = '/$levelName';
        return 'assets/levels/${levelFolder}${additionalPath}';
    }

    inline static public function levelFile(levelFolder:String = 'default', levelName:String)
    {
        return '${levelsFolder(levelFolder, levelName)}/level.json';
    }

    inline static public function objectJson(objectName:String)
    {
        return 'assets/data/objects/$objectName.json';
    }

    inline static public function backgroundJson(bgName:String)
    {
        return 'assets/data/backgrounds/$bgName.json';
    }

    inline static public function textFile(key:String)
    {
        return 'assets/$key.txt';
    }

    #if SCREENSHOTS
    inline static public function screenshotsFolder():String
    {
        if (!pathExists('screenshots'))
            FileSystem.createDirectory('screenshots');
        return 'screenshots';
    }

    inline static public function screenshotFile(key:String, getScreenshot:Bool = true):Dynamic
    {
        var path:String = '${screenshotsFolder()}/$key.$imageExt';
        if (getScreenshot)
            return image(path);
        else
            return path;
    }
    #end

    inline static public function pathExists(path:String)
    {
        var exists:Bool = false;
        #if sys
        if (FileSystem.exists(path))
            exists = true;
        #else
        if (OpenFlAssets.exists(path, null))
            exists = true;
        #end
        return exists;
    }

    inline static public function getText(path:String)
    {
        var content:String = "";
        if (pathExists(path))
        {
            #if sys
            content = File.getContent(path);
            #else
            content = OpenFlAssets.getText(path);
            #end
        }
        return content;
    }

    // Key value getting functions
    inline static public function getTexture(key:String):String
    {
        var value:String = '';
        if (textures.exists(key))
            value = textures.get(key);
        return value;
    }

    inline static public function getSound(key:String):String
    {
        var value:String = '';
        if (sounds.exists(key))
            value = sounds.get(key);
        return value;
    }

    inline static public function getFont(key:String):String
    {
        var value:String = '';
        if (fonts.exists(key))
            value = fonts.get(key);
        return value;
    }
}