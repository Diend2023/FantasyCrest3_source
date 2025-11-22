package game.role
{
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class Es extends GameRole
   {
      
      public function Es(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onSUpdate() : void
      {
         super.onSUpdate();
         addMpPoint(1);
         addMpPoint(1);
      }
   }
}

