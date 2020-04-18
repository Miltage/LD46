import me.miltage.GameScene;
import me.miltage.Title;
import me.miltage.Game;
import me.miltage.EndScreen;

enum SceneName {
    TITLE;
    GAME;
    END;
}

class Main extends hxd.App {

    public static var instance:Main;

    private var currentScene:GameScene;

    override function init() {
        
        hxd.Res.initEmbed();
        instance = this;        

        // switch to new scene
        changeScene(END);

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