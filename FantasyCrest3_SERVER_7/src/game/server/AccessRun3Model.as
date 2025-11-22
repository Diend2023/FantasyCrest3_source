package game.server
{
   import game.display.FCNumberFeedback;
   import game.role.GameRole;
   import game.skill.UDPSkill;
   import game.world.BaseGameWorld;
   import starling.core.Starling;
   import zygame.core.GameCore;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   import zygame.display.NumberFeedback;
   import zygame.display.RefRole;
   import zygame.display.World;
   import zygame.server.Service;
   
   public class AccessRun3Model extends KeyRunModel
   {
      
      public var skinCount:int = 0;
      
      public var _roomDatas:Array = [];
      
      private var _roles:Object;
      
      private var maxframe:int = 0;
      
      private var _skillpids:Array = [];
      
      public var isSkip:Boolean = false;
      
      private var _lowLevelTime:int = 0;
      
      public function AccessRun3Model(roleTarget:String)
      {
         super(roleTarget);
         Service.client.messageFunc = onMessage;
         Service.client.udpFunc = onUDPMessage;
         Service.client.delayFunc = onDelay;
      }
      
      public function onDelay() : void
      {
         if(Service.client.type == "watching")
         {
            return;
         }
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
         var hurt:FCNumberFeedback = null;
         var world:BaseGameWorld = GameCore.currentWorld as BaseGameWorld;
         if(data.target == "func")
         {
            funcRole = world.getRoleFormName(data.role) as GameRole;
            if(funcRole)
            {
               funcRole.doFunc(data.func,data.ret);
            }
         }
         else if(data.target == "wifi")
         {
            wifirole = GameCore.currentWorld.getRoleFormName(data.id);
            if(wifirole)
            {
               (wifirole as GameRole).hpmpDisplay.wifi.updateLevel(data.level);
            }
            if(Service.client.type == "watching")
            {
               return;
            }
            if(data.level == 0 && currentLevel > 0 || data.level <= 1 && currentLevel >= 2 || skinCount > 10)
            {
               _lowLevelTime++;
               if(_lowLevelTime > data.level == 1)
               {
                  §§push(2);
               }
               else
               {
                  §§push(8);
                  if(!8)
                  {
                     §§pop();
                     §§push(skinCount > 10);
                  }
               }
               if(§§pop())
               {
                  Service.client.send({
                     "type":"room_message",
                     "target":"updateRunModel"
                  });
                  GameCore.currentWorld.runModel = new HostRun2Model(target);
                  _lowLevelTime = 0;
               }
            }
            else
            {
               _lowLevelTime = 0;
            }
            return;
         }
         if(data.target == "cd")
         {
            role = world.getRoleFormName(data.role);
            if(role)
            {
               for(var cd in data.data)
               {
                  role.attribute.updateCD(cd,data.data[cd] / 60);
               }
            }
            world.state.onFrame();
            return;
         }
         if(data.target == "hurt")
         {
            hurt = new FCNumberFeedback(data.num,"",data.crit);
            hurt.x = data.x;
            hurt.y = data.y;
            GameCore.currentWorld.addChild(hurt);
            return;
         }
         if(data.target == "role" || data.target == "skill")
         {
            for(var i in _roomDatas)
            {
               if(_roomDatas[i].frame == data.frame)
               {
                  pushFrame(_roomDatas[i],data);
                  return;
               }
            }
            pushFrame(null,data);
         }
      }
      
      private function pushFrame(pushIn:Object, data:Object) : void
      {
         var i2:int = 0;
         if(!pushIn)
         {
            if(data.frame > maxframe)
            {
               pushIn = {
                  "frame":data.frame,
                  "roles":[data.data],
                  "skills":[]
               };
               _roomDatas.push(pushIn);
               maxframe = data.frame;
            }
            else
            {
               i2 = 0;
               while(true)
               {
                  if(i2 < _roomDatas.length)
                  {
                     if(_roomDatas[i2].frame + 1 != data.frame)
                     {
                        continue;
                     }
                     switch(data.target)
                     {
                        case "role":
                           _roomDatas.splice(i2,0,{
                              "frame":data.frame,
                              "roles":[data.data],
                              "skills":[]
                           });
                           break;
                        case "skill":
                           _roomDatas.splice(i2,0,{
                              "frame":data.frame,
                              "roles":[],
                              "skills":[data.data]
                           });
                     }
                  }
                  i2++;
               }
            }
         }
         else
         {
            switch(data.target)
            {
               case "role":
                  for(var i in pushIn.roles)
                  {
                     if(data.id == pushIn.roles[i].id)
                     {
                        (pushIn.roles as Array).splice(int(i),1);
                        pushIn.roles.push(data.data);
                        return;
                     }
                  }
                  pushIn.roles.push(data.data);
                  break;
               case "skill":
                  pushIn.skills.push(data.data);
            }
         }
      }
      
      public function onMessage(data:Object) : void
      {
         var hurt:NumberFeedback = null;
         switch(data.target)
         {
            case "room":
               _roomDatas.push(data.data);
               break;
            case "hurt":
               hurt = new NumberFeedback(data.num,"",data.crit);
               hurt.x = data.x;
               hurt.y = data.y;
               GameCore.currentWorld.addChild(hurt);
         }
      }
      
      public function get roomData() : Object
      {
         var index:int = 0;
         var ob:Object = null;
         if(_roomDatas.length > 0)
         {
            index = 0;
            ob = _roomDatas[index];
            _roomDatas.splice(0,index + 1);
         }
         return ob;
      }
      
      override public function onEffectPasing(arr:Array) : Boolean
      {
         return false;
      }
      
      override public function onRoleFrame(role:RefRole) : Boolean
      {
         var prole:BaseRole = role as BaseRole;
         if(prole.attribute.hp == 0)
         {
            return false;
         }
         if(isSkip || !prole.isLock)
         {
            return false;
         }
         prole.onAttack();
         prole.attribute.updateAllCD();
         return true;
      }
      
      override public function onKillRole(role:BaseRole) : Boolean
      {
         return false;
      }
      
      override public function onHurt(role:BaseRole, hurt:int) : Boolean
      {
         return true;
      }
      
      override public function onEffectFrame(display:EffectDisplay) : Boolean
      {
         return false;
      }
      
      override public function onFrame() : Boolean
      {
         var ob:Object = null;
         var role:BaseRole = null;
         var ob2:Object = null;
         var role2:BaseRole = null;
         var eff:UDPSkill = null;
         super.onFrame();
         isSkip = false;
         var _roomData:Object = roomData;
         var world:World = GameCore.currentWorld;
         (world as BaseGameWorld).mathCenterPos();
         if(!_roomData)
         {
            isSkip = true;
            trace("跳帧！可用数据：",Service.client.waitLength());
            if(currentLevel >= 2)
            {
               skinCount++;
            }
            return false;
         }
         skinCount = 0;
         _roles = _roomData.roles;
         for(var i in _roomData.roles)
         {
            ob = _roomData.roles[i];
            role = world.getRoleFormPid(ob.id);
            if(role)
            {
               (role as GameRole).setData(ob.data);
            }
         }
         var skills:Array = _roomData.skills;
         for(var i2 in skills)
         {
            ob2 = skills[i2];
            role2 = world.getRoleFormPid(ob2.roleid);
            if(role2)
            {
               eff = world.getEffectFormName(ob2.name as String,role2) as UDPSkill;
               if(eff)
               {
                  eff.setData(ob2);
               }
            }
         }
         _roomData = null;
         return false;
      }
      
      override public function onFrameOver() : Boolean
      {
         if(_roomDatas.length > 2)
         {
            GameCore.currentWorld.onFrameUpdate(null);
         }
         return super.onFrameOver();
      }
   }
}

