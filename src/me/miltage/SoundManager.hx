package me.miltage;

import hxd.snd.Manager;
import hxd.res.Sound;

class SoundManager {

    private static var hitSounds:Array<Sound>;
    private static var glassSounds:Array<Sound>;
    private static var impactSounds:Array<Sound>;
    private static var metalSounds:Array<Sound>;
    private static var babySounds:Array<Sound>;
    private static var musicResource:Sound;
    private static var lastBabySound:Int;
    private static var musicPlaying:Bool;
    private static var muted:Bool;

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

        metalSounds = [];
        metalSounds.push(hxd.Res.sounds.metal1);
        metalSounds.push(hxd.Res.sounds.metal2);
        metalSounds.push(hxd.Res.sounds.metal3);
        metalSounds.push(hxd.Res.sounds.metal4);

        //If we support mp3 we have our sound
        if (hxd.res.Sound.supportedFormat(Mp3))
            musicResource = hxd.Res.sounds.music;

        musicPlaying = false;
        muted = false;
    }

    public static function startMusic():Void
    {
        //if (musicResource != null && !musicPlaying)
            //musicResource.play(true, 0.5);
        musicPlaying = true;
    }

    public static function stopMusic():Void
    {
        if (musicResource != null)
            musicResource.stop();
        musicPlaying = false;
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

    public static function playMetal():Void
    {
        metalSounds[Math.floor(Math.random() * metalSounds.length)].play();
    }

    public static function playPop():Void
    {
        hxd.Res.sounds.pop.play();
    }

    public static function playChainsaw():Void
    {
        hxd.Res.sounds.chainsaw.play();
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

    public static function isMuted():Bool
    {
        return muted;
    }

    public static function toggleSound():Void
    {
        muted = !muted;
        Manager.get().masterVolume = muted ? 0 : 1;
    }
}