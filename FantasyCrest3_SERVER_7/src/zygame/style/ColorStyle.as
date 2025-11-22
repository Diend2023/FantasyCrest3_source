package zygame.style
{
   import starling.rendering.MeshEffect;
   import starling.rendering.RenderState;
   import starling.styles.MeshStyle;
   import zygame.effect.ColorEffect;
   
   public class ColorStyle extends MeshStyle
   {
      
      private var _addColor:uint;
      
      public var intensity:Number = 1;
      
      public function ColorStyle(c:uint = 0, i:Number = 1)
      {
         super();
         _addColor = c;
         intensity = i;
      }
      
      public function set addColor(i:uint) : void
      {
         _addColor = i;
      }
      
      public function get addColor() : uint
      {
         return _addColor;
      }
      
      override public function createEffect() : MeshEffect
      {
         return new ColorEffect();
      }
      
      override public function updateEffect(effect:MeshEffect, state:RenderState) : void
      {
         (effect as ColorEffect).color = _addColor;
         (effect as ColorEffect).intensity = intensity;
         super.updateEffect(effect,state);
      }
      
      override public function copyFrom(meshStyle:MeshStyle) : void
      {
         var colorStyle:ColorStyle = meshStyle as ColorStyle;
         if(colorStyle)
         {
            this.addColor = colorStyle.addColor;
            this.intensity = colorStyle.intensity;
         }
         super.copyFrom(meshStyle);
      }
   }
}

