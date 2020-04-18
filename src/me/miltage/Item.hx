package me.miltage;

import h2d.col.Point;
import box2D.common.math.B2Vec2;
import hxd.Res;
import h2d.Tile;
import h2d.Scene;
import h2d.Bitmap;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2World;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2CircleShape;
import box2D.dynamics.B2BodyDef;

using tweenxcore.Tools;

enum ItemType {
    CLEAVER;
    ANVIL;
    TOASTER;
    TELEVISION;
}

class Item {
    private static inline var HIT_TIME:Float = 0.2;

    private var body:B2Body;
    private var type:ItemType;
    private var sprite:Bitmap;
    private var hitTime:Float;

    public function new(type:ItemType, world:B2World, scene:Scene, startY:Int = 1) {
        this.type = type;

        var bodyDef = new B2BodyDef();
        bodyDef.position.set(scene.width/2 / Constants.PPM, startY);
        bodyDef.linearDamping = 0.5;
        bodyDef.type = DYNAMIC_BODY;

        var circle = new B2CircleShape(0.6);
        var fixture = new B2FixtureDef();
        fixture.density = switch (type) {
            case CLEAVER: 0.6;
            case TOASTER: 0.8;
            case TELEVISION: 1.2;
            case ANVIL: 2.0;
        };
        fixture.shape = circle;
        fixture.filter.categoryBits = 2;
        fixture.filter.maskBits = 1;

        body = world.createBody(bodyDef);
        body.createFixture(fixture);
        body.setUserData(this);

        sprite = new Bitmap(getTile().center(), scene);
        sprite.scaleX = 0.5;
        sprite.scaleY = 0.5;

        hitTime = HIT_TIME;
    }

    public function onHit():Void
    {
        hitTime = 0;
    }

    public function update(dt:Float):Void
    {
        var pos:B2Vec2 = body.getWorldCenter();
        sprite.x = pos.x * Constants.PPM;
        sprite.y = pos.y * Constants.PPM;
        sprite.rotation = body.getAngle();

        if (hitTime < HIT_TIME)
        {
            hitTime += dt;
            var rate = hitTime / HIT_TIME;
            var val = rate.yoyo(Easing.linear).lerp(0.5, 0.58);
            sprite.scaleX = val;
            sprite.scaleY = val;
        }
    }

    public function isOnFloor(scene:Scene):Bool
    {
        return (body.getWorldCenter().y * Constants.PPM > scene.height * 0.75);
    }

    public function getWorldPos():Point
    {
        var pos = body.getWorldCenter();
        return new Point(pos.x * Constants.PPM, pos.y * Constants.PPM);
    }

    public function getType():ItemType
    {
        return type;
    }

    private function getTile():Tile
    {
        return switch (type)
        {
            case CLEAVER: Res.cleaver.toTile();
            case ANVIL: Res.anvil.toTile();
            case TELEVISION: Res.television.toTile();
            case TOASTER: Res.toaster.toTile();
        }
    }

    public static function getItemSize(type:ItemType):Int
    {
        return switch (type) {
            case TOASTER: 30;
            case TELEVISION: 60;
            case ANVIL: 80;
            case CLEAVER: 20;
            default: 30;
        }
    }
}