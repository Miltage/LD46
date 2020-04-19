package me.miltage;

import h2d.Graphics;
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
    GRENADE;
    MICROWAVE;
    TOILET;
    CHAINSAW;
}

class Item {
    private static inline var HIT_TIME:Float = 0.2;
    private static inline var APPEAR_TIME:Float = 0.4;

    private var body:B2Body;
    private var type:ItemType;
    private var sprite:GameSprite;
    private var hitTime:Float;
    private var appearTime:Float;

    private var points:Array<Point>;
    private var lineGraphic:Graphics;
    private var plug:Bitmap;

    public function new(type:ItemType, world:B2World, scene:Scene, startY:Int = 1) {
        this.type = type;

        lineGraphic = new Graphics(scene);

        var bodyDef = new B2BodyDef();
        bodyDef.position.set(scene.width/2 / Constants.PPM, startY);
        bodyDef.linearDamping = 0.5;
        bodyDef.type = DYNAMIC_BODY;

        var circle = new B2CircleShape(switch (type) {
            case CLEAVER | GRENADE | TOASTER: 0.6;
            case TELEVISION | ANVIL | TOILET | MICROWAVE: 1.0;
            case CHAINSAW: 0.8;
        });
        var fixture = new B2FixtureDef();
        fixture.density = switch (type) {
            case CLEAVER: 0.75;
            case TOASTER: 1.0;
            case TELEVISION: 1.2;
            case ANVIL: 2.0;
            case GRENADE: 0.75;
            case TOILET: 1.2;
            case MICROWAVE: 1.2;
            case CHAINSAW: 1.0;
        };
        fixture.shape = circle;
        fixture.filter.categoryBits = 2;
        fixture.filter.maskBits = 1;

        body = world.createBody(bodyDef);
        body.createFixture(fixture);
        body.setUserData(this);

        if (isElectrical(type))
        {
            plug = new Bitmap(hxd.Res.plug.toTile().center(), scene);
            plug.scaleX = 0.5;
            plug.scaleY = 0.5;
        }
        sprite = new GameSprite(getFrames(), scene);
        sprite.scaleX = 0.5;
        sprite.scaleY = 0.5;

        hitTime = HIT_TIME;
        appearTime = 0;
        setPos();
        SoundManager.playPop();

        points = [];
        for (i in 0...12)
            points.push(new Point(sprite.x, sprite.y + i*5));
    }

    public function onHit():Void
    {
        hitTime = 0;
    }

    private function setPos():Void
    {
        var pos:B2Vec2 = body.getWorldCenter();
        sprite.x = pos.x * Constants.PPM;
        sprite.y = pos.y * Constants.PPM;
        sprite.rotation = body.getAngle();
    }

    public function update(dt:Float):Void
    {
        setPos();

        if (hitTime < HIT_TIME)
        {
            hitTime += dt;
            var rate = hitTime / HIT_TIME;
            var val = rate.yoyo(Easing.linear).lerp(0.5, 0.58);
            sprite.scaleX = val;
            sprite.scaleY = val;
        }

        if (appearTime < APPEAR_TIME)
        {
            appearTime += dt;
            var rate = appearTime / APPEAR_TIME;
            var val = rate.bounceOut().lerp(0, 0.5);
            sprite.scaleX = val;
            sprite.scaleY = val;
        }

        points[0].set(sprite.x, sprite.y);

        lineGraphic.clear();
        lineGraphic.lineStyle(3, 0x000000);
        lineGraphic.moveTo(points[0].x, points[0].y);

        if (isElectrical(type))
        {
            for (i in 1...points.length)
            {
                var dx = points[i].x - points[i - 1].x;
                var dy = points[i].y - points[i - 1].y;
                var dist = Math.sqrt(dx*dx + dy*dy);
                var tf = 80;
                var len = 1;
                var diff = len - dist;
                if (dist > len)
                {
                    points[i].x += dx/dist*diff/2*dt*tf;
                    points[i].y += dy/dist*diff/2*dt*tf;
                    points[i - 1].x -= dx/dist*diff/2*dt*tf;
                    points[i - 1].y -= dy/dist*diff/2*dt*tf;
                }
                points[i].y += 1*dt*tf;
                lineGraphic.lineTo(points[i].x, points[i].y);
            }
            plug.x = points[points.length - 1].x;
            plug.y = points[points.length - 1].y;

            var dx = points[points.length - 1].x - sprite.x;
            var dy = points[points.length - 1].y - sprite.y;
            var angle = Math.atan2(dy, dx) + Math.PI*1.5;
            plug.rotation = angle;
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

    public function getSprite():GameSprite
    {
        return sprite;
    }

    private function getFrames():Array<Tile>
    {
        return switch (type)
        {
            case CLEAVER: [Res.cleaver.toTile().center()];
            case ANVIL: [Res.anvil.toTile().center()];
            case TELEVISION: [Res.television1.toTile().center(), Res.television2.toTile().center(), Res.television3.toTile().center()];
            case TOASTER: [Res.toaster.toTile().center()];
            case GRENADE: [Res.grenade.toTile().center()];
            case TOILET: [Res.toilet.toTile().center()];
            case CHAINSAW: [Res.chainsaw1.toTile().center(), Res.chainsaw2.toTile().center(), Res.chainsaw3.toTile().center()];
            case MICROWAVE: [Res.microwave.toTile().center()];
        }
    }

    public static function getItemSize(type:ItemType):Int
    {
        return switch (type) {
            case TOASTER | CHAINSAW: 30;
            case TELEVISION | MICROWAVE: 60;
            case ANVIL | TOILET: 80;
            case CLEAVER | GRENADE: 20;
            default: 30;
        }
    }

    public static function isElectrical(type:ItemType):Bool
    {
        return switch (type)
        {
            case TOASTER | TELEVISION | MICROWAVE: true;
            default: false;
        }
    }

    public static function isGlass(type:ItemType):Bool
    {
        return switch (type)
        {
            case TOILET | GRENADE | ANVIL: true;
            default: false;
        }
    }

    public static function isMetal(type:ItemType):Bool
    {
        return switch (type)
        {
            case MICROWAVE | CLEAVER | TOASTER: true;
            default: false;
        }
    }
}