package game.display
{
   import game.uilts.GameFont;
   import starling.display.Quad;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.display.DisplayObjectContainer;
   
   public class RoleIntroduce extends DisplayObjectContainer
   {
      
      private var _text:TextField;
      
      public function RoleIntroduce()
      {
         super();
      }
      
      public function create(w:int, h:int) : void
      {
         var bg:Quad = new Quad(w,h,0);
         bg.alpha = 0.5;
         var text:TextField = new TextField(w - 15,h - 15,"",new TextFormat(GameFont.FONT_NAME,12,16777215,"left"));
         this.addChild(bg);
         this.addChild(text);
         _text = text;
         text.x = 5;
         text.y = 5;
      }
      
      public function set data(value:String) : void
      {
         _text.text = value;
      }
   }
}

