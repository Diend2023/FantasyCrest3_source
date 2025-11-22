package game.world
{
   import flash.filesystem.File;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import game.data.FightData;
   import game.data.OverTag;
   import game.data.WorldRecordData;
   import game.display.SkillPainting;
   import game.role.GameRole;
   import game.view.GameOverView;
   import game.view.GamePauseView;
   import game.view.GameStateView;
   import nape.phys.Body;
   import nape.phys.BodyType;
   import nape.shape.Polygon;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   import zygame.core.SceneCore;
   import zygame.data.RoleFrameGroup;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   import zygame.display.EventDisplay;
   import zygame.display.World;
   import zygame.display.WorldState;
   import zygame.server.Service;
   import zygame.ui.Fade;
   import zygame.utils.GIFUtils;
   import zygame.utils.RTools;
   
   public class BaseGameWorld extends World
   {
      
      public static var DATA:Object;
      
      private var _centerSprite:Quad;
      
      private var _gameOver:Boolean = false;
      
      private var _textures:TextureAtlas;
      
      private var _fightData:FightData;
      
      private var _roleAttr:Dictionary;
      
      private var _1p:BaseRole;
      
      private var _2p:BaseRole;
      
      public var pauseView:GamePauseView;
      
      private var _frameBody:Body;
      
      public var isDoublePlayer:Boolean = false;
      
      public var frameCount:int = 0;
      
      public var worldData:WorldRecordData;
      
      private var _gif:GIFUtils;
      
      private var _skillPainting:Array = [];
      
      public function BaseGameWorld(mapName:String, toName:String)
      {
         super(mapName,toName);
         auto = false;
         _textures = DataCore.getTextureAtlas("hpmp");
         _fightData = new FightData(this);
         _roleAttr = new Dictionary();
         DATA = {};
      }
      
      public function get centerSprite() : Quad
      {
         return _centerSprite;
      }
      
      override public function onInit() : void
      {
         super.onInit();
         _centerSprite = new Quad(40,40,16711680);
         this.addChild(_centerSprite);
         _centerSprite.alignPivot();
         _centerSprite.visible = false;
         ready();
         createFrameBody();
         var tmxXML:XML = DataCore.getXml(targetName);
         if(String(tmxXML.@texture) == "<null>")
         {
            this.map.getMapLayerFormName("hit_layer").visible = false;
         }
      }
      
      public function createFrameBody() : void
      {
         _frameBody = new Body(BodyType.KINEMATIC);
         var left:Polygon = new Polygon(Polygon.rect(-900,-map.getHeight() / 2,100,map.getHeight() * 2));
         var rigth:Polygon = new Polygon(Polygon.rect(900,-map.getHeight() / 2,100,map.getHeight() * 2));
         _frameBody.shapes.add(left);
         _frameBody.shapes.add(rigth);
         _frameBody.space = this.nape;
      }
      
      public function ready() : void
      {
         var show:Tween;
         var out:Tween;
         var show2:Tween;
         var out2:Tween;
         _gameOver = false;
         auto = false;
         var image:Image = new Image(_textures.getTexture("READY.png"));
         this.parent.addChild(image);
         image.alignPivot();
         image.x = stage.stageWidth / 2;
         image.y = stage.stageHeight / 2;
         image.alpha = 0;
         image.scale = 0;
         show = new Tween(image,0.5,"easeOut");
         show.animate("alpha",1);
         show.animate("scale",1);
         Starling.juggler.add(show);
         show.delay = 1;
         out = new Tween(image,0.5,"easeIn");
         out.animate("alpha",0);
         out.animate("scale",1.5);
         out.delay = 0.5;
         show.nextTween = out;
         show2 = new Tween(image,0.5,"easeOut");
         show2.animate("alpha",1);
         show2.animate("scale",1);
         out.onComplete = function():void
         {
            image.texture = _textures.getTexture("FIGHT.png");
            image.alpha = 0;
            image.scale = 0;
            Starling.juggler.delayCall(function():void
            {
               GameCore.soundCore.playEffect("readygo2");
            },1);
         };
         out.nextTween = show2;
         out2 = new Tween(image,0.5,"easeIn");
         out2.animate("alpha",0);
         out2.animate("scale",1.5);
         out2.delay = 0.5;
         out2.onComplete = function():void
         {
            auto = true;
            image.removeFromParent();
         };
         show2.nextTween = out2;
         Starling.juggler.delayCall(function():void
         {
            GameCore.soundCore.playEffect("readygo");
         },1);
      }
      
      override protected function onRoleCreate(index:int, target:String) : void
      {
         super.onRoleCreate(index,target);
         onTroopChange(index,target);
      }
      
      public function onTroopChange(index:int, target:String) : void
      {
         var prole:BaseRole = this.getRoleFormName(target);
      }
      
      override public function addStateContent(pstate:WorldState) : void
      {
         var role2:GameRole = null;
         if(pstate)
         {
            super.addStateContent(pstate);
         }
         this.initRole();
         this.founcDisplay = _centerSprite;
         for(var i in this.getRoleList())
         {
            role2 = getRoleList()[i];
            if(_roleAttr[role2.targetName + role2.troopid])
            {
               _roleAttr[role2.targetName + role2.troopid].x = role2.x;
               _roleAttr[role2.targetName + role2.troopid].y = role2.y;
               _roleAttr[role2.targetName + role2.troopid].scaleX = role2.scaleX > 0 ? 1 : -1;
               _roleAttr[role2.targetName + role2.troopid].action = "待机";
               role2.setData(_roleAttr[role2.targetName + role2.troopid]);
               delete _roleAttr[role2.targetName + role2.troopid];
            }
            role2.fightid = int(i);
         }
      }
      
      public function initRole() : void
      {
         (state as GameStateView).bind(0,this.getRoleList()[0]);
         (state as GameStateView).bind(1,this.getRoleList()[1]);
         this.getRoleList()[0].troopid = 0;
         this.getRoleList()[1].troopid = 1;
         this.getRoleList()[1].ai = false;
         bindXY(this.getRoleList()[0],"1p");
         bindXY(this.getRoleList()[1],"2p");
         _1p = this.getRoleList()[0];
         _2p = this.getRoleList()[1];
         role = _1p;
         hitNumber.role = role;
         this.getRoleList()[1].scaleX = -1;
         mathCenterPos();
         founcDisplay = _centerSprite;
         moveMap(1);
      }
      
      override public function set role(r:BaseRole) : void
      {
         super.role = r;
         founcDisplay = _centerSprite;
      }
      
      public function bindXY(role:BaseRole, tag:String) : void
      {
         var rect:Rectangle = null;
         var event:EventDisplay = this.getEventFormName(tag);
         if(event)
         {
            rect = event.bounds;
            role.setX(50 + rect.x);
            role.setY(rect.y + 100);
         }
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         this.mathCenterPos();
         frameCount++;
         if(!_gameOver)
         {
            overCheak();
         }
         for(var i in this.getRoleList())
         {
            _fightData.update(this.getRoleList()[i] as GameRole);
         }
         if(worldData)
         {
            worldData.pushWorld(this);
         }
      }
      
      public function record() : void
      {
         if(!worldData)
         {
            worldData = new WorldRecordData();
            worldData.initWorld(this);
         }
      }
      
      public function cheakGameOver() : int
      {
         var arr:Array = [];
         for(var i in getRoleList())
         {
            if(arr.indexOf(getRoleList()[i].troopid) == -1)
            {
               arr.push(getRoleList()[i].troopid);
            }
         }
         return arr.length <= 1 ? arr[0] : -1;
      }
      
      public function overCheak() : void
      {
         var isOver:Boolean = false;
         var id:int = cheakGameOver();
         if(id != -1)
         {
            trace("战斗结束，胜利队伍：",id);
            gameOver();
            switch(id)
            {
               case 0:
                  (this.state as GameStateView).pushWin(0);
                  break;
               case 1:
                  (this.state as GameStateView).pushWin(1);
            }
         }
      }
      
      public function reset() : void
      {
         var show:Tween;
         var out:Tween;
         var bg:Quad = new Quad(stage.stageWidth,stage.stageHeight,0);
         this.parent.addChild(bg);
         bg.alpha = 0;
         show = new Tween(bg,0.5);
         show.animate("alpha",1);
         Starling.juggler.add(show);
         show.onComplete = function():void
         {
            var i2:int = 0;
            var i:int = 0;
            var role2:BaseRole = null;
            var effs:Vector.<EffectDisplay> = getEffects();
            for(i2 = effs.length - 1; i2 >= 0; )
            {
               effs[i2].discarded();
               i2--;
            }
            for(i = getRoleList().length - 1; i >= 0; )
            {
               role2 = getRoleList()[i];
               if(role2.attribute.hp > 0)
               {
                  _roleAttr[role2.targetName + role2.troopid] = (role2 as GameRole).copyData();
                  _roleAttr[role2.targetName + role2.troopid].key = [];
               }
               role2.removeFromParent(true);
               i--;
            }
            createRoles();
            addStateContent(null);
         };
         out = new Tween(bg,0.5);
         show.nextTween = out;
         out.animate("alpha",0);
         out.onComplete = function():void
         {
            bg.removeFromParent();
            ready();
         };
         role = null;
      }
      
      public function gameOver() : void
      {
         _gameOver = true;
         var vs:MovieClip = new MovieClip(DataCore.getTextureAtlas("KO").getTextures());
         this.parent.addChild(vs);
         vs.alignPivot();
         vs.x = stage.stageWidth / 2;
         vs.y = stage.stageHeight / 2;
         vs.scale *= 2;
         Starling.juggler.add(vs);
         vs.addEventListener("complete",function(e:Event):void
         {
            vs.removeFromParent();
            Starling.juggler.remove(vs);
            end();
         });
         GameCore.soundCore.playEffect("ko");
      }
      
      public function end() : void
      {
         auto = false;
         for(var i in getRoleList())
         {
            getRoleList()[i].move("wait");
            getRoleList()[i]["win"]();
            trace("输出伤害",(getRoleList()[i] as GameRole).hurt,"每秒伤害",(getRoleList()[i] as GameRole).hurt / (frameCount / 60),"承受伤害：",(getRoleList()[i] as GameRole).beHurt);
         }
         if((state as GameStateView).cheakGameWinCount() < 2)
         {
            reset();
         }
         else
         {
            trace("整局战斗结束");
            over();
         }
      }
      
      public function get fightData() : FightData
      {
         return _fightData;
      }
      
      public function over() : void
      {
         var gameOver:GameOverView = new GameOverView(fightData.data1,fightData.data2,OverTag.NONE);
         SceneCore.pushView(gameOver,true,Fade);
      }
      
      public function mathCenterPos() : void
      {
         var r:BaseRole = null;
         var xz:int = 0;
         var yz:int = 0;
         var minx:* = 9999;
         var miny:* = 9999;
         var maxx:* = 0;
         var maxy:* = 0;
         for(var i in this.getRoleList())
         {
            r = this.getRoleList()[i];
            xz = r.x;
            yz = r.y;
            if(xz < minx)
            {
               minx = xz;
            }
            if(xz > maxx)
            {
               maxx = xz;
            }
            if(yz < miny)
            {
               miny = yz;
            }
            if(yz > maxy)
            {
               maxy = yz;
            }
         }
         _centerSprite.x = (minx + maxx) / 2;
         _centerSprite.y = (miny + maxy) / 2;
         worldScale = 600 / Math.abs(minx - maxx);
         if(worldScale > 1)
         {
            worldScale = 1;
         }
         else if(worldScale < 0.5)
         {
            worldScale = 0.5;
         }
         if(_frameBody)
         {
            _frameBody.position.x = _centerSprite.x;
            _frameBody.position.y = _centerSprite.y;
         }
      }
      
      override public function onDown(key:int) : void
      {
         if(!auto || Service.client)
         {
            super.onDown(key);
            return;
         }
         if(!auto)
         {
            return;
         }
         switch(key)
         {
            case 66:
               if(!_gif || _gif.isDiscarded)
               {
                  _gif = new GIFUtils(12);
                  state.addChild(_gif);
                  _gif.y = 100;
                  _gif.start();
               }
               break;
            case 78:
               if(_gif)
               {
                  _gif.close();
                  _gif.save();
                  _gif = null;
               }
               break;
            case 13:
               if(this.isPause)
               {
                  SceneCore.removeView(pauseView);
                  pauseView.clearKey();
                  this.resume();
                  break;
               }
               pauseView = new GamePauseView();
               SceneCore.pushView(pauseView);
               this.pause();
               break;
            case 65:
            case 68:
            case 87:
            case 83:
            case 74:
            case 75:
            case 85:
            case 73:
            case 79:
            case 80:
            case 76:
            case 72:
               if(_1p && _1p.parent)
               {
                  _1p.onDown(key);
               }
               break;
            case 37:
            case 39:
            case 38:
            case 40:
            case 49:
            case 97:
            case 50:
            case 98:
            case 51:
            case 99:
            case 52:
            case 100:
            case 53:
            case 101:
            case 54:
            case 102:
            case 55:
            case 103:
            case 57:
            case 105:
            case 48:
            case 96:
               if(isDoublePlayer)
               {
                  if(_2p && _2p.parent)
                  {
                     _2p.onDown(conversionKey(key));
                  }
               }
         }
      }
      
      override public function onUp(key:int) : void
      {
         if(!auto || Service.client)
         {
            super.onUp(key);
            return;
         }
         if(!auto)
         {
            return;
         }
         switch(key)
         {
            case 65:
            case 68:
            case 87:
            case 83:
            case 74:
            case 75:
            case 85:
            case 73:
            case 79:
            case 80:
            case 76:
            case 72:
               _1p.onUp(key);
               break;
            case 37:
            case 39:
            case 38:
            case 40:
            case 49:
            case 97:
            case 50:
            case 98:
            case 51:
            case 99:
            case 52:
            case 100:
            case 53:
            case 101:
            case 54:
            case 102:
            case 55:
            case 103:
            case 57:
            case 105:
            case 48:
            case 96:
               if(isDoublePlayer)
               {
                  _2p.onUp(conversionKey(key));
               }
         }
      }
      
      public function conversionKey(key:int) : int
      {
         switch(key)
         {
            case 37:
               return 65;
            case 39:
               return 68;
            case 38:
               return 87;
            case 40:
               return 83;
            case 49:
            case 97:
               break;
            case 50:
            case 98:
               return 75;
            case 51:
            case 99:
               return 76;
            case 52:
            case 100:
               return 85;
            case 53:
            case 101:
               return 73;
            case 54:
            case 102:
               return 79;
            case 57:
            case 105:
               return 80;
            case 48:
            case 96:
               return 72;
            default:
               return 0;
         }
         return 74;
      }
      
      public function set p1(prole:BaseRole) : void
      {
         _1p = prole;
      }
      
      public function get p1() : BaseRole
      {
         return _1p;
      }
      
      public function set p2(prole:BaseRole) : void
      {
         _2p = prole;
      }
      
      public function get p2() : BaseRole
      {
         return _2p;
      }
      
      public function showSkillPainting(target:String, skill:String, troop:int) : void
      {
         var i:int = 0;
         var skillp:SkillPainting = null;
         for(i = _skillPainting.length - 1; i >= 0; )
         {
            if(_skillPainting[i].parent == null)
            {
               _skillPainting.splice(i,1);
            }
            i--;
         }
         if(_skillPainting.length < 2)
         {
            skillp = new SkillPainting(target,skill,troop);
            SceneCore.pushView(skillp);
            _skillPainting.push(skillp);
            if(_skillPainting.length == 2)
            {
               Starling.juggler.tween(_skillPainting[0],0.25,{"y":-10});
               Starling.juggler.tween(_skillPainting[1],0.25,{"y":stage.stageHeight - 240});
            }
         }
      }
      
      override public function discarded() : void
      {
         super.discarded();
      }
      
      public function startInitCD(cdtime:Number = 7) : void
      {
         var prole:BaseRole = null;
         var targetSkill:String = null;
         var targetSkill2:String = null;
         for(var i in this.roles)
         {
            prole = this.roles[i];
            for(var cd1 in prole.roleXmlData.landActions)
            {
               targetSkill = (prole.roleXmlData.landActions[cd1] as RoleFrameGroup).name;
               if(targetSkill != "瞬步" && prole.attribute.getCD(targetSkill) < cdtime * 60)
               {
                  prole.attribute.updateCD(targetSkill,cdtime);
               }
            }
            for(var cd2 in prole.roleXmlData.airActions)
            {
               targetSkill2 = prole.roleXmlData.airActions[cd2];
               if(targetSkill != "瞬步" && prole.attribute.getCD(targetSkill2) < cdtime * 60)
               {
                  prole.attribute.updateCD(targetSkill2,cdtime);
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         var bytes:ByteArray = null;
         if(worldData)
         {
            worldData.stop();
            bytes = worldData.bytes;
            bytes.compress();
            RTools.saveByteArray(File.applicationStorageDirectory.resolvePath("video/" + new Date().time + ".zyvideo"),bytes);
         }
         if(state)
         {
            state.removeFromParent(true);
         }
         this._1p = null;
         this._2p = null;
         this._fightData = null;
         this._frameBody = null;
         this._gif = null;
         this._roleAttr = null;
         this._skillPainting = null;
         this._textures = null;
         this._centerSprite = null;
         DataCore.clearMapRoleData();
         super.dispose();
      }
   }
}

