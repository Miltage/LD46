package me.miltage;

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
import box2D.collision.shapes.B2CircleShape;

class Game extends h2d.Scene {

    var world:B2World;
    var focusedBody:B2Body;

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

        world = new B2World(new B2Vec2(0, 2), true);

        var bxFixDef = new B2FixtureDef();
        var bxPolygonShape = new B2PolygonShape();
        bxPolygonShape.setAsBox(this.width / Constants.PPM, 1);
        bxFixDef.shape = bxPolygonShape;

        var bodyDef = new B2BodyDef();
        bodyDef.type = B2BodyType.STATIC_BODY;
        bodyDef.position.set(this.width / 2 / Constants.PPM, this.height / Constants.PPM);
        world.createBody(bodyDef).createFixture(bxFixDef);

        bxPolygonShape.setAsBox(1, this.height * 10 / Constants.PPM);
        bodyDef.position.set(1, this.height / 2 / Constants.PPM);
        world.createBody(bodyDef).createFixture(bxFixDef);

        bxPolygonShape.setAsBox(1, this.height * 10 / Constants.PPM);
        bodyDef.position.set(this.width / Constants.PPM - 1, this.height / 2 / Constants.PPM);
        world.createBody(bodyDef).createFixture(bxFixDef);

        var dbgDraw:B2HeapsDebugDraw = new B2HeapsDebugDraw();
        var dbgSprite:h2d.Graphics = new Graphics(this);
        dbgDraw.setSprite(dbgSprite);
        dbgDraw.setDrawScale(Constants.PPM);
        dbgDraw.setFillAlpha(0.3);
        dbgDraw.setLineThickness(1.0);
        dbgDraw.setFlags(B2DebugDraw.e_shapeBit | B2DebugDraw.e_jointBit);

        world.setDebugDraw(dbgDraw);

        for (i in 0...5)
        {
            var body = new B2BodyDef();
            body.position.set(this.width/2 / Constants.PPM - i * 0.5, 1 - i * 2);
            body.linearDamping = 0.5;
            body.type = DYNAMIC_BODY;
                
            var circle = new B2CircleShape(0.6);
            var fixture = new B2FixtureDef();
            fixture.density = 0.8 + i * 0.2;
            fixture.shape = circle;
            fixture.filter.categoryBits = 2;
            fixture.filter.maskBits = 1;
                
            var player = world.createBody(body);
            player.createFixture (fixture);
        }
    }

    public function update(dt:Float)
    {
        world.step(1 / 60,  3,  3);
        world.clearForces();
        world.drawDebugData();

        if (hxd.Key.isPressed(hxd.Key.MOUSE_LEFT))
        {
            lastMouse = mousePVec.copy();
            var body = getBodyAtMouse();
            if (body != null)
            {
                //focusedBody = body;
                body.setLinearVelocity(new B2Vec2(0, 0));
                body.applyImpulse(new B2Vec2(Math.random() * 4 - 2, -5), body.getWorldCenter());
            }
        }

        /*if (hxd.Key.isReleased(hxd.Key.MOUSE_LEFT) && focusedBody != null)
        {
            //focusedBody.setActive(true);
            var b:B2Vec2 = mousePVec.copy();
            b.subtract(lastMouse);
            trace(b);
            //b.normalize();
            b.multiply(30);
            focusedBody.applyImpulse(b, focusedBody.getWorldCenter());
            focusedBody = null;
        }

        if (focusedBody != null)
        {
            //focusedBody.setActive(false);
            focusedBody.setPosition(mousePVec);
        }*/
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
                    return false;
                }
            }

            return true;
        }

        world.queryAABB(getBodyCallback, aabb);
        return body;
    }
}