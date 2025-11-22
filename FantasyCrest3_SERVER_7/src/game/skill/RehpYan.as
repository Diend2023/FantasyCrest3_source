package game.skill
{
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   
   public class RehpYan extends EffectDisplay
   {
      
      public function RehpYan(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
      }
      
      override public function discarded() : void
      {
         if(Math.abs(this.x - role.x) < 150 && Math.abs(this.y - role.y) < 16)
         {
            role.restoreHP(0.01);
         }
         super.discarded();
      }
   }
}

