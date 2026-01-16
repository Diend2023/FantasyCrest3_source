package game.data
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class PrivateTest
   {
      
      public static var isPrivate:Boolean = false;
      
      private static const URL:String = "private.json";
      
      public function PrivateTest()
      {
         super();
      }
      
      public static function validation(userName:String, func:Function) : void
      {
         var url:URLLoader;
         if(!isPrivate || Game.vip.value >= 1)
         {
            func(0);
         }
         url = new URLLoader(new URLRequest("private.json?" + Math.random()));
         url.addEventListener("complete",function(e:Event):void
         {
            var arr:Array = JSON.parse(e.target.data) as Array;
            func(arr.indexOf(userName) != -1 ? 0 : 1);
         });
         url.addEventListener("ioError",function(e:IOErrorEvent):void
         {
            func(1);
         });
      }
   }
}

