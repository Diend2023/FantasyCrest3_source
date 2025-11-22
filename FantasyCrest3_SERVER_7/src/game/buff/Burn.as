package game.buff
{
   import zygame.buff.Poisoning;
   import zygame.display.BaseRole;
   
   public class Burn extends Poisoning
   {
      
      public function Burn(target:String, pscale:Number, role:BaseRole, time:int)
      {
         super(pscale,role,time);
         this.targetName = target;
      }
   }
}

