package game.uilts
{
   import flash.utils.ByteArray;
   import zygame.utils.Base64;
   
   public class DecodeFightXML
   {
      
      public function DecodeFightXML()
      {
         super();
      }
      
      public static function decode(xml:XML) : XML
      {
         var i:int = 0;
         var data:String = xml.@data;
         var byte:ByteArray = Base64.decodeToByteArray(data);
         for(i = 0; i < byte.bytesAvailable; )
         {
            var _loc6_:* = i;
            var _loc7_:* = byte[_loc6_] + i;
            byte[_loc6_] = _loc7_;
            i++;
         }
         return new XML(byte.toString());
      }
   }
}

