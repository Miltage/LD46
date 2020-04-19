package me.miltage;

import hxd.res.Sound;

class SoundManager {

    private static var hitSounds:Array<Sound>;
    private static var glassSounds:Array<Sound>;

    public static function init():Void
    {
        hitSounds = [];
        hitSounds.push(hxd.Res.sounds.hit1);
        hitSounds.push(hxd.Res.sounds.hit2);
        hitSounds.push(hxd.Res.sounds.hit3);
        hitSounds.push(hxd.Res.sounds.hit4);

        glassSounds = [];
        glassSounds.push(hxd.Res.sounds.glass1);
        glassSounds.push(hxd.Res.sounds.glass2);

        var musicResource:Sound = null;
        //If we support mp3 we have our sound
        if(hxd.res.Sound.supportedFormat(Mp3)){
            musicResource = hxd.Res.sounds.hit1;
        }  

        if(musicResource != null){
            //Play the music and loop it
            //musicResource.play(true);
        }
    }

    public static function playHit():Void
    {
        hitSounds[Math.floor(Math.random() * hitSounds.length)].play();
    }

    public static function playGlass():Void
    {
        glassSounds[Math.floor(Math.random() * glassSounds.length)].play();
    }

    public static function playUIOver():Void
    {
        hxd.Res.sounds.bong.play();
    }

    public static function playUIClick():Void
    {
        hxd.Res.sounds.click.play();
    }
}