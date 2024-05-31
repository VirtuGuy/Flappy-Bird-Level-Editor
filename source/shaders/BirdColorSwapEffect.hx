package shaders;

import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;

class BirdColorSwapEffect
{
    public var shader(default, null):BirdColorSwapShader = new BirdColorSwapShader();
    public var baseColor(default, set):FlxColor = FlxColor.fromRGB(212, 191, 39);
    public var shadeColor(default, set):FlxColor = FlxColor.fromRGB(228, 129, 23);
    public var lightColor(default, set):FlxColor = FlxColor.fromRGB(221, 226, 177);
    public var beakColor(default, set):FlxColor = FlxColor.fromRGB(235, 80, 64);
    public var eyeColor(default, set):FlxColor = FlxColor.fromRGB(235, 252, 221);
    public var eyeShadeColor(default, set):FlxColor = FlxColor.fromRGB(200, 192, 192);
    public var outlineColor(default, set):FlxColor = FlxColor.fromRGB(84, 56, 70);

    public function new()
    {
        set_baseColor(baseColor);
        set_shadeColor(shadeColor);
        set_lightColor(lightColor);
        set_beakColor(beakColor);
        set_eyeColor(eyeColor);
        set_eyeShadeColor(eyeShadeColor);
        set_outlineColor(outlineColor);
    }

    private function set_baseColor(value:FlxColor):FlxColor
    {
        this.baseColor = value;
        shader.baseColor.value = [value.redFloat, value.greenFloat, value.blueFloat];
        return value;
    }

    private function set_shadeColor(value:FlxColor):FlxColor
    {
        this.shadeColor = value;
        shader.shadeColor.value = [value.redFloat, value.greenFloat, value.blueFloat];
        return value;
    }

    private function set_lightColor(value:FlxColor):FlxColor
    {
        this.lightColor = value;
        shader.lightColor.value = [value.redFloat, value.greenFloat, value.blueFloat];
        return value;
    }

    private function set_beakColor(value:FlxColor):FlxColor
    {
        this.beakColor = value;
        shader.beakColor.value = [value.redFloat, value.greenFloat, value.blueFloat];
        return value;
    }

    private function set_eyeColor(value:FlxColor):FlxColor
    {
        this.eyeColor = value;
        shader.eyeColor.value = [value.redFloat, value.greenFloat, value.blueFloat];
        return value;
    }

    private function set_eyeShadeColor(value:FlxColor):FlxColor
    {
        this.eyeShadeColor = value;
        shader.eyeShadeColor.value = [value.redFloat, value.greenFloat, value.blueFloat];
        return value;
    }

    private function set_outlineColor(value:FlxColor):FlxColor
    {
        this.outlineColor = value;
        shader.outlineColor.value = [value.redFloat, value.greenFloat, value.blueFloat];
        return value;
    }
}

class BirdColorSwapShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        uniform vec3 baseColor;
        uniform vec3 shadeColor;
        uniform vec3 lightColor;
        uniform vec3 beakColor;
        uniform vec3 eyeColor;
        uniform vec3 eyeShadeColor;
        uniform vec3 outlineColor;

        vec3 normalizeColor(vec3 color) {
            return vec3(color[0] / 255.0, color[1] / 255.0, color[2] / 255.0);
        }

        void main() {
            vec4 texture = flixel_texture2D(bitmap, openfl_TextureCoordv);

            // Color swapping
            if (texture.rgb == normalizeColor(vec3(212.0, 191.0, 39.0))) {
                texture.rgb = baseColor;
            }
            else if (texture.rgb == normalizeColor(vec3(228.0, 129.0, 23.0))) {
                texture.rgb = shadeColor;
            }
            else if (texture.rgb == normalizeColor(vec3(221.0, 226.0, 177.0))) {
                texture.rgb = lightColor;
            }
            else if (texture.rgb == normalizeColor(vec3(235.0, 80.0, 64.0))) {
                texture.rgb = beakColor;
            }
            else if (texture.rgb == normalizeColor(vec3(235.0, 252.0, 221.0))) {
                texture.rgb = eyeColor;
            }
            else if (texture.rgb == normalizeColor(vec3(200.0, 192.0, 192.0))) {
                texture.rgb = eyeShadeColor;
            }
            else if (texture.rgb == normalizeColor(vec3(84.0, 56.0, 70.0))) {
                texture.rgb = outlineColor;
            }

            gl_FragColor = texture;
        }
    ')

    override public function new()
    {
        super();
    }
}