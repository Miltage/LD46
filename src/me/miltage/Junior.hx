package me.miltage;

import h2d.Bitmap;
import h2d.Scene;

using tweenxcore.Tools;

class Junior extends h2d.Object {

    private static inline var FRAME_TIME:Float = 2.5;
    private static inline var TRANSITION_TIME:Float = 0.08;
    private static inline var SOUND_INTERVAL:Float = 4;

    var frames:Array<Bitmap>;
    var frameIndex:Int;
    var timeElapsed:Float;
    var soundTime:Float;

    public var width:Float;

    public function new(parent:Scene)
    {
        super(parent);

        frames = [];
        frames.push(new Bitmap(hxd.Res.junior1.toTile().center(), this));
        frames.push(new Bitmap(hxd.Res.junior2.toTile().center(), this));
        frames.push(new Bitmap(hxd.Res.junior3.toTile().center(), this));

        frames[1].visible = false;
        frames[2].visible = false;

        frames[0].smooth = true;
        frames[1].smooth = true;
        frames[2].smooth = true;

        width = frames[0].tile.width;

        timeElapsed = 0;
        frameIndex = 0;
        soundTime = SOUND_INTERVAL;

        scaleX = 0.5 * Main.ratio;
        scaleY = 0.5 * Main.ratio;
    }

    public function update(dt:Float):Void
    {
        timeElapsed += dt;

        if (timeElapsed > FRAME_TIME)
        {
            timeElapsed = 0;
            frames[frameIndex].visible = false;
            var oldIndex = frameIndex;
            while (frameIndex == oldIndex)
                frameIndex = Math.floor(Math.random() * frames.length);
            frames[frameIndex].visible = true;
        }

        if (timeElapsed > FRAME_TIME - TRANSITION_TIME)
        {
            var rate = (FRAME_TIME - timeElapsed) / TRANSITION_TIME;
            var val = (1 - rate).cubicOut().lerp(0.5 * Main.ratio, 0.55 * Main.ratio);
            scaleX = val;
            scaleY = val;
        }
        else if (timeElapsed < TRANSITION_TIME)
        {
            var rate = timeElapsed / TRANSITION_TIME;
            var val = (1 - rate).cubicOut().lerp(0.5 * Main.ratio, 0.55 * Main.ratio);
            scaleX = val;
            scaleY = val;
        }

        soundTime += dt;
        if (soundTime >= SOUND_INTERVAL)
        {
            SoundManager.playBabyNoise();
            soundTime = 0;
        }
    }
}