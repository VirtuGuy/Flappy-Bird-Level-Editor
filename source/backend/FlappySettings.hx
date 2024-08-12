package backend;

import flixel.FlxState;
import states.EditorState.LevelData;

class FlappySettings
{
    // Main game settings
    inline static public var menuScrollSpeed:Float = 2;
    static public var playerSkin:String = 'default';
    static public var levelJson:LevelData = null;
    static public var lastState:FlxState = null;

    // Editor settings
    inline static public var editorScrollSpeed:Float = 6;
    inline static public var editorGridSize:Int = 16;

    // HTTP web settings
    inline static public var httpPrefix:String = 'https://raw.githubusercontent.com/VirtuGuy/Flappy-Bird-Level-Editor/main/';
    inline static public var verCheckLink:String = '${httpPrefix}data/gameVersion.txt';
    inline static public var messageLink:String = '${httpPrefix}data/messages.txt';
    inline static public var gameLink:String = 'https://virtuguy.itch.io/fble';
}