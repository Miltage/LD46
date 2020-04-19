package me.miltage;

import h2d.Tile;
import h2d.Anim;
import h2d.Bitmap;
import h2d.Scene;
import h2d.Object;

class GameSprite extends Object {

    private var sprite:Bitmap;
    private var anim:Anim;

    public function new(?tile:Tile, ?frames:Array<Tile>, parent:Scene)
    {
        super(parent);

        if (frames != null)
            this.fromFrames(frames);
        else if (tile != null)
            this.fromImage(tile);
    }

    public function fromImage(tile:Tile):Void
    {
        sprite = new Bitmap(tile, this);
        sprite.smooth = true;
    }

    public function fromFrames(frames:Array<Tile>):Void
    {
        anim = new Anim(frames, this);
        anim.smooth = true;
    }
}