package game.role
{
   import game.skill.BingDong;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class BingJieShi extends GameRole
   {
      
      public function BingJieShi(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function immuneEffect(object:Object) : Boolean
      {
         if(object is BingDong)
         {
            return true;
         }
         return super.immuneEffect(object);
      }
   }
}

