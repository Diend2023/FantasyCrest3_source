package zygame.event
{
   import starling.events.Event;
   
   public class GameAgentEvent extends Event
   {
      
      public static const GOLD_UPDATE:String = "gold_update";
      
      public var eventData:Object;
      
      public function GameAgentEvent(type:String, pdata:Object = null)
      {
         super(type);
         eventData = pdata;
      }
   }
}

