package lzm.starling.swf.components
{
   import lzm.starling.swf.display.SwfSprite;
   
   public interface ISwfComponent
   {
      
      function get name() : String;
      
      function set name(param1:String) : void;
      
      function initialization(param1:SwfSprite) : void;
      
      function get editableProperties() : Object;
      
      function set editableProperties(param1:Object) : void;
   }
}

