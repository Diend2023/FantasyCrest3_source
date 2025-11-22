package zygame.core
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.system.Capabilities;
   import lzm.starling.STLConstant;
   import lzm.starling.STLRootClass;
   import starling.core.Starling;
   import starling.utils.AssetManager;
   import starling.utils.SystemUtil;
   import zygame.utils.RestoreTextureUtils;
   import zygame.utils.SuperTextureAtlas;
   
   public class CoreStarup extends Sprite
   {
      
      public static var testPath:String = null;
      
      public static var testRole:String = null;
      
      public static var testRoles:Array = null;
      
      public static var testRunderType:String = null;
      
      public static var restoreTextureUtils:RestoreTextureUtils;
      
      private var _isPc:Boolean = false;
      
      private var _statusBarHeight:Number = 0;
      
      private var _mStarling:GameCore;
      
      private var _viewRect:Rectangle;
      
      private var _currentValue:Number = 1;
      
      public function CoreStarup()
      {
         super();
      }
      
      protected function initStarling(configPath:String, mainClass:Class, HDHeight:int = 480, debug:Boolean = false, isPc:Boolean = false, stage3DProfile:String = "auto", isMultitouch:Boolean = true, runMode:String = "auto", antiAliasing:int = 4, loadContextImage:BitmapData = null) : void
      {
         var viewPort:Rectangle;
         var hscale:Number;
         STLConstant.nativeStage = stage;
         trace("初始化高度比：",HDHeight);
         _isPc = isPc;
         Starling.multitouchEnabled = isMultitouch;
         viewPort = _viewRect ? _viewRect : new Rectangle(0,0,isPc ? stage.stageWidth : stage.stageWidth,isPc ? stage.stageHeight : stage.stageHeight);
         if(viewPort.width == 0)
         {
            viewPort.width = 800;
         }
         if(viewPort.height == 0)
         {
            viewPort.height = 550;
         }
         viewPort.y = _statusBarHeight;
         viewPort.height -= _statusBarHeight;
         hscale = viewPort.height / HDHeight;
         STLConstant.StageWidth = (viewPort.width - viewPort.height) / hscale + HDHeight;
         STLConstant.StageHeight = HDHeight;
         _mStarling = new GameCore(configPath,this,STLRootClass,stage,viewPort,null,runMode,stage3DProfile);
         _mStarling.stage.stageWidth = STLConstant.StageWidth;
         _mStarling.stage.stageHeight = STLConstant.StageHeight;
         _mStarling.enableErrorChecking = Capabilities.isDebugger;
         _mStarling.antiAliasing = antiAliasing;
         _mStarling.addEventListener("rootCreated",(function():*
         {
            var onRootCreated:Function;
            return onRootCreated = function(event:Object, app:STLRootClass):void
            {
               STLConstant.currnetAppRoot = app;
               _mStarling.removeEventListener("rootCreated",onRootCreated);
               _mStarling.start();
               if(debug)
               {
                  _mStarling.showStatsAt("right");
               }
               app.start(mainClass);
               if(runMode == "software")
               {
                  SuperTextureAtlas.support = true;
               }
               else if(["baselineExtended","standardExtended"].indexOf(_mStarling.profile) != -1)
               {
               }
               restoreTextureUtils.initAssetses(Vector.<AssetManager>([DataCore.assetsMap.assets,DataCore.assetsSwf.otherAssets]));
               trace("baselineExtended","::",_mStarling.profile);
            };
         })());
         log("Scale:" + STLConstant.scale);
         log("StageWidth:" + STLConstant.StageWidth);
         log("StageHeight:" + STLConstant.StageHeight);
         log("WindowViewPort:" + viewPort);
         log("Starling.multitouchEnabled auto open");
         log("IsPc:" + _isPc);
         this.addEventListener("activate",onActivate);
         this.addEventListener("deactivate",onDeactivate);
         restoreTextureUtils = new RestoreTextureUtils(stage,_mStarling,loadContextImage);
      }
      
      public function onActivate(event:Event) : void
      {
         if(GameCore.currentCore)
         {
            GameCore.currentCore.start();
         }
         if(!SystemUtil.isDesktop)
         {
            SoundMixer.soundTransform = new SoundTransform(_currentValue);
         }
      }
      
      public function onDeactivate(event:Event) : void
      {
         if(GameCore.currentCore)
         {
            GameCore.currentCore.stop();
         }
         if(!SystemUtil.isDesktop)
         {
            _currentValue = SoundMixer.soundTransform.volume;
            SoundMixer.soundTransform = new SoundTransform(0);
         }
      }
      
      public function set nativePath(str:String) : void
      {
         trace(str.split("/").join("\\"));
         str = str.split("\\").join("/");
         DataCore.webAssetsPath = str;
      }
      
      public function set testTmxPath(str:String) : void
      {
         testPath = str;
      }
      
      public function set viewRect(rect:Rectangle) : void
      {
         _viewRect = rect;
      }
      
      public function run(mapName:String, useRole:Array) : void
      {
         GameCore.currentCore.loadTMXMap(mapName,null);
      }
      
      public function set uesRole(str:String) : void
      {
         testRole = str;
      }
      
      public function set runderType(i:int) : void
      {
         switch(i)
         {
            case 0:
               testRunderType = "high";
               break;
            case 1:
               testRunderType = "medium";
               break;
            case 2:
               testRunderType = "low";
         }
      }
   }
}

