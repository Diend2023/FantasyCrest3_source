package zygame.utils
{
   import flash.geom.Point;
   import starling.display.Mesh;
   import starling.utils.deg2rad;
   
   public class VertexUtils
   {
      
      public function VertexUtils()
      {
         super();
      }
      
      public static function getVertexRectPos(display:Mesh) : Vector.<Point>
      {
         var pos:Vector.<Point> = new Vector.<Point>();
         var wh:Point = new Point();
         var offpos:Point = new Point();
         var a:Number = display.rotation;
         display.rotation = 0;
         wh.x = display.width;
         wh.y = display.height * 0.5;
         display.rotation = a;
         var ha:Number = display.rotation - deg2rad(90);
         offpos.x = Math.cos(ha);
         offpos.y = Math.sin(ha);
         var hoffpos:Point = new Point();
         hoffpos.x = Math.cos(a);
         hoffpos.y = Math.sin(a);
         pos.push(new Point(display.x + offpos.x * wh.y,display.y + offpos.y * wh.y));
         pos.push(new Point(pos[0].x + hoffpos.x * wh.x,pos[0].y + hoffpos.y * wh.x));
         pos.push(new Point(display.x - offpos.x * wh.y,display.y - offpos.y * wh.y));
         pos.push(new Point(pos[2].x + hoffpos.x * wh.x,pos[2].y + hoffpos.y * wh.x));
         return pos;
      }
      
      public static function setVertexRectPos(display:Mesh, pos:Vector.<Point>) : void
      {
         var i:int = 0;
         for(i = 0; i < pos.length; )
         {
            display.setVertexPosition(i,pos[i].x - display.x,pos[i].y - display.y + display.pivotY);
            i++;
         }
      }
      
      public static function rotation(display:Mesh, a:Number) : void
      {
         var i:int = 0;
         for(i = 0; i < display.numVertices; )
         {
            mathPoint(i,display,a);
            i++;
         }
         display.setVertexDataChanged();
      }
      
      public static function mathPoint(id:int, display:Mesh, a:Number) : void
      {
         var centerPos:Point = new Point();
         var pos:Point = new Point();
         var newpos:Point = new Point();
         display.getVertexPosition(id,pos);
         newpos.x = (pos.x - centerPos.x) * Math.cos(a) - (pos.y - centerPos.y) * Math.sin(a) + centerPos.x;
         newpos.y = (pos.x - centerPos.x) * Math.sin(a) + (pos.y - centerPos.y) * Math.cos(a) + centerPos.y;
         display.setVertexPosition(id,newpos.x,newpos.y);
      }
      
      public static function setWidth(display:Mesh, w:Number, a:Number) : void
      {
         mathWidth(0,display,w,a);
         mathWidth(2,display,w,a);
      }
      
      public static function mathWidth(id:int, display:Mesh, w:Number, a:Number) : void
      {
         var pos:Point = new Point();
         display.getVertexPosition(id,pos);
         pos.x += w * Math.cos(a);
         pos.y += w * Math.sin(a);
         display.setVertexPosition(id + 1,pos.x,pos.y);
         var uv:Point = new Point();
         display.getTexCoords(id + 1,uv);
         display.setTexCoords(id + 1,w / display.width,uv.y);
      }
      
      public static function px(display:Mesh, w:Number) : void
      {
         mathPx(0,display,w);
         mathPx(1,display,w);
         mathPx(2,display,w);
         mathPx(3,display,w);
      }
      
      public static function mathPx(id:int, display:Mesh, w:Number) : void
      {
         var pos:Point = new Point();
         display.getTexCoords(id,pos);
         trace("原始UV：",id,pos);
         pos.x -= 0.5;
         display.setTexCoords(id,pos.x,pos.y);
         trace("平移后：",id,pos);
      }
      
      public static function join(display:Mesh, endDisplay:Mesh) : void
      {
         joinPos(1,display,endDisplay);
         joinPos(3,display,endDisplay);
      }
      
      public static function joinPos(id:int, display:Mesh, endDisplay:Mesh) : void
      {
         var posStart:Point = new Point();
         display.getVertexPosition(id,posStart);
         posStart.x += display.x;
         posStart.y += display.y;
         var posEnd:Point = new Point();
         endDisplay.getVertexPosition(id - 1,posEnd);
         var r:Number = Math.atan2(display.y - endDisplay.y,display.x - endDisplay.x);
         posEnd.x += endDisplay.x - 1 * Math.cos(r);
         posEnd.y += endDisplay.y - 1 * Math.sin(r);
         trace("相连",posStart,posEnd);
         var sub:Point = posStart.subtract(posEnd);
         endDisplay.getVertexPosition(id - 1,posEnd);
         endDisplay.setVertexPosition(id - 1,posEnd.x + sub.x,posEnd.y + sub.y);
         trace("拼接",posEnd.subtract(posStart));
      }
   }
}

