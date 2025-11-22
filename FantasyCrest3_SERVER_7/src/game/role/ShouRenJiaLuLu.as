package game.role
{
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class ShouRenJiaLuLu extends GameRole
   {
      
      private var _isMS:Boolean = false;
      
      private var _msTime:int = 900;
      
      public function ShouRenJiaLuLu(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onBeHit(beData:BeHitData) : void
      {
         if(_msTime > 0 && _isMS)
         {
            beData.armorScale *= 0.2;
            beData.magicScale *= 0.2;
         }
         super.onBeHit(beData);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(_msTime > 0 && _isMS)
         {
            this.attribute.crit = 30;
         }
         if(_isMS == false && this.attribute.hp < this.attribute.hpmax * 0.3)
         {
            _isMS = true;
         }
      }
   }
}

