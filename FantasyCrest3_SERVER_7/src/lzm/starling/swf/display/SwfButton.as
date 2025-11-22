package lzm.starling.swf.display
{
   import lzm.starling.display.Button;
   import starling.display.DisplayObject;
   
   public class SwfButton extends Button
   {
      
      public var classLink:String;
      
      public function SwfButton(skin:DisplayObject, text:String = null, textFont:String = null)
      {
         super(skin,text,textFont);
      }
   }
}

