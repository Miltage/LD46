package me.miltage;

import hxd.res.Sound;

class SoundManager {

    private static var hitSounds:Array<Sound>;
    private static var glassSounds:Array<Sound>;
    private static var impactSounds:Array<Sound>;
    private static var babySounds:Array<Sound>;
    private static var lastBabySound:Int;

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

        impactSounds = [];
        impactSounds.push(hxd.Res.sounds.impact1);
        impactSounds.push(hxd.Res.sounds.impact2);
        impactSounds.push(hxd.Res.sounds.impact3);

        babySounds = [];
        babySounds.push(hxd.Res.sounds.baby1);
        babySounds.push(hxd.Res.sounds.baby2);
        babySounds.push(hxd.Res.sounds.baby3);
        babySounds.push(hxd.Res.sounds.baby4);
        babySounds.push(hxd.Res.sounds.baby5);
        babySounds.push(hxd.Res.sounds.baby6);

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

    public static function playScream():Void
    {
        hxd.Res.sounds.scream.play();
    }

    public static function playImpact():Void
    {
        impactSounds[Math.floor(Math.random() * impactSounds.length)].play();
    }

    public static function playBabyNoise():Void
    {
        if (lastBabySound == null)
            lastBabySound = 0;
        var sound = lastBabySound;
        while (sound == lastBabySound)
            sound = Math.floor(Math.random() * babySounds.length);
        babySounds[sound].play();
        lastBabySound = sound;
    }
}