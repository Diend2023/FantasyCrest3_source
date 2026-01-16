package zygame.display
{
   public class FeedbackDisplay extends DisplayObjectContainer
   {
      
      public static const SELF:String = "self";
      
      public static const ENEMY:String = "enemy";
      
      private var _time:int = 40;
      
      public function FeedbackDisplay(type:String)
      {
         super();
      }
      
      override public function onFrame() : void
      {
         _time--;
         if(_time <= 0)
         {
            this.y--;
            this.alpha -= 0.1;
         }
         if(this.alpha <= 0)
         {
            this.discarded();
         }
      }
      
      override public function discarded() : void
      {
         this.parent.removeChild(this);
      }
   }
}

