package zygame.style
{
   import starling.rendering.MeshEffect;
   import starling.styles.MeshStyle;
   import zygame.effect.WhiteEffect;
   
   public class WhiteStyle extends MeshStyle
   {
      
      public function WhiteStyle()
      {
         super();
      }
      
      override public function createEffect() : MeshEffect
      {
         return new WhiteEffect();
      }
   }
}

