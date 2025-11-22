package zygame.data
{
   public class GameEXPData
   {
      
      public static var level:int = 40;
      
      public function GameEXPData()
      {
         super();
      }
      
      public static function exp(lv:int, base:int) : int
      {
         if(lv > level)
         {
            lv = level;
         }
         return base * (lv * lv * lv + 5 * lv);
      }
      
      public static function lv(exp2:int, base:int) : int
      {
         var i:int = 0;
         for(i = 1; i <= 40; )
         {
            if(exp(i,base) > exp2)
            {
               return i;
            }
            i++;
         }
         return level;
      }
      
      public static function getMaxExp(base:int) : int
      {
         return exp(level,base);
      }
   }
}

