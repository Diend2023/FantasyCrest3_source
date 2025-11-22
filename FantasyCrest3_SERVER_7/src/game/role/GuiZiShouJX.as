package game.role
{
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class GuiZiShouJX extends GameRole
   {
      
      public function GuiZiShouJX(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(this.frameAt(2,6) && hitRole())
         {
            this.go(6);
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         if(isMandatorySkill)
         {
            this.attribute.crit = 50;
         }
         else
         {
            this.attribute.crit = 1;
         }
         super.onHitEnemy(beData,enemy);
      }
      
      override public function get hitEffectName() : String
      {
         return "chop";
      }
   }
}

