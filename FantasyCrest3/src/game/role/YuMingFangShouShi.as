package game.role
{
   import flash.geom.Point;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class YuMingFangShouShi extends GameRole
   {
      
      public var hitCount:int = 0;
      
      public function YuMingFangShouShi(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         if(this.actionName == "乱雪月花")
         {
            if(this.currentActionLegnth < 64)
            {
               beData.moveY = 0;
               beData.straight = 60;
            }
         }
         hitCount++;
         if(hitCount >= (isOSkill() ? 6 : 12))
         {
            hitCount = 0;
            enemy.hurtNumber(enemy.attribute.hpmax * 0.05,null,new Point(enemy.x,enemy.y - 50));
         }
      }
   }
}

