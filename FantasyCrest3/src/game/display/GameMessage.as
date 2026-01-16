package game.display
{
   import flash.geom.Rectangle;
   import game.uilts.GameFont;
   import starling.display.Image;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.core.DataCore;
   import zygame.display.Dialog;
   
   public class GameMessage extends Dialog
   {
      
      public function GameMessage(message:String, wz:int = 150, hz:int = 120)
      {
         super(message,wz,hz);
      }
      
      override public function onCreateSkin(message:String, wz:int = 150, hz:int = 120) : void
      {
         _image = new MessageImage(DataCore.getTextureAtlas("hpmp").getTexture("com_dialog_box.png"));
         this.addChild(_image);
         (_image as Image).scale9Grid = new Rectangle(32,10,3,3);
         var format:TextFormat = new TextFormat(GameFont.FONT_NAME,24,16777215,"left","bottom");
         _text = new TextField(wz * 2,hz * 2,"",format);
         this.addChild(_text);
         _text.y -= 8;
         _text.scale = 0.75;
         this.pivotX = -24;
      }
      
      override public function set scaleX(value:Number) : void
      {
         super.scaleX = value;
         this.pivotX = 24 * value;
      }
   }
}

