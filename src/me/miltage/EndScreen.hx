package me.miltage;

import h2d.col.Point;
import h2d.Bitmap;
import h2d.Text.Align;

class EndScreen extends GameScene {

    private var replay:TextButton;

    public function new()
    {
        super();

        var font = hxd.Res.fpn.toFont();
        font.resizeTo(64);
        var font2 = font.clone();
        font2.resizeTo(80);

        var tf = new h2d.Text(font, this);
        tf.textAlign = Align.Center;
        tf.x = width / 2;
        tf.smooth = true;
        tf.text = "You protected Junior for\n\n\nseconds\nand juggled a total of \n\n\nitems.";

        var tf2 = new h2d.Text(font2, this);
        tf2.textAlign = Align.Center;
        tf2.x = width/2;
        tf2.y = height * 0.125;
        tf2.smooth = true;
        tf2.text = "00";

        var tf3 = new h2d.Text(font2, this);
        tf3.textAlign = Align.Center;
        tf3.x = width/2;
        tf3.y = height * 0.5;
        tf3.smooth = true;
        tf3.text = "00";

        replay = new TextButton("Try again", this);
        replay.x = width/2;
        replay.y = height * 0.85;
    }

    override public function update(dt:Float):Void
    {
        if (replay.getBounds().contains(new Point(mouseX, mouseY)))
            replay.onOver();
        else
            replay.onOut();

        if (hxd.Key.isDown(hxd.Key.MOUSE_LEFT) && replay.getBounds().contains(new Point(mouseX, mouseY)))
        {
            replay.onDown();
        }
        else if (hxd.Key.isReleased(hxd.Key.MOUSE_LEFT) && replay.getBounds().contains(new Point(mouseX, mouseY)))
        {
            Main.setCurrentScene(GAME);
        }
    }
}