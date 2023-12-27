package;

import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.utils.Assets as OpenFlAssets;

class Paths
{
    public static var imageExt:String = 'png';
    public static var soundExt:String = #if html5 'mp3'; #else 'ogg'; #end

    // For caching images and sounds, which makes assets load faster
    public static var imageCache:Map<String, FlxGraphic> = [];
    public static var soundCache:Map<String, Sound> = [];

    // Textures and sounds (in case of a path change)
    public static var textures:Map<String, String> = [
        "bgSky" => 'background/Sky',
        "bgGround" => 'background/Ground'
    ];

    public static var sounds:Map<String, String> = [
        "wing" => 'sfx_wing',
        "hit" => 'sfx_hit',
        "point" => 'sfx_point',
        "swooshing" => 'sfx_swooshing',
        "die" => 'sfx_die'
    ];

    public static var fonts:Map<String, String> = [
        "default" => '04B.TTF',
    ];

    // Paths
    public static function imagePath(key:String)
    {
        return 'assets/images/$key.$imageExt';
    }

    public static function soundPath(key:String, isMusic:Bool = false)
    {
        var folder:String = 'sounds';
        if (isMusic)
            folder = 'music';

        return 'assets/$folder/$key.$soundExt';
    }

    // Files
    public static function imageFile(key:String):FlxGraphic
    {
        var graphic:FlxGraphic = null;
        var path:String = imagePath(key);

        if (imageCache.exists(path))
        {
            graphic = imageCache.get(path);
        }
        else
        {
            var bitmap:BitmapData = OpenFlAssets.getBitmapData(path);

            graphic = FlxGraphic.fromBitmapData(bitmap, false, path);
            graphic.persist = true;
            graphic.destroyOnNoUse = true;

            imageCache.set(path, graphic);
        }

        return graphic;
    }

    public static function soundFile(key:String, isMusic:Bool = false):Sound
    {
        var sound:Sound = null;
        var path:String = soundPath(key, isMusic);

        if (soundCache.exists(path))
        {
            sound = soundCache.get(path);
        }
        else
        {
            sound = OpenFlAssets.getSound(path);
            soundCache.set(path, sound);
        }

        return sound;
    }

    public static function fontFile(key:String)
    {
        return 'assets/fonts/$key';
    }

    public static function fileExists(path:String)
    {
        var exists:Bool = false;
        if (OpenFlAssets.exists(path, null))
            exists = true;

        return exists;
    }

    public static function getText(path:String)
    {
        var content:String = "";

        if (fileExists(path))
            content = OpenFlAssets.getText(path);

        return content;
    }

    public static function dumpCache()
    {
        for (key in imageCache.keys())
        {
            var graphic:FlxGraphic = imageCache.get(key);

            if (graphic != null)
            {
                imageCache.remove(key);

                OpenFlAssets.cache.removeBitmapData(key);

                graphic.persist = false;
                graphic.destroyOnNoUse = true;
                graphic.destroy();
            }
        }

        for (key in soundCache.keys())
        {
            var sound:Sound = soundCache.get(key);

            if (sound != null)
            {
                soundCache.remove(key);
                OpenFlAssets.cache.removeSound(key);
            }
        }
    }
}