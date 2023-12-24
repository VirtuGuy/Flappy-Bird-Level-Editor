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
    private var ui_back:String = 'ui_back';
    private var game_flap:String = 'game_flap';

    // Keys
    public var UI_ACCEPT(get, default):Bool;
    public var UI_BACK(get, default):Bool;
    public var GAME_FLAP(get, default):Bool;

    private function get_UI_ACCEPT():Bool
    {
        return keyJustPressed(ui_accept);
    }

    private function get_UI_BACK():Bool
    {
        return keyJustPressed(ui_back);
    }

    private function get_GAME_FLAP():Bool
    {
        return keyJustPressed(game_flap);
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
                bindKey(ui_back, [ESCAPE, BACKSPACE]);
                bindKey(game_flap, [SPACE, ENTER]);
            case Keys2:
                bindKey(ui_accept, [Z]);
                bindKey(ui_back, [X]);
                bindKey(game_flap, [Z]);
        }
    }

    public function new()
    {
        setScheme(Keys1);
    }
}