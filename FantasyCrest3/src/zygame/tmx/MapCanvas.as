package zygame.tmx
{
   import nape.dynamics.Arbiter;
   import nape.phys.Body;
   import starling.display.Canvas;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Mesh;
   import starling.geom.Polygon;
   import zygame.display.World;
   
   public class MapCanvas extends Canvas
   {
      
      public var mode:String;
      
      public var body:Body;
      
      public var world:World;
      
      public var image:Image;
      
      public function MapCanvas(pmode:String)
      {
         super();
         mode = pmode;
      }
      
      public function onFrame() : void
      {
         var isShow:Boolean;
         if(mode == "dynamic_visible" && world.role)
         {
            isShow = true;
            if(body.arbiters.length > 0)
            {
               body.arbiters.foreach(function(a:Arbiter):void
               {
                  var body2:Body = a.body1 == body ? a.body2 : a.body1;
                  if(body2 == world.role.body)
                  {
                     isShow = false;
                  }
               });
            }
            if(isShow && this.alpha < 1)
            {
               this.alpha += 0.1;
            }
            else if(!isShow && this.alpha > 0)
            {
               this.alpha -= 0.1;
            }
            if(image)
            {
               image.alpha = this.alpha;
               this.visible = image.visible;
            }
         }
      }
      
      override public function drawPolygon(polygon:Polygon) : void
      {
         super.drawPolygon(polygon);
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         var mesh:Mesh = null;
         if(child is Mesh)
         {
            mesh = child as Mesh;
         }
         return super.addChild(child);
      }
      
      override public function dispose() : void
      {
         if(body)
         {
            for(var i in body.userData)
            {
               body.userData[i] = null;
               delete body.userData[i];
            }
         }
         body = null;
         world = null;
         image = null;
         super.dispose();
      }
   }
}

