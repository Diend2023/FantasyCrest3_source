package zygame.display
{
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class TouchDisplayObject extends DisplayObjectContainer
   {
      
      public function TouchDisplayObject()
      {
         super();
      }
      
      public function set isTouch(value:Boolean) : void
      {
         if(value)
         {
            this.addEventListener("touch",onTouch);
         }
         else if(hasEventListener("touch"))
         {
            this.removeEventListeners("touch");
         }
      }
      
      public function onTouch(e:TouchEvent) : void
      {
         var i:int = 0;
         var touch:Touch = null;
         for(i = 0; i < e.touches.length; )
         {
            touch = e.touches[i];
            switch(touch.phase)
            {
               case "began":
                  onTouchBegin(touch);
                  break;
               case "moved":
                  onTouchMove(touch);
                  break;
               case "ended":
                  onTouchEnd(touch);
                  break;
               case "hover":
                  onTouchHover(touch);
            }
            i++;
         }
      }
      
      public function onTouchBegin(touch:Touch) : void
      {
      }
      
      public function onTouchHover(touch:Touch) : void
      {
      }
      
      public function onTouchMove(touch:Touch) : void
      {
      }
      
      public function onTouchEnd(touch:Touch) : void
      {
      }
   }
}

