package zygame.script
{
   public class IF
   {
      
      public function IF()
      {
         super();
      }
      
      public static function ifInt(v3:Object, v4:Object, k:String) : Boolean
      {
         var v1:int = int(v3);
         var v2:int = int(v4);
         switch(k)
         {
            case ">":
               return v1 > v2;
            case "<":
               return v1 < v2;
            case "==":
               return v1 == v2;
            case ">=":
               return v1 >= v2;
            case "<=":
               return v1 <= v2;
            default:
               return false;
         }
      }
      
      public static function toInt(v:int) : int
      {
         return v;
      }
   }
}

