package zygame.utils
{
   import flash.geom.Point;
   import nape.geom.Vec2;
   
   public class PointUtils
   {
      
      public static const vec2:Vec2 = new Vec2();
      
      public function PointUtils()
      {
         super();
      }
      
      public static function getClockwisePoints(arr:Vector.<Point>) : Vector.<Point>
      {
         var i:int = 0;
         var v:* = null;
         var minXPoint:Point = getMinXPoint(arr);
         var ifv:Vector.<Point> = new Vector.<Point>();
         var it:int = int(arr.indexOf(minXPoint));
         arr = arr.concat(arr);
         ifv.push(arr[it],arr[it + 1],arr[it + 2]);
         var p1:Point = ifv[0].subtract(ifv[1]);
         var p2:Point = ifv[1].subtract(ifv[2]);
         var a:Number = p1.x * p2.y - p1.y * p2.x;
         if(a < -1)
         {
            v = new Vector.<Point>();
            for(i = arr.length - 1; i >= 0; )
            {
               v.push(arr[i]);
               i--;
            }
         }
         else
         {
            v = arr;
         }
         return v;
      }
      
      public static function getMinXPoints(arr:Vector.<Point>) : Vector.<Point>
      {
         var i:int = 0;
         var v:Vector.<Point> = new Vector.<Point>();
         var minXPoint:Point = getMinXPoint(arr);
         var index:int = int(arr.indexOf(minXPoint));
         if(index == 0)
         {
            return arr;
         }
         i = index + 1;
         if(i >= arr.length)
         {
            i = 0;
         }
         v.push(minXPoint);
         while(i != index)
         {
            v.push(arr[i]);
            if(++i >= arr.length)
            {
               i = 0;
            }
         }
         return v;
      }
      
      public static function getMaxXPoint(arr:Vector.<Point>) : Point
      {
         var point:Point = arr[0];
         for(var i in arr)
         {
            if(arr[i].x > point.x)
            {
               point = arr[i];
            }
         }
         return point;
      }
      
      public static function getMinXPoint(arr:Vector.<Point>) : Point
      {
         var point:Point = arr[0];
         for(var i in arr)
         {
            if(arr[i].x < point.x)
            {
               point = arr[i];
            }
         }
         return point;
      }
      
      public static function getMaxYPoint(arr:Vector.<Point>) : Point
      {
         var point:Point = arr[0];
         for(var i in arr)
         {
            if(arr[i].y > point.y)
            {
               point = arr[i];
            }
         }
         return point;
      }
      
      public static function getMinYPoint(arr:Vector.<Point>) : Point
      {
         var point:Point = arr[0];
         for(var i in arr)
         {
            if(arr[i].y < point.y)
            {
               point = arr[i];
            }
         }
         return point;
      }
      
      public static function pointToLine(point1:Point, point2:Point, point3:Point) : Number
      {
         var d:Number = 0;
         var a:Number = Point.distance(point1,point2);
         var b:Number = Point.distance(point1,point3);
         var c:Number = Point.distance(point2,point3);
         if(c + b == a)
         {
            return 0;
         }
         if(c * c >= a * a + b * b)
         {
            return b;
         }
         if(b * b >= a * a + c * c)
         {
            return c;
         }
         var p:Number = (a + b + c) / 2;
         var s:Number = Math.sqrt(p * (p - a) * (p - b) * (p - c));
         return 2 * s / a;
      }
      
      public static function conversionVec2(points:Vector.<Point>) : Vector.<Vec2>
      {
         var i:int = 0;
         if(!points)
         {
            return null;
         }
         var vec2s:Vector.<Vec2> = new Vector.<Vec2>();
         for(i = 0; i < points.length; )
         {
            vec2s.push(new Vec2(points[i].x,points[i].y));
            i++;
         }
         return vec2s;
      }
      
      public static function conversionArray(points:Vector.<Point>) : Array
      {
         var i:int = 0;
         if(!points)
         {
            return null;
         }
         var vec2s:Array = [];
         for(i = 0; i < points.length; )
         {
            vec2s.push(new Point(points[i].x,points[i].y));
            i++;
         }
         return vec2s;
      }
   }
}

