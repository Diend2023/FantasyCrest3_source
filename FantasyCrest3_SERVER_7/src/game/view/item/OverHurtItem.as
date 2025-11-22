package game.view.item
{
   import starling.display.Image;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.core.DataCore;
   import zygame.display.DisplayObjectContainer;
   
   public class OverHurtItem extends DisplayObjectContainer
   {
      
      private var _text:TextField;
      
      public function OverHurtItem(target:String)
      {
         super();
         var img:Image = new Image(DataCore.getTextureAtlas("select_role").getTexture(target));
         this.addChild(img);
         _text = new TextField(img.width,img.height,"99999",new TextFormat("mini",12,16777215));
         this.addChild(_text);
      }
      
      public function set strData(str:String) : void
      {
         _text.text = str;
      }
   }
}

