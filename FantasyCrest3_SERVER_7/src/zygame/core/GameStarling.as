package zygame.core
{
   import flash.display.Stage;
   import flash.display.Stage3D;
   import flash.geom.Rectangle;
   import lzm.starling.swf.FPSUtil;
   import starling.core.Starling;
   import zygame.utils.AutoSkipUtils;
   
   public class GameStarling extends Starling
   {
      
      public var autoSkip:AutoSkipUtils;
      
      public var unSkip:Boolean = false;
      
      private var _runConfig:String;
      
      private var isRender:Boolean;
      
      private var _fps:FPSUtil;
      
      public function GameStarling(rootClass:Class, stage:Stage, viewPort:Rectangle = null, stage3D:Stage3D = null, renderMode:String = "auto", profile:Object = "baselineConstrained")
      {
         super(rootClass,stage,viewPort,stage3D,renderMode,profile);
         autoSkip = new AutoSkipUtils(stage,2);
         log("GameStarling start");
         _fps = new FPSUtil(60);
         runderType = "medium";
      }
      
      override public function render() : void
      {
         if(!unSkip && autoSkip.requestFrameSkip())
         {
            return;
         }
         if(_fps.update())
         {
            super.render();
         }
      }
      
      public function set fps(i:int) : void
      {
         _fps.fps = i;
      }
      
      public function set runderType(str:String) : void
      {
         _runConfig = str;
         switch(str)
         {
            case "high":
               Starling.current.nativeStage.frameRate = 60;
               _fps.fps = 60;
               unSkip = false;
               break;
            case "medium":
               Starling.current.nativeStage.frameRate = 60;
               _fps.fps = 50;
               unSkip = true;
               break;
            case "low":
               Starling.current.nativeStage.frameRate = 30;
               _fps.fps = 30;
               unSkip = true;
         }
      }
      
      public function get runderType() : String
      {
         return _runConfig;
      }
   }
}

