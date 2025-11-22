package zygame.display
{
   import lzm.util.Base64;
   import nape.geom.Vec2;
   import starling.display.Quad;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   import zygame.core.PoltCore;
   
   public class EventDisplay extends BodyDisplayObject
   {
      
      private var _eventData:Object;
      
      private var _polt:Array;
      
      public var hitType:String = "role";
      
      private var _noEvent:int = 3;
      
      private var _available:Boolean = true;
      
      public function EventDisplay(eventData:Object)
      {
         super();
         _eventData = eventData;
         targetName = eventData.instanceName;
         setPolt(eventData.poltData);
      }
      
      override public function onInit() : void
      {
         super.onInit();
         this.x = _eventData.x;
         this.y = _eventData.y;
         var vec:Vector.<Vec2> = new Vector.<Vec2>();
         vec.push(new Vec2(0,0),new Vec2(_eventData.width,0),new Vec2(_eventData.width,_eventData.height),new Vec2(0,_eventData.height));
         this.createBody(vec);
      }
      
      override public function debug() : void
      {
         super.debug();
         var q:Quad = new Quad(_eventData.width,_eventData.height,16711680);
         this.addChild(q);
         q.alpha = 0.5;
      }
      
      public function onEvent(role:BaseRole) : void
      {
         var eventName:String = null;
         var targetXml:XML = null;
         if(!available)
         {
            return;
         }
         if(!this.isEventOver() && _noEvent <= 0)
         {
            if(hitType == "role" && role != GameCore.currentWorld.role)
            {
               return;
            }
            if(type == "warp_event")
            {
               if(!GameCore.currentWorld.isLockAsk)
               {
                  role.onUp(75);
                  role.onUp(74);
                  DataCore.updateValue("warp_x",(role.x - this.x) / this.width);
                  DataCore.updateValue("warp_y",(role.y - this.y) / this.height);
                  DataCore.updateValue("warp_lastX",role.lastTimeX);
                  DataCore.updateValue("warp_scaleX",role.scaleX);
                  DataCore.updateValue("warp_isJump",role.isJump());
                  DataCore.updateValue("warp_jumpMath",role.jumpMath);
                  GameCore.scriptCore.goMap(_eventData.go,_eventData.to);
               }
            }
            else if(!world.poltSystem.isRuning)
            {
               eventName = getEventPolt();
               targetXml = getPoltAtName(eventName);
               GameCore.currentWorld.poltSystem.poltFormXML(targetXml);
               role.lastTimeX = 0;
               if(this.isOneEvent())
               {
                  this.eventOver();
               }
            }
         }
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(_noEvent > 0)
         {
            _noEvent--;
         }
      }
      
      public function isEventOver() : Boolean
      {
         if(!isOneEvent())
         {
            return false;
         }
         var state:String = PoltCore.getPoltState(this.getName());
         return state == "EventOver";
      }
      
      public function eventOver() : void
      {
         PoltCore.changePoltState(this.getName(),"EventOver");
      }
      
      public function startEvent() : void
      {
         PoltCore.changePoltState(this.getName(),"EventStart");
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
      
      protected function getEventPolt() : String
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
         return "默认";
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
            poltName = PoltCore.getPoltState(getName() == "" ? targetName : getName());
            if(poltName == "默认")
            {
               poltName = getEventPolt();
            }
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
         var jsondata:String = null;
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
            jsondata = Base64.decode(data as String);
            arr = JSON.parse(jsondata) as Array;
         }
         _polt = arr;
      }
      
      public function get type() : String
      {
         return _eventData.type;
      }
      
      public function isOneEvent() : Boolean
      {
         if(_eventData.one != null)
         {
            return _eventData.one;
         }
         if(_eventData.type == "onec_event")
         {
            return true;
         }
         return false;
      }
      
      override public function get width() : Number
      {
         return this.body.bounds.width;
      }
      
      override public function get height() : Number
      {
         return this.body.bounds.height;
      }
      
      public function set available(b:Boolean) : void
      {
         PoltCore.changePoltState(this.getName() + "_available","" + b);
      }
      
      public function get available() : Boolean
      {
         var state:String = PoltCore.getPoltState(this.getName() + "_available");
         if(state == "默认")
         {
            return true;
         }
         return state == "true";
      }
   }
}

