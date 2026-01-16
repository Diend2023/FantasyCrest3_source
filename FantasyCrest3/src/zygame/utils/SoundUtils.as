package zygame.utils
{
   import flash.geom.Point;
   
   public class SoundUtils
   {
      
      public function SoundUtils()
      {
         super();
      }
      
      public static function mathPan(x:int, y:int, x1:int, y1:int, width:int) : Number
      {
         var i:Number = 0;
         var d:int = Point.distance(new Point(x,0),new Point(x1,0));
         i = d / width;
         if(x < x1)
         {
            i *= -1;
         }
         return i;
      }
   }
}

