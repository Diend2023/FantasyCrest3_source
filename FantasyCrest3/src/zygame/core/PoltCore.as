package zygame.core
{
   public class PoltCore
   {
      
      private static const HEAD:String = "polt_state_";
      
      public function PoltCore()
      {
         super();
      }
      
      public static function changePoltState(target:String, state:String, targetMap:String = null) : void
      {
         DataCore.updateValue("polt_state_" + (targetMap ? targetMap : GameCore.currentWorld.targetName) + "_" + target,state);
         GameCore.currentWorld.dispatchEventWith("polt_event_change",true);
      }
      
      public static function getPoltState(target:String, targetMap:String = null) : String
      {
         var state:String = DataCore.getString("polt_state_" + (targetMap ? targetMap : GameCore.currentWorld.targetName) + "_" + target);
         if(!state)
         {
            return "默认";
         }
         return state;
      }
      
      public static function addEvent(eventName:String) : void
      {
         var arr:Array = getEvents();
         if(!arr)
         {
            arr = [];
         }
         arr.push(eventName);
         DataCore.updateValue("poltEvents",arr);
         GameCore.currentWorld.dispatchEventWith("polt_event_change",true);
      }
      
      public static function removeEvent(eventName:String) : void
      {
         var index:int = 0;
         var arr:Array = getEvents();
         if(arr)
         {
            index = int(arr.indexOf(eventName));
            if(index != -1)
            {
               arr.splice(arr.indexOf(eventName),1);
               DataCore.updateValue("poltEvents",arr);
            }
         }
         GameCore.currentWorld.dispatchEventWith("polt_event_change",true);
      }
      
      public static function getEvents() : Array
      {
         return DataCore.getArray("poltEvents");
      }
      
      public static function hasEvent(str:String) : Boolean
      {
         var arr:Array = getEvents();
         if(arr)
         {
            return arr.indexOf(str) != -1;
         }
         return false;
      }
   }
}

