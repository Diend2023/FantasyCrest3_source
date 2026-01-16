package zygame.style
{
   import starling.rendering.MeshEffect;
   import starling.styles.MeshStyle;
   import zygame.effect.BlackEffect;
   
   public class BlackStyle extends MeshStyle
   {
      
      public function BlackStyle()
      {
         super();
      }
      
      override public function createEffect() : MeshEffect
      {
         return new BlackEffect();
      }
   }
}

