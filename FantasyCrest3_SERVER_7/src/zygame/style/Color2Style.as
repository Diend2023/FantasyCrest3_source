package zygame.style
{
   import starling.rendering.MeshEffect;
   import starling.rendering.RenderState;
   import starling.styles.MeshStyle;
   import zygame.effect.Color2Effect;
   
   public class Color2Style extends MeshStyle
   {
      
      private var _addColor:uint;
      
      public var intensity:Number = 1;
      
      public function Color2Style(c:uint = 0, i:Number = 1)
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
         return new Color2Effect();
      }
      
      override public function updateEffect(effect:MeshEffect, state:RenderState) : void
      {
         (effect as Color2Effect).color = _addColor;
         (effect as Color2Effect).intensity = intensity;
         super.updateEffect(effect,state);
      }
      
      override public function copyFrom(meshStyle:MeshStyle) : void
      {
         var colorStyle:Color2Style = meshStyle as Color2Style;
         if(colorStyle)
         {
            this.addColor = colorStyle.addColor;
            this.intensity = colorStyle.intensity;
         }
         super.copyFrom(meshStyle);
      }
   }
}

