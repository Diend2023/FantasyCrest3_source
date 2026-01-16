package zygame.data
{
   import flash.utils.Dictionary;
   import lzm.starling.swf.FPSUtil;
   import zygame.core.GameCore;
   import zygame.display.World;
   
   public class SpoilsRefresh
   {
      
      private static var _singleton:SpoilsRefresh;
      
      private var _refreshTime:int = 300;
      
      private var _spoilsDict:Dictionary;
      
      private var _dataDict:Dictionary;
      
      private var _fps:FPSUtil;
      
      public function SpoilsRefresh()
      {
         super();
         _dataDict = new Dictionary();
         _spoilsDict = new Dictionary();
      }
      
      public static function get singleton() : SpoilsRefresh
      {
         if(!_singleton)
         {
            _singleton = new SpoilsRefresh();
         }
         return _singleton;
      }
      
      public function put(key:String, data:Object) : void
      {
         _spoilsDict[key] = _refreshTime;
         _dataDict[key] = data;
      }
      
      public function set refreshTime(i:int) : void
      {
         _refreshTime = i;
      }
      
      public function onFrame() : void
      {
         var id:String = null;
         for(var i in _spoilsDict)
         {
            id = i as String;
            if(id.indexOf(GameCore.currentWorld.targetName + "_") != 0)
            {
               _spoilsDict[i]--;
               if(_spoilsDict[i] <= 0)
               {
                  remove(id);
               }
            }
         }
      }
      
      public function getMapSpoils(world:World, isClear:Boolean = false) : Vector.<Object>
      {
         var id:String = null;
         var list:Vector.<Object> = new Vector.<Object>();
         for(var i in _dataDict)
         {
            id = i as String;
            if(id.indexOf(GameCore.currentWorld.targetName + "_") == 0)
            {
               list.push(_dataDict[id]);
               if(isClear)
               {
                  remove(id);
               }
            }
         }
         return list;
      }
      
      public function remove(id:String) : void
      {
         delete _dataDict[id];
         delete _spoilsDict[id];
      }
      
      public function resetAll() : void
      {
         if(_dataDict)
         {
            for(var i in _dataDict)
            {
               delete _dataDict[i];
            }
         }
         if(_spoilsDict)
         {
            for(var i2 in _spoilsDict)
            {
               delete _spoilsDict[i];
            }
         }
         _dataDict = new Dictionary();
         _spoilsDict = new Dictionary();
      }
   }
}

