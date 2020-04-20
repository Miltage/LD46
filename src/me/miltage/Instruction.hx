package me.miltage;

import h2d.Bitmap;
import h2d.Scene;

class Instruction extends h2d.Object {

    public function new(parent:Scene)
    {
        super(parent);

        var t1 = hxd.Res.click1.toTile().center();
        var t2 = hxd.Res.click2.toTile().center();
        var t3 = hxd.Res.click3.toTile().center();

        // creates an animation for these tiles
        var anim = new h2d.Anim([t1,t2,t3], this);
        anim.smooth = true;
        anim.scaleX = 0.7 * Main.ratio;
        anim.scaleY = 0.7 * Main.ratio;
        anim.x = parent.width * 0.86;
        anim.y = parent.height * 0.54;

        var arrow = new Bitmap(hxd.Res.arrow.toTile().center(), this);
        arrow.smooth = true;
        arrow.x = parent.width * 0.66;
        arrow.y = parent.height * 0.57;
        arrow.scaleX = 0.75 * Main.ratio;
        arrow.scaleY = -0.75 * Main.ratio;
        arrow.rotation = Math.PI / 8;

        var t4 = hxd.Res.protect1.toTile().center();
        var t5 = hxd.Res.protect2.toTile().center();
        var t6 = hxd.Res.protect3.toTile().center();

        var anim2 = new h2d.Anim([t4,t5,t6], this);
        anim2.smooth = true;
        anim2.scaleX = 0.7 * Main.ratio;
        anim2.scaleY = 0.7 * Main.ratio;
        anim2.x = parent.width * 0.18;
        anim2.y = parent.height * 0.55;

        var arrow2 = new Bitmap(hxd.Res.arrow.toTile().center(), this);
        arrow2.smooth = true;
        arrow2.x = parent.width * 0.28;
        arrow2.y = parent.height * 0.73;
        arrow2.scaleX = 0.7 * Main.ratio;
        arrow2.scaleY = 0.7 * Main.ratio;
        arrow2.rotation = Math.PI * 1.1;
    }
}