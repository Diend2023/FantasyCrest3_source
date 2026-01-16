package zygame.display
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Mesh;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import zygame.debug.Debug;
   
   public class DisplayObjectContainer extends Sprite
   {
      
      public static var disableIFMustDraw:Boolean = false;
      
      public var posPoint:Point;
      
      public var rootData:Object;
      
      private var _targetName:String;
      
      private var _gameFogSprite:FogSprite;
      
      public var world:World;
      
      public var isInited:Boolean = false;
      
      private var _lockRect:Rectangle;
      
      private var _lockPoint:Rectangle;
      
      public var isRemoveing:Boolean = false;
      
      public function DisplayObjectContainer()
      {
         super();
         this.addEventListener("addedToStage",onAdd);
         this.addEventListener("removedFromStage",onRemove);
         if(Debug.IS_SHOW_ROLE_LINE)
         {
            debug();
         }
      }
      
      protected function onAdd(e:Event) : void
      {
         this.parsingOther();
         if(!this.isInited)
         {
            this.onInit();
         }
         this.isInited = true;
      }
      
      public function onInit() : void
      {
      }
      
      public function draw(bool:Boolean = false) : void
      {
      }
      
      public function onFrame() : void
      {
         onMove();
         draw();
         onChange();
         this.visible = isMustDrawStage();
      }
      
      public function onFrameAfter() : void
      {
         if(this.parent && isRemoveing)
         {
            this.removeFromParent(true);
         }
      }
      
      public function onMove() : void
      {
      }
      
      public function onChange() : void
      {
      }
      
      public function setFogSprite(spr:FogSprite) : void
      {
         _gameFogSprite = spr;
      }
      
      public function getFogSprite() : FogSprite
      {
         return _gameFogSprite;
      }
      
      public function debug() : void
      {
         var qx:Quad = new Quad(200,1,16711680);
         qx.x -= 100;
         this.addChild(qx);
         var qy:Quad = new Quad(1,200,16711680);
         qy.y -= 100;
         this.addChild(qy);
      }
      
      public function discarded() : void
      {
         isRemoveing = true;
      }
      
      protected function onRemove(e:Event) : void
      {
      }
      
      public function getAttribute() : Object
      {
         return null;
      }
      
      public function setX(i:int) : void
      {
         super.x = i;
      }
      
      public function setY(i:int) : void
      {
         super.y = i;
      }
      
      public function onSUpdate() : void
      {
      }
      
      public function set targetName(str:String) : void
      {
         _targetName = str;
      }
      
      public function get targetName() : String
      {
         return _targetName;
      }
      
      public function isMustDrawStage() : Boolean
      {
         if(disableIFMustDraw || !this.world || !this.parent)
         {
            return super.visible;
         }
         return this.bounds.intersects(this.world.drawRect);
      }
      
      protected function parsingOther() : void
      {
         var fz:Array = null;
         var value:Object = null;
         if(!rootData || !rootData.other)
         {
            return;
         }
         var arr:Array = String(rootData.other).split("\n");
         for(var i in arr)
         {
            fz = String(arr[i]).split("=");
            value = fz[1];
            if(value == "true")
            {
               value = true;
            }
            else if(value == "false")
            {
               value = false;
            }
            if(fz[0] != "" && value != "null")
            {
               this[fz[0]] = value;
               trace("赋值：",fz[0],value);
            }
         }
      }
      
      public function getName() : String
      {
         if(!rootData || !rootData.instanceName || String(rootData.instanceName) == "")
         {
            return this.targetName;
         }
         return String(rootData.instanceName);
      }
      
      public function setName(str:String) : void
      {
         if(!rootData)
         {
            rootData = {};
         }
         rootData.instanceName = str;
      }
      
      override public function get bounds() : Rectangle
      {
         if(_lockRect)
         {
            _lockRect.x = _lockPoint.width + this.x - _lockPoint.x;
            _lockRect.y = _lockPoint.height + this.y - _lockPoint.y;
            return _lockRect;
         }
         return super.bounds;
      }
      
      public function lockBounds() : void
      {
         _lockRect = super.bounds;
         _lockPoint = new Rectangle(this.x,this.y,_lockRect.x,_lockRect.y);
      }
      
      public function unlockBounds() : void
      {
         _lockRect = null;
      }
      
      public function getPoltPos() : Point
      {
         var point:Point = null;
         var rect:Rectangle = this.bounds;
         if(!posPoint)
         {
            point = new Point(this.x,rect.y);
            posPoint = point;
         }
         else
         {
            posPoint.x = this.x;
            posPoint.y = rect.y;
         }
         return posPoint;
      }
      
      public function setPos(pos:Point) : void
      {
         this.x = pos.x;
         this.y = pos.y;
      }
      
      public function callLate(func:Function) : void
      {
         Starling.juggler.delayCall(func,0.016666666666666666);
      }
      
      public function listenerFrame() : void
      {
         this.addEventListener("enterFrame",function(e:Event):void
         {
            this.onFrame();
         });
      }
      
      override public function dispose() : void
      {
         this.world = null;
         this._lockPoint = null;
         this._lockRect = null;
         this._gameFogSprite = null;
         this.rootData = null;
         this.removeEventListeners("enterFrame");
         super.dispose();
      }
      
      public function set style(pstyleClass:Class) : void
      {
         var i:int = 0;
         var child:DisplayObject = null;
         var len:Number = this.numChildren;
         for(i = 0; i < len; )
         {
            child = this.getChildAt(i);
            if(child is Mesh && !((child as Mesh).style is pstyleClass))
            {
               (child as Mesh).style = new pstyleClass();
            }
            else if(child is DisplayObjectContainer)
            {
               (child as DisplayObjectContainer).style = pstyleClass;
            }
            i++;
         }
      }
   }
}

