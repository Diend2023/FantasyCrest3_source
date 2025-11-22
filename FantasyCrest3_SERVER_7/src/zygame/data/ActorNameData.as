package zygame.data
{
   import flash.utils.Dictionary;
   
   public class ActorNameData
   {
      
      private static var _dist:Dictionary;
      
      public function ActorNameData()
      {
         super();
      }
      
      public static function parsing(xml:XML) : void
      {
         if(!xml)
         {
            return;
         }
         var xmlList:XMLList = xml.children();
         _dist = new Dictionary();
         for(var i in xmlList)
         {
            _dist[String(xmlList[i].@target)] = xmlList[i].@name;
         }
      }
      
      public static function getName(target:String) : String
      {
         if(!_dist)
         {
            return null;
         }
         if(_dist[target])
         {
            return _dist[target];
         }
         for(var i in _dist)
         {
            if((i as String).indexOf(target) != -1)
            {
               return _dist[i];
            }
         }
         return null;
      }
   }
}

