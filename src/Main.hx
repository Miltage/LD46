import me.miltage.Game;

class Main extends hxd.App {

    override function init() {
        
        // set up initial scene
        var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
        tf.text = "Hello World!";

        // switch to new scene
        var game = new Game();
        //setScene(game);
        

    }

    static function main() {
        new Main();
    }
}