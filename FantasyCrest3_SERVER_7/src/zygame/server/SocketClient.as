package zygame.server
{
   import flash.events.Event;
   import flash.net.Socket;
   import zygame.utils.SendDataUtils;
   
   public class SocketClient extends BaseSocketClient
   {
      
      public var server:GameServer;
      
      public var room:SocketRoom;
      
      private var _remoteAddress:String;
      
      public var onLockFrameData:Function;
      
      public var udpip:String = "";
      
      public var udpport:int = 0;
      
      public var type:String;
      
      public var ready:Boolean;
      
      public function SocketClient(psocket:Socket, pserver:GameServer = null)
      {
         super(psocket);
         _remoteAddress = socket.remoteAddress;
         server = pserver;
         this.dataFunc = onObjectData;
      }
      
      override protected function onSocketClose(e:Event) : void
      {
         super.onSocketClose(e);
         if(isServer)
         {
            server.log("[离线]",this.userName,this.remoteAddress);
            server.removeSocket(this,true);
            if(room != null)
            {
               server.exitRoom(this,room.id);
            }
         }
      }
      
      public function onObjectData(ob:Object) : void
      {
         var data:Object;
         var putUserData:*;
         if(isServer)
         {
            putUserData = function(userData:Object):*
            {
               if(userData)
               {
                  send(SendDataUtils.userData(userData));
               }
               else
               {
                  send(SendDataUtils.userData(null));
               }
            };
            switch(ob.type)
            {
               case "hand":
                  userName = ob.userName;
                  userCode = ob.userCode;
                  server.hand(this);
                  return;
               case "message":
                  server.log("[消息]",ob.target,userName + ":" + ob.msg);
                  break;
               case "create_room":
                  server.createRoom(this,ob.mode,ob.count,ob.code);
                  break;
               case "join_room":
                  this.ready = false;
                  server.joinRoom(this,ob.id,ob.code);
                  break;
               case "exit_room":
                  this.ready = false;
                  server.exitRoom(this,ob.id);
                  break;
               case "room_message":
               case "room_message_all":
                  if(room)
                  {
                     room.send(this,ob,ob.type == "room_message_all");
                  }
                  break;
               case "room_lock_frame":
                  if(room && onLockFrameData != null)
                  {
                     onLockFrameData(ob);
                  }
                  break;
               case "heart":
                  send({"type":"heart"});
                  break;
               case "room_list":
                  data = SendDataUtils.roomList(roomList);
                  data.count = GameServer.mServer.connectCount;
                  send(data);
                  break;
               case "lock":
                  if(this.room)
                  {
                     this.room.lock();
                  }
                  server.spreadRoomList();
                  break;
               case "unlock":
                  if(this.room)
                  {
                     this.room.unlock();
                  }
                  server.spreadRoomList();
                  break;
               case "change_role":
                  if(room)
                  {
                     server.log("[更换身份]",type + "-->" + ob.change);
                     this.type = ob.change;
                     room.sendPlayer(this);
                  }
                  break;
               case "update_user_data":
               case "getCode":
               case "registration":
               case "addCrystal":
               case "addCoin":
               case "transferMoney":
               case "modificationUserCode":
                  break;
               case "ready":
                  this.ready = true;
                  this.room.sendPlayer(this);
                  break;
               case "cannel":
                  this.ready = false;
                  this.room.sendPlayer(this);
            }
            if(server.hasHand(this))
            {
               server.log("[非法]","无效的握手");
               this.close();
               server.removeSocket(this);
            }
         }
      }
      
      public function get roomList() : Array
      {
         return GameServer.mServer.roomList;
      }
      
      public function get isServer() : Boolean
      {
         return server != null;
      }
      
      override public function close() : void
      {
         super.close();
         if(isServer && room != null)
         {
            server.exitRoom(this,room.id);
         }
      }
      
      public function get remoteAddress() : String
      {
         return _remoteAddress;
      }
   }
}

