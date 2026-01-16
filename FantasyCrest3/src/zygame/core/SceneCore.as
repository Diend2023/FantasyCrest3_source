package zygame.core
{
   import starling.core.Starling;
   import starling.display.DisplayObjectContainer;
   import starling.display.Quad;
   import starling.events.Event;
   
   public class SceneCore
   {
      
      private static var _main:DisplayObjectContainer;
      
      public function SceneCore()
      {
         super();
      }
      
      public static function init(main:DisplayObjectContainer) : void
      {
         _main = main;
      }
      
      public static function pushView(display:DisplayObjectContainer, isModal:Boolean = false, effect:Class = null) : void
      {
         var q:Quad;
         if(isModal)
         {
            q = new Quad(Starling.current.stage.stageWidth,Starling.current.stage.stageHeight,16777215);
            _main.addChild(q);
            q.alpha = 0;
            display.addEventListener("removedFromStage",function(e:Event):void
            {
               display.removeEventListeners("removedFromStage");
               q.removeFromParent(true);
            });
         }
         if(effect)
         {
            new effect(display,_main,function():void
            {
               _main.addChild(display);
            });
         }
         else
         {
            _main.addChild(display);
         }
      }
      
      public static function removeView(display:DisplayObjectContainer, effect:Class = null, isDispose:Boolean = false) : void
      {
         if(effect)
         {
            new effect(display,_main,function():void
            {
               _main.removeChild(display,isDispose);
            });
         }
         else
         {
            _main.removeChild(display,isDispose);
         }
      }
      
      public static function replaceScene(display:DisplayObjectContainer) : void
      {
         try
         {
            _main.removeChildren(0,-1,true);
         }
         catch(e:Error)
         {
            trace("舞台无对象");
         }
         _main.addChild(display);
      }
   }
}

