package states;

import backend.FlappyState;

class ExitState extends FlappyState
{
    override function create()
    {
        #if desktop
        Sys.exit(0);
        #end
    }
}