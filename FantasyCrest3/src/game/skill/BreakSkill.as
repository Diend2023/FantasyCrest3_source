package game.skill
{
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   
   public class BreakSkill extends EffectDisplay
   {
      
      public function BreakSkill(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
         beHitData.isBreakDam = true;
      }
   }
}

