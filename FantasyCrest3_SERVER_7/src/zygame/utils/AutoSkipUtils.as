package zygame.utils
{
   import flash.display.Stage;
   import flash.utils.getTimer;
   
   public class AutoSkipUtils
   {
      
      private var lastTimer:int;
      
      private var deadLine:int;
      
      private var minContiguousFrames:int;
      
      private var maxContiguousSkips:int;
      
      private var framesRendered:int;
      
      private var framesSkipped:int;
      
      public function AutoSkipUtils(stage:Stage, deadLineRate:Number = 1.2, minContiguousFrames:int = 1, maxContiguousSkips:int = 1)
      {
         super();
         this.lastTimer = 0;
         this.deadLine = Math.ceil(1000 / stage.frameRate * deadLineRate);
         this.minContiguousFrames = minContiguousFrames;
         this.maxContiguousSkips = maxContiguousSkips;
         framesRendered = 0;
         framesSkipped = 0;
      }
      
      public function set maxSkipFrameCount(fps:int) : void
      {
         this.maxContiguousSkips = fps;
      }
      
      public function set minDarwFrameCount(fps:int) : void
      {
         this.minContiguousFrames = fps;
      }
      
      public function requestFrameSkip() : Boolean
      {
         var rt:Boolean = false;
         var timer:int = getTimer();
         var dtTimer:int = timer - lastTimer;
         if(dtTimer > deadLine && framesRendered >= minContiguousFrames && framesSkipped < maxContiguousSkips)
         {
            rt = true;
            framesRendered = 0;
            framesSkipped += 1;
         }
         else
         {
            framesSkipped = 0;
            framesRendered += 1;
         }
         lastTimer = timer;
         return rt;
      }
   }
}

