package zygame.utils
{
   import com.adobe.crypto.MD5;
   import flash.filesystem.File;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class PkgUtils
   {
      
      public static var dataFile:File;
      
      public static var hashMaps:Object;
      
      public static var md5s:Dictionary;
      
      private static var bytesData:ByteArray;
      
      public static var bytesFile:File = File.applicationStorageDirectory.resolvePath("game_data.data");
      
      public function PkgUtils()
      {
         super();
      }
      
      public static function init(data:File, hash:File, xmlMd5:File) : void
      {
         var bytes:ByteArray = null;
         trace(data.nativePath,hash.nativePath);
         dataFile = data;
         if(dataFile.isDirectory)
         {
            bytes = getDicBytes(dataFile);
            RTools.saveByteArray(bytesFile,bytes);
            bytes.clear();
            bytes = null;
         }
         var byte:ByteArray = RTools.readByteArray(hash);
         byte.uncompress();
         var hashString:String = byte.readUTFBytes(byte.bytesAvailable);
         hashMaps = JSON.parse(hashString);
         var md5byte:String = RTools.readString(xmlMd5);
         initMD5(md5byte);
      }
      
      public static function initMD5(str:String) : void
      {
         var arr2:Array = null;
         md5s = new Dictionary();
         var arr:Array = str.split(",");
         for(var i in arr)
         {
            arr2 = arr[i].split(":");
            md5s[arr2[0]] = arr2[1];
         }
      }
      
      public static function getDicBytes(file:File) : ByteArray
      {
         var i:int = 0;
         var tfile:File = null;
         var newbyte:ByteArray = null;
         var byte:ByteArray = new ByteArray();
         byte.position = 0;
         var array:Array = file.getDirectoryListing();
         for(i = 0; i < array.length; )
         {
            tfile = file.resolvePath("data_" + (i + 1) + ".data");
            if(!tfile.isHidden && tfile.exists)
            {
               trace("写入：",tfile.name);
               newbyte = RTools.readByteArray(tfile);
               byte.writeBytes(newbyte);
               newbyte.clear();
               newbyte = null;
            }
            i++;
         }
         return byte;
      }
      
      public static function readByteFormTarget(fileName:String, onByteFunc:Function) : void
      {
         if(hashMaps[fileName])
         {
            readByte(hashMaps[fileName],function(byte:ByteArray):void
            {
               md5Func(fileName,byte,onByteFunc);
            });
         }
         else
         {
            onByteFunc(null);
         }
      }
      
      public static function md5Func(fileName:String, byte:ByteArray, func:Function) : void
      {
         var md5:String = null;
         trace("读取",fileName);
         var str:String = fileName.substr(fileName.lastIndexOf("/") + 1);
         if(str.indexOf(".xml") != -1)
         {
            md5 = MD5.hashBinary(byte);
            trace(str,"验证",md5,md5s[str]);
            if(md5s[str] == md5)
            {
               func(byte);
            }
            else
            {
               func(null);
               trace(fileName,"验证错误！","Data:",byte);
            }
         }
         else
         {
            func(byte);
         }
      }
      
      public static function readByte(index:String, onByteFunc:Function) : void
      {
         var arr:Array = index.split("_");
         var start:int = int(arr[0]);
         var len:int = int(arr[1]);
         trace("读取：",index,start,len);
         var byte:ByteArray = new ByteArray();
         var fileSteam:FileStream = new FileStream();
         fileSteam.open(bytesFile,"read");
         fileSteam.position = start;
         fileSteam.readBytes(byte,0,len);
         fileSteam.close();
         try
         {
            byte.uncompress("lzma");
         }
         catch(e:Error)
         {
            trace("解压错误:",e.message);
            return;
         }
         onByteFunc(byte);
      }
   }
}

