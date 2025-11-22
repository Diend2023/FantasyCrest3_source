package game.view
{
   import game.server.GameServerScoket;
   import game.uilts.GameFont;
   import starling.display.Button;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.Texture;
   import zygame.core.DataCore;
   import zygame.core.SceneCore;
   import zygame.display.DisplayObjectContainer;
   
   public class GameLANModeView extends DisplayObjectContainer
   {
      
      public function GameLANModeView()
      {
         super();
      }
      
      override public function onInit() : void
      {
         var bg:Quad = new Quad(stage.stageWidth,stage.stageHeight,0);
         bg.alpha = 0.7;
         this.addChild(bg);
         var text:TextField = new TextField(stage.stageWidth,64,"- WIFI局域网对战，请选择你的身份 -",new TextFormat(GameFont.FONT_NAME,24,16777215));
         text.y = stage.stageHeight / 2 - 100;
         this.addChild(text);
         var skin:Texture = DataCore.getTextureAtlas("start_main").getTexture("btn_style_1");
         var button:Button = new Button(skin,"房主");
         this.addChild(button);
         button.x = stage.stageWidth / 2 - 100;
         button.y = stage.stageHeight / 2 + 30;
         button.alignPivot();
         button.textFormat.size = 24;
         button.name = "maters";
         var button2:Button = new Button(skin,"参与者");
         this.addChild(button2);
         button2.x = stage.stageWidth / 2 + 100;
         button2.y = stage.stageHeight / 2 + 30;
         button2.alignPivot();
         button2.textFormat.size = 24;
         button2.name = "player";
         this.addEventListener("triggered",onTriggered);
      }
      
      public function onTriggered(e:Event) : void
      {
         switch(e.target["name"])
         {
            case "maters":
               GameServerScoket.init();
               SceneCore.replaceScene(new GameOnlineRoomListView(GameServerScoket.ip));
               break;
            case "player":
               SceneCore.replaceScene(new GameOnlineRoomListView(GameServerScoket.ip));
         }
      }
   }
}

