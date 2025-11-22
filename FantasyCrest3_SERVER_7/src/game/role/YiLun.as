package game.role
{
   import feathers.data.ListCollection;
   import game.skill.TrackBall;
   import starling.display.Image;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   import zygame.display.World;
   import zygame.style.ColorStyle;
   
   public class YiLun extends GameRole
   {
      
      public static const BT:String = "BT";
      
      public static const HF:String = "HF";
      
      public var nuqi:cint = new cint();
      
      public var nuqiMode:String = "";
      
      private var _image2:Image;
      
      private var zrole:GameRole;
      
      public function YiLun(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"liliang.png",
            "msg":"0"
         }]);
      }
      
      override public function onInit() : void
      {
         super.onInit();
         _image2 = new Image(this.display["texture"]);
         this.addChild(_image2);
         _image2.blendMode = "add";
         _image2.visible = false;
      }
      
      override public function onShapeChange() : void
      {
         super.onShapeChange();
         if(_image2)
         {
            _image2.visible = nuqiMode != "";
            _image2.texture = this.display["texture"];
            _image2.x = this.display.x;
            _image2.y = this.display.y;
            _image2.width = this.display.width;
            _image2.height = this.display.height;
         }
      }
      
      override public function onFrame() : void
      {
         var px:int = 0;
         var zx:int = 0;
         var zy:int = 0;
         var npc:BaseRole = null;
         var isFight:Boolean = false;
         isFight = false;
         super.onFrame();
         if(inFrame("问答无用妖怪铁拳",1))
         {
            zrole = null;
         }
         var effect:EffectDisplay = this.world.getEffectFormName("zhuaqu",this);
         if(effect)
         {
            px = effect.bounds.x;
            if(effect.scaleX < 0)
            {
               px += effect.bounds.width;
            }
            zx = px + (-int(effect.skillData.currentXml.@frameX) + int(effect.skillData.currentXml.@width) / 2) * effect.scaleX;
            zy = effect.bounds.y - int(effect.skillData.currentXml.@frameY) + int(effect.skillData.currentXml.@height) / 2;
            if(!zrole)
            {
               for(var i in world.getRoleList())
               {
                  npc = world.getRoleList()[i];
                  if(npc.troopid != this.troopid && Math.abs(zx - npc.posx) < 100 && Math.abs(zy - npc.posy) < 100)
                  {
                     zrole = npc as GameRole;
                     break;
                  }
               }
            }
            if(zrole && currentFrame <= 14)
            {
               zrole.posx = zx;
               zrole.posy = zy;
               zrole.breakAction();
               zrole.straight = 30;
            }
         }
         if(inFrame("天变红云焚身",4))
         {
            (this._image2 as Image).style = new ColorStyle(16711680,0.8);
            nuqiMode = "BT";
         }
         if(inFrame("青风拂生道",4))
         {
            (this._image2 as Image).style = new ColorStyle(65535,0.8);
            nuqiMode = "HF";
         }
         if(inFrame("空之云归",4))
         {
            (this._image2 as Image).style = null;
            nuqiMode = "";
         }
         if(inFrame("金光飞旋轮",3))
         {
            if(world.getEffectFormName("lun",this))
            {
               isFight = false;
               for(i in world.getRoleList())
               {
                  if(world.getRoleList()[i].troopid != this.troopid)
                  {
                     (world.getEffectFormName("lun",this) as TrackBall).trackRole(world.getRoleList()[i]);
                     isFight = true;
                     break;
                  }
               }
               if(!isFight)
               {
                  (world.getEffectFormName("lun",this) as TrackBall).continuousTime = 0;
               }
            }
            if(world.getEffectFormName("lun2",this))
            {
               isFight = false;
               for(i in world.getRoleList())
               {
                  if(world.getRoleList()[i].troopid != this.troopid)
                  {
                     (world.getEffectFormName("lun2",this) as TrackBall).trackRole(world.getRoleList()[i]);
                     isFight = true;
                     break;
                  }
               }
               if(!isFight)
               {
                  (world.getEffectFormName("lun2",this) as TrackBall).continuousTime = 0;
               }
            }
         }
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         super.runLockAction(str,canBreak);
         if(nuqiMode == "BT")
         {
            this.goldenTime = 0.5;
         }
      }
      
      override public function onSUpdate() : void
      {
         super.onSUpdate();
         if(nuqiMode == "HF")
         {
            this.restoreHP(0.01);
         }
         if(nuqi.value > 0)
         {
            nuqi.value -= nuqiMode != "" ? 10 : 2;
            this.listData.getItemAt(0).msg = nuqi.value;
         }
         if(nuqi.value < 0)
         {
            nuqi.value = 0;
         }
         if(nuqi.value == 0)
         {
            if((this._image2 as Image).style != null)
            {
               (this._image2 as Image).style = null;
            }
            nuqiMode = "";
         }
         this.listData.updateAll();
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         if(beData.armorScale == 0 && beData.magicScale == 0)
         {
            beData.armorScale = 1;
         }
         if(actionName == "积乱*见越入道云")
         {
            beData.armorScale += 0.0025 * nuqi.value;
         }
         else
         {
            beData.armorScale += 0.005 * nuqi.value;
         }
         super.onHitEnemy(beData,enemy);
         if(actionName == "问答无用妖怪铁拳")
         {
            enemy.jumpMath = 0;
         }
         if(nuqiMode == "")
         {
            nuqi.value += 5;
            if(nuqi.value > 100)
            {
               nuqi.value = 100;
            }
            this.listData.getItemAt(0).msg = nuqi.value;
            this.listData.updateAll();
         }
      }
      
      override public function onBeHit(beData:BeHitData) : void
      {
         super.onBeHit(beData);
         if(nuqiMode == "")
         {
            nuqi.value += 5;
            if(nuqi.value > 100)
            {
               nuqi.value = 100;
            }
         }
         this.listData.getItemAt(0).msg = nuqi.value;
         this.listData.updateAll();
      }
   }
}

