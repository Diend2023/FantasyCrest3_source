package zygame.server
{
   public class SocketRoom
   {
      
      public var roomClient:SocketClient;
      
      public var id:int;
      
      public var code:String;
      
      public var mode:String;
      
      public var clients:Vector.<SocketClient>;
      
      public var maxCount:int = 4;
      
      public var isLock:Boolean = false;
      
      public var _lockFrameDatas:Array = [];
      
      private var _frame:int = 0;
      
      public function SocketRoom(pid:int, client:SocketClient, pcode:String, pmode:String, count:int)
      {
         super();
         id = pid;
         roomClient = client;
         maxCount = count;
         mode = pmode;
         code = pcode;
         clients = new Vector.<SocketClient>();
         clients.push(roomClient);
         roomClient.room = this;
         roomClient.type = "master";
         roomClient.send({
            "type":"room_manages",
            "id":id,
            "code":pcode,
            "mode":mode,
            "count":maxCount,
            "list":getList()
         });
         roomClient.send({
            "type":"room_player_list",
            "list":getList()
         });
         roomClient.onLockFrameData = onLockFrame;
      }
      
      public function onLockFrame(data:Object) : void
      {
         _lockFrameDatas.push(data);
         var datas:Array = [];
         for(var i in _lockFrameDatas)
         {
            if(_lockFrameDatas[i].keyFrame == _frame)
            {
               datas.push(_lockFrameDatas[i]);
            }
         }
         if(datas.length >= maxCount)
         {
            send(roomClient,{
               "type":"room_message",
               "target":"lock_frame",
               "list":datas,
               "keyFrame":_frame
            },true);
            for(var d in datas)
            {
               _lockFrameDatas.removeAt(_lockFrameDatas.indexOf(datas[d]));
            }
            _frame++;
         }
      }
      
      public function onFrame() : void
      {
      }
      
      public function join(client:SocketClient, pcode:String) : void
      {
         if(isLock || client.room != null || currentCount >= maxCount || pcode != code)
         {
            client.send({"type":"room_refused"});
            client.server.log("[拒绝加入]",client.userName,"无法加入房间");
         }
         else
         {
            clients.push(client);
            client.room = this;
            client.type = clients.length > 2 ? "watching" : "player";
            client.send({
               "type":"room_accept",
               "id":id,
               "code":pcode,
               "mode":mode,
               "count":maxCount,
               "list":getList()
            });
            send(client,{
               "type":"join_room",
               "name":client.userName
            });
            send(client,{
               "type":"room_player_list",
               "list":getList()
            });
            client.onLockFrameData = onLockFrame;
            client.server.log("[进入房间]",client.userName,"已加入房间");
         }
      }
      
      public function lock() : void
      {
         isLock = true;
      }
      
      public function unlock() : void
      {
         isLock = false;
         for(var i in clients)
         {
            clients[i].ready = false;
         }
      }
      
      public function exit(client:SocketClient) : void
      {
         client.type = "player";
         if(roomClient == client)
         {
            if(currentCount == 1)
            {
               clients.removeAt(0);
               client.server.removeRoom(this);
            }
            else
            {
               clients.removeAt(clients.indexOf(client));
               roomClient = clients[0];
               roomClient.type = "master";
               clients[0].send({
                  "type":"room_manages",
                  "id":id,
                  "code":code,
                  "mode":mode,
                  "count":maxCount,
                  "list":getList()
               });
               sendPlayer(client);
               client.server.log("[成为房主]","用户",clients[0].userName,"成为房主");
            }
         }
         else
         {
            clients.removeAt(clients.indexOf(client));
            sendPlayer(client);
         }
         send(client,{
            "type":"exit_room",
            "name":client.userName
         });
         client.room = null;
      }
      
      public function sendPlayer(client:SocketClient) : void
      {
         send(client,{
            "type":"room_player_list",
            "id":id,
            "code":code,
            "mode":mode,
            "count":maxCount,
            "list":getList()
         },true);
      }
      
      public function get currentCount() : int
      {
         return clients.length;
      }
      
      public function send(client:SocketClient, data:Object, isAll:Boolean = false) : void
      {
         var i:int = 0;
         for(i = 0; i < clients.length; )
         {
            if(clients[i] != client || isAll)
            {
               clients[i].send(data);
            }
            i++;
         }
      }
      
      public function getList() : Array
      {
         var i:int = 0;
         var arr:Array = [];
         for(i = 0; i < clients.length; )
         {
            arr.push({
               "name":clients[i].userName,
               "master":(clients[i] == roomClient ? 1 : 0),
               "ip":clients[i].socket.remoteAddress,
               "port":clients[i].socket.remotePort,
               "udpip":clients[i].udpip,
               "udpport":clients[i].udpport,
               "type":clients[i].type,
               "isReady":clients[i].ready,
               "nickName":clients[i].userData.nickName
            });
            i++;
         }
         return arr;
      }
   }
}

