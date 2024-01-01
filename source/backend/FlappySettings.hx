package backend;

import states.EditorState.LevelData;

class FlappySettings
{
    // Main game settings
    public static var menuScrollSpeed:Float = 2;
    public static var playerSkin:String = 'default';
    public static var levelJson:LevelData = null;

    // Editor settings
    public static var editorScrollSpeed:Float = 8;
    public static var editorGridSize:Int = 16;

    public static var httpPrefix:String = 'https://raw.githubusercontent.com/AbsurdCoolMan/Flappy-Bird-Level-Editor/main/';
    public static var verCheckLink:String = '${httpPrefix}gameVersion.txt';
    public static var messageLink:String = '${httpPrefix}messages.txt';
    public static var githubLink:String = 'https://github.com/AbsurdCoolMan/Flappy-Bird-Level-Editor';
}