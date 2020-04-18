import me.miltage.Title;
import me.miltage.Game;

enum SceneName {
    TITLE;
    GAME;
}

class Main extends hxd.App {

    private var game:Game;
    private var title:Title;

    private var currentScene:SceneName;

    override function init() {
        
        hxd.Res.initEmbed();
        // set up initial scene
        var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
        tf.text = "Hello World!";

        // switch to new scene
        game = new Game();
        //setScene(game);
        
        title = new Title();
        setScene(title);

        currentScene = TITLE;

    }

    override function update(dt:Float) 
    {
        if (currentScene == TITLE)
            title.update(dt);
        else if (currentScene == GAME)
            game.update(dt);
    }

    static function main() {
        new Main();
    }
}