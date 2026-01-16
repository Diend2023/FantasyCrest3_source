package lzm.starling.swf.display
{
   import lzm.starling.swf.again.ASprite;
   import lzm.starling.swf.components.ISwfComponent;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Image;
   import starling.text.TextField;
   
   public class SwfSprite extends ASprite
   {
      
      public var classLink:String;
      
      public var data:Array;
      
      public var spriteData:Array;
      
      protected var _color:uint;
      
      public function SwfSprite()
      {
         super();
      }
      
      public function getTextField(name:String) : TextField
      {
         return getChildByName(name) as TextField;
      }
      
      public function getButton(name:String) : SwfButton
      {
         return getChildByName(name) as SwfButton;
      }
      
      public function getMovie(name:String) : SwfMovieClip
      {
         return getChildByName(name) as SwfMovieClip;
      }
      
      public function getSprite(name:String) : SwfSprite
      {
         return getChildByName(name) as SwfSprite;
      }
      
      public function getImage(name:String) : SwfImage
      {
         return getChildByName(name) as SwfImage;
      }
      
      public function getScale9Image(name:String) : SwfScale9Image
      {
         return getChildByName(name) as SwfScale9Image;
      }
      
      public function getShapeImage(name:String) : SwfShapeImage
      {
         return getChildByName(name) as SwfShapeImage;
      }
      
      public function addComponent(component:ISwfComponent) : void
      {
      }
      
      public function getComponent(name:String) : ISwfComponent
      {
         return null;
      }
      
      public function set color(value:uint) : void
      {
         _color = value;
         setDisplayColor(this,_color);
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      protected function setDisplayColor(display:DisplayObject, color:uint) : void
      {
         var displayObjectContainer:DisplayObjectContainer = null;
         var numChild:int = 0;
         var i:int = 0;
         if(display is Image)
         {
            (display as Image).color = color;
         }
         else if(display is DisplayObjectContainer)
         {
            displayObjectContainer = display as DisplayObjectContainer;
            numChild = displayObjectContainer.numChildren;
            for(i = 0; i < numChild; )
            {
               display = displayObjectContainer.getChildAt(i);
               if(display is DisplayObjectContainer)
               {
                  setDisplayColor(display as DisplayObjectContainer,color);
               }
               else if(display is Image)
               {
                  (display as Image).color = color;
               }
               i++;
            }
         }
      }
   }
}

