package backend;

import flixel.addons.ui.FlxUISubState;

class FlappySubstate extends FlxUISubState
{
    private var keys:Keys;

    override public function new()
    {
        super();
        keys = new Keys();
    }
}