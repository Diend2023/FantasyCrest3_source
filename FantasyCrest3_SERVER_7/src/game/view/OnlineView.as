package game.view
{
   import zygame.display.KeyDisplayObject;
   import zygame.server.Service;
   
   public class OnlineView extends KeyDisplayObject
   {
      
      public function OnlineView()
      {
         super();
      }
      
      public function onMessage(data:Object) : void
      {
      }
      
      public function action(str:String, data:Object = null) : void
      {
         var ob:Object = data ? data : {
            "type":"room_message",
            "userName":GameOnlineRoomListView._userName
         };
         if(data != null)
         {
            ob.type = "room_message";
            ob.userName = GameOnlineRoomListView._userName;
         }
         ob.action = str;
         Service.send(ob);
      }
   }
}

