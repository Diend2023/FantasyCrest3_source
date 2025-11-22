package game.role
{
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class ZhiRen extends GameRole
   {
      
      public function ZhiRen(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function breakAction() : void
      {
         if(this.getCD(this.actionName) > 0 && !isOSkill())
         {
            if(this.hit == 0)
            {
               this.attribute.updateCD(this.actionName,this.currentGroup.cd * 0.2);
            }
         }
         super.breakAction();
      }
   }
}

