package zygame.display
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import lzm.starling.swf.FPSUtil;
   import nape.dynamics.Arbiter;
   import nape.geom.Geom;
   import nape.geom.GeomPoly;
   import nape.geom.GeomPolyList;
   import nape.geom.Vec2;
   import nape.phys.Body;
   import nape.phys.BodyList;
   import nape.phys.BodyType;
   import nape.phys.Material;
   import nape.shape.Circle;
   import nape.shape.Polygon;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.filters.ColorMatrixFilter;
   import starling.utils.Pool;
   import starling.utils.rad2deg;
   import zygame.ai.AiHeart;
   import zygame.buff.BuffRef;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   import zygame.core.MonsterRefresh;
   import zygame.data.BeHitData;
   import zygame.data.EncryptCEData;
   import zygame.data.GameEXPData;
   import zygame.data.RoleAttributeData;
   import zygame.data.RoleFrameGroup;
   import zygame.data.RoleXMLData;
   import zygame.debug.Debug;
   import zygame.event.GameMapHitType;
   import zygame.filters.GoldenBodyFilter;
   import zygame.utils.PointUtils;
   import zygame.utils.SoundUtils;
   
   public class BaseRole extends RefRole
   {
      
      public static var defalutSpriteRoleClass:Class;
      
      public static var defalutDragonRoleClass:Class;
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      public static const WAIT:String = "wait";
      
      public static var feedbackType:Class = NumberFeedback;
      
      private var _golden:int = 0;
      
      private var _goldenFilter:GoldenBodyFilter;
      
      private var _roleXmlData:RoleXMLData;
      
      private var _id:int = -1;
      
      private var _frame:int = 0;
      
      private var _lastFrame:int = -1;
      
      private var _fps:FPSUtil;
      
      private var _actionName:String = "待机";
      
      private var _lastActionName:String = "";
      
      private var _speedRuning:Boolean = false;
      
      private var _roleAttribute:RoleAttributeData;
      
      private var _jumpBoolean:Boolean = false;
      
      private var _jumpTolerance:int = 0;
      
      private var _jumpMath:int = 0;
      
      private var _jumpPause:int = 0;
      
      private var _hitPause:int = 0;
      
      private var _lock:Boolean = false;
      
      private var _canBreak:Boolean = false;
      
      private var _keyHitMath:int = 0;
      
      private var _jumpHit:Boolean = false;
      
      private var _left:Boolean = false;
      
      private var _right:Boolean = false;
      
      private var _up:Boolean = false;
      
      private var _down:Boolean = false;
      
      private var _oldX:Number = 0;
      
      private var _oldY:Number = 0;
      
      private var _testCount:int = 0;
      
      protected var _beHitX:Number = 0;
      
      protected var _beHitY:Number = 0;
      
      protected var _blow:Boolean = false;
      
      protected var _blow2:Boolean = false;
      
      private var _straight:int = 0;
      
      public var contentScale:Number = 1;
      
      public var dbody:Body;
      
      private var _actionPoint:Point;
      
      private var _isAllowUnJumpAction:String = "";
      
      public var ai:Boolean = true;
      
      private var _blowTime:int = 0;
      
      private var _mandotorySkillMax:int = 1;
      
      private var _mandatorySkill:int = 1;
      
      private var _ceData:EncryptCEData;
      
      private var _hpmini:HPMini;
      
      private var _ai:AiHeart;
      
      public var troopid:int = 0;
      
      private var _hit:int = 0;
      
      private var _hitBody:Body;
      
      private var _hateDict:Dictionary;
      
      private var _troopImage:Image;
      
      private var _dieColor:ColorMatrixFilter;
      
      private var _isDie:Boolean = false;
      
      protected var _lastTimeX:Number = 0;
      
      protected var _maxTimeX:int = 0;
      
      private var _cardFrame:int = 0;
      
      private var _mapHitType:String = "";
      
      private var _pid:int;
      
      private var _isPlay:Boolean = true;
      
      private var _isMoveing:Boolean = false;
      
      public var god:Boolean = false;
      
      public var liveRect:Rectangle;
      
      private var _isFlip:Boolean = false;
      
      private var _actionChange:Boolean = false;
      
      private var _beHitCount:int;
      
      public var hitMapPoint:Point = new Point();
      
      public var abody:Vector.<Body> = new Vector.<Body>();
      
      public function BaseRole(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super();
         targetName = roleTarget;
         this.troopid = troop;
         this.contentScale = Math.abs(pscale);
         this.scaleX = pscale > 0 ? 1 : -1;
         world = pworld;
         _ceData = new EncryptCEData();
         applyAttridute(roleAttr ? roleAttr : new RoleAttributeData(roleTarget));
         var roleXml:XML = DataCore.assetsRole.getXmlData(roleTarget);
         _roleXmlData = new RoleXMLData(this,roleXml);
         if(roleXml.@fps != undefined)
         {
            fps = int(roleXml.@fps);
         }
         _hateDict = new Dictionary();
         this.isGravMode = true;
         _fps = new FPSUtil(fps);
         if(roleXml.@scale != undefined)
         {
            this.contentScale = Number(roleXml.@scale);
         }
         this.x = xz;
         this.y = yz;
         if(Debug.UNAI)
         {
            ai = false;
         }
         if(!(this is SpriteRole || this is DragonRole))
         {
            throw new Error("请勿直接继承BaseRole类，转试用SpriteRole或者DragonRole。");
         }
      }
      
      public function set canJumpHit(b:Boolean) : void
      {
         _jumpHit = !b;
      }
      
      override public function onInit() : void
      {
         super.onInit();
         attribute.onUpdateLevel = onUpdateLevel;
         this.lockBounds();
      }
      
      public function set golden(i:int) : void
      {
         if(i <= 0)
         {
            this.filter = null;
         }
         _golden = i;
      }
      
      public function get golden() : int
      {
         return _golden;
      }
      
      public function set goldenTime(num:Number) : void
      {
         golden = num * 60;
      }
      
      public function onUpdateLevel() : void
      {
         this.dispatchEventWith("update_level",true);
      }
      
      public function get minihp() : HPMini
      {
         return _hpmini;
      }
      
      public function set minihp(hpdisplay:HPMini) : void
      {
         _hpmini = hpdisplay;
      }
      
      public function set isFlip(b:Boolean) : void
      {
         _isFlip = b;
         display.scaleX = -1 * this.contentScale;
      }
      
      public function get isFlip() : Boolean
      {
         return _isFlip;
      }
      
      public function applyAttridute(data:RoleAttributeData) : void
      {
         if(_roleAttribute)
         {
            _roleAttribute.onChange = null;
         }
         _roleAttribute = data;
         if(troopid == 1)
         {
            data.onChange = onAttributeChange;
         }
         _roleAttribute.updateRole(this);
         onAttributeChange();
      }
      
      public function set pid(i:int) : void
      {
         _pid = i;
      }
      
      public function get pid() : int
      {
         return _pid;
      }
      
      public function get roleXmlData() : RoleXMLData
      {
         return _roleXmlData;
      }
      
      public function set id(i:int) : void
      {
         _id = i;
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function get mandatorySkill() : int
      {
         return _mandatorySkill;
      }
      
      public function set mandatorySkill(i:int) : void
      {
         _mandatorySkill = i;
      }
      
      public function get maxMandatorySkill() : int
      {
         return _mandotorySkillMax;
      }
      
      public function set maxMandatorySkill(i:int) : void
      {
         _mandotorySkillMax = i;
      }
      
      public function get isPlay() : Boolean
      {
         return _isPlay;
      }
      
      public function play() : void
      {
         _isPlay = true;
      }
      
      public function stop() : void
      {
         _isPlay = false;
      }
      
      protected function onAttributeChange() : void
      {
         if(world.role == this && world.state)
         {
            world.state.onRoleStateUpdate(_roleAttribute);
         }
      }
      
      override public function onFrame() : void
      {
         if(world.runModel && world.runModel.onRoleFrame(this))
         {
            return;
         }
         if(isGravMode)
         {
            if(body)
            {
               body.gravMass = this.isJump() ? 0 : 1;
            }
         }
         if(golden > 0)
         {
            golden--;
         }
         if(_cardFrame > 0)
         {
            _cardFrame--;
         }
         roleXmlData.onFrame();
         if(_hpmini)
         {
            _hpmini.onFrame();
         }
         attribute.updateAllCD();
         this.aiFunc();
         this.mandatoryAction();
         super.onFrame();
         this.onMoved();
         this.onKillRole();
         dbody.position.x = body.position.x;
         dbody.position.y = body.position.y;
         if(!isJump())
         {
            _jumpTolerance = 10;
         }
         else if(_jumpTolerance > 0)
         {
            _jumpTolerance--;
         }
         _oldX = this.x;
         _oldY = this.y;
         if(!_lock)
         {
            mandatorySkill = maxMandatorySkill;
         }
      }
      
      public function mandatoryAction() : void
      {
         var actionTo:String = null;
         if(this._straight > 0)
         {
            if(isInjured())
            {
               breakAction();
            }
            this.runLockAction("受伤");
            if(!_blow2)
            {
               this._straight--;
            }
            else
            {
               _lock = false;
               actionTo = _beHitY > 0 ? "打飞" : "倒落";
               if(this.hasAction(actionTo))
               {
                  this.runLockAction(actionTo);
               }
               else
               {
                  this._straight--;
               }
            }
            if(this._straight == 0)
            {
               _blow = false;
               _blow2 = false;
               _lock = false;
               this._jumpMath = this._beHitY * 0.5;
            }
         }
         else if(this.actionName == "受伤")
         {
            breakAction();
         }
         if(!isInjured())
         {
            if(!isJump())
            {
               beHitCount = 0;
            }
            if(_down && !isJump())
            {
               this.runLockAction("防御");
            }
            else if(isDefense())
            {
               _lock = false;
            }
         }
         if(!hasAction(this.actionName))
         {
            this.action = "待机";
         }
      }
      
      public function setAi(h:AiHeart) : void
      {
         _ai = h;
      }
      
      public function getAi() : AiHeart
      {
         return _ai;
      }
      
      public function aiFunc() : void
      {
         if(!_ai || !ai || !world.auto || world.poltSystem.isRuning)
         {
            return;
         }
         _ai.onUpdate();
      }
      
      public function get jumpMath() : int
      {
         return _jumpMath;
      }
      
      public function set jumpMath(i:int) : void
      {
         _jumpMath = i;
      }
      
      public function set liveRectEvent(str:String) : void
      {
         var event:EventDisplay = world.getEventFormName(str) as EventDisplay;
         if(event)
         {
            liveRect = event.bounds.clone();
         }
      }
      
      public function move(tag:String) : void
      {
         _left = false;
         _right = false;
         onUp(65);
         onUp(68);
         switch(tag)
         {
            case "left":
               _left = true;
               onDown(65);
               break;
            case "right":
               _right = true;
               onDown(68);
               break;
            case "wait":
         }
      }
      
      private function onMoved() : void
      {
         _isMoveing = true;
         if(_oldX == this.body.position.x && _oldY == this.body.position.y)
         {
            if(_testCount > 0)
            {
               _isMoveing = false;
            }
            else
            {
               _testCount++;
            }
         }
         else
         {
            _testCount = 0;
         }
         if(isHitMap())
         {
            if(isJump())
            {
               lastTimeX = 0;
            }
            if(!isJump() || (_jumpMath <= 0 || _beHitY <= 0 && isInjured()))
            {
               if(_actionPoint && _actionPoint.y != 0)
               {
                  _isAllowUnJumpAction = this._actionName;
                  _jumpBoolean = true;
                  jumpMath = 0;
                  lastTimeX = 0;
                  return;
               }
               if(!_lock && _jumpBoolean || isInjured())
               {
                  jumpOff();
               }
            }
         }
         if(_hitBody)
         {
            _hitBody.position.x = body.position.x;
            _hitBody.position.y = body.position.y;
         }
         if(!isJump() && (this.isLock || this._left || this._right))
         {
            this.body.surfaceVel.x = this.body.velocity.x;
         }
         else
         {
            this.body.surfaceVel.x = 0;
         }
      }
      
      override public function setX(i:int) : void
      {
         super.setX(i);
         if(_hitBody)
         {
            _hitBody.position.x = i;
         }
      }
      
      override public function setY(i:int) : void
      {
         super.setY(i);
         if(_hitBody)
         {
            _hitBody.position.y = i;
         }
      }
      
      public function get isAllowUnJumpAction() : String
      {
         return _isAllowUnJumpAction;
      }
      
      public function set isAllowUnJumpAction(str:String) : void
      {
         _isAllowUnJumpAction = str;
      }
      
      public function get isLock() : Boolean
      {
         return _lock;
      }
      
      public function set isLock(b:Boolean) : void
      {
         _lock = b;
      }
      
      override public function onFrameAfter() : void
      {
         if(attribute.hp == 0)
         {
            if(!_isDie)
            {
               onDie(null);
               _isDie = true;
               playDieSound();
            }
            dieEffect();
         }
         super.onFrameAfter();
      }
      
      public function get attribute() : RoleAttributeData
      {
         return _roleAttribute;
      }
      
      public function isHitMap() : Boolean
      {
         var isHit:Boolean;
         var i:int;
         var bodyList:Vector.<Body>;
         var d:Number;
         var b:int;
         var d2:Number;
         if(hitMapPoint.x == this.posx && hitMapPoint.y == this.posy && mapHitType == GameMapHitType.HIT)
         {
            return true;
         }
         hitMapPoint.x = this.posx;
         hitMapPoint.y = this.posy;
         if(!isInjured() && this.jumpMath > 0)
         {
            _mapHitType = GameMapHitType.OUT;
            return false;
         }
         isHit = false;
         for(i = abody.length - 1; i >= 0; )
         {
            abody.removeAt(i);
            i = i - 1;
         }
         if(this.body.arbiters.length > 0)
         {
            this.body.arbiters.foreach(function(a:Arbiter):void
            {
               var d:Number = NaN;
               var collisionAngle:int = rad2deg(a.collisionArbiter.normal.angle);
               var body2:Body = a.body1 == body ? a.body2 : a.body1;
               abody.push(body2);
               if(body2 == a.body2)
               {
                  collisionAngle *= -1;
               }
               if(!isHit)
               {
                  if(collisionAngle < -20 && collisionAngle > -160)
                  {
                     if(!body2.userData.noHit && !(body2.userData.ref is BaseRole))
                     {
                        if(body2.userData.isThrough)
                        {
                           d = Geom.distanceBody(body,body2,PointUtils.vec2,PointUtils.vec2);
                           if(d > -1)
                           {
                              isHit = true;
                           }
                        }
                        else
                        {
                           isHit = true;
                        }
                     }
                  }
               }
            });
         }
         if(!isHit && mapHitType == GameMapHitType.HIT)
         {
            dbody.position.x = this.body.position.x;
            dbody.position.y = this.body.position.y + 10;
            bodyList = this.hitTestAtMap(dbody);
            if(bodyList)
            {
               d = 999;
               for(b = 0; b < bodyList.length; )
               {
                  if(abody.indexOf(bodyList[b]) == -1)
                  {
                     d2 = Geom.distanceBody(body,bodyList[b],PointUtils.vec2,PointUtils.vec2);
                     if(d > d2)
                     {
                        d = d2;
                     }
                  }
                  b = b + 1;
               }
               if(d > -1 && d < 5)
               {
                  this.body.position.y += d;
                  isHit = true;
               }
               else if(d < 0)
               {
                  isHit = true;
               }
               bodyList.splice(0,bodyList.length);
            }
            bodyList = null;
         }
         if(isHit)
         {
            mapHitType = isHit ? GameMapHitType.HIT : GameMapHitType.OVER;
            return isHit;
         }
         mapHitType = GameMapHitType.OUT;
         return false;
      }
      
      public function isTop(testBody:Body) : Boolean
      {
         var i:int = 0;
         var a:Arbiter = null;
         if(!testBody)
         {
            return false;
         }
         for(i = 0; i < body.arbiters.length; )
         {
            a = body.arbiters.at(i);
            if(testBody == a.body2 || testBody == a.body1)
            {
               if(a.collisionArbiter.normal.y > 0)
               {
                  return true;
               }
            }
            i++;
         }
         return false;
      }
      
      public function set hitBody(body:Body) : void
      {
         _hitBody = body;
      }
      
      public function get hitBody() : Body
      {
         if(_hitBody)
         {
            return _hitBody;
         }
         return body;
      }
      
      override public function onDown(key:int) : void
      {
         var npc:Actor = null;
         if(!this.parent)
         {
            return;
         }
         if(this.attribute.hp <= 0)
         {
            return;
         }
         super.onDown(key);
         switch(key)
         {
            case 65:
               _left = true;
               break;
            case 68:
               _right = true;
               break;
            case 83:
               _down = true;
               break;
            case 87:
               _up = true;
               npc = world.getCanMessageNpc();
               if(npc)
               {
                  world.poltSystem.polt(npc);
               }
               break;
            case 75:
               this.jump(-1,false,true);
               break;
            case 85:
               this.playSkillFormKey("U");
               break;
            case 73:
               this.playSkillFormKey("I");
               break;
            case 79:
               this.playSkillFormKey("O");
               break;
            case 80:
               this.playSkillFormKey("P");
               break;
            case 74:
               this.playSkill(this.isJump() ? "空中攻击" : "普通攻击");
         }
      }
      
      public function get fps() : int
      {
         return _fps.fps;
      }
      
      public function set fps(i:int) : void
      {
         _fps.fps = i;
      }
      
      override public function onUp(key:int) : void
      {
         if(!this.parent)
         {
            return;
         }
         if(!this.attribute || this.attribute.hp <= 0)
         {
            return;
         }
         super.onUp(key);
         switch(key)
         {
            case 65:
               _left = false;
               break;
            case 68:
               _right = false;
               break;
            case 83:
               _down = false;
               break;
            case 87:
               _up = false;
         }
      }
      
      public function overDown() : void
      {
         _left = false;
         _right = false;
         _down = false;
         _up = false;
      }
      
      public function isStopEvent() : Boolean
      {
         return roleXmlData.ifStopTag(actionName,currentFrame);
      }
      
      public function inFrame(actionName:String, pframe:int) : Boolean
      {
         if(this._actionName == actionName && _frame == pframe && _lastFrame != _frame)
         {
            _lastFrame = _frame;
            return true;
         }
         return false;
      }
      
      public function get currentActionLegnth() : int
      {
         return roleXmlData.getActionLength(actionName) - 1;
      }
      
      public function get currentGroup() : RoleFrameGroup
      {
         return this._roleXmlData.currentRoleFrame.group;
      }
      
      public function hasAction(str:String) : Boolean
      {
         return roleXmlData.hasAction(str);
      }
      
      override public function onChange() : void
      {
         var stopBoolean:Boolean = false;
         if(_lock)
         {
            // var _temp_1:* = §§findproperty(_keyHitMath); // 直接注释掉反编译错误的代码
            _keyHitMath -= _keyHitMath > 0 ? 1 : 0;
            stopBoolean = isStopEvent();
            if((_left || _right) && stopBoolean)
            {
               this.scaleX = _left ? -1 : 1;
            }
            if(_keyHitMath <= 0 && stopBoolean)
            {
               breakAction();
            }
            else if(_left || _right)
            {
               tryBreakLock();
            }
            return;
         }
         if(isJump())
         {
            this.action = this._jumpMath >= 0 ? "跳跃" : "降落";
         }
         else if(_left || _right)
         {
            if(hasAction("跑步"))
            {
               action = "跑步";
            }
            else
            {
               action = "行走";
            }
            if(!isLock)
            {
               this.scaleX = _left ? -1 : 1;
            }
         }
         else
         {
            action = "待机";
         }
      }
      
      public function getCurrentMoveSpeedPoint() : Point
      {
         var point:Point = roleXmlData.getMoveSpeed(actionName,currentFrame,fps);
         if(!point)
         {
            return Pool.getPoint();
         }
         point.x *= isFlip ? -1 : 1;
         return point;
      }
      
      public function get isHitMapGoOn() : Boolean
      {
         if(roleXmlData.currentRoleFrame)
         {
            return roleXmlData.currentRoleFrame.isHitMapGoOn;
         }
         return false;
      }
      
      override public function onMove() : void
      {
         var my:int = 0;
         if(cardFrame > 0)
         {
            xMove(0);
            yMove(0);
            return;
         }
         var actionPoint:Point = getCurrentMoveSpeedPoint();
         _actionPoint = actionPoint;
         if(actionPoint)
         {
            if(actionPoint.x != 0 || actionPoint.y != 0 || isLock)
            {
               my = actionPoint.y * contentScale;
               if(my < 0 && !isHitMap() || my > 0)
               {
                  if(isHitMap() && my > 0)
                  {
                     this._isAllowUnJumpAction = this.actionName;
                  }
                  if(isHitMapGoOn)
                  {
                     my += _jumpMath;
                     _jumpMath--;
                  }
                  yMove(-my);
               }
               else if(mapHitType == GameMapHitType.OVER)
               {
                  yMove(0);
               }
               else
               {
                  yMove(0);
               }
               xMove(-actionPoint.x * this.scaleX);
            }
         }
         if(isDefense() || this.isInjured())
         {
            debuffMove();
            return;
         }
         if(_lock && roleXmlData.currentRoleFrame)
         {
            if(isLock && (this.currentGroup.type == "land" || this.currentGroup.name == "普通攻击") && this.body.velocity.y == 0 && !isJump())
            {
               yMove(10);
            }
            if(_actionName != "空中攻击")
            {
               return;
            }
            if(_actionPoint && (_actionPoint.x != 0 || _actionPoint.y != 0))
            {
               this._jumpMath = _actionPoint.y;
               lastTimeX = -_actionPoint.x * this.scaleX;
               _maxTimeX = Math.abs(_lastTimeX);
               return;
            }
         }
         if(isJump())
         {
            if(!isLock || actionName == "空中攻击")
            {
               yMove(-this._jumpMath * 0.8);
               if(this._jumpMath == 0 && this._jumpPause > 0)
               {
                  this._jumpPause--;
               }
               else
               {
                  this._jumpMath--;
               }
            }
         }
         if(isDefense())
         {
            xMove(0);
            yMove(0);
         }
         else if(isJump())
         {
            xMove(_lastTimeX);
            if(_left)
            {
               lastTimeX -= 0.5;
            }
            else if(_right)
            {
               lastTimeX += 0.5;
            }
            if(Math.abs(_lastTimeX) > _maxTimeX)
            {
               lastTimeX = _maxTimeX * (_lastTimeX > 0 ? 1 : -1);
            }
         }
         else if(_left)
         {
            xMove(-_roleAttribute.speed);
         }
         else if(_right)
         {
            xMove(_roleAttribute.speed);
         }
         else
         {
            lastTimeX = 0;
         }
         if(this.body.velocity.x != 0 && this.body.velocity.y == 0 && !isJump())
         {
            yMove(10);
         }
      }
      
      public function debuffMove() : void
      {
         if(_cardFrame > 0)
         {
            xMove(0);
            yMove(0);
            return;
         }
         if(_blow && _cardFrame <= 0)
         {
            if(_beHitY > 0 || !isHitMap())
            {
               _beHitY--;
               this.yMove(-_beHitY * 0.5);
            }
         }
         if(_hitPause > 0 || _cardFrame > 0)
         {
            _hitPause--;
            if(_beHitX != 0)
            {
               this.xMove(_beHitX > 0 ? 1 : -1);
            }
            return;
         }
         this.xMove(_beHitX);
         if(!_blow)
         {
            if(int(_beHitX) != 0)
            {
               _beHitX += (0 - _beHitX) * 0.1;
            }
            else
            {
               _beHitX = 0;
            }
         }
      }
      
      override public function xMove(xz:Number) : void
      {
         if(!isJump())
         {
            if(!this.isLock)
            {
               this.lastTimeX = xz;
               this._maxTimeX = Math.abs(xz);
               if(_maxTimeX == 0)
               {
                  _maxTimeX = 3;
               }
            }
         }
         super.xMove(xz);
      }
      
      public function get mapHitType() : String
      {
         return _mapHitType;
      }
      
      public function set mapHitType(str:String) : void
      {
         _mapHitType = str;
      }
      
      public function set cardFrame(i:int) : void
      {
         this._cardFrame = i;
      }
      
      public function get cardFrame() : int
      {
         return this._cardFrame;
      }
      
      override public function draw(bool:Boolean = false) : void
      {
         if(!_fps.update() && !bool)
         {
            return;
         }
         if(_cardFrame > 0)
         {
            return;
         }
         if(this.visible)
         {
            onShapeChange();
         }
      }
      
      public function onShapeChange() : void
      {
         if(_actionChange)
         {
            onActionChange();
         }
      }
      
      public function onDraw() : void
      {
      }
      
      public function isInjured() : Boolean
      {
         return this._actionName == "受伤" || this._actionName == "打飞" || this._actionName == "倒落" || straight > 0;
      }
      
      public function isDefense() : Boolean
      {
         if(isJump())
         {
            return false;
         }
         if(isLock && actionName == "防御")
         {
            return true;
         }
         if(!isLock && !isInjured() && isKeyDown(83))
         {
            return true;
         }
         return false;
      }
      
      public function set action(str:String) : void
      {
         if(_actionName == str || _lock)
         {
            return;
         }
         _lastActionName = _actionName;
         if(str == "待机" || str == "行走")
         {
            _speedRuning = false;
         }
         else if(str == "跑步")
         {
            _speedRuning = true;
         }
         _actionName = str;
         _frame = 0;
         _actionChange = true;
      }
      
      protected function onActionChange() : void
      {
         if(this.roleXmlData.currentRoleFrame)
         {
            _actionChange = false;
            this.fps = this.roleXmlData.currentRoleFrame.group.fps;
         }
      }
      
      public function get actionName() : String
      {
         return _actionName;
      }
      
      public function set actionName(str:String) : void
      {
         _actionName = str;
      }
      
      public function playSkillFormKey(key:String) : void
      {
         var group:RoleFrameGroup = roleXmlData.getFrameGroupFromKey(key);
         if(group && cheakCanPlay(key))
         {
            this.playSkill(group.name);
         }
      }
      
      public function getCD(target:String) : Number
      {
         var ob:Object = roleXmlData.getGroupAt(target);
         if(ob)
         {
            return ob.cd;
         }
         return 0;
      }
      
      public function playSkill(target:String) : void
      {
         _keyHitMath = 18;
         var group:RoleFrameGroup = this.roleXmlData.getGroupAt(target);
         if(!group)
         {
            return;
         }
         if(actionName == "防御")
         {
            _lock = false;
         }
         if(!hasAction(target) || isInjured() && group.type != "injured" || _actionName == "起身")
         {
            return;
         }
         if(_lock && _actionName != target && target == "普通攻击")
         {
            return;
         }
         if(attribute.getCD(target) > 0)
         {
            return;
         }
         if(group.type == "injured")
         {
            this.clearDebuffMove();
            this.breakAction();
         }
         if(target == "空中攻击" && _isAllowUnJumpAction == "普通攻击")
         {
            target = "普通攻击";
         }
         if(this._lock)
         {
            if(this._mandatorySkill <= 0 || this._frame <= 3)
            {
               return;
            }
            if(this._actionName != target)
            {
               breakAction();
               this._lock = false;
               mandatorySkill--;
               if(_left || _right)
               {
                  this.scaleX = _left ? -1 : 1;
               }
            }
         }
         if(target != "空中攻击")
         {
            jumpMath = 0;
            lastTimeX = 0;
         }
         attribute.updateCD(target,getCD(target));
         if(world.runModel)
         {
            world.runModel.onCDChange(this,target);
         }
         runLockAction(target);
      }
      
      public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         if(!hasAction(str))
         {
            return;
         }
         if(str == "空中攻击" && _jumpHit)
         {
            return;
         }
         if(str == "空中攻击")
         {
            _jumpHit = true;
         }
         action = str;
         _lock = true;
         _canBreak = canBreak;
      }
      
      override public function setFogSprite(spr:FogSprite) : void
      {
         super.setFogSprite(spr);
         spr.setPXY(0,-50);
      }
      
      public function jump(hv:int = -1, foc:Boolean = false, jumpEff:Boolean = false) : void
      {
         if(this.attribute.hp <= 0)
         {
            return;
         }
         if(_actionName == "普通攻击" && !isJump())
         {
            if(_isAllowUnJumpAction != this._actionName)
            {
               yMove(10);
            }
            if(hv == 0)
            {
               return;
            }
            if(hv == -1)
            {
               breakAction();
            }
         }
         if(!(foc && !_lock))
         {
            if(isJump() || _lock)
            {
               if(!isJump() && _actionName == "待机")
               {
                  _lock = false;
               }
               else
               {
                  if(_jumpTolerance <= 0)
                  {
                     return;
                  }
                  if(jumpMath > 0)
                  {
                     return;
                  }
                  if(isLock)
                  {
                     return;
                  }
               }
            }
         }
         if(hv > 0)
         {
            _jumpPause = 6;
         }
         else
         {
            _jumpPause = 0;
         }
         if(jumpEff)
         {
            onJumpEffect();
         }
         _jumpBoolean = true;
         _jumpMath = hv != -1 ? hv : _roleAttribute.jump;
         if(_left || _right)
         {
            _maxTimeX = attribute.speed;
         }
         this.jumped();
      }
      
      public function jumped() : void
      {
      }
      
      public function set jumpTolerance(i:int) : void
      {
         _jumpTolerance = i;
      }
      
      public function get jumpTolerance() : int
      {
         return _jumpTolerance;
      }
      
      public function onJumpEffect() : void
      {
         var ob:Object = null;
         var skillEffect:EffectDisplay = null;
         if(DataCore.getTextureAtlas("jump"))
         {
            ob = EffectDisplay.getBaseObject();
            ob.rota = 0;
            skillEffect = new EffectDisplay("jump",ob,this);
            skillEffect.x = this.x;
            skillEffect.y = this.y;
            world.addChild(skillEffect);
            skillEffect.scale = 0.5;
         }
      }
      
      public function isJump() : Boolean
      {
         if(_isAllowUnJumpAction == this.actionName)
         {
            return mapHitType != GameMapHitType.HIT;
         }
         if(_jumpBoolean)
         {
            return true;
         }
         return mapHitType == GameMapHitType.OUT;
      }
      
      public function set jumpBoolean(b:Boolean) : void
      {
         _jumpBoolean = b;
      }
      
      public function cheakCanPlay(key:String) : Boolean
      {
         var group:RoleFrameGroup = roleXmlData.getFrameGroupFromKey(key);
         if(this.isInjured() && group.type != "injured")
         {
            return false;
         }
         if(this.isJump() && group.type == "land")
         {
            return false;
         }
         if(!this.isJump() && group.type == "air")
         {
            return false;
         }
         return true;
      }
      
      public function jumpOff() : void
      {
         if(_blow2)
         {
            if(_beHitY < -30)
            {
               _beHitY = -_beHitY * 0.3;
               this.onFallGroundEffect();
               return;
            }
            _blow = false;
            _blow2 = false;
            _lock = false;
            _jumpMath = 0;
            runLockAction("起身");
            clearDebuffMove();
            return;
         }
         if(_blow)
         {
            if(this._beHitY > 0 && this.isInjured())
            {
               return;
            }
            _blow = false;
            _blowTime = 0;
         }
         if(!_jumpBoolean || _jumpMath > -15)
         {
            if(!_actionPoint || _actionPoint.y == 0)
            {
               runLockAction("待机",true);
               unJump(true);
               return;
            }
         }
         unJump();
         jumpMath = 0;
         runLockAction("落地",true);
         this.onHitGroundEffect();
      }
      
      public function onHitGroundEffect() : void
      {
         if(!DataCore.getTextureAtlas("ground"))
         {
            return;
         }
         var ob2:Object = EffectDisplay.getBaseObject();
         ob2.rota = 0;
         var skillEffect2:EffectDisplay = new EffectDisplay("ground",ob2,this);
         skillEffect2.x = this.x;
         skillEffect2.y = this.y;
         world.addChild(skillEffect2);
      }
      
      public function onFallGroundEffect() : void
      {
         var ob:Object = null;
         var skillEffect:EffectDisplay = null;
         if(DataCore.getTextureAtlas("daodichen"))
         {
            ob = EffectDisplay.getBaseObject();
            ob.rota = 0;
            skillEffect = new EffectDisplay("daodichen",ob,this);
            skillEffect.x = this.x;
            skillEffect.y = this.y;
            world.addChild(skillEffect);
         }
      }
      
      public function unJump(unLock:Boolean = false) : void
      {
         if(!this.isJump())
         {
            return;
         }
         if(this._blow)
         {
            this.jumpOff();
         }
         if(_actionName == "空中攻击")
         {
            breakAction();
         }
         _jumpBoolean = false;
         _jumpMath = 0;
         _jumpHit = false;
         if(unLock)
         {
            _lock = false;
            _isAllowUnJumpAction = "";
         }
      }
      
      public function clearDebuffMove() : void
      {
         this._beHitX = 0;
         this._beHitY = 0;
         this._straight = 0;
         _blowTime = 0;
         _blow = false;
         _blow2 = false;
      }
      
      public function set beHitX(i:int) : void
      {
         _beHitX = i;
      }
      
      public function get beHitX() : int
      {
         return _beHitX;
      }
      
      public function set beHitY(i:int) : void
      {
         _beHitY = i;
      }
      
      public function get beHitY() : int
      {
         return _beHitY;
      }
      
      public function tryBreakLock() : void
      {
         if(_lock && _canBreak)
         {
            breakAction();
         }
      }
      
      public function breakAction() : void
      {
         onBreakAction(actionName);
         this._lock = false;
         this._isAllowUnJumpAction = "";
      }
      
      public function set canBreakAction(b:Boolean) : void
      {
         _canBreak = b;
      }
      
      public function onBreakAction(a:String) : void
      {
      }
      
      public function go(i:int) : void
      {
         currentFrame = i;
      }
      
      public function set currentFrame(i:int) : void
      {
         _lastFrame = _frame;
         this._frame = i;
      }
      
      public function get currentFrame() : int
      {
         return this._frame;
      }
      
      override public function createBody(vertice:Vector.<Vec2>, type:BodyType = null) : void
      {
         var box:Body = new Body(BodyType.DYNAMIC);
         var p:Polygon = new Polygon(Polygon.rect(-7,-105,14,100));
         p.material = new Material(0,0,0,1);
         var yuan:Circle = new Circle(6,new Vec2(0,-6));
         yuan.material = createMaterial();
         box.shapes.add(p);
         box.shapes.add(yuan);
         box.space = world.nape;
         box.allowRotation = false;
         box.rotation = 0;
         box.position.x = this.x;
         box.position.y = this.y;
         this.body = box;
         this.body.userData.ref = this;
         box.userData.role = this;
         box.userData.rolebase = true;
         this.body.scaleShapes(this.scaleX,this.scaleY);
         box.shapes.at(0).filter.collisionGroup = 100;
         box.gravMass = 0;
         dbody = new Body(BodyType.DYNAMIC);
         var p2:Polygon = new Polygon(Polygon.rect(-5,-10,10,10));
         var mate2:Material = createMaterial();
         p2.material = mate2;
         dbody.shapes.add(p2);
         dbody.allowRotation = false;
         dbody.rotation = 0;
         dbody.userData.noHit = true;
         body.shapes.at(0).filter.collisionGroup = 8;
      }
      
      override public function createMaterial() : Material
      {
         return new Material(0,1,1,1);
      }
      
      public function createBodyVec(vertice:Vector.<Vec2>) : void
      {
         var polygon:GeomPoly;
         var pbody:Body;
         var polyShapeList:GeomPolyList;
         if(_hitBody)
         {
            this._hitBody.space.bodies.remove(_hitBody);
            this._hitBody = null;
         }
         polygon = new GeomPoly(vertice);
         pbody = new Body(BodyType.DYNAMIC);
         polyShapeList = polygon.convexDecomposition();
         polyShapeList.foreach(function(shape:*):void
         {
            var polygon:Polygon = new Polygon(shape);
            polygon.material = new Material(0,1,2,1);
            pbody.shapes.push(polygon);
         });
         pbody.position.x = this.x;
         pbody.position.y = this.y;
         pbody.space = GameCore.currentWorld.nape;
         pbody.allowRotation = false;
         this._hitBody = pbody;
         this._hitBody.gravMass = 0;
         this._hitBody.userData.ref = this;
         this._hitBody.shapes.at(0).filter.collisionGroup = 100;
         this._hitBody.userData.noHit = true;
         this._hitBody.scaleShapes(this.scaleX,this.scaleY);
      }
      
      private function onKillRole() : void
      {
         onAttack();
      }
      
      public function get currentScaleX() : Number
      {
         return this.scaleX * (isFlip ? -1 : 1);
      }
      
      public function get currentScaleY() : Number
      {
         return this.scaleY;
      }
      
      public function onAttack() : void
      {
         var prole:BaseRole;
         var bodiesUnderMouse:BodyList;
         if(!this.roleXmlData.hitBody)
         {
            return;
         }
         if(this.isInjured() || actionName != roleXmlData.currentRoleFrame.group.name)
         {
            this.roleXmlData.clearBody();
            return;
         }
         prole = this;
         bodiesUnderMouse = this.world.nape.bodiesInBody(this.roleXmlData.hitBody);
         bodiesUnderMouse.foreach(function(body2:Body):void
         {
            if((body2.userData.ref is DamageActor || body2.userData.ref is BaseRole && body2 == body2.userData.ref.hitBody) && body2.userData.ref != prole)
            {
               roleXmlData.hited();
               roleXmlData.hitData.hitRect = roleXmlData.currentHitBody.bounds.toRect().intersection(body2.bounds.toRect());
               hate(body2.userData.ref as BaseRole,true);
               hitDataBuff(roleXmlData.hitData);
               body2.userData.ref.onBeHit(roleXmlData.hitData);
            }
         });
      }
      
      public function hitDataBuff(beData:BeHitData) : void
      {
      }
      
      public function set hit(i:int) : void
      {
         _hit = i;
      }
      
      public function get hit() : int
      {
         return _hit;
      }
      
      public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
      }
      
      public function get hitEffectName() : String
      {
         return roleXmlData.hitEffectName;
      }
      
      public function get beHitEffectName() : String
      {
         return roleXmlData.beHitEffect;
      }
      
      public function set beHitEffectName(str:String) : void
      {
         roleXmlData.beHitEffect = str;
      }
      
      public function playDieSound() : void
      {
         roleXmlData.playDieSound();
      }
      
      public function set beHitCount(i:int) : void
      {
         this._beHitCount = i;
      }
      
      public function get beHitCount() : int
      {
         return this._beHitCount;
      }
      
      public function isGod() : Boolean
      {
         if(this.attribute.hp <= 0)
         {
            return true;
         }
         if(god)
         {
            return true;
         }
         return this._actionName == "起身";
      }
      
      public function onMiss(beData:BeHitData) : void
      {
         var pbounds:Rectangle = beData.hitRect;
         var miss:MissFeedback = new MissFeedback(world.role == beData.role ? "self" : "enemy");
         miss.x = pbounds.x + pbounds.width * Math.random();
         miss.y = pbounds.y + pbounds.height * Math.random();
         world.addChild(miss);
         if(GameCore.currentWorld.runModel && GameCore.currentWorld.runModel.onMiss(this))
         {
         }
      }
      
      public function onBeHit(beData:BeHitData) : void
      {
         var beHurt2:int = 0;
         var skillEffect:EffectDisplay = null;
         var vpan:Number = NaN;
         if(this.world.runModel && this.world.runModel.onKillRole(this))
         {
            return;
         }
         if(!parent)
         {
            return;
         }
         if(!beData.isNoRole && beData.role.troopid == this.troopid)
         {
            return;
         }
         if(isGod())
         {
            return;
         }
         var pbounds:Rectangle = beData.hitRect;
         if(!beData.isNoRole && !beData.isHit(this.attribute))
         {
            onMiss(beData);
            return;
         }
         beData.role.cardFrame = beData.cardFrame;
         if(beData.hitVibrationSize > 6)
         {
            world.vibrationSize = beData.hitVibrationSize;
         }
         if(golden > 0)
         {
            beData.straight = 0;
            beData.moveX = 0;
            beData.moveY = 0;
            this.cardFrame += 4;
         }
         if(!beData.isNoRole)
         {
            beData.role.hit++;
         }
         beHitCount++;
         var effectPos:Point = new Point(pbounds.x + pbounds.width * Math.random(),pbounds.y + pbounds.height * Math.random());
         _beHitX = beData.moveX;
         if(!beData.isBreakDam && isDefense() && (beData.isNoRole || isRightInFront(beData.role)))
         {
            beHurt2 = beData.getHurt(this.attribute);
            hurtNumber(beHurt2 * 0.5,beData,effectPos);
            this.onDefenseEffect();
            return;
         }
         if(DataCore.getTextureAtlas(beData.hitEffectName))
         {
            skillEffect = new EffectDisplay(beData.hitEffectName,null,this);
            skillEffect.x = effectPos.x;
            skillEffect.y = effectPos.y;
            skillEffect.rotation = Math.random() * 3.14;
            skillEffect.unhit = true;
            world.addChild(skillEffect);
         }
         _hitPause = 6;
         onHitEffect(beData,effectPos);
         if(Math.abs(beData.moveX) > 10 && (Math.abs(beData.moveY) != 0 || isJump()))
         {
            _blow = true;
         }
         this.cardFrame = beData.cardFrame;
         if(beData.isCrit || beData.cardFrame > 0)
         {
            vpan = SoundUtils.mathPan(this.x,this.y,GameCore.currentWorld.centerX,GameCore.currentWorld.centerY,GameCore.currentWorld.stage.stageWidth);
            world.vibration(vpan);
         }
         if(_blow)
         {
            _blow2 = true;
         }
         if(beData.moveY != 0)
         {
            _blow = true;
            if(_beHitY < beData.moveY)
            {
               _beHitY = beData.moveY;
            }
            if(!beData.isNoRole)
            {
               this.scaleX = -beData.role.scaleX / beData.role.contentScale;
            }
            if(beData.blow || _blowTime > 0)
            {
               _blow2 = true;
            }
            _blowTime++;
            if(this._jumpBoolean == false)
            {
               this._jumpBoolean = true;
            }
         }
         else if(_blow2)
         {
            if(_beHitY < 15)
            {
               _beHitY = 15;
            }
         }
         this._jumpMath = 1;
         straight = beData.straight;
         if(_roleAttribute.hp == 0)
         {
            _beHitY = 5;
            _blow = true;
            _blow2 = true;
            if(!_isDie)
            {
               onDie(beData);
               _isDie = true;
               playDieSound();
            }
         }
         else
         {
            hate(beData.role);
         }
         _beHitX *= this.attribute.gravity / 100;
         _beHitY *= this.attribute.gravity / 100;
         onAttributeChange();
         if(!beData.isNoRole)
         {
            beData.role.onHitEnemy(beData,this);
         }
         var beHurt:int = beData.getHurt(this.attribute);
         hurtNumber(beHurt,beData,effectPos);
      }
      
      public function onHitEffect(beData:BeHitData, pos:Point) : EffectDisplay
      {
         if(beHitEffectName)
         {
            return createHitEffect(beHitEffectName,beData,pos);
         }
         return null;
      }
      
      public function createHitEffect(effectName:String, beData:BeHitData, pos:Point) : EffectDisplay
      {
         var beHitEffect:EffectDisplay = new EffectDisplay(effectName,null,this);
         beHitEffect.x = pos.x;
         beHitEffect.y = pos.y;
         beHitEffect.scale = Math.random() * 0.5 + 0.5;
         beHitEffect.unhit = true;
         if(!beData.isNoRole)
         {
            beHitEffect.scaleX *= beData.role.scaleX;
         }
         world.addChild(beHitEffect);
         return beHitEffect;
      }
      
      public function hurtNumber(beHurt:int, beData:BeHitData, pos:Point) : void
      {
         if(isGod())
         {
            return;
         }
         if(this.world.runModel && this.world.runModel.onHurt(this,beHurt))
         {
            return;
         }
         var ftype:String = "enemy";
         var isCrit:Boolean = false;
         if(beData != null)
         {
            isCrit = beData.isCrit;
            ftype = beData.isNoRole ? "" : (world.role == beData.role ? "self" : "enemy");
         }
         attribute.hp -= beHurt;
         var hurt:NumberFeedback = new feedbackType(beHurt,ftype,isCrit);
         hurt.x = pos.x;
         hurt.y = pos.y;
         world.addChild(hurt);
      }
      
      public function onDefenseEffect() : void
      {
         var skillEffect2:EffectDisplay = new EffectDisplay("defense",null,this,1.5,1.5);
         world.addChild(skillEffect2);
         skillEffect2.x = this.x;
         skillEffect2.y = this.y - 100 * Math.random();
      }
      
      protected function onDie(beData:BeHitData) : void
      {
         MonsterRefresh.singleton.add(this,this.attribute.resurrectionTime);
         var arr:Vector.<String> = null;
         if(beData)
         {
            arr = DataCore.fightData.getProps(this.attribute,beData.role.attribute);
         }
         else
         {
            arr = DataCore.fightData.getProps(this.attribute,null);
         }
         buildSpoils(arr);
      }
      
      public function buildSpoils(arr:Vector.<String>) : void
      {
         var n:int = 0;
         var spolis:Spoils = null;
         if(arr)
         {
            for(n = 0; n < arr.length; )
            {
               spolis = new Spoils.defaultClass(this.world,this.attribute,this.x + Math.random() * 10 - 5,this.y,arr[n],true);
               GameCore.currentWorld.addChild(spolis);
               DataCore.statisticalProps(arr[n]);
               n++;
            }
         }
      }
      
      public function hate(em:BaseRole, noadd:Boolean = false) : void
      {
         if(!em)
         {
            return;
         }
         if(!_hateDict[em])
         {
            _hateDict[em] = int(this.attribute.desire * 0.1);
         }
         else if(!noadd)
         {
            var _loc3_:* = em;
            var _loc4_:* = _hateDict[_loc3_] + int(this.attribute.desire * 0.1);
            _hateDict[_loc3_] = _loc4_;
         }
      }
      
      public function clearHate() : void
      {
         for(var i in _hateDict)
         {
            delete _hateDict[i];
         }
      }
      
      public function getHateDict() : Dictionary
      {
         return _hateDict;
      }
      
      public function getHateRole() : BaseRole
      {
         var mh:int = 0;
         var r2:* = null;
         var r:BaseRole = null;
         for(var rIndex in _hateDict)
         {
            r = rIndex as BaseRole;
            if(r && r.parent)
            {
               if(_hateDict[r] > mh)
               {
                  r2 = r;
                  mh = int(_hateDict[r]);
               }
            }
            else
            {
               delete _hateDict[r];
            }
         }
         return r2;
      }
      
      public function isRightInFront(role:BaseRole) : Boolean
      {
         var scale:Number = this.scaleX;
         if(scale < 0 && role.x < this.x)
         {
            return true;
         }
         if(scale > 0 && role.x > this.x)
         {
            return true;
         }
         return false;
      }
      
      public function set straight(value:int) : void
      {
         if(this.attribute.beatBack > 0)
         {
            this.attribute.weakenBeatBack();
         }
         else
         {
            this._straight = value;
            this.attribute.replyBeatBack();
         }
      }
      
      public function get straight() : int
      {
         return this._straight;
      }
      
      override public function get scaleX() : Number
      {
         // return _scaleX * contentScale;
         return super.scaleX * contentScale; // 改用super获取scaleX
      }
      
      override public function get scaleY() : Number
      {
         // return _scaleY * contentScale;
         return super.scaleY * contentScale; // 改用super获取scaleY
      }
      
      public function dieEffect() : void
      {
         if(!_dieColor)
         {
            _dieColor = new ColorMatrixFilter();
            _dieColor.adjustBrightness(1);
            this.filter = _dieColor;
         }
         this.alpha -= 0.1;
         if(this.alpha <= 0)
         {
            this.discarded();
         }
      }
      
      public function get identification() : String
      {
         return this.targetName + "_" + this.world.targetName + "_" + id;
      }
      
      public function get exp() : int
      {
         return GameEXPData.exp(_roleAttribute.lv,_roleAttribute.expRewards) - GameEXPData.exp(_roleAttribute.lv - 1,_roleAttribute.expRewards);
      }
      
      public function restoreHP(i:Number) : void
      {
         this.attribute.hp += this.attribute.hpmax * i;
         if(this.attribute.hp > this.attribute.hpmax)
         {
            this.attribute.hp = this.attribute.hpmax;
         }
      }
      
      override public function onSUpdate() : void
      {
         this.attribute.onBuffFrame();
      }
      
      public function addBuff(buff:BuffRef, maxCount:int = 1, clear:Boolean = false) : void
      {
         this.attribute.pushBuff(buff,maxCount,clear);
      }
      
      public function hasBuff(pclass:Class) : Boolean
      {
         return this.attribute.hasBuff(pclass);
      }
      
      public function getActionNameFromKey(key:String) : String
      {
         var group:RoleFrameGroup = roleXmlData.getFrameGroupFromKey(key);
         if(!group)
         {
            return null;
         }
         return group.name;
      }
      
      public function get display() : DisplayObject
      {
         return null;
      }
      
      public function get isMoveing() : Boolean
      {
         return _isMoveing;
      }
      
      public function get lastTimeX() : Number
      {
         return _lastTimeX;
      }
      
      public function set lastTimeX(i:Number) : void
      {
         this._lastTimeX = i;
      }
      
      public function set maxTimeX(i:Number) : void
      {
         this._maxTimeX = i;
      }
      
      public function get isHitKey() : Boolean
      {
         return _keyHitMath > 0;
      }
      
      public function set blow(b:Boolean) : void
      {
         _blow = b;
      }
      
      public function copyState() : Object
      {
         return {
            "action":this._actionName,
            "beHitCount":this._beHitCount
         };
      }
      
      override public function dispose() : void
      {
         trace("BaseRole dispose");
         if(_ai)
         {
            _ai.clear();
            _ai = null;
         }
         if(roleXmlData && roleXmlData.hitBody && roleXmlData.hitBody.space)
         {
            roleXmlData.hitBody.space.bodies.remove(roleXmlData.hitBody);
         }
         if(world)
         {
            world.removeRole(this);
         }
         if(_ceData)
         {
            _ceData.gc();
         }
         if(body && body.space)
         {
            clearBodyAttr(body);
            body.space.bodies.remove(body);
         }
         if(_hitBody && this._hitBody.space)
         {
            clearBodyAttr(_hitBody);
            this._hitBody.space.bodies.remove(_hitBody);
         }
         if(_dieColor)
         {
            _dieColor.dispose();
         }
         this._hitBody = null;
         dbody = null;
         _dieColor = null;
         this.hitBody = null;
         body = null;
         _ceData = null;
         _hpmini = null;
         if(roleXmlData)
         {
            this.roleXmlData.clear();
         }
         this._roleXmlData = null;
         this._roleAttribute = null;
         this._ai = null;
         this._actionPoint = null;
         this.world = null;
         super.dispose();
      }
      
      override public function discarded() : void
      {
         trace("BaseRole discarded");
         super.discarded();
      }
   }
}

