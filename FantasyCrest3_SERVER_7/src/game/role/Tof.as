package game.role
{
   import feathers.data.ListCollection;
   import fight.effect.ColorQuad;
   import flash.geom.Point;
   import game.server.AccessRun3Model;
   import game.server.HostRun2Model;
   import game.view.GameStateView;
   import game.world.BaseGameWorld;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Image;
   import zygame.core.DataCore;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class Tof extends GameRole
   {
      
      private var cd:cint = new cint(600);
      
      private var lock:Boolean = false;
      
      private var isInit:Boolean = false;
      
      public function Tof(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"mofa.png",
            "msg":"10"
         }]);
      }
      
      override public function onInit() : void
      {
         super.onInit();
         attribute.updateCD("和服杀",999);
         Starling.juggler.delayCall(initSO,1);
      }
      
      public function initSO() : void
      {
         var count:int = 0;
         if(!isInit)
         {
            if((this.world as BaseGameWorld).state as GameStateView)
            {
               count = ((this.world as BaseGameWorld).state as GameStateView).allWinCount;
               if(count == 1 && hpmpDisplay && hpmpDisplay.winNum == 0)
               {
                  attribute.updateCD("和服杀",0);
               }
               else
               {
                  attribute.updateCD("和服杀",999);
               }
            }
            else
            {
               attribute.updateCD("和服杀",999);
            }
            isInit = true;
         }
      }
      
      override public function onFrame() : void
      {
         if(isLockAction())
         {
            this.attribute.shooting = 200;
            this.cardFrame = 0;
            for(var i in this.world.getRoleList())
            {
               if(this.world.getRoleList()[i] != this)
               {
                  this.world.getRoleList()[i].cardFrame = 3;
               }
            }
         }
         else
         {
            this.attribute.shooting = 100;
         }
         if(cd.value > 0)
         {
            cd.value--;
            listData.getItemAt(0).msg = (cd.value / 60).toFixed(1);
         }
         else
         {
            listData.getItemAt(0).msg = "Auto";
         }
         listData.updateAll();
         if(this.isLock == false)
         {
            lock = false;
         }
         super.onFrame();
         if(inFrame("和服杀",2))
         {
            showSOImg();
         }
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         if(str == "瞬杀" || str == "瞬斩")
         {
            if(cd.value == 0)
            {
               lock = true;
               cd.value = 600;
               if(world.runModel is AccessRun3Model)
               {
                  return;
               }
               shiting();
            }
         }
         else if(str == "和服杀")
         {
            shiting();
         }
         super.runLockAction(str,canBreak);
      }
      
      public function shiting() : void
      {
         if(world.runModel is HostRun2Model)
         {
            (world.runModel as HostRun2Model).doFunc(this.name,"shiting");
         }
         new ColorQuad(16711935,0.5,0.7).create();
      }
      
      override public function isGod() : Boolean
      {
         if(actionName == "和服杀")
         {
            return true;
         }
         return super.isGod();
      }
      
      public function showSOImg() : void
      {
         this.cardFrame = 240;
         var img:Image = new Image(DataCore.getTexture("TOF_SKILL"));
         this.world.parent.addChild(img);
         new ColorQuad(16777215,1,1).create();
         var tw:Tween = new Tween(img,1);
         tw.fadeTo(0);
         tw.delay = 1;
         tw.onComplete = img.removeFromParent;
         Starling.juggler.add(tw);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         var hp:int = 0;
         var hp2:int = 0;
         if(actionName == "和服杀" && currentFrame > 35)
         {
            hp = enemy.attribute.hp;
            beData.armorScale = hp / (this.attribute.power / 2);
         }
         else if(actionName == "直死魔之眼—斩")
         {
            hp2 = enemy.attribute.hp;
            beData.armorScale = 0.8;
            beData.magicScale = 0;
            if(Math.random() > 0.7)
            {
               enemy.hurtNumber(hp2 * 0.05,beData,new Point(enemy.x,enemy.y));
            }
         }
         super.onHitEnemy(beData,enemy);
      }
      
      public function isLockAction() : Boolean
      {
         if(actionName == "瞬杀" || actionName == "瞬斩")
         {
            return lock;
         }
         return actionName == "和服杀";
      }
   }
}

