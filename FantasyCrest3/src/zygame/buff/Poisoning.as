package zygame.buff
{
   import flash.geom.Point;
   import zygame.display.BaseRole;
   
   public class Poisoning extends BuffRef
   {
      
      public var scale:Number;
      
      public function Poisoning(pscale:Number, role:BaseRole, time:int)
      {
         scale = pscale;
         super("poisoning",role,time);
      }
      
      override public function action() : void
      {
         super.action();
         var hurt:int = this.currentRole.attribute.hpmax * scale;
         this.currentRole.hurtNumber(hurt,null,new Point(this.currentRole.posx + (Math.random() * 50 - 25),this.currentRole.y + (Math.random() * 50 - 25)));
      }
   }
}

