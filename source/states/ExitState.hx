package states;

import backend.FlappyState;

class ExitState extends FlappyState
{
    override public function new()
    {
        super(false, false, false, false);
    }

    override function create()
    {
        #if desktop
        Sys.exit(0);
        #end
    }
}