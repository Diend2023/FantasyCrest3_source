package game.skill
{
   import flash.geom.Rectangle;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   
   public class Protect extends EffectDisplay
   {
      
      public function Protect(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         var rect:Rectangle = this.bounds;
         if(role && rect.x < this.role.x && rect.width + rect.x > this.role.x)
         {
            this.role.goldenTime = 0.5;
         }
      }
   }
}

