package game.role
{
   import game.buff.Burn;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class PenHuoLong extends GameRole
   {
      
      public var lockRole:BaseRole;
      
      public var cd:cint = new cint();
      
      public function PenHuoLong(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(inFrame("地球上投",1))
         {
            lockRole = null;
         }
         if(lockRole && actionName == "地球上投" && frameAt(5,99))
         {
            lockRole.posx = this.posx;
            lockRole.posy = this.posy;
         }
         if(cd.value > 0)
         {
            cd.value--;
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         if(actionName == "地球上投")
         {
            enemy.breakAction();
            enemy.golden = 0;
            enemy.straight = 30;
            enemy.actionName = "受伤";
            lockRole = enemy;
         }
         super.onHitEnemy(beData,enemy);
         if(actionName == "喷射火焰" || actionName == "火之誓约" || actionName == "火焰旋涡" || actionName == "逆鳞")
         {
            if(cd.value == 0 || actionName == "逆鳞")
            {
               enemy.addBuff(new Burn("penhuolong",0.003 * (enemy.attribute.getBuffCount("penhuolong") + 1),enemy,5),3);
               cd.value = 60;
            }
         }
      }
   }
}

