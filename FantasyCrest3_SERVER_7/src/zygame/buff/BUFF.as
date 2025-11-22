package zygame.buff
{
   import zygame.display.BaseRole;
   
   public class BUFF
   {
      
      public function BUFF()
      {
         super();
      }
      
      public static function createPoisoning(role:BaseRole, pscale:Number, time:int) : void
      {
         role.addBuff(new Poisoning(pscale,role,time));
      }
   }
}

