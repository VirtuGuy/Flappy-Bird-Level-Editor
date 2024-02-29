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
    private var k_up:String = 'k_up';
    private var k_down:String = 'k_down';
    private var k_flip:String = 'k_flip';
    private var k_pause:String = 'k_pause';
    private var k_accept:String = 'k_accept';
    private var k_back:String = 'k_back';
    private var k_flap:String = 'k_flap';

    /// Volume key strings
    private var v_mute:String = 'v_mute';
    private var v_up:String = 'v_up';
    private var v_down:String = 'v_down';

    // Keys
    public var LEFT(get, default):Bool;
    public var RIGHT(get, default):Bool;
    public var LEFT_P(get, default):Bool;
    public var RIGHT_P(get, default):Bool;
    public var LEFT_R(get, default):Bool;
    public var RIGHT_R(get, default):Bool;
    public var UP(get, default):Bool;
    public var DOWN(get, default):Bool;
    public var UP_P(get, default):Bool;
    public var DOWN_P(get, default):Bool;
    public var UP_R(get, default):Bool;
    public var DOWN_R(get, default):Bool;
    public var FLIP(get, default):Bool;
    public var PAUSE(get, default):Bool;
    public var ACCEPT(get, default):Bool;
    public var BACK(get, default):Bool;
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

    private function get_UP():Bool
    {
        return keyPressed(k_up);
    }

    private function get_DOWN():Bool
    {
        return keyPressed(k_down);
    }

    private function get_UP_P():Bool
    {
        return keyJustPressed(k_up);
    }

    private function get_DOWN_P():Bool
    {
        return keyJustPressed(k_down);
    }

    private function get_UP_R():Bool
    {
        return keyJustReleased(k_up);
    }

    private function get_DOWN_R():Bool
    {
        return keyJustReleased(k_down);
    }

    private function get_FLIP():Bool
    {
        return keyJustPressed(k_flip);
    }

    private function get_PAUSE():Bool
    {
        return keyJustPressed(k_pause);
    }

    private function get_ACCEPT():Bool
    {
        return keyJustPressed(k_accept);
    }

    private function get_BACK():Bool
    {
        return keyJustPressed(k_back);
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
                bindKey(k_up, [A, FlxKey.UP]);
                bindKey(k_down, [D, FlxKey.DOWN]);
                bindKey(k_pause, [P]);
                bindKey(k_accept, [SPACE, ENTER]);
                bindKey(k_back, [ESCAPE, BACKSPACE]);

                bindKey(k_flip, [F]);
                bindKey(k_flap, [SPACE, ENTER]);

                bindKey(v_mute, [NUMPADZERO]);
                bindKey(v_up, [NUMPADPLUS]);
                bindKey(v_down, [NUMPADMINUS]);
        }
    }

    public function toggleVolumeKeys(toggle:Bool)
    {
        if (!toggle)
        {
            FlxG.sound.muteKeys = [];
            FlxG.sound.volumeUpKeys = [];
            FlxG.sound.volumeDownKeys = [];
        }
        else
        {
            FlxG.sound.muteKeys = keybinds.get(v_mute);
            FlxG.sound.volumeUpKeys = keybinds.get(v_up);
            FlxG.sound.volumeDownKeys = keybinds.get(v_down);
        }
    }

    public function new()
    {
        setScheme(Keys1);
        toggleVolumeKeys(true);
    }
}