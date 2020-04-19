package me.miltage;

import h2d.Bitmap;

using tweenxcore.Tools;

class Title extends GameScene {

    private static inline var ROTATION_TIME:Float = 1000;
    private static inline var SCALE_TIME:Float = 200;

    private var radial:Bitmap;
    private var title:Bitmap;
    private var timeElapsed:Float;

    public function new() {
        super();

        timeElapsed = 0;

        var room = new Bitmap(hxd.Res.room.toTile(), this);
        room.scaleX = 0.5;
        room.scaleY = 0.5;

        var junior = new Junior(this);
        junior.scaleX = 0.5;
        junior.scaleY = 0.5;
        junior.x = width/2;
        junior.y = height - 130;

        radial = new Bitmap(hxd.Res.radial.toTile().center(), this);
        radial.scaleX = 0.5;
        radial.scaleY = 0.5;
        radial.x = width/2;
        radial.y = height/2;

        title = new Bitmap(hxd.Res.title.toTile().center(), this);
        title.scaleX = 0.5;
        title.scaleY = 0.5;
        title.x = width/2;
        title.y = height/2;
    }

    override public function update(dt:Float)
    {
        timeElapsed += dt;

        /*radial.rotation += dt/4;
        radial.scaleX = 0.5 + Math.sin(timeElapsed) * 0.1;
        radial.scaleY = 0.5 + Math.sin(timeElapsed) * 0.1;

        title.y = height/2 + Math.sin(timeElapsed * 4) * height * 0.01;*/

        radial.rotation = (timeElapsed/ROTATION_TIME).linear().lerp(0, 360);
        
        if (hxd.Key.isReleased(hxd.Key.MOUSE_LEFT))
        {
            Main.setCurrentScene(GAME);
        }
    }

}