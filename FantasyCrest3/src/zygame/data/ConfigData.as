package zygame.data
{
   public class ConfigData
   {
      
      private var _config:XML;
      
      public function ConfigData(xml:XML)
      {
         super();
         _config = xml;
      }
      
      public function getMainMap() : String
      {
         return _config.@mapMain;
      }
      
      public function getLoads() : Vector.<String>
      {
         var vector:Vector.<String> = new Vector.<String>();
         var list:XMLList = _config.child("file");
         for(var i in list)
         {
            vector.push(list[i].@path);
         }
         return vector;
      }
   }
}

