package me.miltage;

import box2D.dynamics.B2Body;
import box2D.dynamics.B2World;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2CircleShape;
import box2D.dynamics.B2BodyDef;

class Item {

    private var body:B2Body;

    public function new(world:B2World) {
        var bodyDef = new B2BodyDef();
        bodyDef.position.set(1, 1);
        bodyDef.linearDamping = 0.5;
        bodyDef.type = DYNAMIC_BODY;
            
        var circle = new B2CircleShape(0.6);
        var fixture = new B2FixtureDef();
        fixture.density = 0.8;
        fixture.shape = circle;
        fixture.filter.categoryBits = 2;
        fixture.filter.maskBits = 1;
            
        body = world.createBody(bodyDef);
        body.createFixture(fixture);
    }
}