package backend;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

private enum KeyScheme
{
    Keys1;
}

class Keys
{
    public var keybinds:Map<String, Array<FlxKey>> = new Map<String, Array<FlxKey>>();

    // Key strings
    private var k_left:String = 'k_left';
    private var k_right:String = 'k_right';
    private var k_rotate:String = 'k_rotate';
    private var k_pause:String = 'k_pause';
    private var k_flap:String = 'k_flap';

    // Keys
    public var LEFT(get, default):Bool;
    public var RIGHT(get, default):Bool;
    public var LEFT_P(get, default):Bool;
    public var RIGHT_P(get, default):Bool;
    public var LEFT_R(get, default):Bool;
    public var RIGHT_R(get, default):Bool;
    public var ROTATE(get, default):Bool;
    public var PAUSE(get, default):Bool;
    public var FLAP(get, default):Bool;

    // Key functions
    private function get_LEFT():Bool
    {
        return keyPressed(k_left);
    }

    private function get_RIGHT():Bool
    {
        return keyPressed(k_right);
    }

    private function get_LEFT_P():Bool
    {
        return keyJustPressed(k_left);
    }

    private function get_RIGHT_P():Bool
    {
        return keyJustPressed(k_right);
    }

    private function get_LEFT_R():Bool
    {
        return keyJustReleased(k_left);
    }

    private function get_RIGHT_R():Bool
    {
        return keyJustReleased(k_right);
    }

    private function get_ROTATE():Bool
    {
        return keyJustPressed(k_rotate);
    }

    private function get_PAUSE():Bool
    {
        return keyJustPressed(k_pause);
    }

    private function get_FLAP():Bool
    {
        return keyJustPressed(k_flap);
    }

    // Other stuff
    private function keyJustPressed(keyName:String):Bool
    {
        return FlxG.keys.anyJustPressed(keybinds.get(keyName));
    }

    private function keyPressed(keyName:String):Bool
    {
        return FlxG.keys.anyPressed(keybinds.get(keyName));
    }

    private function keyJustReleased(keyName:String):Bool
    {
        return FlxG.keys.anyJustReleased(keybinds.get(keyName));
    }

    public function bindKey(keyName:String, keys:Array<FlxKey>)
    {
        keybinds.set(keyName, keys);
    }

    public function setScheme(scheme:KeyScheme)
    {
        switch (scheme)
        {
            case Keys1:
                bindKey(k_left, [A, FlxKey.LEFT]);
                bindKey(k_right, [D, FlxKey.RIGHT]);
                bindKey(k_rotate, [R]);
                bindKey(k_pause, [P]);
                bindKey(k_flap, [SPACE, ENTER]);
        }
    }

    public function new()
    {
        setScheme(Keys1);
    }
}