package backend;

import states.EditorState.LevelData;

class FlappySettings
{
    // Main game settings
    public static var menuScrollSpeed:Float = 2;
    public static var playerSkin:String = 'default';
    public static var levelJson:LevelData = null;

    // Editor settings
    public static var editorScrollSpeed:Float = 6;
    public static var editorGridSize:Int = 16;

    // HTTP web settings
    public static var httpPrefix:String = 'https://raw.githubusercontent.com/VirtuGuy/Flappy-Bird-Level-Editor/main/';
    public static var verCheckLink:String = '${httpPrefix}data/gameVersion.txt';
    public static var messageLink:String = '${httpPrefix}data/messages.txt';
    public static var gameLink:String = 'https://virtuguy.itch.io/fble';
}