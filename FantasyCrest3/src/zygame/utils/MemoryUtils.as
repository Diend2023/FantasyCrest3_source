package zygame.utils
{
   public class MemoryUtils
   {
      
      public function MemoryUtils()
      {
         super();
      }
      
      public static function clearObject(data:Object) : void
      {
         if(!data)
         {
            return;
         }
         for(var i in data)
         {
            delete data[i];
         }
         i = null;
      }
   }
}

