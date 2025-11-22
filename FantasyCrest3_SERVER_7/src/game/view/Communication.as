package game.view
{
   import game.uilts.GameFont;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.display.DisplayObjectContainer;
   import zygame.utils.ServerUtils;
   
   public class Communication extends DisplayObjectContainer
   {
      
      public function Communication()
      {
         super();
      }
      
      override public function onInit() : void
      {
         super.onInit();
         var bg:Quad = new Quad(stage.stageWidth,stage.stageHeight,0);
         this.addChild(bg);
         bg.alpha = 0.5;
         var txt:TextField = new TextField(stage.stageWidth,32,"通信中...",new TextFormat(GameFont.FONT_NAME,12,16776960));
         this.addChild(txt);
         txt.y = stage.stageHeight / 2 - 16;
         this.addEventListener("enterFrame",onDataFrame);
      }
      
      public function onDataFrame(e:Event) : void
      {
         if(!ServerUtils.sending)
         {
            close();
         }
      }
      
      public function close() : void
      {
         this.removeEventListener("enterFrame",onDataFrame);
         this.removeFromParent(true);
      }
   }
}

