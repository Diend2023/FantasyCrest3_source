package game.role
{
   import flash.geom.Rectangle;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class Kaixa extends GameRole
   {
      
      public function Kaixa(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onFrame() : void
      {
         var baseRole:BaseRole = null;
         super.onFrame();
         if(actionName == "瞬步" && attribute.getCD("暴力连踢") <= 0)
         {
            baseRole = findRole(new Rectangle(posx - 100,posy - 100,200,200));
            if(baseRole && baseRole.isJump())
            {
               breakAction();
               playSkill("暴力连踢");
            }
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         if(actionName == "暴击连踢")
         {
            enemy.golden = 0;
            enemy.jumpMath = 0;
         }
         super.onHitEnemy(beData,enemy);
      }
      
      override public function playSkill(target:String) : void
      {
         if(target == "瞬步" && attribute.getCD(target) <= 0)
         {
            this.breakAction();
         }
         super.playSkill(target);
      }
   }
}

