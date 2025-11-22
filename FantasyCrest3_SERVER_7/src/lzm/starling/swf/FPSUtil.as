package lzm.starling.swf
{
   import flash.utils.getTimer;
   
   public class FPSUtil
   {
      
      private var _fps:int;
      
      private var _fpsTime:Number;
      
      private var _currentTime:Number;
      
      private var _lastFrameTimestamp:Number;
      
      private var _pause:Boolean = false;
      
      public function FPSUtil(fps:int)
      {
         super();
         this.fps = fps;
      }
      
      public function get fps() : int
      {
         return _fps;
      }
      
      public function set fps(value:int) : void
      {
         _fps = value;
         _fpsTime = 1000 / _fps * 0.001;
         _currentTime = 0;
         _lastFrameTimestamp = getTimer() / 1000;
      }
      
      public function update() : Boolean
      {
         if(_pause)
         {
            return false;
         }
         var now:Number = getTimer() / 1000;
         var passedTime:Number = now - _lastFrameTimestamp;
         _lastFrameTimestamp = now;
         _currentTime += passedTime;
         if(_currentTime >= _fpsTime)
         {
            _currentTime -= _fpsTime;
            if(_currentTime > _fpsTime)
            {
               _currentTime = 0;
            }
            return true;
         }
         return false;
      }
      
      public function pause() : void
      {
         _pause = true;
      }
      
      public function resume() : void
      {
         _pause = false;
      }
   }
}

