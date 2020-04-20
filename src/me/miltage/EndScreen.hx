package me.miltage;

import h2d.col.Point;
import h2d.Text.Align;
import h2d.Text;

class EndScreen extends GameScene {

    private static inline var WAIT_TIME:Float = 1;
    private static inline var WAIT_TIME_2:Float = 2;
    private static inline var WAIT_TIME_3:Float = 3;
    private static inline var WAIT_TIME_4:Float = 5;

    private var replay:TextButton;
    private var waitTime:Float;
    private var tf:Text;
    private var tf2:Text;
    private var tf3:Text;

    private var score1:Float;
    private var score2:Float;

    public function new()
    {
        super();

        var font = hxd.Res.fpn.toFont().clone();
        font.resizeTo(Std.int(64 * Main.ratio));
        var font2 = hxd.Res.fpn.toFont().clone();
        font2.resizeTo(Std.int(80 * Main.ratio));

        tf = new Text(font, this);
        tf.textAlign = Align.Center;
        tf.x = width / 2;
        tf.smooth = true;
        tf.text = "You protected Junior for\n\n\nseconds\nand juggled a total of \n\n\nitems.";
        tf.visible = false;

        tf2 = new Text(font2, this);
        tf2.textAlign = Align.Center;
        tf2.x = width/2;
        tf2.y = height * 0.125;
        tf2.smooth = true;
        tf2.text = "00";
        tf2.visible = false;

        tf3 = new Text(font2, this);
        tf3.textAlign = Align.Center;
        tf3.x = width/2;
        tf3.y = height * 0.5;
        tf3.smooth = true;
        tf3.text = "00";
        tf3.visible = false;

        replay = new TextButton("Try again", this);
        replay.x = width/2;
        replay.y = height * 0.85;
        replay.visible = false;

        waitTime = 0;
        score1 = 0;
        score2 = 0;

        SoundManager.stopMusic();
    }

    override public function update(dt:Float):Void
    {
        if (replay.getBounds().contains(new Point(mouseX, mouseY)))
        {
            if (hxd.Key.isDown(hxd.Key.MOUSE_LEFT))
                replay.onDown();
            else if (hxd.Key.isReleased(hxd.Key.MOUSE_LEFT))
                Main.setCurrentScene(GAME);
            else
                replay.onOver();
        }
        else
            replay.onOut();

        

        waitTime += dt;

        tf.visible = waitTime >= WAIT_TIME;
        tf2.visible = waitTime >= WAIT_TIME_2;
        tf3.visible = waitTime >= WAIT_TIME_3;
        replay.visible = waitTime >= WAIT_TIME_4;

        tf2.text = Math.round(score1) + "";
        tf3.text = Math.round(score2) + "";

        if (tf2.visible && waitTime > WAIT_TIME_2 + 0.5)
            score1 += (Main.seconds - score1) / 20;
        if (tf3.visible && waitTime > WAIT_TIME_3 + 0.5)
            score2 += (Main.itemsJuggled - score2) / 20;
    }
}