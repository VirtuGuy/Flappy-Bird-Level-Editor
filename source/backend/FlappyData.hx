package backend;

import flixel.FlxG;

class FlappyData
{
    public static var dataMap:Map<String, Dynamic> = [
        'infiniteScore' => 0
    ];
    public static var ogDataMap:Map<String, Dynamic> = dataMap.copy();

    public static function saveData()
    {
        for (key in dataMap.keys())
            Reflect.setField(FlxG.save.data, key, dataMap.get(key));
        FlxG.save.flush();
    }

    public static function loadData()
    {
        dataMap = ogDataMap.copy();
        for (key in dataMap.keys())
        {
            var field:Dynamic = Reflect.field(FlxG.save.data, key);
            if (field != null)
                dataMap.set(key, field);
        }
    }

    public static function eraseData()
    {
        FlxG.save.erase();
        loadData();
    }

    // Setting functions
    public static function getData(varr:String):Dynamic
    {
        var value:Dynamic = null;
        if (dataMap.exists(varr))
            value = dataMap.get(varr);
        return value;
    }

    public static function setData(varr:String, value:Dynamic, ?save:Bool = false)
    {
        dataMap.set(varr, value);
        if (save)
            saveData();
    }

    // Highscore functions
    public static function setScore(varr:String, value:Float, ?save:Bool = false)
    {
        var score:Null<Float> = getData(varr);
        if (score == null)
            score = 0;
        if (value > score)
            setData(varr, value, save);
    }
}