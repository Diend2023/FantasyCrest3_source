package zygame.buff
{
   import zygame.display.BaseRole;
   
   public class Treatment extends BuffRef
   {
      
      private var _scaleNum:Number = 0;
      
      public function Treatment(prole:BaseRole, time:int, scaleNum:Number)
      {
         super("treatment",prole,time);
         _scaleNum = scaleNum;
      }
      
      override public function action() : void
      {
         super.action();
         this.currentRole.attribute.hp += this.currentRole.attribute.hpmax * _scaleNum;
         if(this.currentRole.attribute.hp > this.currentRole.attribute.hpmax)
         {
            this.currentRole.attribute.hp = this.currentRole.attribute.hpmax;
         }
      }
   }
}

