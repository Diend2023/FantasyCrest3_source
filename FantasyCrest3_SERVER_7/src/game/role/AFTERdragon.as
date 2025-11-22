package game.role
{
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class AFTERdragon extends GameRole
   {
      
      public function AFTERdragon(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         if(this.actionName == "毒锯" || this.actionName == "掠噬")
         {
            enemy.addBuff(new DuBuff("dubuff2",50,enemy,10),10);
         }
         else
         {
            enemy.addBuff(new DuBuff("dubuff",50,enemy,5),10);
         }
         super.onHitEnemy(beData,enemy);
      }
   }
}

import flash.geom.Point;
import zygame.buff.BuffRef;
import zygame.display.BaseRole;

class DuBuff extends BuffRef
{
   
   private var _hurt:int = 0;
   
   public function DuBuff(type:String, hurt:int, role:BaseRole, time:int)
   {
      _hurt = hurt;
      super(type,role,time);
   }
   
   override public function action() : void
   {
      this.currentRole.hurtNumber(_hurt,null,new Point(this.currentRole.posx + (Math.random() * 50 - 25),this.currentRole.y + (Math.random() * 50 - 25)));
   }
}
