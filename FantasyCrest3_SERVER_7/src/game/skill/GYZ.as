package game.skill
{
   import zygame.display.BaseRole;
   
   public class GYZ extends UDPSkill
   {
      
      private var mk:int = 3;
      
      public function GYZ(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
      }
      
      override public function onHitRole(r:BaseRole) : void
      {
         super.onHitRole(role);
         if(mk > 0)
         {
            mk--;
            return;
         }
         if(Math.abs(this.gox) > 4)
         {
            this.gox = this.gox > 0 ? 4 : -4;
         }
         if(r.beHitCount > 8)
         {
            r.beHitCount = 8;
         }
         r.jumpMath = 0;
      }
   }
}

