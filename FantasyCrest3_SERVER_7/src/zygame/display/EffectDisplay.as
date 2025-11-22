package zygame.display
{
   import flash.geom.Rectangle;
   import lzm.starling.swf.FPSUtil;
   import nape.dynamics.InteractionFilter;
   import nape.geom.Vec2;
   import nape.phys.Body;
   import nape.phys.BodyList;
   import nape.phys.BodyType;
   import starling.core.Starling;
   import starling.display.BlendMode;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.textures.Texture;
   import starling.utils.deg2rad;
   import zygame.core.DataCore;
   import zygame.data.BeHitData;
   import zygame.data.SkillXMLData;
   import zygame.style.BlackStyle;
   import zygame.style.Color2Style;
   import zygame.style.ColorStyle;
   import zygame.style.WhiteStyle;
   
   public class EffectDisplay extends BodyDisplayObject
   {
      
      private var _texture:Texture;
      
      private var _image:Image;
      
      private var _skillXmlData:SkillXMLData;
      
      private var _frame:int = 0;
      
      private var _fps:FPSUtil;
      
      private var _attribute:Object = null;
      
      private var _canFight:Boolean = false;
      
      private var _interval:int = 0;
      
      private var _beHitData:BeHitData;
      
      private var _continuousTime:int = 0;
      
      public var cardFrame:int = 0;
      
      public var pid:int = 0;
      
      public var isHitEffect:Boolean;
      
      private var _currentXml:XML = null;
      
      public var role:BaseRole;
      
      public var live:int = 0;
      
      public var isABlow:Boolean = false;
      
      public var isLockAction:Boolean = false;
      
      private var _isLockActionName:String = null;
      
      private var _lockCardFrame:int = 0;
      
      private var _unhit:Boolean = false;
      
      private var _hitFights:Vector.<BaseRole>;
      
      public var blendModeString:String;
      
      public function EffectDisplay(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super();
         targetName = target;
         if(!data)
         {
            data = getBaseObject();
         }
         if(pRole)
         {
            this.x = pRole.x + data.x * pRole.currentScaleX;
            this.y = pRole.y + data.y * pRole.scaleY;
         }
         role = pRole;
         _texture = DataCore.getTexture(target);
         _image = new Image(_texture);
         this.addChild(_image);
         _hitFights = new Vector.<BaseRole>();
         if(data.canHit)
         {
            this.isCanHit = data.canHit;
         }
         if(data.through)
         {
            this.isThrough = data.through;
         }
         this.blendModeData = data;
         this.scaleX = pScaleX;
         if(pRole && pRole.isFlip)
         {
            this.scaleX *= -1;
         }
         this.scaleY = pScaleY;
         _fps = new FPSUtil(role ? role.fps : 24);
         _attribute = data;
         _lockCardFrame = int(data.cardFrame);
         isABlow = data.isABlow;
         isLockAction = data.isLockAction;
         if(data.isLockActionShow)
         {
            _isLockActionName = role.actionName;
         }
         if(pRole)
         {
            gox = _attribute.gox * role.contentScale;
            goy = _attribute.goy * role.contentScale;
         }
         _beHitData = new BeHitData(this);
         _beHitData.moveX = data.hitX * this.scaleX;
         if(data.scaleX < 0)
         {
            _beHitData.moveX *= -1;
         }
         if(pRole && pRole.isFlip)
         {
            _beHitData.moveX *= -1;
         }
         if(data.unhit)
         {
            _unhit = data.unhit;
         }
         _beHitData.moveY = data.hitY;
         _beHitData.straight = data.stiff;
         _beHitData.blow = data.blow;
         continuousTime = data.time;
         if(pRole && data.rotation)
         {
            this.rotation = deg2rad(data.rotation * (this.scaleX > 0 ? 1 : -1));
            if(data.scaleX < 0 || pRole.isFlip && (pScaleX < 0 ? -1 : 1) == (pRole.currentScaleX < 0 ? -1 : 1))
            {
               this.rotation *= -1;
            }
         }
         if(data.isLaunch)
         {
            this.launch();
         }
         if(data.fadeIn)
         {
            this.display.alpha = 0;
            Starling.juggler.tween(display,0.25,{"alpha":1});
         }
      }
      
      public static function getBaseObject() : Object
      {
         return {
            "scaleX":1,
            "scaleY":1,
            "fps":3,
            "fightTime":0,
            "gox":0,
            "goy":0,
            "rota":Math.random() * 360,
            "wFight":0,
            "mFight":0
         };
      }
      
      public function get objectData() : Object
      {
         return _attribute;
      }
      
      public function set blendModeData(data:Object) : void
      {
         var pcolor2:Color2Style = null;
         var pcolor:ColorStyle = null;
         if(blendModeString != data.blendMode)
         {
            blendModeString = data.blendMode;
            if(data.blendMode == "changeColor2")
            {
               pcolor2 = new Color2Style();
               pcolor2.addColor = int(data.addColor);
               if(data.intensityValue)
               {
                  pcolor2.intensity = int(data.intensityValue);
               }
               this._image.style = pcolor2;
            }
            else if(data.blendMode == "changeColor")
            {
               pcolor = new ColorStyle();
               pcolor.addColor = int(data.addColor);
               if(data.intensityValue)
               {
                  pcolor.intensity = int(data.intensityValue);
               }
               this._image.style = pcolor;
            }
            else if(data.blendMode)
            {
               // if(BlendMode.has(data.blendMode))
               if(BlendMode.get(data.blendMode)) // 修改错误的BlendMode.has方法，改为正确的get方法
               {
                  this.blendMode = data.blendMode;
               }
               else if(data.blendMode == "white")
               {
                  _image.style = new WhiteStyle();
               }
               else if(data.blendMode == "black")
               {
                  _image.style = new BlackStyle();
               }
               else
               {
                  this.blendMode = "screen";
               }
            }
            else
            {
               this.blendMode = "screen";
            }
            return;
         }
         if(data.blendMode == null)
         {
            this.blendMode = "screen";
         }
      }
      
      public function set hitX(i:int) : void
      {
         if(objectData)
         {
            objectData.hitX = i;
            _beHitData.moveX = i;
         }
      }
      
      public function set hitY(i:int) : void
      {
         if(objectData)
         {
            objectData.hitY = i;
            _beHitData.moveY = i;
         }
      }
      
      public function set gox(i:int) : void
      {
         if(_attribute)
         {
            _attribute.dqgox = i * (_fps.fps / 60);
         }
      }
      
      public function set gox2(i:int) : void
      {
         if(_attribute)
         {
            _attribute.dqgox = i;
         }
      }
      
      public function get gox() : int
      {
         if(!_attribute)
         {
            return 0;
         }
         return _attribute.dqgox;
      }
      
      public function set goy2(i:int) : void
      {
         if(_attribute)
         {
            _attribute.dqgoy = i;
         }
      }
      
      public function set goy(i:int) : void
      {
         if(_attribute)
         {
            _attribute.dqgoy = i * (_fps.fps / 60);
         }
      }
      
      public function get goy() : int
      {
         if(!_attribute)
         {
            return 0;
         }
         return _attribute.dqgoy;
      }
      
      public function get currentFrame() : int
      {
         return _frame;
      }
      
      public function set fps(i:int) : void
      {
         this._fps.fps = i;
      }
      
      public function get fps() : int
      {
         if(!this._fps)
         {
            return 0;
         }
         return this._fps.fps;
      }
      
      override public function onInit() : void
      {
         _skillXmlData = new SkillXMLData(targetName,this);
         this.onFrame();
         updateBody();
         _beHitData.hitEffect = _skillXmlData.hitEffect;
         this.lockBounds();
      }
      
      override public function onFrame() : void
      {
         if(!_skillXmlData)
         {
            return;
         }
         if(role && role.world && role.world.runModel && role.world.runModel.onEffectFrame(this))
         {
            return;
         }
         if(cardFrame > 0)
         {
            cardFrame--;
            return;
         }
         super.onFrame();
         if(this.body)
         {
            this.x = this.body.position.x;
            this.y = this.body.position.y;
         }
         this.updateActionTexture();
         this.onFight();
         if(_isLockActionName && (role && role.actionName != _isLockActionName || role && role.isInjured()))
         {
            live = 0;
            removeBody();
            if(this.alpha > 0)
            {
               this.alpha -= 0.5;
            }
            else
            {
               this.discarded();
            }
         }
      }
      
      public function updateActionTexture() : void
      {
         if(_skillXmlData)
         {
            _skillXmlData.updateActionTexture(_frame,_image);
         }
      }
      
      override public function onMove() : void
      {
         if(isLockAction)
         {
            if(role)
            {
               if(this.body)
               {
                  this.body.position.x = role.x + _attribute.x * (this.scaleX > 0 ? 1 : -1);
                  this.body.position.y = role.y + _attribute.y;
               }
               else
               {
                  this.x = role.x + _attribute.x * (this.scaleX > 0 ? 1 : -1);
                  this.y = role.y + _attribute.y;
               }
            }
         }
         else
         {
            xMove(_attribute.dqgox * (this.scaleX > 0 ? 1 : -1));
            yMove(_attribute.dqgoy);
         }
      }
      
      override public function set posx(i:int) : void
      {
         super.posx = i;
      }
      
      override public function set posy(i:int) : void
      {
         super.posy = i;
      }
      
      public function go(i:int) : void
      {
         _frame = i;
      }
      
      override public function draw(bool:Boolean = false) : void
      {
         if(_fps.update() || bool)
         {
            if(cardFrame > 0)
            {
               return;
            }
            if(!_canFight || _hitFights.length > 0)
            {
               if(_attribute.interval > 0)
               {
                  _interval++;
                  if(_interval >= _attribute.interval)
                  {
                     _interval = 0;
                     _canFight = true;
                     _hitFights.splice(0,_hitFights.length);
                  }
               }
            }
            if(_frame < _skillXmlData.length - 1)
            {
               _frame++;
               updateBody();
            }
            if(_continuousTime <= 0)
            {
               if(_frame >= _skillXmlData.length - 1)
               {
                  if(this.alpha <= 0)
                  {
                     live = 0;
                     removeBody();
                     this.discarded();
                  }
                  else
                  {
                     this.alpha -= 0.5;
                  }
               }
            }
            else
            {
               _continuousTime--;
               if(_skillXmlData.rootXML.@end != undefined && _skillXmlData.rootXML.@start != undefined)
               {
                  if(_frame >= int(_skillXmlData.rootXML.@end))
                  {
                     _frame = int(_skillXmlData.rootXML.@start);
                  }
               }
            }
         }
      }
      
      override public function discarded() : void
      {
         this.removeFromParent(true);
      }
      
      protected function onFight() : void
      {
         var bodiesUnderMouse:BodyList;
         if(_canFight && cardFrame <= 0)
         {
            if(!this.body)
            {
               return;
            }
            if(this.role.world)
            {
               bodiesUnderMouse = this.role.world.nape.bodiesInBody(body);
               bodiesUnderMouse.foreach(function(body2:Body):void
               {
                  var prole:BaseRole = null;
                  if((body2.userData.ref is BaseRole && body2 == body2.userData.ref.hitBody || body2.userData.ref is DamageActor) && body2.userData.ref != role)
                  {
                     prole = body2.userData.ref as BaseRole;
                     if(_hitFights.indexOf(prole) == -1)
                     {
                        _hitFights.push(prole);
                        _beHitData.hitRect = body.bounds.toRect().intersection(body2.bounds.toRect());
                        _beHitData.armorScale = Number(_attribute.wFight) / 100;
                        _beHitData.magicScale = Number(_attribute.mFight) / 100;
                        if(objectData.hitEffectName)
                        {
                           _beHitData.hitEffect = objectData.hitEffectName;
                        }
                        if(!prole.isGod() && prole.troopid != role.troopid)
                        {
                           role.hitDataBuff(_beHitData);
                           body2.userData.ref.onBeHit(_beHitData);
                           if(_beHitData.lastIsHit)
                           {
                              cardFrame = _beHitData.cardFrame;
                              role.cardFrame = cardFrame;
                              onHitRole(body2.userData.ref as BaseRole);
                           }
                        }
                     }
                  }
               });
               if(!_canFight && isABlow)
               {
                  this.discarded();
               }
            }
         }
      }
      
      public function onHitRole(role:BaseRole) : void
      {
      }
      
      public function get skillData() : SkillXMLData
      {
         return _skillXmlData;
      }
      
      public function updateBody() : void
      {
         var points:* = undefined;
         var arr:Array = null;
         var i:int = 0;
         var pointStr:Array = null;
         if(!_unhit && role && _skillXmlData.currentXml && _skillXmlData.currentXml != this._currentXml && _skillXmlData.currentXml.@hitPoint != "" && _skillXmlData.currentXml.@hitPoint != undefined)
         {
            points = new Vector.<Vec2>();
            arr = String(_skillXmlData.currentXml.@hitPoint).split(" ");
            live = int(_skillXmlData.currentXml.@hitEffect);
            _attribute.interval = int(_skillXmlData.currentXml.@hurtInterval);
            _canFight = true;
            _hitFights.splice(0,_hitFights.length);
            _currentXml = _skillXmlData.currentXml;
            for(i = 0; i < arr.length; )
            {
               pointStr = arr[i].split(",");
               points.push(new Vec2(int(pointStr[0]),int(pointStr[1])));
               i++;
            }
            createBody(points,BodyType.KINEMATIC);
            if(int(_skillXmlData.currentXml.@cardFrame) != -1)
            {
               _beHitData.cardFrame = _lockCardFrame > 0 ? _lockCardFrame : int(_skillXmlData.currentXml.@cardFrame);
            }
            _beHitData.hitVibrationSize = int(objectData.hitVibrationSize);
         }
         else if(body)
         {
            live--;
            if(live <= 0)
            {
               this.removeBody();
            }
         }
      }
      
      public function set s9rect(rect:Rectangle) : void
      {
         _image.scale9Grid = rect;
      }
      
      public function launch() : void
      {
         var cos:Number = Math.cos(this.rotation);
         var sin:Number = Math.sin(this.rotation);
         if(this.scaleX < 0)
         {
            cos *= -1;
            sin *= -1;
         }
         var moveV:Vec2 = new Vec2(cos,sin);
         var wint:int = ray(moveV) + 64;
         this.scaleX = wint / this.width * (this.scaleX > 0 ? 1 : -1);
         if(this.scaleX == 0)
         {
            this.scaleX = 0.1;
         }
         this.s9rect = new Rectangle(30,5,47,20);
      }
      
      public function set continuousTime(i:Number) : void
      {
         _continuousTime = i * (fps / 60);
      }
      
      public function get continuousTime() : Number
      {
         return _continuousTime / (fps / 60);
      }
      
      public function set unhit(b:Boolean) : void
      {
         _unhit = b;
      }
      
      public function get display() : DisplayObject
      {
         return _image;
      }
      
      public function get beHitData() : BeHitData
      {
         return _beHitData;
      }
      
      override public function onBodyFilter(filter:InteractionFilter) : void
      {
         filter.collisionGroup = 4;
         if(objectData.hitMap)
         {
            filter.collisionMask = -5;
         }
         else
         {
            filter.collisionMask = -7;
         }
      }
      
      override public function createBody(vertice:Vector.<Vec2>, type:BodyType = null) : void
      {
         super.createBody(vertice,BodyType.DYNAMIC);
      }
      
      override public function dispose() : void
      {
         role = null;
         if(_hitFights)
         {
            _hitFights.splice(0,_hitFights.length);
            _hitFights = null;
         }
         _canFight = false;
         this.removeBody();
         if(this._beHitData)
         {
            this._beHitData.discarded();
         }
         this._beHitData = null;
         this._currentXml = null;
         this._attribute = null;
         this._fps = null;
         this._image = null;
         this._skillXmlData.discarded();
         this._attribute = null;
         this._beHitData = null;
         this._currentXml = null;
         this._fps = null;
         this._hitFights = null;
         this._texture = null;
         super.dispose();
      }
   }
}

