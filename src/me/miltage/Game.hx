package me.miltage;

import haxe.Timer;
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

    private var types:Array<ItemType> = [TOASTER, TELEVISION, CLEAVER, MICROWAVE, GRENADE, TOILET, CHAINSAW, ANVIL];
    private var typeIndex:Int;
    private var items:Array<Item>;
    private var shadows:Graphics;

    private var world:B2World;
    private var spawnTime:Float;
    private var playing:Bool;
    private var timer:Timer;
    private var junior:Junior;
    private var instruction:Instruction;

    public function new() {
        super();

        initWorld();
        typeIndex = 0;
        spawnTime = 0;
        items = [];
        playing = false;

        Main.seconds = 0;
        Main.itemsJuggled = 0;

        var room = new Bitmap(hxd.Res.room.toTile(), this);
        room.scaleX = 0.5;
        room.scaleY = 0.5;

        junior = new Junior(this);
        junior.scaleX = 0.5;
        junior.scaleY = 0.5;
        junior.x = width/2;
        junior.y = height - 130;

        shadows = new Graphics(this);
        
        instruction = new Instruction(this);

        // debug draw stuff
        var dbgDraw:B2HeapsDebugDraw = new B2HeapsDebugDraw();
        var dbgSprite:h2d.Graphics = new Graphics(this);
        dbgDraw.setSprite(dbgSprite);
        dbgDraw.setDrawScale(Constants.PPM);
        dbgDraw.setFillAlpha(0.3);
        dbgDraw.setLineThickness(1.0);
        dbgDraw.setFlags(B2DebugDraw.e_shapeBit | B2DebugDraw.e_jointBit);
        //world.setDebugDraw(dbgDraw);

        SoundManager.startMusic();
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
                var item = cast(body.getUserData(), Item);
                body.setLinearVelocity(new B2Vec2(0, 0));
                body.applyImpulse(new B2Vec2(Math.random() * 4 - 2, -5), body.getWorldCenter());
                var amount = (100 - Item.getItemSize(item.getType())) / 2;
                body.applyTorque(Math.random() * amount - (amount/2));
                item.onHit();
                if (Item.isGlass(item.getType()))
                    SoundManager.playGlass();
                else
                    SoundManager.playHit();

                if (!playing)
                {
                    timer = new Timer(1000);
                    timer.run = function(){
                        Main.seconds++;
                    };
                    playing = true;
                    instruction.visible = false;
                }
            }
        }

        shadows.clear();
        shadows.beginFill(0, 1);
        shadows.alpha = 0.2;

        for (item in items)
        {
            item.update(dt);

            var p = item.getWorldPos();
            var itemSize = Item.getItemSize(item.getType());
            var dy = height * 0.9 - p.y;
            var size = Math.max(1, itemSize * (1 - dy / height * 0.5));
            shadows.drawEllipse(p.x, height * 0.9, size, size/2, 0, 30);

            if (item.isOnFloor(this))
            {
                Main.itemsJuggled = items.length;
                timer.stop();
                Main.setCurrentScene(END);
                SoundManager.playScream();
                SoundManager.playImpact();
            }
        }

        junior.update(dt);
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

        var bodies:Array<B2Body> = [];

        var body = world.getBodyList();

        for (i in 0...world.getBodyCount() - 1)
        {
            var fixture = body.getFixtureList();
            var shape:B2Shape = fixture.getShape();
            if (fixture.getBody().getType() != 0 || includeStatic)
            {
                var inside:Bool = shape.testPoint(fixture.getBody().getTransform(), mousePVec);
                if (inside)
                {
                    bodies.push(body);
                }
            }
            body = body.getNext();
        }

        if (bodies.length == 0)
            return null;

        bodies.sort(function(a, b) {
            var itemA = cast(a.getUserData(), Item);
            var itemB = cast(b.getUserData(), Item);
            var indexA = this.getChildIndex(itemA.getSprite());
            var indexB = this.getChildIndex(itemB.getSprite());
            return indexA < indexB ? 1 : -1;
        });

        return bodies[0];
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
        bodyDef.position.set(this.width / 2 / Constants.PPM, (this.height + 60) / Constants.PPM + 60);
        world.createBody(bodyDef).createFixture(bxFixDef);

        // left wall
        bxPolygonShape.setAsBox(1, this.height * 10 / Constants.PPM);
        bodyDef.position.set(1, this.height / 2 / Constants.PPM);
        world.createBody(bodyDef).createFixture(bxFixDef);

        // right wall
        bxPolygonShape.setAsBox(1, this.height * 10 / Constants.PPM);
        bodyDef.position.set(this.width / Constants.PPM - 1, this.height / 2 / Constants.PPM);
        world.createBody(bodyDef).createFixture(bxFixDef);

        
    }
}