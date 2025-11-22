package game.role
{
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class XueCai extends GameRole
   {
      
      public function XueCai(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(this.hit > 12)
         {
            this.attribute.power = 575;
         }
         else
         {
            this.attribute.power = 350;
         }
      }
   }
}

