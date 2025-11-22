package zygame.core
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import parser.Script;
   import starling.display.DisplayObject;
   import zygame.display.Actor;
   import zygame.display.Dialog;
   import zygame.display.DisplayObjectContainer;
   import zygame.display.PoltSelect;
   import zygame.display.World;
   
   public class PoltSystem
   {
      
      public static var moveMaxX:int = 50;
      
      public static var defaultDialogClass:Class = Dialog;
      
      public static var defaultPoltSelectClass:Class = PoltSelect;
      
      private var _world:World;
      
      public var isRuning:Boolean = false;
      
      private var _moveX:int = 0;
      
      private var _isMove:Boolean = false;
      
      private var _isCanMessage:Boolean = false;
      
      private var _npc:Actor;
      
      private var _index:int = 0;
      
      private var _rootXml:XMLList;
      
      private var _childXml:XMLList;
      
      private var _childIndex:int = 0;
      
      public var currentDialog:Dialog;
      
      public var createMessageFunc:Function;
      
      public function PoltSystem(world:World)
      {
         super();
         _world = world;
      }
      
      public function polt(npc:Actor, isMove:Boolean = true) : void
      {
         npc.onPoltEvent();
         GameCore.currentWorld.stopAllAction();
         if(npc.polt == null)
         {
            return;
         }
         _npc = npc;
         _rootXml = _npc.polt.children();
         isRuning = true;
         Script.vm.npc = npc;
         if(npc.body != null)
         {
            isMove = false;
         }
         if(npc.targetName == "warp" || !isMove)
         {
            _moveX = _world.role.x;
            _isMove = true;
            _isCanMessage = true;
         }
         else
         {
            _moveX = _npc.bounds.x + _npc.bounds.width / 2 - moveMaxX * (_npc.rootData.dialogue == "right" ? -1 : 1);
            _isMove = false;
            _isCanMessage = true;
         }
      }
      
      public function poltFormXML(xml:XML) : void
      {
         if(!xml)
         {
            return;
         }
         _npc = null;
         _rootXml = xml.children();
         _isCanMessage = true;
         isRuning = true;
         _isMove = true;
         GameCore.currentWorld.stopAllAction();
         trace("开始执行剧情",xml.toXMLString());
      }
      
      public function onFrame() : void
      {
         if(!isRuning)
         {
            return;
         }
         if(!_isMove)
         {
            _world.role.overDown();
            if(_world.role.x > _moveX && _npc.rootData.dialogue == "left")
            {
               _world.role.onDown(65);
            }
            else if(_world.role.x < _moveX && _npc.rootData.dialogue == "right")
            {
               _world.role.onDown(68);
            }
            else
            {
               _world.role.scaleX = _npc.rootData.dialogue == "right" ? -1 : 1;
               _isMove = true;
               _world.role.action = "待机";
            }
         }
         else if(_isCanMessage)
         {
            _isCanMessage = false;
            _index = 0;
            messageOver();
         }
      }
      
      public function messageOver() : void
      {
         GameCore.currentWorld.founcDisplay = GameCore.currentWorld.role;
         currentDialog = null;
         if(this._childXml && this._childXml[this._childIndex])
         {
            _childIndex++;
            doXml(_childXml[_childIndex - 1]);
            return;
         }
         if(!_rootXml[_index])
         {
            closePolt();
            return;
         }
         _index++;
         doXml(_rootXml[_index - 1]);
      }
      
      public function doXml(xml:XML, isInit:Boolean = false) : void
      {
         var select:PoltSelect = null;
         var code:String = null;
         switch(xml.localName())
         {
            case "select":
               select = new defaultPoltSelectClass(xml,onPoltSelectBack);
               select.world = _world;
               _world.parent.addChild(select);
               break;
            case "m":
               createMessage(xml);
               break;
            case "as3":
               code = String(xml.@message);
               if(!isInit && (code.indexOf("move(") == -1 && code.indexOf("GameAgent.overPolt()") == -1) && code.indexOf("GameAgent.closePolt()") == -1 && code.indexOf("GameAgent.breakPolt()") == -1)
               {
                  code += "GameAgent.overPolt();";
               }
               trace("触发脚本：" + code);
               Script.execute(code);
         }
      }
      
      public function initNPC(npc:Actor) : void
      {
         var as3list:XMLList = null;
         var initXML:XML = npc.getPoltAtName("初始化");
         Script.vm.npc = npc;
         if(initXML)
         {
            as3list = initXML.child("as3");
            for(var a in as3list)
            {
               this.doXml(as3list[a],true);
            }
         }
      }
      
      private function onPoltSelectBack(xml:XML) : void
      {
         this._childIndex = 0;
         this._childXml = xml.children();
         messageOver();
      }
      
      protected function createMessage(xml:XML) : void
      {
         if(createMessageFunc != null)
         {
            createMessageFunc(xml);
            return;
         }
         var strData:String = String(xml.@message);
         strData = strData.substr(strData.lastIndexOf("#") + 1);
         strData = as3Message(strData);
         currentDialog = new defaultDialogClass(strData);
         _world.addChild(currentDialog);
         var ref:DisplayObjectContainer = this.getRef(String(xml.@target));
         GameCore.currentWorld.founcDisplay = ref;
         var pos:Point = ref.getPoltPos();
         currentDialog.x = pos.x;
         currentDialog.y = pos.y;
         currentDialog.followDisplay = ref;
         if(ref != GameCore.currentWorld.role)
         {
            GameCore.currentWorld.role.scaleX = ref.x > GameCore.currentWorld.role.x ? 1 : -1;
         }
         updateScaleX(currentDialog,ref);
         currentDialog.backFunc = messageOver;
      }
      
      public function as3Message(str:String) : String
      {
         var i:int = 0;
         var code:String = null;
         var arr:Array = str.split("@");
         trace(arr);
         str = "";
         for(i = 0; i < arr.length; )
         {
            if(arr[i].indexOf("{") != -1)
            {
               code = "function poltValue():Object{" + String(arr[i]).substr(1,String(arr[i]).indexOf("}") - 1) + "}";
               trace(code);
               Script.declare(code);
               str += Script.getFunc("poltValue")();
               str += String(arr[i]).substr(String(arr[i]).indexOf("}") + 1);
            }
            else
            {
               str += arr[i];
            }
            i++;
         }
         return str;
      }
      
      private function getRect(target:String) : Rectangle
      {
         var length:int = 0;
         var i:int = 0;
         if(target)
         {
            if(target == "self")
            {
               return _world.role.bounds;
            }
            length = int(_world.map.getNpcs().length);
            for(i = 0; i < length; )
            {
               if(_world.map.getNpcs()[i].targetName == target)
               {
                  return _world.map.getNpcs()[i].bounds;
               }
               i++;
            }
         }
         return _npc.bounds;
      }
      
      public function getRef(target:String) : DisplayObjectContainer
      {
         var list:* = undefined;
         var length:int = 0;
         var i:int = 0;
         if(target && target != "current")
         {
            if(target == "self")
            {
               return _world.role;
            }
            list = _world.map.getNpcs();
            length = int(list.length);
            for(i = 0; i < length; )
            {
               if(list[i].targetName == target || list[i].getName() == target)
               {
                  return _world.map.getNpcs()[i];
               }
               i++;
            }
            return _world.getRoleFormName(target);
         }
         return _npc;
      }
      
      public function go(pname:String) : void
      {
         trace("查找",pname);
         _childXml = null;
         _childIndex = 0;
         if(findChildXmlList(_rootXml,pname))
         {
            trace("查找成功");
         }
         else
         {
            trace("查找失败");
         }
      }
      
      public function findChildXmlList(xml:XMLList, pname:String) : Boolean
      {
         var i:int = 0;
         if(xml)
         {
            i = 0;
            while(xml[i])
            {
               if(String(xml[i].@message).indexOf(pname + "#") != -1)
               {
                  if(xml[i].parent().localName() == "polt")
                  {
                     _index = i;
                  }
                  else
                  {
                     _childXml = xml[i].parent().children();
                     _childIndex = i;
                  }
                  return true;
               }
               if(xml[i].children().length() > 0)
               {
                  if(findChildXmlList(xml[i].children(),pname))
                  {
                     return true;
                  }
               }
               i++;
            }
         }
         return false;
      }
      
      private function updateScaleX(dig:Dialog, ref:DisplayObject) : void
      {
         if(ref)
         {
            if(ref == _world.role)
            {
               dig.scaleX = _world.role.scaleX * -1;
            }
            else
            {
               dig.scaleX = ref.x < _world.role.x ? -1 : 1;
            }
            if(_world.founcDisplay.x < 250)
            {
               dig.scaleX = 1;
            }
            else if(_world.founcDisplay.x > _world.map.getWidth() - 250)
            {
               dig.scaleX = -1;
            }
            return;
         }
         dig.scaleX = _world.role.scaleX;
      }
      
      public function breakPolt() : void
      {
         if(_childXml)
         {
            _childXml = null;
            messageOver();
            return;
         }
         isRuning = false;
      }
      
      public function closePolt() : void
      {
         _childXml = null;
         isRuning = false;
         trace("结束剧情");
      }
      
      public function rootPoltIndexChanage(i:int) : void
      {
         _index += i;
      }
      
      public function get npc() : Actor
      {
         return _npc;
      }
      
      public function quick() : void
      {
         if(currentDialog && currentDialog.parent)
         {
            currentDialog.quick();
         }
      }
   }
}

