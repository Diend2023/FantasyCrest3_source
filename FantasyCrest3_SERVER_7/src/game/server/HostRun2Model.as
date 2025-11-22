package game.server
{
   import game.role.GameRole;
   import game.skill.UDPSkill;
   import game.world.BaseGameWorld;
   import lzm.starling.swf.FPSUtil;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import zygame.core.GameCore;
   import zygame.display.BaseRole;
   import zygame.display.NumberFeedback;
   import zygame.display.RefRole;
   import zygame.display.World;
   import zygame.server.Service;
   
   public class HostRun2Model extends KeyRunModel
   {
      
      private var debug:FPSUtil = new FPSUtil(50);
      
      public function HostRun2Model(roleTarget:String)
      {
         super(roleTarget);
         Service.client.messageFunc = onMessage;
         Service.client.udpFunc = onUDPMessage;
         Service.client.delayFunc = onDelay;
      }
      
      public function onDelay() : void
      {
         if(Starling.current.statsDisplay.fps < 30 || Service.client.delay > 200)
         {
            sendWifiLevel(0);
         }
         else if(Starling.current.statsDisplay.fps < 50 || Service.client.delay > 100)
         {
            sendWifiLevel(1);
         }
         else
         {
            sendWifiLevel(2);
         }
      }
      
      public function onUDPMessage(data:Object) : void
      {
         var funcRole:GameRole = null;
         var wifirole:BaseRole = null;
         var role:BaseRole = null;
         var newKeys:Array = null;
         var oldKeys:Array = null;
         switch(data.target)
         {
            case "func":
               funcRole = GameCore.currentWorld.getRoleFormName(data.role) as GameRole;
               if(funcRole)
               {
                  funcRole.doFunc(data.func,data.ret);
               }
               break;
            case "wifi":
               wifirole = GameCore.currentWorld.getRoleFormName(data.id);
               if(wifirole)
               {
                  (wifirole as GameRole).hpmpDisplay.wifi.updateLevel(data.level);
               }
               break;
            case "keys":
               if(!GameCore.currentWorld.auto)
               {
                  return;
               }
               role = GameCore.currentWorld.getRoleFormName(data.role);
               if(!role)
               {
                  break;
               }
               newKeys = data.key;
               oldKeys = role.getDownKeys();
               for(var i in oldKeys)
               {
                  if(newKeys.indexOf(oldKeys[i]) == -1)
                  {
                     role.onUp(oldKeys[i]);
                  }
               }
               var _loc12_:int = 0;
               var _loc11_:* = newKeys;
               while(§§hasnext(_loc11_,_loc12_))
               {
                  var i2:Object = §§nextname(_loc12_,_loc11_);
                  if(oldKeys.indexOf(newKeys[i2]) == -1)
                  {
                     role.onDown(newKeys[i2]);
                  }
               }
               break;
            case "down":
               if(!GameCore.currentWorld.auto)
               {
                  return;
               }
               GameCore.currentWorld.getRoleFormName(data.role).onDown(data.key);
               break;
            case "up":
               if(!GameCore.currentWorld.auto)
               {
                  return;
               }
               GameCore.currentWorld.getRoleFormName(data.role).onUp(data.key);
         }
      }
      
      public function onMessage(data:Object) : void
      {
         var _loc2_:* = data.target;
         if("updateRunModel" === _loc2_)
         {
            GameCore.currentWorld.runModel = new AccessRun3Model(target);
         }
      }
      
      override public function onAddChild(child:DisplayObject) : void
      {
         if(child is NumberFeedback)
         {
            Service.radioUDP({
               "type":"radio",
               "data":{
                  "target":"hurt",
                  "num":(child as NumberFeedback).hurtNumber,
                  "crit":(child as NumberFeedback).crit,
                  "x":child.x,
                  "y":child.y
               }
            });
         }
      }
      
      override public function onCDChange(role:BaseRole, skillName:String) : void
      {
         Service.radioUDP({
            "type":"radio",
            "data":{
               "target":"cd",
               "role":role.name,
               "data":role.attribute.cdData
            }
         });
      }
      
      override public function onRoleFrame(role:RefRole) : Boolean
      {
         return false;
      }
      
      override public function onFrame() : Boolean
      {
         super.onFrame();
         sendWorldMessage();
         return false;
      }
      
      private function sendWorldMessage() : void
      {
         var num:int;
         var i:int;
         var skill:UDPSkill;
         var world:World = GameCore.currentWorld;
         var curFrame:int = (world as BaseGameWorld).frameCount;
         world.getRoleList().forEach(function(role:BaseRole, index:int, v:Vector.<BaseRole>):void
         {
            Service.radioUDP({
               "type":"radio",
               "data":{
                  "type":"room_message",
                  "target":"role",
                  "frame":curFrame,
                  "data":{
                     "name":role.targetName,
                     "id":role.pid,
                     "data":(role as GameRole).copyData()
                  }
               }
            });
         });
         num = world.map.roleLayer.numChildren;
         for(i = 0; i < num; )
         {
            skill = world.map.roleLayer.getChildAt(i) as UDPSkill;
            if(skill)
            {
               Service.radioUDP({
                  "type":"radio",
                  "data":{
                     "type":"room_message",
                     "target":"skill",
                     "frame":curFrame,
                     "data":skill.copyData()
                  }
               });
            }
            i++;
         }
      }
   }
}

