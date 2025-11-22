package zygame.utils
{
   import flash.net.NetworkInfo;
   import flash.net.NetworkInterface;
   
   public class IPUtils
   {
      
      public function IPUtils()
      {
         super();
      }
      
      public static function get currentIP() : String
      {
         var i:int = 0;
         var i2:int = 0;
         var address:String = null;
         var netinfo:NetworkInfo = NetworkInfo.networkInfo;
         var interfaces:Vector.<NetworkInterface> = netinfo.findInterfaces();
         if(interfaces != null)
         {
            for(i = 0; i < interfaces.length; )
            {
               if(interfaces[i].addresses.length != 0)
               {
                  for(i2 = 0; i2 < interfaces[i].addresses.length; )
                  {
                     address = interfaces[i].addresses[i2].address;
                     if(address.indexOf("127.") != 0 && address.indexOf(".",2) != -1)
                     {
                        return address;
                     }
                     i2++;
                  }
               }
               i++;
            }
         }
         return null;
      }
   }
}

