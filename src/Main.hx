import me.miltage.GameScene;
import me.miltage.Title;
import me.miltage.Game;
import me.miltage.SoundManager;
import me.miltage.EndScreen;

enum SceneName {
    TITLE;
    GAME;
    END;
}

class Main extends hxd.App {

    public static var instance:Main;
    public static var seconds:Int;
    public static var itemsJuggled:Int;
    public static var ratio:Float;

    private var currentScene:GameScene;

    override function init() {
        
        hxd.Res.initEmbed();
        SoundManager.init();
        seconds = 0;
        itemsJuggled = 0;
        instance = this;

        Main.ratio = s2d.width / 700;

        // switch to new scene
        changeScene(TITLE);
    }

    public function changeScene(scene:SceneName):Void
    {
        var newScene = switch (scene)
        {
            case TITLE: new Title();
            case GAME: new Game();
            case END: new EndScreen();
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