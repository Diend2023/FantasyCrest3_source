package zygame.display
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   import starling.display.Mesh;
   import starling.display.MeshBatch;
   import starling.events.Event;
   import starling.utils.MeshSubset;
   import zygame.debug.Debug;
   
   public class BatchContainer extends MeshBatch
   {
      
      public static var disableIFMustDraw:Boolean = false;
      
      public var rootData:Object;
      
      private var _targetName:String;
      
      private var _gameFogSprite:FogSprite;
      
      private var _meshs:Vector.<Mesh>;
      
      private var _mx:Matrix = new Matrix();
      
      public var world:World;
      
      public var isInited:Boolean = false;
      
      private var _lockRect:Rectangle;
      
      private var _lockPoint:Rectangle;
      
      public function BatchContainer()
      {
         super();
         _meshs = new Vector.<Mesh>();
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
      }
      
      public function onFrameAfter() : void
      {
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
      }
      
      public function addChild(child:DisplayObject) : void
      {
         if(child as Mesh)
         {
            _meshs.push(child);
            if(child as BatchContainer)
            {
               (child as BatchContainer).onAdd(null);
            }
            super.addMesh(child as Mesh);
         }
      }
      
      public function addToBatch(batch:BatchContainer) : void
      {
         for(var i in _meshs)
         {
            if(_meshs[i].visible)
            {
               batch.addMesh(_meshs[i]);
            }
         }
      }
      
      public function updateDisplay() : void
      {
         this.clear();
         this.addToBatch(this);
      }
      
      override public function addMesh(mesh:Mesh, matrix:Matrix = null, alpha:Number = 1, subset:MeshSubset = null, ignoreTransformations:Boolean = false) : void
      {
         super.addMesh(mesh,matrix,mesh.alpha);
      }
      
      public function removeChild(child:DisplayObject, d:Boolean = false) : void
      {
         var index:int = int(_meshs.indexOf(child as Mesh));
         if(index != -1)
         {
            _meshs.removeAt(index);
         }
      }
      
      public function discarded() : void
      {
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
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
         var rect:Rectangle = this.bounds;
         return new Point(this.x,rect.y);
      }
      
      public function setPos(pos:Point) : void
      {
         this.x = pos.x;
         this.y = pos.y;
      }
   }
}

