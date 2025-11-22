package zygame.display
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import lzm.util.Base64;
   import nape.phys.BodyType;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   import zygame.core.PoltCore;
   import zygame.data.ActorNameData;
   import zygame.utils.NapeUtils;
   
   public class Actor extends MovieDisplay
   {
      
      public static var defaultSpriteClass:Class = null;
      
      public static var defaultDragonClass:Class = null;
      
      private var _polt:Array;
      
      private var _show:Boolean = true;
      
      public var nameUiText:TextureUIText;
      
      private var _createFrame:int = -1;
      
      private var _isCanHit:Boolean;
      
      private var _lockX:int = 0;
      
      private var _lockY:int = 0;
      
      private var _xmlList:XMLList;
      
      public function Actor(target:String, fps:int = 24)
      {
         super(target,fps);
      }
      
      override public function onInit() : void
      {
         var bound:Rectangle = null;
         var npcName:String = ActorNameData.getName(targetName);
         if(npcName != null)
         {
            bound = this.bounds;
            nameUiText = new TextureUIText(npcName,TextureUIText.defaultTextureName,10);
            world.addChild(nameUiText);
            nameUiText.x = this.x;
            nameUiText.y = this.y + 12;
            nameUiText.scale = 0.5;
         }
         _xmlList = this.xml.children();
         draw(true);
         var arr:Array = DataCore.getArray(this.getPointLockName());
         if(arr)
         {
            setX(arr[0]);
            setY(arr[1]);
         }
         else
         {
            setX(this.x);
            setY(this.y);
         }
         this.isCanHit = false;
         GameCore.currentWorld.poltSystem.initNPC(this);
         this.lockBounds();
      }
      
      public function getPoltAtName(pname:String) : XML
      {
         for(var i in _polt)
         {
            if(_polt[i].name == pname)
            {
               return new XML(_polt[i].data);
            }
         }
         return null;
      }
      
      public function getEventPolt() : String
      {
         var arr:Array = PoltCore.getEvents();
         if(arr)
         {
            for(var i in _polt)
            {
               if(arr.indexOf(_polt[i].name) != -1)
               {
                  return _polt[i].name;
               }
            }
         }
         return PoltCore.getPoltState(getName());
      }
      
      public function get polt() : XML
      {
         var poltName:String = null;
         if(this.alpha < 0.9)
         {
            return null;
         }
         if(_polt != null)
         {
            poltName = getEventPolt();
            return getPoltAtName(poltName);
         }
         return null;
      }
      
      public function hasPolt() : Boolean
      {
         return _polt != null;
      }
      
      public function setPolt(data:Object) : void
      {
         if(!data)
         {
            return;
         }
         var arr:Array = null;
         if(data is Array)
         {
            arr = data as Array;
         }
         else
         {
            arr = JSON.parse(Base64.decode(data as String)) as Array;
         }
         _polt = arr;
      }
      
      override public function discarded() : void
      {
         super.discarded();
      }
      
      private function removeSelf() : void
      {
         this.removeFromParent(true);
         if(this.body && this.body.space)
         {
            this.body.space.bodies.remove(this.body);
         }
      }
      
      public function set show(b:Boolean) : void
      {
         _show = b;
         if(b)
         {
            super.isCanHit = _isCanHit;
         }
         else
         {
            super.isCanHit = false;
         }
         this.visible = b;
      }
      
      public function get show() : Boolean
      {
         return _show;
      }
      
      override public function set visible(value:Boolean) : void
      {
         if(value)
         {
            value = show;
         }
         super.visible = value;
         if(nameUiText)
         {
            nameUiText.visible = value;
         }
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(this.body)
         {
            this.x = this.body.position.x;
            this.y = this.body.position.y;
         }
      }
      
      override public function draw(bool:Boolean = false) : void
      {
         var drawFrame:int = 0;
         super.draw(bool);
         var curFrame:int = currentDrawFrame;
         if(_createFrame != curFrame || bool)
         {
            drawFrame = currentXmlDrawFrame;
            if(!_xmlList)
            {
               _xmlList = xml.children();
            }
            if(_xmlList[drawFrame].@hitPoint != undefined)
            {
               _createFrame = curFrame;
               updateBody(drawFrame);
            }
         }
      }
      
      public function updateBody(drawFrame:int) : void
      {
         this.createBody(NapeUtils.parsingPoint(String(xml.children()[drawFrame].@hitPoint)),BodyType.KINEMATIC);
      }
      
      override public function set isCanHit(b:Boolean) : void
      {
         _isCanHit = b;
         if(this.targetName == "door_lock")
         {
            trace("lock",b);
         }
         super.isCanHit = _isCanHit;
      }
      
      public function lockPoint(point:Point = null) : void
      {
         if(point)
         {
            DataCore.updateValue(this.getPointLockName(),[point.x,point.y]);
         }
         else if(int(this.x) != _lockX || int(this.y) != _lockY)
         {
            _lockX = this.x;
            _lockY = this.y;
            DataCore.updateValue(this.getPointLockName(),[this.x,this.y]);
         }
      }
      
      public function isLockPoint() : Boolean
      {
         return DataCore.getArray(this.getPointLockName()) != null;
      }
      
      public function getPointLockName() : String
      {
         return "point_" + GameCore.currentWorld.targetName + "_" + this.getName();
      }
      
      public function onPoltEvent() : void
      {
      }
      
      public function cheakCanMessage(display:BaseRole) : Boolean
      {
         var rect:Rectangle = this.bounds;
         var pos:Point = new Point(rect.x + rect.width / 2,rect.y + rect.height);
         if(Math.abs(pos.x - display.x) < 100 && Math.abs(pos.y - display.y) < 64)
         {
            return true;
         }
         return false;
      }
   }
}

