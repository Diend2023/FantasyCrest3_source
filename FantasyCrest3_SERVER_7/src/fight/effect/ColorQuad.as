package fight.effect
{
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Quad;
   
   public class ColorQuad extends BaseEffect
   {
      
      private var _color:uint;
      
      private var _outtime:Number;
      
      private var _dey:Number;
      
      public function ColorQuad(color:uint, fadeOutTime:Number = 1, initAlpha:Number = 1, deyle:Number = 0)
      {
         super();
         _color = color;
         _outtime = fadeOutTime;
         this.blendMode = "add";
         this.alpha = initAlpha;
         _dey = deyle;
      }
      
      override public function onInit() : void
      {
         var q:Quad = new Quad(stage.stageWidth,stage.stageHeight,_color);
         this.addChild(q);
         var tw:Tween = new Tween(this,_outtime);
         tw.fadeTo(0);
         tw.delay = _dey;
         tw.onComplete = remove;
         Starling.juggler.add(tw);
      }
   }
}

