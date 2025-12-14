package game.role
{
   import feathers.data.ListCollection;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.data.RoleData;
   import game.display.FCNumberFeedback;
   import game.display.HPMP;
   import game.view.GameStateView;
   import game.world.AssistWorld;
   import game.world.BaseGameWorld;
   import game.world._FBBaseWorld;
   import nape.dynamics.Arbiter;
   import nape.geom.Vec2;
   import nape.phys.Body;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Image;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.data.RoleFrameGroup;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   import zygame.display.World;
   import zygame.event.GameMapHitType;
   import zygame.style.Color2Style;
   
   public class GameRole extends BullyRole implements RoleData
   {
      
      public var hpmpDisplay:HPMP;
      
      public var currentMp:cint = new cint();
      
      public var mpPoint:cint = new cint();
      
      private var _beHurtCount:int = 0;
      
      private var _hurtCount:int = 0;
      
      private var _jumpCount:int = 1;
      
      private var _jumpCountMax:int = 1;
      
      public var listData:ListCollection;
      
      public var overPos:Point;
      
      public var overPosTime:int = 0;
      
      public var buffImage:Image;
      
      public var beHitTime:int = 12;
      
      public var fightid:int = -1;
      
      public var inkeys:Array = [65,68,87,83];
      
      private var _isBackJump:Boolean = false;
      
      public function GameRole(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         feedbackType = FCNumberFeedback;
      }
      
      public function usePoint(i:int) : Boolean
      {
         if(i <= currentMp.value)
         {
            currentMp.value -= i;
            return true;
         }
         return false;
      }
      
      public function immuneEffect(object:Object) : Boolean
      {
         return false;
      }
      
      public function addMpPoint(i:int) : void
      {
         if(mpPoint.value < 10)
         {
            mpPoint.value++;
         }
         if(mpPoint.value >= 10 && currentMp.value < mpMax)
         {
            currentMp.value++;
            mpPoint.value = 0;
         }
      }
      
      public function get mpMax() : int
      {
         return attribute.getValue("crystal");
      }
      
      public function quickGetUp() : void
      {
         this.clearDebuffMove();
         this._blow = false;
         this._blow2 = false;
         this.goldenTime = 0.1;
         this.breakAction();
         this.jump();
      }
      
      override public function onDown(key:int) : void
      {
         pushKey(key);
         switch(key - 72)
         {
            case 0:
               if(world is AssistWorld)
               {
                  (world as AssistWorld).replaceRole(this);
               }
               break;
            case 1:
               if(isKeyDown(87))
               {
                  this.playSkillFormKey("WI");
                  break;
               }
               if(isKeyDown(83))
               {
                  this.playSkillFormKey("SI");
                  break;
               }
               this.playSkillFormKey("I");
               break;
            case 2:
               if(isKeyDown(87))
               {
                  this.playSkillFormKey("WJ");
                  break;
               }
               if(isKeyDown(83))
               {
                  this.playSkillFormKey("SJ");
                  break;
               }
               this.playSkill(this.isJump() ? "空中攻击" : "普通攻击");
               break;
            case 3:
               if(!isJump() && isKeyDown(83))
               {
                  this.backJump();
                  break;
               }
               if(this.isInjured() && _jumpCount > 0 && this._blow2)
               {
                  quickGetUp();
                  break;
               }
               super.onDown(key);
               break;
            case 4:
               if(this.isJump() && this.roleXmlData.airActions["瞬步"])
               {
                  this.playSkill("瞬步");
                  break;
               }
               if(!this.isJump())
               {
                  this.playSkill("瞬步");
               }
               break;
            case 7:
               if(isKeyDown(87))
               {
                  this.playSkillFormKey("WO");
                  break;
               }
               if(isKeyDown(83))
               {
                  this.playSkillFormKey("SO");
                  break;
               }
               this.playSkillFormKey("O");
               break;
            case 8:
               if(isKeyDown(87))
               {
                  this.playSkillFormKey("WP");
                  break;
               }
               if(isKeyDown(83))
               {
                  this.playSkillFormKey("SP");
                  break;
               }
               this.playSkillFormKey("P");
               break;
            case 13:
               if(isKeyDown(87))
               {
                  this.playSkillFormKey("WU");
                  break;
               }
               if(isKeyDown(83))
               {
                  this.playSkillFormKey("SU");
                  break;
               }
               this.playSkillFormKey("U");
               break;
            default:
               super.onDown(key);
         }
      }
      
      override public function playSkillFormKey(key:String) : void
      {
         if(!this.parent)
         {
            return;
         }
         if(isLock && isOSkill())
         {
            return;
         }
         super.playSkillFormKey(key);
      }
      
      public function isOSkill() : Boolean
      {
         var group:RoleFrameGroup = this.roleXmlData.getGroupAt(actionName);
         if(group && group.key && group.key.indexOf("O") != -1)
         {
            return true;
         }
         return false;
      }
      
      public function hitRole() : BaseRole
      {
         var isHit:BaseRole = null;
         var self:BaseRole = this;
         this.body.arbiters.foreach(function(a:Arbiter):void
         {
            var body2:Body = a.body1 == body ? a.body2 : a.body1;
            var prole:BaseRole = body2.userData.ref as BaseRole;
            if(prole && prole != self && prole.troopid != troopid)
            {
               isHit = body2.userData.ref as BaseRole;
            }
         });
         return isHit;
      }
      
      public function findRole(rect:Rectangle) : BaseRole
      {
         var i:int = 0;
         var list:Vector.<BaseRole> = world.getRoleList();
         for(i = 0; i < list.length; )
         {
            if(!list[i].isGod() && list[i] != this && list[i].troopid != this.troopid && list[i].body.bounds.toRect().intersects(rect))
            {
               return list[i];
            }
            i++;
         }
         return null;
      }
      
      override public function onSUpdate() : void
      {
         super.onSUpdate();
         addMpPoint(1);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(world)
         {
            if(this.x < 64)
            {
               this.posx = 64;
            }
            if(this.x > world.map.getWidth() - 64)
            {
               this.posx = world.map.getWidth() - 64;
            }
            if(buffImage)
            {
               buffImage.texture = this.display["texture"];
               buffImage.x = this.display.x;
               buffImage.y = this.display.y;
               buffImage.width = this.display.width;
               buffImage.height = this.display.height;
               (buffImage.style as Color2Style).intensity -= 0.05;
               if((buffImage.style as Color2Style).intensity <= 0)
               {
                  buffImage.removeFromParent(true);
                  buffImage = null;
               }
            }
         }
      }
      
      override public function set rotation(value:Number) : void
      {
         super.rotation = value;
      }
      
      override public function set action(str:String) : void
      {
         if(str == "起身")
         {
            this.golden = 60;
         }
         super.action = str;
      }
      
      override public function set beHitCount(i:int) : void
      {
         if(beHitTime > 0)
         {
            beHitTime--;
         }
         if(beHitTime <= 0 || i != 0)
         {
            super.beHitCount = i;
         }
      }
      
      override public function onBeHit(beData:BeHitData) : void
      {
         var dao:int = 0;
         beHitTime = 12;
         var hit:int = beData.role.actionName == "普通攻击" || beData.role.actionName == "空中攻击" ? 8 : 12;
         if(beHitCount > hit && !(beData.role as GameRole).isOSkill())
         {
            if(!_blow2 && !isJump())
            {
               this.goldenTime = 1;
               this.straight = 0;
            }
            else if(!_blow2 && isJump())
            {
               if(beData.moveY == 0)
               {
                  beData.moveY = 10;
               }
            }
            if(beData.moveY > 0)
            {
               dao = 30 - beHitCount;
               if(dao > 0)
               {
                  beData.moveY *= dao / (beData.role.actionName == "普通攻击" ? 36 : 18);
               }
               else
               {
                  beData.moveY *= 0;
               }
            }
            if(beData.moveY == 0)
            {
               beData.moveY = 1;
            }
         }
         else if(beData.role.actionName == "普通攻击")
         {
            if(!_blow2 && isJump())
            {
               if(beData.moveY == 0)
               {
                  beData.moveY = 15;
               }
            }
         }
         super.onBeHit(beData);
      }
      
      override public function breakAction() : void
      {
         super.breakAction();
         if(actionName == "普通攻击" && this.currentFrame != 0)
         {
            this.attribute.updateCD(actionName,0.5);
         }
      }
      
      override public function onHitEffect(beData:BeHitData, pos:Point) : EffectDisplay
      {
         var eff:EffectDisplay = null;
         var eff2:EffectDisplay = null;
         if(beData.cardFrame > 6)
         {
            eff = super.createHitEffect("blow",beData,pos);
            eff.scaleX *= 1.5;
            eff.scaleY *= 1.5;
            return eff;
         }
         eff2 = super.onHitEffect(beData,pos);
         if(eff2)
         {
            eff2.scaleX *= 1.5;
            eff2.scaleY *= 1.5;
         }
         return eff2;
      }
      
      override public function hurtNumber(beHurt:int, beData:BeHitData, pos:Point) : void
      {
         super.hurtNumber(beHurt,beData,pos);
         statisticalBeHurt(beHurt);
         if(beData)
         {
            (beData.role as GameRole).statisticalHurt(beHurt);
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         if(!isOSkill() && mpPoint.value < 10)
         {
            mpPoint.value++;
         }
         if(world.role == this && world is _FBBaseWorld)
         {
            (world.state as GameStateView).hitFBRole = enemy;
         }
      }
      
      public function frameAt(start:int, end:int) : Boolean
      {
         if(start < currentFrame && currentFrame < end)
         {
            return true;
         }
         return false;
      }
      
      public function get isMandatorySkill() : Boolean
      {
         return maxMandatorySkill != mandatorySkill;
      }
      
      override public function isGod() : Boolean
      {
         var len:int = this.currentActionLegnth * 0.2;
         if(actionName == "瞬步" && frameAt(len,this.currentActionLegnth - len))
         {
            return true;
         }
         return super.isGod();
      }
      
      override public function playSkill(target:String) : void
      {
         if(isOSkill())
         {
            return;
         }
         var group:RoleFrameGroup = this.roleXmlData.getGroupAt(target);
         if(group)
         {
            if(group["mp"] && int(group["mp"]) > currentMp.value)
            {
               return;
            }
            if(currentGroup["noc"] == "Y" && this.isLock)
            {
               return;
            }
         }
         _isBackJump = false;
         super.playSkill(target);
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         var effect:EffectDisplay = null;
         if(str == "瞬步" && maxMandatorySkill != mandatorySkill)
         {
            attribute.updateCD(str,getCD(str) + 3);
            mandatorySkill++;
         }
         if(str == "空中攻击")
         {
            if(this.actionName == "普通攻击")
            {
               return;
            }
            this.attribute.updateCD(str,0.5);
         }
         var group:RoleFrameGroup = this.roleXmlData.getGroupAt(str);
         if(group && group["mp"])
         {
            usePoint(int(group["mp"]));
         }
         if(!isLock)
         {
            if(isKeyDown(65))
            {
               this.scaleX = -1;
            }
            else if(isKeyDown(68))
            {
               this.scaleY = 1;
            }
         }
         if(group && group.key && group.key.indexOf("O") != -1 && actionName != str)
         {
            effect = new EffectDisplay("bisha",null,this,1.5,1.5);
            effect.x = this.x;
            effect.y = this.y;
            this.world.addChild(effect);
            effect.fps = 24;
            for(var i in this.world.getRoleList())
            {
               this.world.getRoleList()[i].cardFrame = 40;
            }
            (this.world as BaseGameWorld).showSkillPainting(targetName,group.name,troopid);
         }
         super.runLockAction(str,canBreak);
      }
      
      override public function onShapeChange() : void
      {
         super.onShapeChange();
         if(maxMandatorySkill != mandatorySkill && isLock)
         {
            createShadow(16776960);
         }
         if(actionName == "瞬步" && isGod())
         {
            createShadow(8846335);
         }
      }
      
      public function buffColor(color:uint) : void
      {
         if(!buffImage)
         {
            buffImage = new Image(this.display["texture"]);
            this.addChild(buffImage);
            buffImage.x = this.display.x;
            buffImage.y = this.display.y;
            buffImage.width = this.display.width;
            buffImage.height = this.display.height;
            buffImage.style = new Color2Style(color);
         }
         (buffImage.style as Color2Style).intensity = 1;
      }
      
      public function createShadow(color:uint) : Image
      {
         var image:Image;
         var scaleNum:Number;
         var tw:Tween;
         if(!this.parent)
         {
            return null;
         }
         image = new Image((this.display as Image).texture);
         this.parent.addChildAt(image,0);
         scaleNum = contentScale + (1 - contentScale);
         // image.x = this.x + display.x * (this._scaleX * scaleNum);
         // image.y = this.y + display.y * (this._scaleY * scaleNum);
         image.x = this.x + display.x * (this.getRawScaleX() * scaleNum); // 改用this获取scaleX
         image.y = this.y + display.y * (this.getRawScaleY() * scaleNum); // 改用this获取scaleY
         image.scaleX = this.scaleX;
         image.scaleY = this.scaleY;
         image.color = color;
         image.blendMode = "add";
         tw = new Tween(image,0.5);
         tw.animate("alpha",0);
         Starling.juggler.add(tw);
         tw.onComplete = function():void
         {
            image.removeFromParent();
         };
         return image;
      }
      
      override protected function onDie(beData:BeHitData) : void
      {
      }
      
      public function statisticalHurt(i:int) : void
      {
         _hurtCount += i;
      }
      
      public function statisticalBeHurt(i:int) : void
      {
         _beHurtCount += i;
      }
      
      public function get beHurt() : int
      {
         return _beHurtCount;
      }
      
      public function set beHurt(i:int) : void
      {
         _beHurtCount = i;
      }
      
      public function get hurt() : int
      {
         return _hurtCount;
      }
      
      public function set hurt(i:int) : void
      {
         _hurtCount = i;
      }
      
      override public function onInit() : void
      {
         super.onInit();
         (this.display as Image).textureSmoothing = "trilinear";
      }
      
      override public function onDefenseEffect() : void
      {
         super.onDefenseEffect();
      }
      
      override public function get hitEffectName() : String
      {
         if(roleXmlData.hitEffectName && roleXmlData.hitEffectName != "fistHit")
         {
            return roleXmlData.hitEffectName;
         }
         return "blade";
      }
      
      override public function onFallGroundEffect() : void
      {
         if(beHitCount > 18)
         {
            _beHitY = 0;
         }
         super.onFallGroundEffect();
      }
      
      override public function jump(hv:int = -1, foc:Boolean = false, jumpEff:Boolean = false) : void
      {
         if(this.actionName == "起身")
         {
            return;
         }
         if(hv == -1 && isJump())
         {
            if(_jumpCount > 0)
            {
               _jumpCount--;
               this.jumpMath = this.attribute.jump * 0.8;
               this.onJumpEffect();
               if(isKeyDown(65))
               {
                  this.scaleX = -1;
               }
               else if(isKeyDown(68))
               {
                  this.scaleX = 1;
               }
            }
         }
         else
         {
            super.jump(hv,foc,jumpEff);
         }
      }
      
      override public function jumped() : void
      {
         super.jumped();
      }
      
      override public function unJump(unLock:Boolean = false) : void
      {
         _jumpCount = _jumpCountMax;
         super.unJump(unLock);
      }
      
      public function set jumpTime(i:int) : void
      {
         _jumpCount = i;
      }
      
      public function get jumpTime() : int
      {
         return _jumpCount;
      }
      
      public function set jumpTimeMax(i:int) : void
      {
         _jumpCount = i;
         _jumpCountMax = i;
      }
      
      public function copyData() : Object
      {
         return {
            "hp":attribute.hp,
            "straight":straight,
            "golden":this.golden,
            "scaleX":(this.scaleX > 0 ? 1 : -1),
            "frame":this.currentFrame,
            "action":(isDefense() ? "防御" : this.actionName),
            "x":this.posx,
            "y":this.posy,
            "mx":this.body.velocity.x,
            "my":this.body.velocity.y,
            "isLock":this.isLock,
            "hitX":this._beHitX,
            "hitY":this._beHitY,
            "jumpMath":this.jumpMath,
            "blow":this._blow,
            "blow2":this._blow2,
            "jump":this.isJump(),
            "key":this.getDownKeys(),
            "mp":currentMp.value
         };
      }
      
      public function setData(value:Object) : void
      {
         var curFrame:int = 0;
         attribute.hp = value.hp;
         straight = value.straight;
         golden = value.golden;
         scaleX = value.scaleX;
         this.jumpBoolean = value.jump;
         if(!value.jump)
         {
            mapHitType = GameMapHitType.HIT;
         }
         var actionTarget:String = actionName;
         if(actionName != value.action)
         {
            this.breakAction();
            if(value.frame <= 3)
            {
               this.runLockAction(value.action,true);
            }
            actionName = value.action;
         }
         else
         {
            actionName = value.action;
         }
         if(value.isLock)
         {
            posx = value.x;
            posy = value.y;
            curFrame = this.currentFrame;
            if(value.frame - curFrame >= 3)
            {
               this.currentFrame = value.frame;
               this.onShapeChange();
            }
            else
            {
               while(curFrame <= value.frame)
               {
                  this.currentFrame = curFrame;
                  this.onShapeChange();
                  curFrame++;
               }
            }
         }
         else
         {
            posx += (value.x - posx) * 0.5;
            posy += (value.y - posy) * 0.5;
         }
         this.isLock = value.isLock;
         this.jumpMath = value.jumpMath;
         this._beHitX = value.hitX;
         this._beHitY = value.hitY;
         this._blow = value.blow;
         this._blow2 = value.blow2;
         updateKey(value);
         this.body.velocity.x = value.mx;
         this.body.velocity.y = value.my;
         this.currentMp.value = value.mp;
      }
      
      public function updateKey(data:Object) : void
      {
         var newKeys:Array = null;
         var oldKeys:Array = null;
         var role:BaseRole = this;
         if(role)
         {
            newKeys = data.key;
            oldKeys = role.getDownKeys();
            for(var i in oldKeys)
            {
               if(inkeys.indexOf(oldKeys[i]) != -1)
               {
                  if(newKeys.indexOf(oldKeys[i]) == -1)
                  {
                     role.onUp(oldKeys[i]);
                  }
               }
            }
            for(var i2 in newKeys)
            {
               if(inkeys.indexOf(newKeys[i2]) != -1)
               {
                  if(oldKeys.indexOf(newKeys[i2]) == -1)
                  {
                     role.onDown(newKeys[i2]);
                  }
               }
            }
         }
      }
      
      public function debugOnlineDraw(value:Object) : void
      {
         var img:Image = createShadow(16776960);
         img.x += value.x - posx;
         img.y += value.y - posy;
      }
      
      public function get roleStateArray() : ListCollection
      {
         return listData;
      }
      
      public function win() : void
      {
      }
      
      public function over() : void
      {
      }
      
      override public function discarded() : void
      {
         this.over();
         super.discarded();
      }
      
      override public function dispose() : void
      {
         if(this.hpmpDisplay)
         {
            this.hpmpDisplay.role = null;
            this.hpmpDisplay = null;
         }
         this.listData = null;
         super.dispose();
      }
      
      public function backJump() : void
      {
         if(this.isOSkill() || this.straight > 0)
         {
            return;
         }
         _isBackJump = true;
         this.breakAction();
         this.runLockAction("跳跃");
         this.jumpMath = 10;
         if(golden == 0)
         {
            this.goldenTime = 0.15;
         }
      }
      
      override public function onMove() : void
      {
         super.onMove();
         if(_isBackJump && !isInjured())
         {
            this.xMove(-this.scaleX * this.attribute.speed);
            if(!isJump() && this.jumpMath <= 0)
            {
               _isBackJump = false;
            }
         }
      }
      
      public function getRoundPx() : int
      {
         return ray(new Vec2(0,1));
      }
      
      public function doFunc(func:String, ret:Array) : void
      {
         if(!ret)
         {
            this[func]();
         }
         switch(int(ret.length))
         {
            case 0:
               this[func]();
               break;
            case 1:
               this[func](ret[0]);
               break;
            case 2:
               this[func](ret[0],ret[1]);
               break;
            case 3:
               this[func](ret[0],ret[1],ret[2]);
               break;
            case 4:
               this[func](ret[0],ret[1],ret[2],ret[3]);
         }
      }
      
      override public function getPoltPos() : Point
      {
         return new Point(this.x,this.y - 130 * Math.abs(this.currentScaleY));
      }
   }
}

