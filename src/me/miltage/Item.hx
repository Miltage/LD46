package me.miltage;

import box2D.dynamics.B2Body;
import box2D.dynamics.B2World;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2CircleShape;
import box2D.dynamics.B2BodyDef;

enum ItemType {
    CLEAVER;
    ANVIL;
    TOASTER;
    TELEVISION;
}

class Item {

    private var body:B2Body;
    private var type:ItemType;

    public function new(type:ItemType, world:B2World, width:Float) {
        this.type = type;

        var bodyDef = new B2BodyDef();
        bodyDef.position.set(width/2 / Constants.PPM, 1);
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
    }
}