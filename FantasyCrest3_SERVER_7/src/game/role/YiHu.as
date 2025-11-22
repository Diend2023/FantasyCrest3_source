package game.role
{
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class YiHu extends GameRole
   {
      
      private var isDie:Boolean = false;
      
      private var godCD:cint = new cint();
      
      private var maxPower:cint = new cint();
      
      public function YiHu(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         maxPower.value = roleAttr.power;
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(inFrame("卍解",8))
         {
            this.breakAction();
            roleXmlData.parsingAction("yihu");
            draw(true);
         }
         if(roleXmlData.targetName == "yihu")
         {
            this.attribute.speed = 8;
            this.attribute.power = maxPower.value * 0.85;
         }
         else
         {
            this.attribute.speed = 6;
            this.attribute.power = maxPower.value;
         }
         if(godCD.value > 0)
         {
            godCD.value--;
            if(godCD.value % 3 == 0)
            {
               createShadow(16711935);
            }
         }
      }
      
      override public function playSkill(target:String) : void
      {
         if(target == "包围网")
         {
            if(godCD.value <= 0)
            {
               return;
            }
         }
         super.playSkill(target);
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         if(str == "包围网")
         {
            godCD.value = 0;
            this.attribute.hp += this.attribute.hpmax * 0.1;
         }
         super.runLockAction(str,canBreak);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         var scaleNum:Number = NaN;
         var m:Number = NaN;
         if(actionName == "包围网")
         {
            scaleNum = 0.5 + 0.5 * (currentMp.value / 5);
            m = beData.armorScale;
            if(m == 0)
            {
               m = 1;
            }
            m *= scaleNum;
            beData.armorScale = m;
         }
         super.onHitEnemy(beData,enemy);
      }
      
      override public function isGod() : Boolean
      {
         if(actionName == "脱离")
         {
            return true;
         }
         if(godCD.value > 0)
         {
            return true;
         }
         return super.isGod();
      }
      
      override public function dieEffect() : void
      {
         if(!isDie)
         {
            godCD.value = 60 * this.currentMp.value;
            isDie = true;
            this.attribute.hp = 1;
            return;
         }
         super.dieEffect();
      }
      
      override public function copyData() : Object
      {
         var ob:Object = super.copyData();
         ob.roleTarget = roleXmlData.targetName;
         ob.isDie = this.isDie;
         ob.god = this.godCD.value;
         return ob;
      }
      
      override public function setData(value:Object) : void
      {
         super.setData(value);
         isDie = value.isDie;
         this.godCD.value = value.god;
         if(value.roleTarget)
         {
            roleXmlData.parsingAction(value.roleTarget);
         }
      }
   }
}

