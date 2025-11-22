package game.skill
{
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   
   public class JGZSkill extends EffectDisplay
   {
      
      public function JGZSkill(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(role)
         {
            role.golden = 5;
         }
      }
   }
}

