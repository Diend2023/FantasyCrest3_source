package zygame.display
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import lzm.starling.swf.display.SwfScale9Image;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.Texture;
   import zygame.core.DataCore;
   import zygame.utils.RUtils;
   
   public class TextureUIText extends DisplayObjectContainer
   {
      
      public static var defaultTextureName:String = "s9_namespr";
      
      private var _s9spr:SwfScale9Image;
      
      private var textField:TextField;
      
      private var _width:int = 0;
      
      public function TextureUIText(text:String, s9name:String = null, size:int = 12)
      {
         var bitmap:BitmapData = null;
         super();
         if(!s9name)
         {
            s9name = defaultTextureName;
         }
         _s9spr = DataCore.assetsSwf.createS9Image(s9name);
         if(!_s9spr)
         {
            bitmap = new BitmapData(120,32,true,0);
            _s9spr = new SwfScale9Image(Texture.fromBitmapData(bitmap),new Rectangle());
            bitmap.dispose();
         }
         textField = new TextField(200,64,RUtils.annotationText(text),new TextFormat("Verdana",size * 2,16777215));
         this.addChild(textField);
         textField.alignPivot();
         this.touchGroup = true;
         _s9spr.alignPivot();
         this.addChildAt(_s9spr,0);
         width = textField.textBounds.width;
      }
      
      override public function set width(value:Number) : void
      {
         _s9spr.width = value + 32;
         textField.width = value + 32;
         textField.alignPivot();
         _s9spr.alignPivot();
      }
      
      public function get bg() : SwfScale9Image
      {
         return _s9spr;
      }
   }
}

