package me.miltage;

class Game extends h2d.Scene {

    public function new() {
        super();

        var tf = new h2d.Text(hxd.res.DefaultFont.get(), this);
        tf.text = "Hello Game!";

        // creates three tiles with different color
        var t1 = h2d.Tile.fromColor(0xFF0000, 30, 30);
        var t2 = h2d.Tile.fromColor(0x00FF00, 30, 40);
        var t3 = h2d.Tile.fromColor(0x0000FF, 30, 50);

        // creates an animation for these tiles
        var anim = new h2d.Anim([t1,t2,t3], this);
        anim.x = 100;
        anim.y = 100;
    }
}