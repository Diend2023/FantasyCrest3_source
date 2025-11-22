package game.skill
{
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   
   public class BingHua extends EffectDisplay
   {
      
      public function BingHua(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(role)
         {
            if(Math.random() > 0.9)
            {
               objectData.x = -50 + -100 * Math.random();
               objectData.y = -50 + -100 * Math.random();
            }
            this.posx += (role.x + objectData.x * role.currentScaleX - (role.currentScaleX < 0 ? 100 : 0) - this.x) * 0.05;
            this.posy += (role.y + objectData.y * role.currentScaleY - this.y) * 0.05;
         }
      }
   }
}

