package game.role
{
   import flash.geom.Point;
   import game.world._FBBaseWorld;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class HBL extends GameRole
   {
      
      public var beData:BeHitData;
      
      public function HBL(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         this.beData = beData;
         super.onHitEnemy(beData,enemy);
         if(isOSkill())
         {
            if(actionName == "Gate Of Hades")
            {
               hurtBFB(enemy,0.025);
            }
            else if(currentFrame >= 18)
            {
               hurtBFB(enemy,0.3);
            }
         }
         else if(actionName == "The Crime Of Destory Souls" || actionName == "Burial Of Death")
         {
            hurtBFB(enemy,0.02);
         }
         else if(actionName == "Evil Sickle" && currentFrame < 14)
         {
            hurtBFB(enemy,0.02);
         }
         else if(actionName == "Dark Circling" && currentFrame < 2)
         {
            hurtBFB(enemy,0.02);
         }
         else if(actionName == "普通攻击" && currentFrame < 24)
         {
            hurtBFB(enemy,0.02);
         }
         else
         {
            hurtBFB(enemy,0.01);
         }
      }
      
      public function hurtBFB(enemy:BaseRole, i:Number) : void
      {
         var hurt:int = enemy.attribute.hpmax * i;
         if(world is _FBBaseWorld && hurt > 300)
         {
            hurt = 300;
         }
         enemy.hurtNumber(hurt,beData,new Point(enemy.x,enemy.y - Math.random() * 100 + 50));
      }
   }
}

