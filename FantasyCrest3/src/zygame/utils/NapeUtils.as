package zygame.utils
{
   import nape.geom.Vec2;
   
   public class NapeUtils
   {
      
      public function NapeUtils()
      {
         super();
      }
      
      public static function parsingPoint(data:String) : Vector.<Vec2>
      {
         var i:int = 0;
         var intarr:Array = null;
         var v:Vector.<Vec2> = new Vector.<Vec2>();
         var arr:Array = data.split(" ");
         for(i = 0; i < arr.length; )
         {
            intarr = arr[i].split(",");
            v.push(new Vec2(int(intarr[0]),int(intarr[1])));
            i++;
         }
         return v;
      }
   }
}

