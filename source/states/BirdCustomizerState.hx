package states;

import backend.FlappyState;
import backend.FlappyText;
import objects.Bird;
import shaders.BirdColorSwapEffect;

class BirdCustomizerState extends FlappyState
{
    var bird:Bird;
    var birdColorSwap:BirdColorSwapEffect;

    override public function create()
    {
        birdColorSwap = new BirdColorSwapEffect();

        var titleTxt:FlappyText = new FlappyText(0, 32, 0, 'Bird Customizer [WIP]', 32, CENTER);
        titleTxt.screenCenter(X);
        add(titleTxt);

        bird = new Bird(50);
        bird.scale.set(10, 10);
        bird.updateHitbox();
        bird.screenCenter(Y);
        bird.shader = birdColorSwap.shader;
        bird.animation.play('idle');
        add(bird);

        super.create();
    }
}