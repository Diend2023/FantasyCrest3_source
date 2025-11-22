package zygame.server
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.Socket;
   import flash.system.Security;
   import flash.utils.setTimeout;
   import zygame.utils.SendDataUtils;
   
   public class Service extends BaseSocketClient
   {
      
      public static var userData:Object;
      
      public static var client:Service;
      
      private var _type:String = "tourists";
      
      public var joinFunc:Function;
      
      public var exitFunc:Function;
      
      public var createRoom:Function;
      
      public var messageFunc:Function;
      
      public var delayFunc:Function;
      
      public var progressFunc:Function;
      
      public var roomlistFunc:Function;
      
      public var rolelistFunc:Function;
      
      public var getroledataFunc:Function;
      
      public var userDataFunc:Function;
      
      private var _heartbeat:Boolean = false;
      
      private var _oldtime:int = 0;
      
      private var _delays:Vector.<int>;
      
      private var _port:int = 0;
      
      private var _deady:Number;
      
      public var roomPlayerList:Array;
      
      private var _autoFind:Boolean = false;
      
      private var _findip:int = 1;
      
      private var _autoip:String;
      
      private var _timeout:uint = 3000;
      
      private var _findSockets:Vector.<Socket>;
      
      private var _errorCount:int = 0;
      
      public function Service(ip:String, post:int, autoFind:Boolean = false)
      {
         var psocket:Socket;
         _delays = new Vector.<int>();
         trace("Service ip:",ip,post,autoFind);
         _findSockets = new Vector.<Socket>();
         _port = post;
         _autoip = ip.substr(0,ip.lastIndexOf("."));
         _autoFind = autoFind;
         psocket = new Socket();
         psocket.timeout = _timeout;
         Security.loadPolicyFile("http://" + ip + ":4999/crossdomain.xml");
         psocket.connect(ip,post);
         super(psocket);
         this.dataFunc = function(data:Object):void
         {
            var i:int = 0;
            var newtime:int = 0;
            try
            {
               switch(data.type)
               {
                  case "push_udp":
                     break;
                  case "bind_udp":
                     for(i = 0; i < 15; )
                     {
                        hitUDP(data.ip,data.port + i);
                        i++;
                     }
                     pushUDP(data.ip,data.port);
                     break;
                  case "handed":
                     userData = data.userData;
                     if(userDataFunc != null)
                     {
                        userDataFunc(data.userData);
                     }
                     break;
                  case "room_manages":
                     _type = "master";
                     if(createRoom != null)
                     {
                        createRoom(data);
                     }
                     break;
                  case "room_accept":
                     _type = "player";
                     if(createRoom != null)
                     {
                        createRoom(data);
                     }
                     break;
                  case "room_refused":
                     break;
                  case "join_room":
                     if(joinFunc != null)
                     {
                        joinFunc(data);
                     }
                     break;
                  case "exit_room":
                     if(exitFunc != null)
                     {
                        exitFunc(data);
                     }
                     break;
                  case "room_message":
                  case "room_message_all":
                     if(messageFunc != null)
                     {
                        messageFunc(data);
                     }
                     break;
                  case "heart":
                     _heartbeat = false;
                     newtime = new Date().time;
                     _delays.push(newtime - _oldtime);
                     if(_delays.length > 10)
                     {
                        _delays.shift();
                     }
                     heartbeat();
                     if(delayFunc != null)
                     {
                        delayFunc();
                     }
                     break;
                  case "room_list":
                     if(roomlistFunc != null)
                     {
                        roomlistFunc(data);
                     }
                     break;
                  case "room_player_list":
                     Service.client.type = "player";
                     for(var t in data.list)
                     {
                        if(data.list[t].name == userName)
                        {
                           Service.client.type = data.list[t].type;
                        }
                     }
                     roomPlayerList = data.list;
                     if(rolelistFunc != null)
                     {
                        rolelistFunc(data);
                     }
                     break;
                  case "get_room_player_data":
                     if(getroledataFunc != null)
                     {
                        getroledataFunc(data);
                     }
                     break;
                  case "user_data":
                     userData = data;
                     if(userDataFunc != null)
                     {
                        userDataFunc(data.data);
                     }
               }
            }
            catch(e:Error)
            {
               trace("Service Error",e.message);
            }
         };
         client = this;
      }
      
      public static function startService(ip:String, post:int, ioFunc:Function, autoFind:Boolean = false) : void
      {
         var ser:Service = null;
         if(!client || !client.connected)
         {
            ser = new Service(ip,post,autoFind);
            ser.ioerrorFunc = ioFunc;
         }
      }
      
      public static function createRoom(userName:String, userId:String, code:String, mode:String = "none", count:int = 4) : void
      {
         client.handFunc = function():void
         {
            client.send(SendDataUtils.handData(userName,userId));
            client.send(SendDataUtils.createRoom(mode,count,code));
         };
      }
      
      public static function joinRoom(userName:String, userId:String, roomid:int, code:String) : void
      {
         client.handFunc = function():void
         {
            trace("登场成功");
            client.send(SendDataUtils.handData(userName,userId));
            client.send(SendDataUtils.joinRoom(roomid,code));
         };
      }
      
      public static function send(data:Object) : void
      {
         if(client && client.connected)
         {
            client.send(data);
         }
      }
      
      public static function sendUDP(data:Object) : void
      {
         if(client && client.connected)
         {
            client.sendUDPAll(data);
         }
      }
      
      public static function radioUDP(data:Object) : void
      {
         data.userName = client.userName;
         Service.client.sendUDP(data,Service.client.socket.remoteAddress,Service.client.socket.remotePort);
      }
      
      public function hitUDP(ip:String, port:int) : void
      {
         var i:int;
         for(i = 0; i < 3; )
         {
            setTimeout(function():void
            {
               Service.client.sendUDP({"type":"acceat"},ip,port);
            },2000 * i);
            i = i + 1;
         }
      }
      
      override protected function onError(e:IOErrorEvent) : void
      {
         var i:int;
         var psocket:Socket;
         if(_autoFind && _findip < 255)
         {
            _findip = 255;
            for(i = 1; i <= 255; )
            {
               psocket = new Socket();
               psocket.timeout = _timeout;
               psocket.connect(_autoip + "." + i,_port);
               psocket.addEventListener("ioError",function(e:IOErrorEvent):void
               {
                  _errorCount++;
                  if(progressFunc != null)
                  {
                     progressFunc(_errorCount / 255);
                  }
                  if(_errorCount == 255)
                  {
                     onError(e);
                     _findSockets.splice(0,_findSockets.length);
                     _errorCount = 0;
                  }
               });
               psocket.addEventListener("connect",function(e:Event):void
               {
                  socket = e.target as Socket;
                  for(var o in _findSockets)
                  {
                     try
                     {
                        if(_findSockets[o] != socket)
                        {
                           _findSockets[o].close();
                        }
                     }
                     catch(e:Error)
                     {
                     }
                  }
                  _findSockets.splice(0,_findSockets.length);
                  onConnect(e);
               });
               _findSockets.push(psocket);
               i = i + 1;
            }
            if(progressFunc != null)
            {
               progressFunc(0);
            }
         }
         else
         {
            if(progressFunc != null)
            {
               progressFunc(1);
            }
            super.onError(e);
         }
      }
      
      override protected function onConnect(e:Event) : void
      {
         super.onConnect(e);
         _oldtime = new Date().time;
         heartbeat();
         if(progressFunc != null)
         {
            progressFunc(1);
         }
      }
      
      public function get type() : String
      {
         return _type;
      }
      
      public function set type(str:String) : void
      {
         _type = str;
      }
      
      public function get delay() : int
      {
         var num:int = 0;
         for(var i in _delays)
         {
            num += _delays[i];
         }
         return num / _delays.length;
      }
      
      public function heartbeat() : void
      {
         if(!_heartbeat)
         {
            _heartbeat = true;
            setTimeout(function():void
            {
               _oldtime = new Date().time;
               send({"type":"heart"});
            },1000);
         }
      }
      
      public function waitLength() : int
      {
         return socket.bytesAvailable;
      }
      
      public function sendUDPAll(data:Object) : void
      {
         for(var i in udps)
         {
            sendUDP(data,udps[i].ip,udps[i].port);
         }
      }
   }
}

