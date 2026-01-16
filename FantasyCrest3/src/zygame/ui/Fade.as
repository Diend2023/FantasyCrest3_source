package zygame.ui
{
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Quad;
   
   public class Fade extends BaseUiEffect
   {
      
      public function Fade(display:DisplayObject, main:DisplayObjectContainer, func:Function)
      {
         var bg:Quad;
         var tw:Tween;
         var out:Tween;
         super(display,main,func);
         bg = new Quad(main.stage.stageWidth,main.stage.stageHeight,0);
         main.addChild(bg);
         bg.alpha = 0;
         tw = new Tween(bg,0.25);
         tw.fadeTo(1);
         tw.onComplete = function():void
         {
            func();
            main.addChild(bg);
         };
         out = new Tween(bg,0.25);
         out.fadeTo(0);
         out.onComplete = function():void
         {
            bg.removeFromParent();
         };
         tw.nextTween = out;
         Starling.juggler.add(tw);
      }
   }
}

