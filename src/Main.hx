import me.miltage.Game;

class Main extends hxd.App {

    private var game:Game;

    override function init() {
        
        // set up initial scene
        var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
        tf.text = "Hello World!";

        // switch to new scene
        game = new Game();
        setScene(game);
        

    }

    override function update(dt:Float) 
    {
        game.update(dt);
    }

    static function main() {
        new Main();
    }
}