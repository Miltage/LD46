import me.miltage.GameScene;
import h2d.Scene;
import me.miltage.Title;
import me.miltage.Game;

enum SceneName {
    TITLE;
    GAME;
}

class Main extends hxd.App {

    public static var instance:Main;

    private var currentScene:GameScene;

    override function init() {
        
        hxd.Res.initEmbed();
        instance = this;

        // set up initial scene
        var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
        tf.text = "Hello World!";

        // switch to new scene
        changeScene(TITLE);

    }

    public function changeScene(scene:SceneName):Void
    {
        var newScene = switch (scene)
        {
            case TITLE: new Title();
            case GAME: new Game();
        }
        currentScene = newScene;
        setScene(newScene);
    }

    override function update(dt:Float) 
    {
        if (currentScene != null)
            currentScene.update(dt);
    }

    static function main() {
        new Main();
    }

    static public function getInstance():Main
    {
        return Main.instance;
    }

    static public function setCurrentScene(scene:SceneName):Void
    {
        Main.getInstance().changeScene(scene);
    }
}