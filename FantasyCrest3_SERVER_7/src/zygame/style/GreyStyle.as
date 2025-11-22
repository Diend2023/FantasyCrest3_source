package zygame.style
{
   import starling.rendering.MeshEffect;
   import starling.styles.MeshStyle;
   import zygame.effect.GreyStyleEffect;
   
   public class GreyStyle extends MeshStyle
   {
      
      public function GreyStyle()
      {
         super();
      }
      
      override public function createEffect() : MeshEffect
      {
         return new GreyStyleEffect();
      }
   }
}

