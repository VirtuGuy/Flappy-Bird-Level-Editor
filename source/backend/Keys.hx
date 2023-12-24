package backend;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

private enum KeyScheme
{
    Keys1;
    Keys2;
}

class Keys
{
    public var keybinds:Map<String, Array<FlxKey>> = new Map<String, Array<FlxKey>>();

    // Key strings
    private var ui_accept:String = 'ui_accept';

    // Keys
    public var UI_ACCEPT(get, default):Bool;

    private function get_UI_ACCEPT():Bool
    {
        return keyJustPressed(ui_accept);
    }

    private function keyJustPressed(keyName:String):Bool
    {
        return FlxG.keys.anyJustPressed(keybinds.get(keyName));
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
                bindKey(ui_accept, [SPACE, ENTER]);
            case Keys2:
                bindKey(ui_accept, [Z]);
        }
    }

    public function new()
    {
        setScheme(Keys1);
    }
}