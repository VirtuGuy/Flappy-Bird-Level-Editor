package backend;

import flixel.FlxG;

class FlappyData
{
    static public var dataMap:Map<String, Dynamic> = [
        'infiniteScore' => 0,

        // Options
        'option_classic' => false,
        'option_muteSFX' => false,
        'option_birdSkin' => 'default'
    ];
    static public var ogDataMap:Map<String, Dynamic> = dataMap.copy();

    inline static public function saveData()
    {
        for (key in dataMap.keys())
            Reflect.setField(FlxG.save.data, key, dataMap.get(key));
        FlxG.save.flush();
    }

    inline static public function loadData()
    {
        dataMap = ogDataMap.copy();
        for (key in dataMap.keys())
        {
            var field:Dynamic = Reflect.field(FlxG.save.data, key);
            if (field != null)
                dataMap.set(key, field);
        }
    }

    inline static public function eraseData()
    {
        FlxG.save.erase();
        loadData();
    }

    // Setting functions
    inline static public function getData(varr:String):Dynamic
    {
        var value:Dynamic = null;
        if (dataMap.exists(varr))
            value = dataMap.get(varr);
        return value;
    }

    inline static public function setData(varr:String, value:Dynamic, ?save:Bool = false)
    {
        dataMap.set(varr, value);
        if (save)
            saveData();
    }

    // Highscore functions
    inline static public function setScore(varr:String, value:Float, ?save:Bool = false)
    {
        var score:Null<Float> = getData(varr);
        if (score == null)
            score = 0;
        if (value > score)
            setData(varr, value, save);
    }

    // Options functions
    inline static public function getOption(varr:String):Dynamic
    {
        return getData('option_${varr}');
    }

    inline static public function setOption(varr:String, value:Dynamic)
    {
        setData('option_${varr}', value, true);
    }
}