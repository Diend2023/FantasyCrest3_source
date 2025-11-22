package game.role
{
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class ManYou extends GameRole
   {
      
      public function ManYou(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         this.attribute.crit = 35 + 3 * this.hit;
      }
   }
}

