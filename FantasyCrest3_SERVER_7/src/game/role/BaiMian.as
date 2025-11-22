package game.role
{
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class BaiMian extends GameRole
   {
      
      public function BaiMian(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function set fps(i:int) : void
      {
         super.fps = 24;
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
      }
      
      override public function onBeHit(beData:BeHitData) : void
      {
         if(beData.magicScale > 0)
         {
            beData.magicScale *= 0.7;
         }
         if(beData.armorScale > 0)
         {
            beData.armorScale *= 0.7;
         }
         super.onBeHit(beData);
      }
   }
}

