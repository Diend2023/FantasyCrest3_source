package game.role
{
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class MingRen extends GameRole
   {
      
      public function MingRen(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         if(isOSkill())
         {
            if(beData.armorScale == 0 && beData.magicScale == 0)
            {
               beData.armorScale = 1;
            }
            beData.armorScale += 0.3 * (1 - this.attribute.hp / this.attribute.hpmax);
         }
         super.onHitEnemy(beData,enemy);
      }
   }
}

