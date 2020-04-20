package me.miltage;

import h2d.Text;
import h2d.filter.ColorMatrix;
import h2d.Text.Align;
import h2d.Scene;

enum ButtonState {
    OVER;
    OUT;
    DOWN;
}

class TextButton extends h2d.Object {

    var tf:Text;
    var state:ButtonState;

    public function new(text:String, parent:Scene)
    {
        super(parent);

        var font = hxd.Res.fpn.toFont().clone();
        font.resizeTo(Std.int(64 * Main.ratio));

        tf = new Text(font, this);
        tf.textAlign = Align.Center;
        tf.x = 0;
        tf.smooth = true;
        tf.text = text;

        state = OUT;
    }

    public function onOver():Void
    {
        tf.textColor = 0xcd6684;
        tf.y = -1;
        if (state != OVER)
        {
            SoundManager.playUIOver();
            state = OVER;
        }
    }

    public function onOut():Void
    {
        tf.textColor = 0xffffff;
        tf.y = 0;
        state = OUT;
    }

    public function onDown():Void
    {
        tf.textColor = 0x6f5a7e;
        tf.y = 2;
        if (state != DOWN)
        {
            SoundManager.playUIClick();
            state = DOWN;
        }
    }

    
}