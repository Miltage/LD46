package me.miltage;

import h2d.col.Point;
import h2d.Bitmap;
import h2d.Scene;
import h2d.Object;

class MuteButton extends Object {
    
    var mute1:Bitmap;
    var mute2:Bitmap;
    var mute3:Bitmap;
    
    public function new(parent:Scene)
    {
        super(parent);

        mute1 = new Bitmap(hxd.Res.mute_default.toTile(), this);
        mute2 = new Bitmap(hxd.Res.mute_over.toTile(), this);
        mute3 = new Bitmap(hxd.Res.muted.toTile(), this);

        mute2.visible = false;
        mute3.visible = false;
        mute2.y = -2;

        scaleX = 0.5 * Main.ratio;
        scaleY = 0.5 * Main.ratio;
        this.x = parent.width * 0.9;
        this.y = parent.height * 0.04;
    }

    public function update(dt:Float, mouseX:Float, mouseY:Float):Void
    {
        if (this.getBounds().contains(new Point(mouseX, mouseY)))
        {
            if (hxd.Key.isPressed(hxd.Key.MOUSE_LEFT))
                onDown();
            else
                onOver();
        }
        else
            onOut();
    }

    private function onOver():Void
    {
        mute1.visible = false;
        mute2.visible = !SoundManager.isMuted();
        mute3.visible = SoundManager.isMuted();
    }

    private function onDown():Void
    {
        SoundManager.toggleSound();
    }

    private function onOut():Void
    {
        mute1.visible = !SoundManager.isMuted();
        mute2.visible = false;
        mute3.visible = SoundManager.isMuted();
    }
}