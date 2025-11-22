package zygame.display
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import nape.dynamics.Arbiter;
   import nape.phys.Body;
   import nape.phys.BodyList;
   import nape.phys.BodyType;
   import nape.shape.Polygon;
   import starling.animation.Tween;
   import starling.core.Starling;
   
   public class EventActor extends Actor
   {
      
      public var impulse:Point = new Point(0,1);
      
      public var vibration:Boolean = true;
      
      public var lock:Boolean = false;
      
      public var moveSpeed:int = 0;
      
      public var tweenSpeed:int = 0;
      
      public var onContainsBody:Function;
      
      public var onArbitersBody:Function;
      
      private var _lockPoint:Point;
      
      private var _eventBody:Body;
      
      private var _isTrigger:Boolean = false;
      
      private var _activation:Boolean = false;
      
      public function EventActor(target:String, fps:int = 24)
      {
         super(target,fps);
      }
      
      override public function onInit() : void
      {
         trace("onCreateEvent");
         super.onInit();
      }
      
      override public function onFrame() : void
      {
         var bodys:BodyList;
         super.onFrame();
         if(!body)
         {
            return;
         }
         if(!lock)
         {
            if(onArbitersBody != null)
            {
               if(body.arbiters.length > 0)
               {
                  body.arbiters.foreach(function(a:Arbiter):void
                  {
                     var body2:Body = a.body1 == body ? a.body2 : a.body1;
                     if(body2.userData.ref is BaseRole && (body2.userData.ref as BaseRole).hitBody != body2)
                     {
                        return;
                     }
                     onArbitersBody(body2);
                  });
               }
            }
            else if(onContainsBody != null)
            {
               bodys = world.nape.bodiesInBody(body);
               if(bodys.length > 0)
               {
                  bodys.foreach(onContainsBody);
               }
               else
               {
                  trace("无接触");
               }
            }
         }
         if(!body || _isTrigger || !_eventBody)
         {
            return;
         }
         _eventBody.position.x = this.x;
         _eventBody.position.y = this.y;
         if(_eventBody.arbiters.length > 0)
         {
            _eventBody.arbiters.foreach(function(a:Arbiter):void
            {
               var body2:Body = a.body1 == _eventBody ? a.body2 : a.body1;
               if(body2.userData.ref is BaseRole && !_isTrigger)
               {
                  if((body2.userData.ref as BaseRole).troopid == 1)
                  {
                     trigger();
                  }
               }
            });
         }
      }
      
      public function trigger() : void
      {
         var tw:Tween = null;
         _isTrigger = true;
         if(tweenSpeed != moveSpeed)
         {
            tw = new Tween(this,0.5,"easeIn");
            tw.animate("moveSpeed",tweenSpeed);
            Starling.juggler.add(tw);
         }
      }
      
      public function set rect(r:Rectangle) : void
      {
         _eventBody = new Body(BodyType.KINEMATIC);
         var p:Polygon = new Polygon(Polygon.rect(r.x,r.y,r.width,r.height));
         _eventBody.shapes.add(p);
         _eventBody.space = world.nape;
         _eventBody.userData.noHit = true;
      }
      
      public function discardedBody() : void
      {
         _eventBody.space.bodies.remove(_eventBody);
      }
      
      override public function set rotation(value:Number) : void
      {
         if(body)
         {
            body.rotation = value;
         }
         if(_eventBody)
         {
            _eventBody.rotation = value;
         }
         super.rotation = value;
         impulse.x = Math.sin(-value);
         impulse.y = Math.cos(-value);
      }
   }
}

