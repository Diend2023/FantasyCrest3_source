package game.role
{
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class LanQuan extends GameRole
   {
      
      public function LanQuan(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onBeHit(beData:BeHitData) : void
      {
         if(actionName == "神圣反击")
         {
            goldenTime = 1;
            this.breakAction();
            this.playSkill("反击");
            return;
         }
         super.onBeHit(beData);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         var hurt:int = 0;
         super.onHitEnemy(beData,enemy);
         if(world.getEffectFormName("wuqi",this))
         {
            hurt = beData.getHurt(enemy.attribute);
            this.attribute.hp += hurt * 0.25;
            if(this.attribute.hp > this.attribute.hpmax)
            {
               this.attribute.hp = this.attribute.hpmax;
            }
         }
      }
   }
}

