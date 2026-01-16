package game.skill
{
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   
   public class ShiZiHuo extends EffectDisplay
   {
      
      public function ShiZiHuo(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         this.hitX = Math.abs(this.gox) * (this.scaleX > 0 ? 1 : -1);
      }
      
      override public function discarded() : void
      {
         var eff:EffectDisplay = new EffectDisplay("YanDi",null,role,3,3);
         eff.go(7);
         eff.objectData.cardFrame = 6;
         eff.hitY = 18;
         eff.hitX = 5 * (this.scaleX > 0 ? 1 : -1);
         eff.x = this.x;
         eff.y = this.y + 220;
         world.addChild(eff);
         world.vibrationSize = 32;
         world.mapVibrationTime = 16;
         super.discarded();
      }
   }
}

