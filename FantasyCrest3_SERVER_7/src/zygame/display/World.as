package zygame.display
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import lzm.starling.swf.FPSUtil;
   import nape.callbacks.CbEvent;
   import nape.callbacks.CbType;
   import nape.callbacks.InteractionCallback;
   import nape.callbacks.InteractionListener;
   import nape.callbacks.InteractionType;
   import nape.callbacks.PreCallback;
   import nape.callbacks.PreFlag;
   import nape.callbacks.PreListener;
   import nape.dynamics.Arbiter;
   import nape.dynamics.CollisionArbiter;
   import nape.geom.Geom;
   import nape.geom.Vec2;
   import nape.phys.Body;
   import nape.space.Space;
   import nape.util.ShapeDebug;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.rendering.Painter;
   import starling.textures.RenderTexture;
   import starling.utils.Pool;
   import zygame.ai.AI;
   import zygame.core.CoreStarup;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   import zygame.core.MonsterRefresh;
   import zygame.core.PoltSystem;
   import zygame.data.RoleAttributeData;
   import zygame.data.RoleFrameGroupCache;
   import zygame.data.SpoilsRefresh;
   import zygame.debug.Debug;
   import zygame.event.GameMapHitType;
   import zygame.event.ZYError;
   import zygame.run.IRunModel;
   import zygame.tmx.Map;
   import zygame.utils.PointUtils;
   
   public class World extends KeyDisplayObject
   {
      
      public static var worldScale:Number = 1.3;
      
      public static var velocityIterations:int = 10;
      
      public static var positionIterations:int = 10;
      
      public static var defalutClass:Class = World;
      
      public var cameraPx:Number = 0.5;
      
      public var cameraPy:Number = 0.4;
      
      private var _fogSystem:FogSystem;
      
      private var _keyRole:Vector.<BaseRole>;
      
      private var _nape:Space;
      
      private var _debug:ShapeDebug;
      
      private var _starlingMap:Map;
      
      private var _role:BaseRole;
      
      private var _roles:Vector.<BaseRole>;
      
      private var _isPause:Boolean = false;
      
      private var _state:WorldState;
      
      private var _messageTips:Actor;
      
      private var _messageNpc:Actor;
      
      private var arbiter:Arbiter;
      
      public var poltSystem:PoltSystem;
      
      private var _tipsLayer:Sprite;
      
      private var _mapTarget:String;
      
      private var _mapTargetNpcName:String;
      
      private var _q:Quad;
      
      private var _gameBG:BackgroundSprite;
      
      private var _hit:HitNumer;
      
      private var _spolispid:int = 0;
      
      private var _spolis:Vector.<Spoils>;
      
      private var _sfps:FPSUtil;
      
      private var inFrame:Boolean = false;
      
      private var _refs:Vector.<DisplayObjectContainer>;
      
      private var _isAuto:Boolean = true;
      
      private var _mapVibrationTime:int = 0;
      
      public var founcDisplay:DisplayObject;
      
      private var _renderTexture:RenderTexture;
      
      private var _lockAsk:Boolean = false;
      
      private var _keyDict:Array;
      
      private var _vibrationSize:Number = 6;
      
      private var _drawRect:Rectangle;
      
      private var _drawPos:Point;
      
      private var _worldType:String;
      
      public var runModel:IRunModel;
      
      private var _roleAssets:Array;
      
      private var preVec2:Vec2 = new Vec2();
      
      public var isDiscarded:Boolean = false;
      
      public function World(mapName:String, toName:String)
      {
         super();
         targetName = mapName;
         _mapTarget = mapName;
         _mapTargetNpcName = toName;
         create();
      }
      
      public function set vibrationSize(i:int) : void
      {
         if(i > _vibrationSize)
         {
            _vibrationSize = i;
         }
      }
      
      public function get vibrationSize() : int
      {
         return _vibrationSize;
      }
      
      private function create() : void
      {
         _nape = new Space(new Vec2(0,5000));
         _keyRole = new Vector.<BaseRole>();
         _roles = new Vector.<BaseRole>();
         poltSystem = new PoltSystem(this);
         _spolis = new Vector.<Spoils>();
         _sfps = new FPSUtil(1);
         _keyDict = [];
         _refs = new Vector.<DisplayObjectContainer>();
         this.addEventListener("enterFrame",onFrameUpdate);
         var preListener:PreListener = new PreListener(InteractionType.ANY,CbType.ANY_BODY,CbType.ANY_BODY,onPre);
         _nape.listeners.add(preListener);
         var collisionListener:InteractionListener = new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,CbType.ANY_BODY,CbType.ANY_BODY,onCollide);
         _nape.listeners.add(collisionListener);
      }
      
      public function createRole(roles:Array) : void
      {
         _roleAssets = roles;
      }
      
      private function onCollide(cb:InteractionCallback) : void
      {
         var spoils:Spoils = null;
         var role:BaseRole = null;
         var prole:BaseRole = null;
         if(cb.arbiters.length <= 0)
         {
            return;
         }
         arbiter = cb.arbiters.at(0);
         if(arbiter.collisionArbiter.body1.userData.ref is Spoils || arbiter.collisionArbiter.body2.userData.ref is Spoils)
         {
            if(this.role == arbiter.collisionArbiter.body1.userData.ref || this.role == arbiter.collisionArbiter.body2.userData.ref)
            {
               spoils = null;
               if(arbiter.collisionArbiter.body1.userData.ref is Spoils)
               {
                  spoils = arbiter.collisionArbiter.body1.userData.ref as Spoils;
                  role = arbiter.collisionArbiter.body2.userData.ref as BaseRole;
               }
               else
               {
                  spoils = arbiter.collisionArbiter.body2.userData.ref as Spoils;
                  role = arbiter.collisionArbiter.body1.userData.ref as BaseRole;
               }
               spoils.pickUp(role);
            }
            return;
         }
         if(arbiter.collisionArbiter.body1.userData.ref as BaseRole && arbiter.collisionArbiter.body2.userData.ref as BaseRole)
         {
            return;
         }
         if(arbiter.collisionArbiter.body1.userData.noHit || arbiter.collisionArbiter.body2.userData.noHit)
         {
            if(arbiter.collisionArbiter.body1.userData.ref is EventDisplay && arbiter.collisionArbiter.body2.userData.ref is BaseRole)
            {
               if(arbiter.collisionArbiter.body2.userData.ref.body == arbiter.collisionArbiter.body2)
               {
                  (arbiter.collisionArbiter.body1.userData.ref as EventDisplay).onEvent(arbiter.collisionArbiter.body2.userData.ref as BaseRole);
               }
            }
            else if(arbiter.collisionArbiter.body2.userData.ref is EventDisplay && arbiter.collisionArbiter.body1.userData.ref is BaseRole)
            {
               if(arbiter.collisionArbiter.body1.userData.ref.body == arbiter.collisionArbiter.body1)
               {
                  (arbiter.collisionArbiter.body2.userData.ref as EventDisplay).onEvent(arbiter.collisionArbiter.body1.userData.ref as BaseRole);
               }
            }
            return;
         }
         if(arbiter.collisionArbiter.body1.userData.isThrough || arbiter.collisionArbiter.body2.userData.isThrough)
         {
            return;
         }
         if(arbiter.collisionArbiter.normal.y > 0.5)
         {
            prole = arbiter.body1.userData.ref as BaseRole;
            if(!prole)
            {
               prole = arbiter.body2.userData.ref as BaseRole;
            }
            if(prole && prole.jumpMath > 0)
            {
               prole.jump(0,true);
            }
         }
      }
      
      private function onPre(e:PreCallback) : PreFlag
      {
         var r:RefRole = null;
         var v:Vec2 = null;
         var len:Number = NaN;
         var collsion:CollisionArbiter = e.arbiter.collisionArbiter;
         if(!collsion)
         {
            return acceptPre(r,v,PreFlag.ACCEPT);
         }
         r = e.arbiter.collisionArbiter.body1.userData.ref as RefRole;
         if(!r)
         {
            r = e.arbiter.collisionArbiter.body2.userData.ref as RefRole;
         }
         preVec2.x = collsion.normal.x;
         preVec2.y = collsion.normal.y;
         v = preVec2;
         if(r && !(collsion.body2.userData.ref is RefRole))
         {
            v.x = collsion.normal.x * -1;
            v.y = collsion.normal.y * -1;
         }
         if(collsion.body1.userData.ref is Spoils || collsion.body2.userData.ref is Spoils)
         {
            if(collsion.body1.userData.ref is Spoils && collsion.body2.userData.ref is Spoils)
            {
               return acceptPre(r,v,PreFlag.ACCEPT);
            }
            if(collsion.body1.userData.ref is RefRole || collsion.body2.userData.ref is RefRole)
            {
               return PreFlag.IGNORE;
            }
         }
         if(collsion.body1.userData.noHit || collsion.body2.userData.noHit)
         {
            return PreFlag.IGNORE;
         }
         if(collsion.body1.userData.isThrough || collsion.body2.userData.isThrough)
         {
            len = Geom.distanceBody(collsion.body1,collsion.body2,PointUtils.vec2,PointUtils.vec2);
            if(len < -15)
            {
               return PreFlag.IGNORE;
            }
            if(v.x < -0.95 || v.x > 0.95)
            {
               return PreFlag.IGNORE;
            }
            if(e.swapped && v.y < 0)
            {
               return PreFlag.IGNORE;
            }
            if(!e.swapped && v.y > 0)
            {
               return PreFlag.IGNORE;
            }
            return acceptPre(r,v,PreFlag.ACCEPT_ONCE);
         }
         if(e.arbiter.collisionArbiter.body1.userData.ref as RefRole && e.arbiter.collisionArbiter.body2.userData.ref as RefRole)
         {
            return PreFlag.IGNORE;
         }
         if(e.arbiter.collisionArbiter.body1.userData.ref && e.arbiter.collisionArbiter.body2.userData.ref)
         {
            if((e.arbiter.collisionArbiter.body1.userData.ref as BodyDisplayObject).acceptOne || (e.arbiter.collisionArbiter.body2.userData.ref as BodyDisplayObject).acceptOne)
            {
               return acceptPre(r,v,PreFlag.ACCEPT_ONCE);
            }
         }
         return acceptPre(r,v,PreFlag.ACCEPT_ONCE);
      }
      
      private function acceptPre(r:RefRole, v:Vec2, flag:PreFlag) : PreFlag
      {
         var r2:BaseRole = null;
         if(r)
         {
            r2 = r as BaseRole;
            if(r2 && v.y < 0 && v.x > -0.7 && v.x < 0.7 && r2.jumpMath < 0)
            {
               r2.unJump();
            }
         }
         return flag;
      }
      
      override public function onInit() : void
      {
         var bgSprite:BackgroundSprite = null;
         _drawRect = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
         _drawPos = new Point();
         _tipsLayer = new Sprite();
         this.name = "map" + Math.random() * 2;
         var tmxXML:XML = DataCore.getXml(_mapTarget);
         if(tmxXML.@type != undefined)
         {
            _worldType = tmxXML.@type;
         }
         else
         {
            _worldType = "adventure";
         }
         _starlingMap = new Map(tmxXML,this);
         this.addChild(_starlingMap);
         this.createRoles();
         this.openKey();
         if(DataCore.assetsSwf.otherAssets.getTextureAtlas("message"))
         {
            _messageTips = new Actor("message",6);
            _starlingMap.addChild(_messageTips);
         }
         this.addChild(_tipsLayer);
         _hit = new HitNumer();
         _hit.role = role;
         this.parent.addChild(_hit);
         _q = new Quad(stage.stageWidth,stage.stageHeight,0);
         this.parent.addChild(_q);
         onInitSpoils();
         trace("BG",DataCore.assetsMap.backgroundConfig);
         if(tmxXML.@bg != undefined && String(tmxXML.@bg) != "<null>" && DataCore.assetsMap.backgroundConfig)
         {
            bgSprite = new BackgroundSprite(DataCore.assetsMap.backgroundConfig[String(tmxXML.@bg)]);
            bgSprite.targetName = String(tmxXML.@bg);
            addBackgroundContent(bgSprite);
         }
         if(CoreStarup.testRunderType)
         {
            GameCore.currentCore.runderType = CoreStarup.testRunderType;
         }
         if(Debug.IS_DRAW_DEBUG_NAPE)
         {
            _debug = new ShapeDebug(map.getWidth(),map.getHeight());
         }
         GameCore.keyCore.resetPort();
         trace("create new world");
      }
      
      public function createRoles() : void
      {
         for(var r in _roleAssets)
         {
            onRoleCreate(int(r),_roleAssets[r]);
            if(this.worldType == "peace")
            {
               break;
            }
         }
      }
      
      public function get loadRoles() : Array
      {
         return _roleAssets;
      }
      
      protected function onRoleCreate(index:int, target:String) : void
      {
         var prole:BaseRole = null;
         trace("创建：",index,target);
         var pclass:Class = DataCore.assetsRole.getClass(target);
         if(pclass)
         {
            prole = new pclass(target,stage.stageWidth / 2,400,this,24,1,1,DataCore.getRoleConfig(target));
            prole.name = "role" + index;
            if(index == 0)
            {
               role = prole;
               prole.ai = false;
               if(_starlingMap.extendData && _starlingMap.extendData.targetPoint)
               {
                  prole.setX(_starlingMap.extendData.targetPoint.x);
                  prole.setY(_starlingMap.extendData.targetPoint.y);
               }
               this.changeXYFormNpc(prole,this._mapTargetNpcName);
            }
            else
            {
               prole.ai = !Debug.UNAI;
               prole.setX(role.x);
               prole.setY(role.y);
            }
            _role.troopid = 1;
            this.addRole(prole);
         }
         else
         {
            log(target,"未加载角色资源");
         }
      }
      
      public function addStateContent(state:WorldState) : void
      {
         if(_state)
         {
            _state.removeFromParent();
         }
         _state = state;
         _state.world = this;
         if(role)
         {
            _state.onRoleStateUpdate(role.attribute);
         }
         this.parent.addChild(state);
      }
      
      public function addBackgroundContent(content:BackgroundSprite) : void
      {
         if(_gameBG)
         {
            _gameBG.removeFromParent();
         }
         _gameBG = content;
         _gameBG.touchable = false;
         _gameBG.world = this;
         this.parent.addChildAt(_gameBG,0);
      }
      
      public function get backgroundContent() : BackgroundSprite
      {
         return _gameBG;
      }
      
      public function lockAsk() : void
      {
         _lockAsk = true;
      }
      
      public function unLockAsk() : void
      {
         _lockAsk = false;
      }
      
      public function get isLockAsk() : Boolean
      {
         var roles:* = undefined;
         if(_lockAsk)
         {
            roles = this.getRoleList();
            for(var i in roles)
            {
               if(roles[i].troopid != role.troopid)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function onInitSpoils() : void
      {
         var data:Object = null;
         var gameSpolis:Spoils = null;
         var obs:Vector.<Object> = SpoilsRefresh.singleton.getMapSpoils(this,true);
         for(var i in obs)
         {
            data = obs[i];
            gameSpolis = new Spoils.defaultClass(this,new RoleAttributeData(data.roleTarget),data.x,data.y,data.targetName);
            this.addChild(gameSpolis);
         }
      }
      
      public function mathIndex() : void
      {
      }
      
      public function changeXYFormNpc(prole:BaseRole, target:String) : void
      {
         var i2:int = 0;
         var event:EventDisplay = null;
         var npcs:Vector.<Actor> = this.map.getNpcs();
         for(var i in npcs)
         {
            if(npcs[i].getName() == target)
            {
               prole.body.position.x = npcs[i].x;
               prole.body.position.y = npcs[i].y;
               prole.x = prole.body.position.x;
               prole.y = prole.body.position.y;
               prole.scaleX = prole.body.position.x < this.map.getWidth() / 2 ? 1 : -1;
               break;
            }
         }
         for(i2 = this.map.eventLayer.numChildren - 1; i2 >= 0; )
         {
            event = this.map.eventLayer.getChildAt(i2) as EventDisplay;
            if(event && event.getName() == target)
            {
               if(event.height > event.width)
               {
                  if(event.x > map.getWidth() / 2)
                  {
                     prole.body.position.x = event.x - 16;
                  }
                  else
                  {
                     prole.body.position.x = event.x + event.width + 16;
                  }
                  prole.body.position.y = event.y + event.height * DataCore.getNumber("warp_y");
               }
               else
               {
                  if(event.y < map.getHeight() / 2)
                  {
                     prole.body.position.y = event.y + event.height + 16;
                  }
                  else
                  {
                     prole.body.position.y = event.y - 16;
                     prole.jump(prole.attribute.jump * 0.75);
                     prole.maxTimeX = prole.attribute.speed;
                  }
                  prole.body.position.x = event.x + event.width * DataCore.getNumber("warp_x");
               }
               prole.x = prole.body.position.x;
               prole.y = prole.body.position.y;
               prole.scaleX = prole.body.position.x < this.map.getWidth() / 2 ? 1 : -1;
               if(DataCore.getInt("warp_scaleX") != 0)
               {
                  prole.scaleX = DataCore.getInt("warp_scaleX");
               }
               if(DataCore.getBoolean("warp_isJump"))
               {
                  prole.jumpMath = DataCore.getInt("warp_jumpMath");
                  prole.jumpTolerance = 0;
                  prole.lastTimeX = DataCore.getInt("warp_lastX");
                  prole.xMove(prole.lastTimeX);
                  prole.mapHitType = GameMapHitType.OUT;
               }
            }
            i2--;
         }
         moveMap(1);
      }
      
      public function get map() : Map
      {
         return _starlingMap;
      }
      
      public function set auto(b:Boolean) : void
      {
         _isAuto = b;
      }
      
      public function get auto() : Boolean
      {
         return _isAuto;
      }
      
      override public function onDown(key:int) : void
      {
         super.onDown(key);
         if(!_isAuto)
         {
            return;
         }
         for(var i in _keyDict)
         {
            _keyDict[i].onDown(key);
         }
         if(runModel && runModel.onDown(key))
         {
            return;
         }
         if(poltSystem.isRuning)
         {
            if(key == 74)
            {
               poltSystem.quick();
            }
            return;
         }
         for(var i2 in _keyRole)
         {
            _keyRole[i2].onDown(key);
         }
      }
      
      override public function onUp(key:int) : void
      {
         super.onUp(key);
         if(!_isAuto)
         {
            return;
         }
         for(var i in _keyDict)
         {
            _keyDict[i].onUp(key);
         }
         if(poltSystem.isRuning)
         {
            return;
         }
         if(runModel && runModel.onUp(key))
         {
            return;
         }
         for(var i2 in _keyRole)
         {
            _keyRole[i2].onUp(key);
         }
      }
      
      public function addKeyDisplay(key:DisplayObjectContainer) : void
      {
         _keyDict.push(key);
      }
      
      public function removeKeyDisplay(key:DisplayObjectContainer) : void
      {
         var index:int = int(_keyDict.indexOf(key));
         if(index != -1)
         {
            _keyDict.removeAt(index);
         }
      }
      
      public function onFrameUpdate(e:Event) : void
      {
         var npcActor:Actor = null;
         var i:int = 0;
         var ref:DisplayObjectContainer = null;
         GameCore.soundCore.updateSound();
         if(!this.parent)
         {
            return;
         }
         inFrame = true;
         if(_state)
         {
            _state.onFrame();
         }
         if(runModel && runModel.onFrame())
         {
            inFrame = false;
            return;
         }
         if(_messageTips)
         {
            _messageTips.visible = false;
         }
         _messageNpc = null;
         if(role && !role.isLock && !role.isJump() && !poltSystem.isRuning && !AI.enemy(role,240,240))
         {
            for(var npc in _starlingMap.getNpcs())
            {
               npcActor = _starlingMap.getNpcs()[npc];
               if(npcActor.show && npcActor.hasPolt() && npcActor.cheakCanMessage(_role))
               {
                  if(_messageTips)
                  {
                     _messageTips.visible = true;
                     _messageTips.x = npcActor.x;
                     _messageTips.y = npcActor.y - 110;
                     _messageTips.onFrame();
                  }
                  _messageNpc = npcActor;
                  break;
               }
            }
         }
         for(var r in _refs)
         {
            _refs[r].onFrame();
         }
         if(_q)
         {
            _q.alpha -= 0.1;
            if(_q.alpha <= 0)
            {
               _q.removeFromParent(true);
               _q = null;
            }
         }
         if(_isPause)
         {
            inFrame = false;
            return;
         }
         var count:int = this.numChildren;
         for(i = count - 1; i >= 0; )
         {
            ref = this.getChildAt(i) as DisplayObjectContainer;
            if(ref is DisplayObjectContainer)
            {
               ref.onFrame();
            }
            i--;
         }
         if(this._sfps.update())
         {
            for(var r2 in _refs)
            {
               _refs[r2].onSUpdate();
            }
            for(var buff in this._roles)
            {
               this._roles[buff].onSUpdate();
            }
            if(_state)
            {
               this._state.onSUpdate();
            }
            SpoilsRefresh.singleton.onFrame();
            MonsterRefresh.singleton.onFrame();
         }
         refershNape();
         poltSystem.onFrame();
         moveMap(0.1);
         _hit.onFrame();
         if(_gameBG)
         {
            _gameBG.onFrame();
         }
         this.onFrame();
         if(runModel)
         {
            runModel.onFrameOver();
         }
         if(e != null && Starling.current.nativeStage.frameRate == 30)
         {
            onFrameUpdate(null);
         }
         inFrame = false;
         for(r2 in _refs)
         {
            _refs[r2].onFrameAfter();
         }
         if(isDiscarded)
         {
            this.removeFromParent(true);
            super.discarded();
         }
      }
      
      public function get hitNumber() : HitNumer
      {
         return _hit;
      }
      
      public function moveMap(speed:Number) : void
      {
         this.visible = true;
         if(!founcDisplay || !stage)
         {
            return;
         }
         var mx:int = stage.stageWidth / (4 * cameraPx) - founcDisplay.x * this.scaleX;
         var my:int = stage.stageHeight / (4 * cameraPy) - founcDisplay.y * this.scaleX;
         if(mx > 0)
         {
            mx = 0;
         }
         else if(mx < -map.getWidth() * this.scaleX + stage.stageWidth)
         {
            mx = -map.getWidth() * this.scaleX + stage.stageWidth;
         }
         if(my > 0)
         {
            my = 0;
         }
         else if(my < -map.getHeight() * this.scaleX + stage.stageHeight)
         {
            my = -map.getHeight() * this.scaleX + stage.stageHeight;
         }
         this.x += int((mx - this.x) * speed);
         this.y += int((my - this.y) * speed);
         var oldWidth:int = map.getWidth() * this.scaleX;
         var oldHeight:int = map.getHeight() * this.scaleX;
         this.scale += (worldScale - this.scaleX) * speed;
         var newWidth:int = map.getWidth() * this.scaleX;
         var newHeight:int = map.getHeight() * this.scaleX;
         this.x -= (newWidth - oldWidth) / 2;
         this.y -= (newHeight - oldHeight) / 2;
         if(this.x > 0)
         {
            this.x = 0;
         }
         else if(this.x < -map.getWidth() * this.scaleX + stage.stageWidth)
         {
            this.x = -map.getWidth() * this.scaleX + stage.stageWidth;
         }
         if(_mapVibrationTime > 0 || vibrationSize > 6)
         {
            _mapVibrationTime--;
            if(vibrationSize > 3)
            {
               _vibrationSize -= 1;
            }
            this.x += Math.random() * vibrationSize * 2 - vibrationSize;
            this.y += Math.random() * vibrationSize * 2 - vibrationSize;
         }
         else
         {
            _vibrationSize = 3;
         }
      }
      
      public function addUpdateList(ref:DisplayObjectContainer) : void
      {
         _refs.push(ref);
      }
      
      public function removeUpdateList(ref:DisplayObjectContainer) : void
      {
         _refs.removeAt(_refs.indexOf(ref));
      }
      
      public function getCanMessageNpc() : Actor
      {
         if(!this.isLockAsk && _messageNpc && _messageNpc.hasPolt())
         {
            return _messageNpc;
         }
         return null;
      }
      
      public function refershNape() : void
      {
         var body:Body = null;
         var graphic:DisplayObject = null;
         var i:int = 0;
         _nape.step(0.016666666666666666,velocityIterations,positionIterations);
         if(!_nape)
         {
            return;
         }
         for(i = 0; i < _nape.liveBodies.length; )
         {
            body = _nape.liveBodies.at(i);
            graphic = body.userData.ref as DisplayObject;
            if(graphic)
            {
               graphic.x = body.position.x;
               graphic.y = body.position.y;
               graphic.rotation = body.rotation;
            }
            i++;
         }
         if(Debug.IS_DRAW_DEBUG_NAPE)
         {
            _debug.clear();
            _debug.flush();
            _debug.drawCollisionArbiters = true;
            _debug.draw(_nape);
            _debug.display.x = this.x - 32;
            _debug.display.y = this.y - 32;
            _debug.display.scaleY = this.scaleX;
            _debug.display.scaleX = this.scaleX;
            GameCore.currentCore.nativeStage.addChild(_debug.display);
         }
      }
      
      public function get isPause() : Boolean
      {
         return _isPause;
      }
      
      public function pause() : void
      {
         _isPause = true;
      }
      
      public function resume() : void
      {
         _isPause = false;
      }
      
      public function getRoleList() : Vector.<BaseRole>
      {
         return _roles;
      }
      
      public function get nape() : Space
      {
         return _nape;
      }
      
      public function get role() : BaseRole
      {
         return _role;
      }
      
      public function set role(r:BaseRole) : void
      {
         _role = r;
         founcDisplay = r;
         if(_role && _keyRole.indexOf(r) == -1)
         {
            _keyRole.push(r);
         }
         if(_role && this.role.parent)
         {
            this.role.parent.setChildIndex(role,this.role.parent.numChildren);
         }
      }
      
      public function stopAllAction() : void
      {
         var i:int = 0;
         for(i = 0; i < _roles.length; )
         {
            _roles[i].onUp(65);
            _roles[i].onUp(68);
            i++;
         }
      }
      
      public function get state() : WorldState
      {
         return _state;
      }
      
      public function addRole(prole:BaseRole) : void
      {
         _roles.push(prole);
         prole.pid = _roles.length;
         map.addRole(prole);
      }
      
      public function removeRole(prole:BaseRole) : void
      {
         if(prole.id != -1 && prole.attribute.hp <= 0)
         {
            onExpAdd(prole);
         }
         if(role == prole && prole.attribute.hp <= 0)
         {
            this.dispatchEventWith("role_die",true);
         }
         if(_roles.indexOf(prole) != -1)
         {
            _roles.removeAt(_roles.indexOf(prole));
         }
         if(!prole.isRemoveing)
         {
            prole.discarded();
         }
      }
      
      public function onExpAdd(prole:BaseRole) : void
      {
         var i:int = 0;
         var att:RoleAttributeData = null;
         var addexp2:int = 0;
         var len:int = int(DataCore.troop.getAttrudetes().length);
         var addexp:int = prole.exp / len;
         for(i = 0; i < len; )
         {
            att = DataCore.troop.getAttrudetes()[i];
            addexp2 = addexp / att.lv;
            att.exp += addexp2;
            state.pushLog(att.roleName + "得到" + addexp2 + "经验值");
            i++;
         }
      }
      
      public function remove(pObject:Object) : void
      {
         if(pObject is Spoils)
         {
            _spolis.removeAt(_spolis.indexOf(pObject as Spoils));
         }
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         runModel && runModel.onAddChild(child);
         if(child is DisplayObjectContainer)
         {
            (child as DisplayObjectContainer).world = this;
         }
         if(child is Actor)
         {
            map.addActor(child as Actor);
         }
         else if(child is BaseRole)
         {
            this.addRole(child as BaseRole);
         }
         else if(child is TextureUIText)
         {
            _tipsLayer.addChild(child);
         }
         else
         {
            if(!(child is EffectDisplay))
            {
               if(child is Spoils)
               {
                  child.name = targetName + "_" + _spolispid;
                  _spolispid++;
                  _spolis.push(child);
               }
               return super.addChild(child);
            }
            map.addEffect(child as EffectDisplay);
         }
         return child;
      }
      
      public function getRoleFormName(target:String) : BaseRole
      {
         for(var i in _roles)
         {
            if(_roles[i].targetName == target || _roles[i].name == target)
            {
               return _roles[i];
            }
         }
         return null;
      }
      
      public function getActorFormName(pname:String) : Actor
      {
         var npcs:Vector.<Actor> = map.getNpcs();
         for(var i in map.getNpcs())
         {
            if(npcs[i].getName() == pname)
            {
               return npcs[i];
            }
         }
         return null;
      }
      
      public function getEventFormName(pname:String) : EventDisplay
      {
         for(var e in map.eventDisplays)
         {
            if(map.eventDisplays[e].getName() == pname)
            {
               return map.eventDisplays[e];
            }
         }
         return null;
      }
      
      public function getRoleFormPid(pid:int) : BaseRole
      {
         for(var i in _roles)
         {
            if(_roles[i].pid == pid)
            {
               return _roles[i];
            }
         }
         return null;
      }
      
      public function getEffectFormPid(pid:int) : EffectDisplay
      {
         var i:int = 0;
         var effect:EffectDisplay = null;
         var num:int = map.roleLayer.numChildren;
         for(i = 0; i < num; )
         {
            effect = map.roleLayer.getChildAt(i) as EffectDisplay;
            if(effect && effect.pid == pid)
            {
               return effect;
            }
            i++;
         }
         return null;
      }
      
      public function getEffectFormName(pname:String, findRole:BaseRole = null) : EffectDisplay
      {
         var i:int = 0;
         var effect:EffectDisplay = null;
         var num:int = map.roleLayer.numChildren;
         for(i = 0; i < num; )
         {
            effect = map.roleLayer.getChildAt(i) as EffectDisplay;
            if(effect && (effect.getName() == pname || effect.name == pname))
            {
               if(!findRole || effect.role == findRole)
               {
                  return effect;
               }
            }
            i++;
         }
         return null;
      }
      
      public function getEffects() : Vector.<EffectDisplay>
      {
         var i:int = 0;
         var effect:EffectDisplay = null;
         var effes:Vector.<EffectDisplay> = new Vector.<EffectDisplay>();
         var num:int = map.roleLayer.numChildren;
         for(i = 0; i < num; )
         {
            effect = map.roleLayer.getChildAt(i) as EffectDisplay;
            if(effect)
            {
               effes.push(effect);
            }
            i++;
         }
         return effes;
      }
      
      public function filterEffectFormPid(pids:Array) : void
      {
         var i:int = 0;
         var effect:EffectDisplay = null;
         var num:int = map.roleLayer.numChildren;
         for(i = num - 1; i >= 0; )
         {
            effect = map.roleLayer.getChildAt(i) as EffectDisplay;
            if(effect && pids.indexOf(effect.pid) == -1)
            {
               effect.discarded();
            }
            i--;
         }
      }
      
      override public function discarded() : void
      {
         if(isDiscarded)
         {
            return;
         }
         isDiscarded = true;
         trace("world discarded");
      }
      
      override public function dispose() : void
      {
         var r:int = 0;
         var i:int = 0;
         trace("world dispose");
         if(inFrame)
         {
            throw new ZYError("不要在世界的onFrame中进行释放（dispose）世界");
         }
         RoleFrameGroupCache.cache.clearAll();
         if(_state)
         {
            if(_state.parent)
            {
               _state.removeFromParent();
            }
            _state = null;
         }
         removeEventListeners();
         clearKeyLient();
         if(_gameBG)
         {
            _gameBG.removeFromParent();
         }
         DataCore.assetsSwf.otherAssets.removeXml(_mapTarget);
         if(_debug && _debug.display.parent)
         {
            _debug.display.parent.removeChild(_debug.display);
         }
         if(_hit.parent)
         {
            _hit.parent.removeChild(_hit);
         }
         if(_keyRole)
         {
            _keyRole.splice(0,_keyRole.length);
            _keyRole = null;
         }
         if(_roles)
         {
            for(r = _roles.length - 1; r >= 0; )
            {
               _roles[r].discarded();
               r--;
            }
            _roles.splice(0,_roles.length);
            _role = null;
         }
         i = 0;
         while(i < _spolis.length)
         {
            SpoilsRefresh.singleton.put(_spolis[i].name,_spolis[i].data);
            i++;
         }
         if(_nape)
         {
            _nape.bodies.clear();
            _nape.clear();
            _nape = null;
         }
         if(_refs)
         {
            _refs.splice(0,_refs.length);
            _refs = null;
         }
         if(_starlingMap)
         {
            _starlingMap.discarded();
            _starlingMap = null;
         }
         if(backgroundContent)
         {
            _gameBG.removeFromParent(true);
         }
         _gameBG = null;
         if(state)
         {
            state.removeFromParent(true);
         }
         _state = null;
         super.dispose();
      }
      
      override public function clearKey() : void
      {
      }
      
      public function clearKeyLient() : void
      {
         super.clearKey();
      }
      
      public function get drawRect() : Rectangle
      {
         return _drawRect;
      }
      
      override public function render(painter:Painter) : void
      {
         var point:Point = Pool.getPoint();
         Pool.putPoint(point);
         this.globalToLocal(point,_drawPos);
         _drawRect.x = _drawPos.x;
         _drawRect.y = _drawPos.y;
         super.render(painter);
      }
      
      public function get worldType() : String
      {
         return this._worldType;
      }
      
      public function set mapVibrationTime(i:int) : void
      {
         if(i > this._mapVibrationTime)
         {
            this._mapVibrationTime = i;
         }
      }
      
      public function vibration(pan:Number) : void
      {
         if(pan < 0)
         {
            pan *= -1;
         }
         pan = 1 - pan;
         if(pan < 0)
         {
            return;
         }
         this._mapVibrationTime = 16 * pan;
      }
      
      public function get centerX() : int
      {
         return -this.x / scaleX + stage.stageWidth / 2;
      }
      
      public function get centerY() : int
      {
         return -this.y / scaleX + stage.stageHeight / 2;
      }
      
      public function pushMessage(data:Object) : void
      {
         if(runModel != null)
         {
            runModel.message(this,data);
         }
      }
      
      public function get roles() : Vector.<BaseRole>
      {
         return _roles;
      }
   }
}

