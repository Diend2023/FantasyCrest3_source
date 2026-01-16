package zygame.event
{
   public class ZYError extends Error
   {
      
      public function ZYError(message:* = "", id:* = 0)
      {
         super("ZYGameEngine:" + message,id);
      }
   }
}

