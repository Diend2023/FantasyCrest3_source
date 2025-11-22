package game.role
{
   import flash.geom.Point;
   import game.world.BaseGameWorld;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class Ruler extends GameRole
   {
      
      public function Ruler(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      public function getTimeHurt(role:GameRole) : int
      {
         return role.hurt / ((world as BaseGameWorld).frameCount / 60);
      }
      
      override public function onBeHit(beData:BeHitData) : void
      {
         super.onBeHit(beData);
      }
      
      override public function hurtNumber(beHurt:int, beData:BeHitData, pos:Point) : void
      {
         if(beData != null && beData.isCrit)
         {
            beHurt *= 0.2;
         }
         super.hurtNumber(beHurt,beData,pos);
      }
   }
}

