package shaders;

import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;

class ColorSwapEffect
{
    public var shader(default, null):ColorSwapShader = new ColorSwapShader();
    public var targetColor(default, set):FlxColor = FlxColor.fromRGB(212, 191, 39);
    public var newColor(default, set):FlxColor = FlxColor.fromRGB(255, 255, 255);

    public function new() {
        set_targetColor(targetColor);
        set_newColor(newColor);
    }

    private function set_targetColor(value:FlxColor):FlxColor
    {
        this.targetColor = value;
        shader.targetColor.value = [value.redFloat, value.greenFloat, value.blueFloat];
        return value;
    }

    private function set_newColor(value:FlxColor):FlxColor
    {
        this.newColor = value;
        shader.newColor.value = [value.redFloat, value.greenFloat, value.blueFloat];
        return value;
    }
}

class ColorSwapShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        uniform vec3 targetColor;
        uniform vec3 newColor;

        void main() {
            vec4 texture = flixel_texture2D(bitmap, openfl_TextureCoordv);
            if (texture.rgb == targetColor) {
                texture.rgb = newColor;
            }

            gl_FragColor = texture;
        }
    ')

    override public function new()
    {
        super();
    }
}