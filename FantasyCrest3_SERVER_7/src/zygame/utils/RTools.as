package zygame.utils
{
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileStream;
   import flash.geom.Rectangle;
   import flash.net.SharedObject;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class RTools
   {
      
      private static var _share:SharedObject = SharedObject.getLocal("net.zygame.act.builder");
      
      public function RTools()
      {
         super();
      }
      
      public static function readString(file:File) : String
      {
         var fileStream:FileStream = new FileStream();
         fileStream.open(file,"read");
         var bytes:ByteArray = new ByteArray();
         fileStream.readBytes(bytes);
         var type:String = getFileType(bytes);
         trace("读取类型",type);
         fileStream.position = 0;
         var data:String = "";
         data = fileStream.readUTFBytes(fileStream.bytesAvailable);
         try
         {
            if(data.indexOf("<") == -1)
            {
               fileStream.position = 0;
               data = bytes.toString();
            }
            else
            {
               new XML(data);
            }
         }
         catch(e:Error)
         {
            fileStream.position = 0;
            data = fileStream.readMultiByte(fileStream.bytesAvailable,type);
         }
         return data;
      }
      
      private static function getFileType(fileData:ByteArray) : String
      {
         var b0:int = int(fileData.readUnsignedByte());
         var b1:int = int(fileData.readUnsignedByte());
         var fileType:String = "gb2312";
         if(b0 == 255 && b1 == 254)
         {
            fileType = "unicode";
         }
         else if(b0 == 254 && b1 == 255)
         {
            fileType = "UTF-8";
         }
         else if(b0 == 239 && b1 == 187)
         {
            fileType = "utf-8";
         }
         return fileType;
      }
      
      public static function readImage(file:File, func:Function) : void
      {
         var urlLoader:URLLoader = new URLLoader(new URLRequest(file.url));
         urlLoader.dataFormat = "binary";
         urlLoader.addEventListener("complete",function(e:Event):void
         {
            var loader:Loader = new Loader();
            loader.loadBytes(e.target.data as ByteArray);
            loader.contentLoaderInfo.addEventListener("complete",func);
         });
         urlLoader.addEventListener("ioError",function(e:IOErrorEvent):void
         {
            trace("无法加载" + file.nativePath,"加载失败");
         });
      }
      
      public static function saveString(file:File, data:String) : void
      {
         var fileStream:FileStream = new FileStream();
         fileStream.open(file,"write");
         fileStream.writeUTFBytes(data);
         fileStream.close();
      }
      
      public static function saveByteArray(file:File, data:ByteArray) : void
      {
         var fileStream:FileStream = new FileStream();
         fileStream.open(file,"write");
         fileStream.writeBytes(data);
         fileStream.close();
      }
      
      public static function readByteArray(file:File) : ByteArray
      {
         if(file.isDirectory)
         {
            return null;
         }
         var byte:ByteArray = new ByteArray();
         var fileStream:FileStream = new FileStream();
         fileStream.open(file,"read");
         fileStream.readBytes(byte);
         fileStream.close();
         return byte;
      }
      
      public static function type(str:String) : Object
      {
         if(str == "true" || str == "false")
         {
            return str == "true";
         }
         if(str == "null")
         {
            return "无";
         }
         if(String(int(str)) == str)
         {
            return int(str);
         }
         return str;
      }
      
      public static function openFile(call:Function, tips:String, types:Array) : void
      {
         var file:File = new File();
         if(types.indexOf("dic") != -1)
         {
            file.browseForDirectory(tips);
         }
         else
         {
            file.browseForOpen(tips,types);
         }
         file.addEventListener("select",call);
      }
      
      public static function createSelectSprite(spr:Sprite, rect:Rectangle) : void
      {
         spr.graphics.clear();
         spr.graphics.beginFill(16776960,0.5);
         spr.graphics.drawRect(0,0,rect.width,1);
         spr.graphics.drawRect(0,1,1,rect.height - 1);
         spr.graphics.drawRect(rect.width,1,1,rect.height - 1);
         spr.graphics.drawRect(1,rect.height,rect.width - 2,1);
         spr.graphics.endFill();
         spr.x = int(rect.x);
         spr.y = int(rect.y);
      }
      
      public static function setObject(key:String, ob:Object) : void
      {
         _share.data[key] = ob;
         _share.flush();
      }
      
      public static function getObject(key:String) : Object
      {
         return _share.data[key];
      }
      
      public static function optimizeName(str:String) : String
      {
         return str.split(" ").join("_").toLocaleLowerCase();
      }
   }
}

