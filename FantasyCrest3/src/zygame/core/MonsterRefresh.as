package zygame.core
{
   import flash.utils.Dictionary;
   import zygame.display.BaseRole;
   
   public class MonsterRefresh
   {
      
      private static var _singleton:MonsterRefresh;
      
      private var _refreshDict:Dictionary;
      
      public function MonsterRefresh()
      {
         super();
         _refreshDict = new Dictionary();
      }
      
      public static function get singleton() : MonsterRefresh
      {
         if(!_singleton)
         {
            _singleton = new MonsterRefresh();
         }
         return _singleton;
      }
      
      public function add(role:BaseRole, time:int = 60) : void
      {
         _refreshDict[role.identification] = time;
      }
      
      public function onFrame() : void
      {
         for(var i in _refreshDict)
         {
            _refreshDict[i]--;
            if(_refreshDict[i] <= 0)
            {
               delete _refreshDict[i];
            }
         }
      }
      
      public function resurrection(target:String) : Boolean
      {
         if(_refreshDict[target])
         {
            return false;
         }
         return true;
      }
   }
}

