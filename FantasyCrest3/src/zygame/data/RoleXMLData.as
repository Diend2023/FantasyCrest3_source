package zygame.data
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import nape.geom.GeomPoly;
   import nape.geom.GeomPolyList;
   import nape.geom.Vec2;
   import nape.phys.Body;
   import nape.phys.BodyType;
   import nape.phys.Material;
   import nape.shape.Polygon;
   import starling.display.Image;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   import zygame.utils.NapeUtils;
   import zygame.utils.SoundUtils;
   
   public class RoleXMLData
   {
      
      public var targetName:String;
      
      private var _xml:XML;
      
      public var roleFrameGroupActions:RoleFrameGroupActions;
      
      private var _point:Point;
      
      private var _role:BaseRole;
      
      private var _textures:TextureAtlas;
      
      private var _hitBody:Body;
      
      public var fight:Boolean = false;
      
      public var hitData:BeHitData;
      
      public var live:int = 0;
      
      public var fightInterval:int = 0;
      
      public var targetXML:XML;
      
      public var bodyVec:Vector.<Vec2>;
      
      public var interval:int = 0;
      
      private var _rootHitEffect:String = "";
      
      public var beHitEffect:String = null;
      
      public var currentRoleFrame:RoleFrame;
      
      private var _effects:Vector.<EffectDisplay>;
      
      public var dieSoundName:String = "";
      
      public function RoleXMLData(role:BaseRole, xml:XML)
      {
         super();
         _role = role;
         _xml = xml;
         hitData = new BeHitData(role);
         _effects = new Vector.<EffectDisplay>();
         this.parsingAction(_role.targetName);
         if(targetXML)
         {
            _point = new Point(int(targetXML.@px),int(targetXML.@py));
            bodyVec = NapeUtils.parsingPoint(String(targetXML.children()[0].@hitPoint));
         }
         _rootHitEffect = String(_xml.@hitEffectName);
         if(_xml.@beHitEffect != undefined)
         {
            beHitEffect = _xml.@beHitEffect;
         }
         if(_xml.@dieSound != undefined)
         {
            dieSoundName = xml.@dieSound;
         }
      }
      
      public function parsingAction(target:String = null) : void
      {
         var child:XMLList = null;
         var targetList:XMLList = null;
         if(targetName == target)
         {
            return;
         }
         targetName = target;
         targetXML = DataCore.getXml(target);
         if(targetXML)
         {
            _point = new Point(int(targetXML.@px),int(targetXML.@py));
         }
         _textures = DataCore.getTextureAtlas(target);
         roleFrameGroupActions = RoleFrameGroupCache.cache.getRoleFrameGroup(target);
         if(!roleFrameGroupActions)
         {
            if(target)
            {
               targetList = _xml.child(target);
               if(targetList.length() > 0)
               {
                  child = targetList[0].action.children();
               }
               else
               {
                  _xml = DataCore.assetsRole.getXmlData(target);
                  child = _xml.action.children();
               }
            }
            else
            {
               child = _xml.action.children();
            }
            roleFrameGroupActions = new RoleFrameGroupActions(target,child);
            roleFrameGroupActions.parsingAction(_xml.@fps);
            RoleFrameGroupCache.cache.pushRoleFrameGroup(target,roleFrameGroupActions);
         }
      }
      
      public function getGroupAt(actionName:String) : RoleFrameGroup
      {
         if(roleFrameGroupActions.actions == null)
         {
            return null;
         }
         return roleFrameGroupActions.actions[actionName];
      }
      
      public function getFrameAt(actionName:String, frame:int) : RoleFrame
      {
         if(!hasAction(actionName) || getGroupAt(actionName).frames.length == 0 || getGroupAt(actionName).frames.length <= frame)
         {
            return null;
         }
         return getGroupAt(actionName).frames[frame];
      }
      
      public function updateActionTexture(actionName:String, frame:int, image:Image = null, texture:Texture = null) : void
      {
         var roleFrame:RoleFrame = null;
         var scaleMath:Number = NaN;
         var frameName:String = null;
         var rectFrame:Rectangle = null;
         var vpan:Number = NaN;
         if(roleFrameGroupActions.actions.hasOwnProperty(actionName))
         {
            roleFrame = this.getFrameAt(actionName,frame);
            if(roleFrame && roleFrame != currentRoleFrame)
            {
               currentRoleFrame = roleFrame;
               if(roleFrame.golden > 0)
               {
                  _role.golden = roleFrame.golden;
               }
               if(roleFrame.turn)
               {
                  _role.scaleX = _role.scaleX > 0 ? -1 : 1;
               }
               if(!image || !texture)
               {
                  parsingEffects(roleFrame.effects);
                  playSound(roleFrame,actionName,_role.posx,_role.posy);
                  if(roleFrame.hitPoint)
                  {
                     updateBody(roleFrame);
                  }
                  else if(_hitBody && live <= 0)
                  {
                     this._hitBody.space.bodies.remove(_hitBody);
                     this._hitBody = null;
                  }
                  else if(!fight && interval != 0)
                  {
                     fightInterval++;
                     if(fightInterval >= interval)
                     {
                        trace("攻击恢复");
                        fight = true;
                        fightInterval = 0;
                     }
                  }
                  live--;
                  return;
               }
               scaleMath = _role.scaleX;
               if(scaleMath < 0)
               {
                  scaleMath *= -1;
               }
               frameName = roleFrame.name;
               rectFrame = _textures.getFrame(frameName);
               if(!rectFrame)
               {
                  rectFrame = _textures.getRegion(frameName);
               }
               if(rectFrame)
               {
                  image.width = rectFrame.width * scaleMath;
                  image.height = rectFrame.height * scaleMath;
               }
               image.x = _point.x * scaleMath;
               image.y = _point.y * scaleMath;
               image.texture = _textures.getTexture(frameName);
               parsingEffects(roleFrame.effects);
               playSound(roleFrame,actionName,image.parent.x,image.parent.y);
               if(roleFrame.vibration)
               {
                  vpan = SoundUtils.mathPan(_role.x,_role.y,GameCore.currentWorld.centerX,GameCore.currentWorld.centerY,GameCore.currentWorld.stage.stageWidth);
                  _role.world.vibration(vpan);
               }
               if(roleFrame.mapVibrationTime > 0)
               {
                  _role.world.vibrationSize = roleFrame.mapVibrationSize;
                  _role.world.mapVibrationTime = roleFrame.mapVibrationTime;
               }
               if(roleFrame.hitPoint)
               {
                  updateBody(roleFrame);
               }
               else if(_hitBody && live <= 0)
               {
                  this._hitBody.space.bodies.remove(_hitBody);
                  this._hitBody = null;
               }
               else if(!fight && interval != 0)
               {
                  fightInterval++;
                  if(fightInterval >= interval)
                  {
                     trace("攻击恢复");
                     fight = true;
                     fightInterval = 0;
                  }
               }
               live--;
            }
         }
         this.updateEffects();
      }
      
      public function playSound(roleFrame:RoleFrame, actionName:String, px:int, py:int) : void
      {
         var soundName:String;
         var pan:Number;
         if(roleFrame.soundName != "" && roleFrame.soundName != null)
         {
            soundName = roleFrame.soundName;
            if(soundName.indexOf(".") != -1)
            {
               soundName = soundName.substr(0,soundName.indexOf("."));
            }
            if(soundName.indexOf("/") != -1)
            {
               soundName = soundName.substr(soundName.indexOf("/") + 1);
            }
            pan = SoundUtils.mathPan(px,py,GameCore.currentWorld.centerX,GameCore.currentWorld.centerY,GameCore.currentWorld.stage.stageWidth);
            GameCore.soundCore.playEffect(soundName,pan,function():Boolean
            {
               if(_role)
               {
                  return actionName != _role.actionName;
               }
               return false;
            });
         }
      }
      
      public function playDieSound() : void
      {
         var soundName:String = this.dieSoundName;
         if(soundName.indexOf(".") != -1)
         {
            soundName = soundName.substr(0,soundName.indexOf("."));
         }
         var pan:Number = SoundUtils.mathPan(_role.x,_role.y,GameCore.currentWorld.centerX,GameCore.currentWorld.centerY,GameCore.currentWorld.stage.stageWidth);
         GameCore.soundCore.playEffect(soundName,pan);
      }
      
      private function updateEffects(remove:Boolean = false) : void
      {
         var i:int = 0;
         var len:int = int(this._effects.length);
         for(i = len - 1; i >= 0; )
         {
            if(!this._effects[i].parent || remove)
            {
               this._effects.removeAt(i);
            }
            i--;
         }
      }
      
      public function onFrame() : void
      {
         if(_hitBody)
         {
            _hitBody.position.x = this._role.x;
            _hitBody.position.y = this._role.y;
         }
      }
      
      public function updateBody(frame:RoleFrame) : void
      {
         var polygon:GeomPoly;
         var pbody:Body;
         var polyShapeList:GeomPolyList;
         if(_hitBody)
         {
            this._hitBody.space.bodies.remove(_hitBody);
            this._hitBody = null;
         }
         if(frame.hitPoint.length < 3)
         {
            return;
         }
         fight = true;
         fightInterval = 0;
         live = frame.live;
         interval = frame.interval;
         polygon = new GeomPoly(frame.hitPoint);
         pbody = new Body(BodyType.DYNAMIC);
         polyShapeList = polygon.convexDecomposition();
         polyShapeList.foreach(function(shape:*):void
         {
            var polygon:Polygon = new Polygon(shape);
            polygon.material = new Material(0,0,2,1);
            pbody.shapes.push(polygon);
         });
         pbody.position.x = this._role.x;
         pbody.position.y = this._role.y;
         pbody.space = GameCore.currentWorld.nape;
         this._hitBody = pbody;
         this._hitBody.userData.ref = this._role;
         this._hitBody.userData.noHit = true;
         this._hitBody.userData.noFight = true;
         this._hitBody.userData.id = "roleXMLDataBody";
         _hitBody.gravMass = 0;
         this._hitBody.scaleShapes(this._role.currentScaleX,this._role.currentScaleY);
         hitData.moveX = frame.hitX * this._role.scaleX;
         hitData.moveY = frame.hitY;
         hitData.armorScale = frame.wScale;
         hitData.magicScale = frame.mScale;
         hitData.straight = frame.straight;
         hitData.hitVibrationSize = frame.hitVibrationSize;
         hitData.cardFrame = frame.cardFrame;
         if(frame.hitEffectName)
         {
            hitData.hitEffect = frame.hitEffectName;
         }
         if(hitData.straight == 0)
         {
            hitData.straight = 30;
         }
      }
      
      public function clearBody() : void
      {
         if(_hitBody)
         {
            this._hitBody.space.bodies.remove(_hitBody);
            this._hitBody = null;
         }
      }
      
      public function get hitBody() : Body
      {
         if(!fight)
         {
            return null;
         }
         return _hitBody;
      }
      
      public function get currentHitBody() : Body
      {
         return _hitBody;
      }
      
      public function hited() : void
      {
         fight = false;
      }
      
      public function getActionLength(actionName:String) : int
      {
         if(!roleFrameGroupActions.actions[actionName])
         {
            return 0;
         }
         return this.getGroupAt(actionName).frames.length;
      }
      
      public function hasAction(actionName:String) : Boolean
      {
         if(roleFrameGroupActions.actions == null)
         {
            return false;
         }
         return roleFrameGroupActions.actions[actionName] != null;
      }
      
      public function ifStopTag(actionName:String, frame:int) : Boolean
      {
         var frameRole:RoleFrame = this.getFrameAt(actionName,frame);
         if(!frameRole)
         {
            return false;
         }
         return frameRole.isStop;
      }
      
      public function getMoveSpeed(actionName:String, frame:int, fps:int) : Point
      {
         var numX:Number = NaN;
         var numY:Number = NaN;
         var roleFrame:RoleFrame = this.getFrameAt(actionName,frame);
         if(roleFrame)
         {
            numX = -roleFrame.nextGox;
            numY = -roleFrame.nextGoy;
            numX /= 60 / fps;
            numY /= 60 / fps;
            return new Point(numX,numY);
         }
         return null;
      }
      
      public function parsingEffects(arr:Array) : void
      {
         var ob:Object = null;
         var pscaleX:Number = NaN;
         var pscaleY:Number = NaN;
         var className:String = null;
         var pClass:Class = null;
         var skillEffect:EffectDisplay = null;
         if(_role && _role.world && _role.world.runModel && _role.world.runModel.onEffectPasing(arr))
         {
            return;
         }
         if(arr.length == 0)
         {
            return;
         }
         var scaleMath:Number = _role.scaleX;
         if(scaleMath < 0)
         {
            scaleMath *= -1;
         }
         for(var i in arr)
         {
            ob = arr[i];
            pscaleX = ob.scaleX * this._role.scaleX;
            pscaleY = ob.scaleY * scaleMath;
            if(DataCore.getXml(ob.name))
            {
               className = DataCore.getXml(ob.name)["class"];
               pClass = EffectDisplay;
               if(className)
               {
                  pClass = GameCore.currentCore.getClass(className);
               }
               if(ob.overrideClass && GameCore.currentCore.getClass(ob.overrideClass))
               {
                  pClass = GameCore.currentCore.getClass(ob.overrideClass);
               }
               skillEffect = new pClass(ob.name,ob,this._role,pscaleX,pscaleY);
               _role.world.addChild(skillEffect);
               skillEffect.name = ob.findName;
               if(ob.atbottom)
               {
                  skillEffect.parent.setChildIndex(skillEffect,0);
               }
               skillEffect.onFrame();
               _effects.push(skillEffect);
            }
         }
      }
      
      public function get hitEffectName() : String
      {
         if(_rootHitEffect == "")
         {
            _rootHitEffect = "fistHit";
         }
         return _rootHitEffect;
      }
      
      public function getFrameGroupFromKey(key:String) : RoleFrameGroup
      {
         if(this._role.isJump())
         {
            return roleFrameGroupActions.airActions[key];
         }
         return roleFrameGroupActions.landActions[key];
      }
      
      public function get landActions() : Dictionary
      {
         return roleFrameGroupActions.landActions;
      }
      
      public function get airActions() : Dictionary
      {
         return roleFrameGroupActions.airActions;
      }
      
      public function clear() : void
      {
         updateEffects(true);
         _xml = null;
         _point = null;
         _role = null;
         _textures = null;
         _effects = null;
         _hitBody = null;
         this.currentRoleFrame = null;
         this.bodyVec = null;
         this.hitData = null;
         this.targetXML = null;
      }
      
      public function get xml() : String
      {
         return _xml;
      }
   }
}

