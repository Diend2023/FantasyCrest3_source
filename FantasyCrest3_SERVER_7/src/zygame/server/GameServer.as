package zygame.server
{
   import flash.desktop.NativeApplication;
   import flash.events.DatagramSocketDataEvent;
   import flash.events.Event;
   import flash.events.ServerSocketConnectEvent;
   import flash.net.DatagramSocket;
   import flash.net.ServerSocket;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import zygame.utils.SendDataUtils;
   
   public class GameServer
   {
      
      public static var mServer:GameServer;
      
      private var _CTRL:Array = [];
      
      private var sockets:Vector.<SocketClient>;
      
      private var hands:Vector.<SocketClient>;
      
      private var rooms:Vector.<SocketRoom>;
      
      public var server:ServerSocket;
      
      public var server843:ServerSocket;
      
      public var udp:DatagramSocket;
      
      public var logFunc:Function;
      
      public var changeFunc:Function;
      
      public function GameServer(ip:String, post:int)
      {
         super();
         mServer = this;
         sockets = new Vector.<SocketClient>();
         hands = new Vector.<SocketClient>();
         rooms = new Vector.<SocketRoom>();
         server = new ServerSocket();
         server.bind(post,ip);
         setTimeout(function():void
         {
            log("[侦听]" + ip + ":" + post);
            log("[侦听UDP]" + ip + ":" + post);
            udp = new DatagramSocket();
            udp.bind(post,ip);
            udp.addEventListener("data",onUDPData);
            udp.receive();
         },100);
         server.addEventListener("connect",onServerConnect);
         NativeApplication.nativeApplication.addEventListener("exiting",onExit);
         server.listen();
      }
      
      public function onUDPData(e:DatagramSocketDataEvent) : void
      {
         var clinet:SocketClient = null;
         var sendData:ByteArray = null;
         var backData:ByteArray = null;
         var byte:ByteArray = e.data;
         var ob:Object = byte.readObject();
         updateUDPPort(e,ob);
         if(ob.type == "connect")
         {
            log("[UDP打洞]","发送端：",e.srcAddress,e.srcPort,"宿主：",ob.userName);
         }
         else if(ob.type == "radio")
         {
            clinet = getClientFormName(ob.userName);
            if(clinet && clinet.room)
            {
               for(var i in clinet.room.clients)
               {
                  if(clinet.room.clients[i] != clinet)
                  {
                     sendData = new ByteArray();
                     sendData.writeObject(ob.data);
                     udp.send(sendData,0,0,clinet.room.clients[i].udpip,clinet.room.clients[i].udpport);
                  }
               }
            }
         }
         else if(ob.type == "back")
         {
            backData = new ByteArray();
            backData.writeObject(ob.data);
            udp.send(backData,0,0,e.srcAddress,e.srcPort);
         }
      }
      
      public function getClientFormName(pname:String) : SocketClient
      {
         for(var i in sockets)
         {
            if(sockets[i].userName == pname)
            {
               return sockets[i];
            }
         }
         return null;
      }
      
      public function updateUDPPort(e:DatagramSocketDataEvent, ob:Object) : void
      {
         var i:Object;
         var i2:int;
         for(i in sockets)
         {
            if(sockets[i].userName == ob.userName)
            {
               if(sockets[i].udpip != e.srcAddress || sockets[i].udpport != e.srcPort)
               {
                  log("[端口变更]",ob.userName,sockets[i].udpip + ":" + sockets[i].udpport + " >> " + e.srcAddress + ":" + e.srcPort);
                  sockets[i].udpip = e.srcAddress;
                  sockets[i].udpport = e.srcPort;
                  sockets[i].room.send(sockets[i],{
                     "type":"bind_udp",
                     "ip":sockets[i].udpip,
                     "port":sockets[i].udpport
                  });
                  for(i2 = 3; i2 >= 0; )
                  {
                     setTimeout(function():void
                     {
                        var byte:ByteArray = new ByteArray();
                        byte.writeObject({"type":"back"});
                        log("[UDP回应]",e.srcAddress,e.srcPort);
                        udp.send(byte,0,0,e.srcAddress,e.srcPort);
                     },3000 * i2);
                     i2--;
                  }
               }
            }
         }
      }
      
      private function onExit(e:Event) : void
      {
         log("[服务器停止]");
         if(server && server.listening)
         {
            server.close();
         }
         if(server843 && server843.listening)
         {
            server843.close();
         }
      }
      
      private function onServerConnect843(e:ServerSocketConnectEvent) : void
      {
         log("[843用户连接]",e.socket.remoteAddress);
         var tmpsocket:Socket = e.socket;
         var xml:XML = <cross-domain-policy> 
					<site-control permitted-cross-domain-policies="all"/> 
					<allow-access-from domain="*" to-ports="*"/>
					</cross-domain-policy>
				;
         tmpsocket.writeUTFBytes(xml.toString());
         tmpsocket.flush();
         log("[发送策略文件到]:" + tmpsocket.remoteAddress + ":" + tmpsocket.remotePort);
         tmpsocket.close();
      }
      
      private function onServerConnect(e:ServerSocketConnectEvent) : void
      {
         var xml:XML = null;
         log("[用户连接]",e.socket,e.socket.remoteAddress);
         if(_CTRL.indexOf(e.socket.remoteAddress) == -1 && false)
         {
            _CTRL.push(e.socket.remoteAddress);
            xml = <cross-domain-policy> 
									<site-control permitted-cross-domain-policies="all"/> 
									<allow-access-from domain="*" to-ports="*"/>
									</cross-domain-policy>
					;
            e.socket.writeUTFBytes(xml.toString());
            e.socket.flush();
            e.socket.close();
            log("[发送策略文件]");
            return;
         }
         var _loc3_:* = e.type;
         if("connect" === _loc3_)
         {
            listener(e.socket);
         }
      }
      
      private function listener(socket:Socket) : void
      {
         if(sockets.length >= maxCount || hasIp(socket))
         {
            log(">[拒绝]",socket.remoteAddress);
            socket.close();
            return;
         }
         hands.push(new SocketClient(socket,this));
         if(changeFunc != null)
         {
            changeFunc();
         }
         log("[握手]",socket.remoteAddress);
      }
      
      private function hasIp(socket:Socket) : Boolean
      {
         var i:int = 0;
         return false;
      }
      
      public function removeSocket(socket:SocketClient, updateBool:Boolean = false) : void
      {
         var ci:int = int(_CTRL.indexOf(socket.remoteAddress));
         var si:int = int(sockets.indexOf(socket));
         var hi:int = int(hands.indexOf(socket));
         if(ci != -1)
         {
            _CTRL.removeAt(ci);
         }
         if(si != -1)
         {
            sockets.removeAt(si);
         }
         if(hi != -1)
         {
            hands.removeAt(hi);
         }
         if(updateBool)
         {
            if(changeFunc != null)
            {
               changeFunc();
            }
         }
         clearSocket();
      }
      
      public function clearSocket() : void
      {
         var i:int = 0;
         for(i = sockets.length - 1; i >= 0; )
         {
            if(sockets[i].connected == false)
            {
               sockets.removeAt(i);
            }
            i--;
         }
      }
      
      public function get connectCount() : int
      {
         return sockets.length + hands.length;
      }
      
      public function get roomCount() : int
      {
         return rooms.length;
      }
      
      public function get maxCount() : int
      {
         return 50;
      }
      
      public function log(... ret) : void
      {
         var msg:String = ret.join(" ");
         if(logFunc != null)
         {
            logFunc(msg);
         }
      }
      
      public function hand(client:SocketClient) : void
      {
         log("[登录]",client.userName,"code:",client.userCode,"IP:",client.remoteAddress);
         if(true || client.userName == "tourists" && client.userCode == "tourists")
         {
            client.userData = null;
            if(true)
            {
               client.userData = {"nickName":client.userName};
            }
            removeSocket(client);
            sockets.push(client);
            client.send({"type":"handed"});
            if(changeFunc != null)
            {
               changeFunc();
            }
            return;
         }
         if(changeFunc != null)
         {
            changeFunc();
         }
      }
      
      public function hasHand(client:SocketClient) : Boolean
      {
         return hands.indexOf(client) != -1;
      }
      
      public function createRoom(client:SocketClient, mode:String, count:int, code:String) : void
      {
         if(client.room)
         {
            log("[创建房间失败]","已有归属的房间");
            return;
         }
         var room:SocketRoom = new SocketRoom(createRoomID(),client,code,mode,count);
         rooms.push(room);
         spreadRoomList();
         log("[创建房间]","创建房间",room.id,"房主：" + client.userName,"密码：",code);
         if(changeFunc != null)
         {
            changeFunc();
         }
      }
      
      public function spreadRoomList() : void
      {
         var i:int = 0;
         var data:Object = null;
         for(i = 0; i < this.sockets.length; )
         {
            if(sockets[i].room == null)
            {
               data = SendDataUtils.roomList(roomList);
               data.count = this.connectCount;
               sockets[i].send(data);
            }
            i++;
         }
      }
      
      public function get roomList() : Array
      {
         var i:int = 0;
         var arr:Array = [];
         for(i = 0; i < this.roomCount; )
         {
            arr.push({
               "id":this.rooms[i].id,
               "master":this.rooms[i].roomClient.userData.nickName,
               "code":(this.rooms[i].code != "" ? 1 : 0),
               "num":this.rooms[i].clients.length,
               "maxCount":this.rooms[i].maxCount,
               "lock":this.rooms[i].isLock,
               "mode":this.rooms[i].mode
            });
            i++;
         }
         return arr;
      }
      
      public function joinRoom(client:SocketClient, id:int, code:String) : void
      {
         var i:int = 0;
         for(i = 0; i < rooms.length; )
         {
            if(rooms[i].id == id)
            {
               log("[加入房间]","用户：",client.userName,"加入房间",id,"密码为",code);
               rooms[i].join(client,code);
               spreadRoomList();
               if(changeFunc != null)
               {
                  changeFunc();
               }
               return;
            }
            i++;
         }
         client.send({"type":"room_refused"});
         client.server.log("[拒绝加入]",client.userName,"无法加入房间");
         if(changeFunc != null)
         {
            changeFunc();
         }
      }
      
      public function exitRoom(client:SocketClient, id:int) : void
      {
         if(client.room != null)
         {
            log("[退出房间]",client.userName,"退出房间",id);
            client.room.exit(client);
         }
      }
      
      public function removeRoom(room:SocketRoom) : void
      {
         log("[关闭房间]","房号:",room.id,"已关闭");
         rooms.removeAt(rooms.indexOf(room));
         spreadRoomList();
         if(changeFunc != null)
         {
            changeFunc();
         }
      }
      
      public function createRoomID() : int
      {
         var i:int = 0;
         var id:int = 1;
         for(i = 0; i < rooms.length; )
         {
            if(rooms[i].id >= id)
            {
               id = rooms[i].id + 1;
            }
            i++;
         }
         return id;
      }
      
      public function onFrame() : void
      {
         for(var i in rooms)
         {
            rooms[i].onFrame();
         }
      }
   }
}

