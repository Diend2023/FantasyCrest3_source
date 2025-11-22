package game.role
{
   import game.world.BaseGameWorld;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class BL extends GameRole
   {
      
      public function BL(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      public function getTimeHurt(role:GameRole) : int
      {
         return role.hurt / ((world as BaseGameWorld).frameCount / 60);
      }
      
      override public function onBeHit(beData:BeHitData) : void
      {
         var bl:Number = NaN;
         var hurt:int = getTimeHurt(beData.role as GameRole);
         if(hurt > 400)
         {
            hurt = 400;
         }
         if(hurt > 200)
         {
            if(beData.armorScale == 0)
            {
               beData.armorScale = 1;
            }
            if(beData.magicScale == 0)
            {
               beData.magicScale = 1;
            }
            bl = 1 - (hurt - 200) / 200 * 0.5;
            beData.armorScale *= bl;
            beData.magicScale *= bl;
         }
         super.onBeHit(beData);
      }
   }
}

