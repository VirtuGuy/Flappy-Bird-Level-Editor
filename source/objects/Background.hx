package objects;

import backend.FlappyTools;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;

typedef BackgroundJSON = {
    elements:Array<BackgroundElement>,
    ground:BackgroundElement
}

typedef BackgroundElement = {
    path:Null<String>,
    scale:Null<Float>,
    y:Null<Float>,
    scrollFactor:Null<Float>,
    foreground:Null<Bool>
}

class Background extends FlxGroup
{
    public var backgroundName(default, set):String = 'default';
    public var elements:Array<FlxBackdrop> = [];
    public var ground:FlxBackdrop;
    public var backObjects:FlxTypedGroup<FlxBasic>;

    override public function new()
    {
        super();

        backObjects = new FlxTypedGroup<FlxBasic>();
        add(backObjects);
        set_backgroundName(backgroundName);
    }

    private function addBackgroundElement(element:BackgroundElement, isGround:Bool = false)
    {
        var path:String = element.path ?? '';
        if (!Paths.pathExists(Paths.imagePath(path))) return;

        var backdrop:FlxBackdrop = new FlxBackdrop(Paths.imageFile(path), X, 0, 0);
        backdrop.setGraphicSize(Std.int(backdrop.width * element.scale ?? 2));
        backdrop.updateHitbox();
        backdrop.scrollFactor.set(element.scrollFactor ?? 1, 0);
        elements.push(backdrop);

        // Adds the element
        if (element.foreground)
            add(backdrop);
        else
            insert(members.indexOf(backObjects), backdrop);

        // Positions the element
        if (element.y == null)
            backdrop.y = FlxG.height - backdrop.height;
        else
            backdrop.y = element.y;

        // Sets the element as the ground if it is the ground element
        if (isGround)
            ground = backdrop;
    }

    private function set_backgroundName(value:String):String
    {
        this.backgroundName = value;
        if (!Paths.pathExists(Paths.backgroundJson(value))) return value;

        if (ground != null)
        {
            remove(ground, true);
            ground.destroy();
            ground = null;
        }

        while (elements.length > 0)
        {
            remove(elements[0], true);
            elements[0].destroy();
            elements.shift();
        }

        var json:BackgroundJSON = FlappyTools.loadJSON(Paths.backgroundJson(value));
        for (element in json.elements)
            addBackgroundElement(element);
        addBackgroundElement(json.ground, true);

        // If the ground is still null, then add the default ground
        if (ground == null)
        {
            addBackgroundElement({
                path: 'background/Ground',
                scale: 2,
                y: null,
                scrollFactor: 0.7,
                foreground: true
            }, true);
        }

        return value;
    }
}