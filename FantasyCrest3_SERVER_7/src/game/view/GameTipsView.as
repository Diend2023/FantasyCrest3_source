package game.view
{
   import flash.geom.Rectangle;
   import game.uilts.GameFont;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.core.DataCore;
   import zygame.display.DisplayObjectContainer;
   
   public class GameTipsView extends DisplayObjectContainer
   {
      
      public static var tips:GameTipsView;
      
      private var _message:String;
      
      public function GameTipsView(message:String)
      {
         if(tips)
         {
            tips.out();
         }
         tips = this;
         _message = message;
         super();
      }
      
      override public function onInit() : void
      {
         super.onInit();
         var spr:Sprite = new Sprite();
         var img:Image = new Image(DataCore.getTextureAtlas("select_role").getTexture("tips_frame"));
         spr.addChild(img);
         img.scale9Grid = new Rectangle(10,10,32,32);
         var txt:TextField = new TextField(img.width,img.height,_message,new TextFormat(GameFont.FONT_NAME,12,16777215));
         spr.addChild(txt);
         spr.x = -300;
         spr.y = 128;
         this.addChild(spr);
         Starling.juggler.tween(spr,0.5,{"x":-35});
         Starling.juggler.delayCall(out,3);
      }
      
      public function out() : void
      {
         var tw:Tween = null;
         if(this.parent)
         {
            tw = new Tween(this,0.5);
            tw.animate("x",-300);
            Starling.juggler.add(tw);
            tw.onComplete = removeFromParent;
         }
      }
   }
}

