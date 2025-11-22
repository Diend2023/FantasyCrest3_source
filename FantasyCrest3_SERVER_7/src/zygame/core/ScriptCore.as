package zygame.core
{
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import parser.Script;
   import starling.display.DisplayObject;
   import starling.events.EventDispatcher;
   import zygame.ai.AI;
   import zygame.buff.BUFF;
   import zygame.data.ItemPropsData;
   import zygame.display.Actor;
   import zygame.display.BaseRole;
   import zygame.display.Spoils;
   import zygame.event.GameAgentEvent;
   import zygame.script.IF;
   
   public class ScriptCore extends EventDispatcher
   {
      
      public var data:Dictionary = new Dictionary();
      
      public function ScriptCore()
      {
         super();
      }
      
      public function initScript(spr:Sprite) : void
      {
         Script.init(spr);
         Script.vm.GameAgent = this;
         Script.vm.AI = AI;
         Script.vm.IF = IF;
         Script.vm.BUFF = BUFF;
         Script.vm.changePolt = PoltCore.changePoltState;
         Script.vm.changePoltState = PoltCore.changePoltState;
         Script.vm.addEvent = PoltCore.addEvent;
         Script.vm.removeEvent = PoltCore.removeEvent;
         Script.vm.addSpoils = addSpoils;
         Script.vm.removeSpoils = removeSpoils;
         Script.vm.goPolt = goPolt;
         Script.vm.breakPolt = breakPolt;
         Script.vm.getActor = getActor;
         Script.vm.cheakProps = cheakProps;
         Script.vm.goMap = goMap;
         Script.vm.setFocus = setFocus;
         Script.vm.getRole = getRole;
         Script.vm.joinTroop = joinTroop;
         Script.vm.getGold = this.getGold;
         Script.vm.addGold = this.addGold;
         Script.vm.move = this.move;
         Script.vm.hasEvent = PoltCore.hasEvent;
      }
      
      public function joinTroop(target:String) : void
      {
         DataCore.troop.joinAttrudetes(target);
      }
      
      public function getRole(target:String) : BaseRole
      {
         var i:int = 0;
         if(target == "self")
         {
            return GameCore.currentWorld.role;
         }
         var list:Vector.<BaseRole> = GameCore.currentWorld.getRoleList();
         for(i = 0; i < list.length; )
         {
            if(list[i].targetName == target)
            {
               return list[i];
            }
            i++;
         }
         return null;
      }
      
      public function setFocus(display:DisplayObject) : void
      {
         if(!display || !(display is BaseRole))
         {
            return;
         }
         GameCore.currentWorld.founcDisplay = display as BaseRole;
      }
      
      public function cheakProps(target:String) : Boolean
      {
         var i:int = DataCore.props.cheakAll(target);
         return i > 0;
      }
      
      public function getActor(target:String) : Actor
      {
         return GameCore.currentWorld.poltSystem.getRef(target) as Actor;
      }
      
      public function addSpoils(target:String, count:int = 1) : Boolean
      {
         var spoils:Spoils = null;
         if(DataCore.props.add(new ItemPropsData(DataCore.props.queryAll(target),count,null)))
         {
            return true;
         }
         spoils = new Spoils(GameCore.currentWorld,null,GameCore.currentWorld.role.x,GameCore.currentWorld.role.y,target,true,count);
         GameCore.currentWorld.addChild(spoils);
         return false;
      }
      
      public function removeSpoils(target:String, count:int = 1) : Boolean
      {
         return DataCore.props.remove(new ItemPropsData(DataCore.props.queryAll(target),count,null));
      }
      
      public function addGold(num:int) : int
      {
         GameCore.currentWorld.state.pushLog("获得了" + num + "个金币");
         var num2:int = DataCore.getInt("game_gold");
         num2 += num;
         if(num2 < 0)
         {
            num2 = 0;
         }
         DataCore.updateValue("game_gold",num2);
         this.dispatchEvent(new GameAgentEvent("gold_update",num2));
         return num2;
      }
      
      public function getGold() : int
      {
         return DataCore.getInt("game_gold");
      }
      
      public function overPolt() : void
      {
         GameCore.currentWorld.poltSystem.messageOver();
      }
      
      public function goPolt(polt:String) : void
      {
         GameCore.currentWorld.poltSystem.go(polt);
      }
      
      public function closePolt() : void
      {
         GameCore.currentWorld.poltSystem.closePolt();
      }
      
      public function setValue(key:String, pdata:Object) : void
      {
         data[key] = pdata;
      }
      
      public function getValue(key:String) : Object
      {
         return data[key];
      }
      
      public function countValue(key:String, v:Number) : void
      {
         setValue(key,Number(getValue(key)) + v);
      }
      
      public function rootPoltLast() : void
      {
         GameCore.currentWorld.poltSystem.rootPoltIndexChanage(-1);
      }
      
      public function breakPolt() : void
      {
         GameCore.currentWorld.poltSystem.breakPolt();
      }
      
      public function goMap(mapName:String, targetName:String = null) : void
      {
         if(targetName == null)
         {
            targetName = GameCore.currentWorld.targetName;
         }
         DataCore.updateValue("go_map_" + mapName,"end");
         GameCore.currentCore.loadTMXMap(mapName + ".tmx",targetName);
      }
      
      public function interval(target:String, time:int) : int
      {
         var oldtime:int = 0;
         var nowtime:int = 0;
         var key:String = "time_interval_" + target;
         var newtime:int = int(new Date().getTime());
         if(DataCore.getInt(key))
         {
            oldtime = DataCore.getInt(key);
            nowtime = newtime - oldtime;
            if(nowtime > time)
            {
               DataCore.updateValue(key,newtime);
               return 0;
            }
            return (time - nowtime) / 1000 / 60 + 1;
         }
         DataCore.updateValue(key,newtime);
         return 0;
      }
      
      public function move(target:String, px:int, py:int = 0) : void
      {
         var role:BaseRole;
         var cpos:Point;
         var id:uint;
         if(target == "self")
         {
            role = GameCore.currentWorld.role;
         }
         else
         {
            role = GameCore.currentWorld.getRoleFormName(target);
         }
         if(role)
         {
            cpos = new Point(role.x + px,role.y + py);
            id = setInterval(function():void
            {
               if(px > 0)
               {
                  role.move("right");
               }
               else if(px < 0)
               {
                  role.move("left");
               }
               if(role.x < cpos.x && px < 0 || role.x > cpos.x && px > 0)
               {
                  role.move("wait");
                  overPolt();
                  clearInterval(id);
               }
            },0.016666666666666666);
         }
      }
   }
}

