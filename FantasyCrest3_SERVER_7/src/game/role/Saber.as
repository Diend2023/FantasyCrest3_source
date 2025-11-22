package game.role
{
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class Saber extends GameRole
   {
      
      public function Saber(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(inFrame("已然遥远的理想乡",3))
         {
            this.addBuff(new HuiBuff(this,10));
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         var hp:Number = 1 - enemy.attribute.hp / enemy.attribute.hpmax;
         var bs:int = hp / 0.1;
         if(beData.armorScale == 0)
         {
            beData.armorScale = 1;
         }
         beData.armorScale += bs * 0.05;
         super.onHitEnemy(beData,enemy);
      }
   }
}

import zygame.buff.BuffRef;
import zygame.display.BaseRole;

class HuiBuff extends BuffRef
{
   
   public function HuiBuff(role:BaseRole, time:int)
   {
      super("lixiangxiang",role,time);
   }
   
   override public function action() : void
   {
      currentRole.restoreHP(0.01);
   }
}
