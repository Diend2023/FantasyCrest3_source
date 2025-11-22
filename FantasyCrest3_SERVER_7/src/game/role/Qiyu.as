package game.role
{
   import game.world._FBBaseWorld;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class Qiyu extends GameRole
   {
      
      public function Qiyu(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onBeHit(beData:BeHitData) : void
      {
         super.onBeHit(beData);
         this.clearDebuffMove();
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         beData.armorScale = 30000;
         super.onHitEnemy(beData,enemy);
      }
      
      override public function onMove() : void
      {
         if(world is _FBBaseWorld)
         {
            this.troopid = 2;
         }
         if(!isLock)
         {
            if(this.isKeyDown(65))
            {
               this.scaleX = -1;
            }
            else if(this.isKeyDown(68))
            {
               this.scaleX = 1;
            }
         }
         move(null);
         if(actionName == "待机")
         {
            xMove(0);
            playSkill("瞬步");
         }
         super.onMove();
      }
   }
}

