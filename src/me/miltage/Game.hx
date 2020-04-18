package me.miltage;

import h2d.Bitmap;
import me.miltage.Item.ItemType;

import h2d.Graphics;

import box2D.dynamics.B2HeapsDebugDraw;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2World;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2BodyType;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.B2AABB;
import box2D.collision.shapes.B2Shape;
import box2D.collision.shapes.B2PolygonShape;

using tweenxcore.Tools;

class Game extends GameScene {

    private var types:Array<ItemType> = [TOASTER, TELEVISION, CLEAVER, ANVIL];
    private var typeIndex:Int;
    private var items:Array<Item>;

    private var world:B2World;
    private var spawnTime:Float;
    private var playing:Bool;

    public function new() {
        super();

        /*var tf = new h2d.Text(hxd.res.DefaultFont.get(), this);
        tf.text = "Hello Game!";

        // creates three tiles with different color
        var t1 = h2d.Tile.fromColor(0xFF0000, 30, 30);
        var t2 = h2d.Tile.fromColor(0x00FF00, 30, 40);
        var t3 = h2d.Tile.fromColor(0x0000FF, 30, 50);

        // creates an animation for these tiles
        var anim = new h2d.Anim([t1,t2,t3], this);
        anim.x = 100;
        anim.y = 100;*/

        initWorld();
        typeIndex = 0;
        spawnTime = 0;
        items = [];
        playing = false;

        var room = new Bitmap(hxd.Res.room.toTile(), this);
        room.scaleX = 0.5;
        room.scaleY = 0.5;

        var junior = new Bitmap(hxd.Res.junior.toTile().center(), this);
        junior.scaleX = 0.5;
        junior.scaleY = 0.5;
        junior.x = width/2;
        junior.y = height - 130;
    }

    override public function update(dt:Float)
    {
        if (playing)
            world.step(1 / 60,  3,  3);
        world.clearForces();
        world.drawDebugData();

        if (spawnTime > 0)
        {
            if (playing)
                spawnTime -= dt;
        }
        else
        {
            var item = new Item(getNextType(), world, this, items.length > 0 ? 1 : 3);
            items.push(item);
            spawnTime = Constants.SPAWN_TIME;
        }

        if (hxd.Key.isPressed(hxd.Key.MOUSE_LEFT))
        {
            lastMouse = mousePVec.copy();
            var body = getBodyAtMouse();
            if (body != null)
            {
                body.setLinearVelocity(new B2Vec2(0, 0));
                body.applyImpulse(new B2Vec2(Math.random() * 4 - 2, -5), body.getWorldCenter());
                playing = true;
            }
        }

        for (item in items)
        {
            item.update(dt);
        }
    }

    private function getNextType():ItemType
    {
        var type = types[typeIndex];

        typeIndex++;
        if (typeIndex >= types.length)
            typeIndex = 0;

        return type;
    }

    private var lastMouse:B2Vec2 = new B2Vec2();
    private var mousePVec:B2Vec2 = new B2Vec2();
    public function getBodyAtMouse(includeStatic:Bool = false):B2Body 
    {
        // Make a small box.
        var mouseXWorldPhys = this.mouseX / Constants.PPM;
        var mouseYWorldPhys = this.mouseY / Constants.PPM;
        mousePVec.set(mouseXWorldPhys, mouseYWorldPhys);
        var aabb:B2AABB = new B2AABB();
        aabb.lowerBound.set(mouseXWorldPhys - 0.001, mouseYWorldPhys - 0.001);
        aabb.upperBound.set(mouseXWorldPhys + 0.001, mouseYWorldPhys + 0.001);
        var body:B2Body = null;
        var fixture:B2Fixture;
        
        // Query the world for overlapping shapes.
        function getBodyCallback(fixture:B2Fixture):Bool
        {
            var shape:B2Shape = fixture.getShape();
            if (fixture.getBody().getType() != 0 || includeStatic)
            {
                var inside:Bool = shape.testPoint(fixture.getBody().getTransform(), mousePVec);
                if (inside)
                {
                    body = fixture.getBody();
                    cast(body.getUserData(), Item).onHit();
                    return false;
                }
            }

            return true;
        }

        world.queryAABB(getBodyCallback, aabb);
        return body;
    }

    public function initWorld():Void
    {
        world = new B2World(new B2Vec2(0, 2), true);

        var bxFixDef = new B2FixtureDef();
        var bxPolygonShape = new B2PolygonShape();
        bxPolygonShape.setAsBox(this.width / Constants.PPM, 1);
        bxFixDef.shape = bxPolygonShape;

        var bodyDef = new B2BodyDef();
        bodyDef.type = B2BodyType.STATIC_BODY;

        // floor
        bodyDef.position.set(this.width / 2 / Constants.PPM, this.height / Constants.PPM);
        world.createBody(bodyDef).createFixture(bxFixDef);

        // left wall
        bxPolygonShape.setAsBox(1, this.height * 10 / Constants.PPM);
        bodyDef.position.set(1, this.height / 2 / Constants.PPM);
        world.createBody(bodyDef).createFixture(bxFixDef);

        // right wall
        bxPolygonShape.setAsBox(1, this.height * 10 / Constants.PPM);
        bodyDef.position.set(this.width / Constants.PPM - 1, this.height / 2 / Constants.PPM);
        world.createBody(bodyDef).createFixture(bxFixDef);

        // debug draw stuff
        var dbgDraw:B2HeapsDebugDraw = new B2HeapsDebugDraw();
        var dbgSprite:h2d.Graphics = new Graphics(this);
        dbgDraw.setSprite(dbgSprite);
        dbgDraw.setDrawScale(Constants.PPM);
        dbgDraw.setFillAlpha(0.3);
        dbgDraw.setLineThickness(1.0);
        dbgDraw.setFlags(B2DebugDraw.e_shapeBit | B2DebugDraw.e_jointBit);
        world.setDebugDraw(dbgDraw);
    }
}