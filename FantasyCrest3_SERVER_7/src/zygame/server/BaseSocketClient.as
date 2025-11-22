package zygame.server
{
   import flash.events.DatagramSocketDataEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.DatagramSocket;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import zygame.utils.Base64;
   
   public class BaseSocketClient
   {
      
      public static var allSendPkgSize:int = 0;
      
      private var _socket:Socket;
      
      public var _udp:DatagramSocket;
      
      public var handFunc:Function;
      
      public var ioerrorFunc:Function;
      
      public var dataFunc:Function;
      
      public var closeFunc:Function;
      
      public var udpFunc:Function;
      
      public var userName:String;
      
      public var userCode:String;
      
      public var userData:Object;
      
      public var logFunc:Function;
      
      public var udps:Array = [];
      
      private var _alldata:String = "";
      
      private var _cache:ByteArray;
      
      public function BaseSocketClient(psocket:Socket)
      {
         super();
         socket = psocket;
      }
      
      public static function code(str:String) : String
      {
         return str;
      }
      
      public static function uncode(str:*) : String
      {
         return str;
      }
      
      public function get udp() : DatagramSocket
      {
         return _udp;
      }
      
      public function pushUDP(ip:String, port:int) : void
      {
         for(var i in udps)
         {
            if(udps[i].ip == ip && udps[i].port == port)
            {
               return;
            }
         }
         udps.push({
            "ip":ip,
            "port":port
         });
      }
      
      public function onUDPData(e:DatagramSocketDataEvent) : void
      {
         var ob:Object = toObject(e.data);
         if(!ob)
         {
            return;
         }
         if(logFunc != null)
         {
            logFunc("接收到数据UDP",userName,JSON.stringify(ob),e.data.length,"drc",e.dstAddress,e.dstPort,"src",e.srcAddress,e.srcPort);
         }
         switch(ob.type)
         {
            case "back":
               return;
            case "acceated":
               return;
            case "acceat":
               Service.client.sendUDP({"type":"acceated"},e.srcAddress,e.srcPort);
               return;
            default:
               if(Boolean(udpFunc))
               {
                  udpFunc(ob);
               }
               return;
         }
      }
      
      public function set socket(s:Socket) : void
      {
         if(_socket)
         {
            _socket.removeEventListener("close",onSocketClose);
            _socket.removeEventListener("socketData",onSocketData);
            _socket.removeEventListener("connect",onConnect);
            _socket.removeEventListener("ioError",onError);
         }
         _socket = s;
         if(!s)
         {
            return;
         }
         _socket.addEventListener("close",onSocketClose);
         _socket.addEventListener("socketData",onSocketData);
         _socket.addEventListener("connect",onConnect);
         _socket.addEventListener("ioError",onError);
      }
      
      public function get socket() : Socket
      {
         return _socket;
      }
      
      protected function onError(e:IOErrorEvent) : void
      {
         trace("失败：",e.errorID,e.text);
         if(ioerrorFunc != null)
         {
            ioerrorFunc();
         }
      }
      
      protected function onSocketData(e:ProgressEvent) : void
      {
         if(socket.bytesAvailable == 0)
         {
            return;
         }
         var byte:ByteArray = new ByteArray();
         socket.readBytes(byte,0,e.bytesTotal);
         pushCache(byte);
         parsingCache();
      }
      
      public function pushCache(byte:ByteArray) : void
      {
         if(_cache == null)
         {
            _cache = byte;
         }
         else
         {
            _cache.position = _cache.length;
            _cache.writeBytes(byte);
            byte.clear();
         }
      }
      
      public function parsingCache() : void
      {
         var len:* = 0;
         var data:ByteArray = null;
         var newbyte:ByteArray = null;
         if(!_cache)
         {
            return;
         }
         var par:int = 0;
         _cache.position = par;
         while(_cache.bytesAvailable > 2)
         {
            len = uint(_cache.readShort());
            if(_cache.bytesAvailable < len)
            {
               break;
            }
            _cache.position = par + 2;
            data = new ByteArray();
            _cache.readBytes(data,0,len);
            backData(data);
            par += 2 + len;
            _cache.position = par;
         }
         if(par != 0)
         {
            if(_cache.bytesAvailable > 0)
            {
               newbyte = new ByteArray();
               _cache.position = par;
               _cache.readBytes(newbyte,0,_cache.bytesAvailable);
               _cache.clear();
               _cache = newbyte;
            }
            else
            {
               _cache.clear();
               _cache = null;
            }
         }
      }
      
      private function backData(data:ByteArray) : void
      {
         var ob:Object = null;
         try
         {
            data.position = 0;
            ob = data.readObject();
            if(ob)
            {
               if(dataFunc != null)
               {
                  dataFunc(ob);
               }
            }
         }
         catch(e:Error)
         {
            trace("解析出现异常",data,e.message,e.errorID,e.getStackTrace());
         }
      }
      
      protected function onSocketClose(e:Event) : void
      {
         if(closeFunc != null)
         {
            closeFunc();
         }
         socket.removeEventListener("close",onSocketClose);
         socket.removeEventListener("socketData",onSocketData);
      }
      
      public function sendUDP(data:Object, ip:String = null, port:int = 0) : void
      {
         try
         {
            _udp.send(toByte(data),0,0,ip,port);
         }
         catch(e:Error)
         {
            trace("UDP Error ",e.message);
         }
      }
      
      public function toByte(ob:Object) : ByteArray
      {
         var byte:ByteArray = new ByteArray();
         byte.writeObject(ob);
         return byte;
      }
      
      public function toObject(byte:ByteArray) : Object
      {
         return byte.readObject();
      }
      
      public function send(data:Object) : void
      {
         if(!socket || !socket.connected)
         {
            return;
         }
         var _loc4_:* = data.type;
         if("hand" === _loc4_)
         {
            userName = data.userName;
            userCode = data.userCode;
         }
         var byte:ByteArray = toByte(data);
         socket.writeShort(byte.length);
         socket.writeBytes(byte);
         var len:int = String(byte.length).length + byte.length;
         allSendPkgSize += len + byte.length;
         socket.flush();
      }
      
      public function openUDP() : void
      {
         if(Boolean(logFunc))
         {
            logFunc("开始打洞");
         }
         _udp.send(toByte({
            "type":"connect",
            "ip":socket.localAddress,
            "port":socket.localPort,
            "userName":userName
         }),0,0,socket.remoteAddress,socket.remotePort);
      }
      
      public function bindUDP(ip:String, port:int) : void
      {
         if(_udp)
         {
            trace("开始绑定",ip,port);
            _udp.bind(port,ip);
            _udp.receive();
         }
      }
      
      protected function onConnect(e:Event) : void
      {
         _udp = new DatagramSocket();
         bindUDP(socket.localAddress,socket.localPort);
         _udp.addEventListener("data",onUDPData);
         if(handFunc != null)
         {
            handFunc();
         }
      }
      
      public function get connected() : Boolean
      {
         if(!socket)
         {
            return false;
         }
         return socket.connected;
      }
      
      public function close() : void
      {
         if(socket && socket.connected)
         {
            socket.close();
         }
         socket = null;
      }
   }
}

