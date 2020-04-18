package me.miltage;

import h2d.Bitmap;

class Title extends h2d.Scene {

    private var radial:Bitmap;
    private var title:Bitmap;
    private var timeElapsed:Float;

    public function new() {
        super();

        timeElapsed = 0;

        var room = new Bitmap(hxd.Res.room.toTile(), this);
        room.scaleX = 0.5;
        room.scaleY = 0.5;

        var junior = new Bitmap(hxd.Res.junior.toTile().center(), this);
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

    public function update(dt:Float)
    {
        timeElapsed += dt;

        radial.rotation += dt/4;
        radial.scaleX = 0.5 + Math.sin(timeElapsed) * 0.1;
        radial.scaleY = 0.5 + Math.sin(timeElapsed) * 0.1;

        title.y = height/2 + Math.sin(timeElapsed * 4) * height * 0.01;
    }
}