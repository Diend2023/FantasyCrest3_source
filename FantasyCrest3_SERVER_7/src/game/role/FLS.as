package game.role
{
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class FLS extends SuperFlyRole
   {
      
      public function FLS(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         if(actionName == "流放之拳")
         {
            enemy.goldenTime = 0;
            enemy.straight = 30;
         }
      }
      
      override public function win() : void
      {
         this.attribute.hp += this.attribute.hpmax * 0.25;
         if(this.attribute.hp > this.attribute.hpmax)
         {
            this.attribute.hp = this.attribute.hpmax;
         }
      }
      
      override public function onInit() : void
      {
         super.onInit();
      }
   }
}

