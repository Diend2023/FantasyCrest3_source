package zygame.core
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.display.Stage3D;
   import flash.geom.Rectangle;
   import flash.net.LocalConnection;
   import flash.system.System;
   import flash.utils.setTimeout;
   import lzm.starling.swf.Swf;
   import parser.Script;
   import starling.display.Sprite;
   import starling.events.Event;
   import zygame.debug.Debug;
   import zygame.display.World;
   import zygame.utils.SuperTextureAtlas;
   
   public class GameCore extends GameStarling
   {
      
      public static const VERSION:String = "0.0.1";
      
      private static var _world:World;
      
      public static var keyCore:KeyCore;
      
      public static var soundCore:SoundCore;
      
      public static var scriptCore:ScriptCore;
      
      private var _configPath:String;
      
      private var _loadHeader:String;
      
      public var baseDisplay:DisplayObjectContainer;
      
      private var _roleAssets:Array;
      
      public function GameCore(configPath:String, gameDisplay:DisplayObjectContainer, rootClass:Class, stage:Stage, viewPort:Rectangle = null, stage3D:Stage3D = null, renderMode:String = "auto", profile:Object = "baselineConstrained")
      {
         log("GameCore start",rootClass,stage,viewPort,stage3D,renderMode,profile);
         log("Config path:",_configPath);
         baseDisplay = gameDisplay;
         _configPath = configPath;
         soundCore = new SoundCore();
         keyCore = new KeyCore(stage);
         super(rootClass,stage,viewPort,stage3D,renderMode,profile);
         this.addEventListener("rootCreated",onRootCreated);
      }
      
      public static function get currentCore() : GameCore
      {
         return current as GameCore;
      }
      
      public static function get currentWorld() : World
      {
         return _world;
      }
      
      public static function set currentWorld(world:World) : void
      {
         Script.vm.world = world;
         _world = world;
      }
      
      public function setRoleAssets(roles:Array) : void
      {
         _roleAssets = roles;
      }
      
      public function initTMXMap(dic:String, pmainMap:String = null, pTarget:String = null, roles:Array = null, onCreate:Function = null) : void
      {
         var mainMap:String;
         var mainTarget:String;
         if(CoreStarup.testRole)
         {
            roles = [CoreStarup.testRole];
         }
         if(!roles)
         {
            roles = _roleAssets;
         }
         if(CoreStarup.testRoles)
         {
            roles = CoreStarup.testRoles;
         }
         if(dic == "")
         {
            _loadHeader = "";
         }
         else
         {
            _loadHeader = dic + "/";
         }
         mainMap = DataCore.getString("saveMap");
         mainTarget = null;
         if(!mainMap && DataCore.config)
         {
            mainMap = DataCore.config.getMainMap();
         }
         else
         {
            mainTarget = DataCore.getString("saveMapTarget");
         }
         if(pmainMap)
         {
            mainMap = pmainMap;
         }
         if(pTarget)
         {
            mainTarget = pTarget;
         }
         dispatchEventWith("world_loading_start",false,mainMap);
         DataCore.assetsMap.loadMap(DataCore.webAssetsPath + _loadHeader + "tmx/" + mainMap,function(code:Number):void
         {
            trace("地图加载情况：",code);
            if(onCreate != null)
            {
               onCreate(mainMap.substr(0,mainMap.lastIndexOf(".")),mainTarget,roles);
            }
            else
            {
               createWorld(mainMap.substr(0,mainMap.lastIndexOf(".")),mainTarget,roles);
            }
         },roles);
      }
      
      public function loadTMXMap(url:String, target:String, back:Function = null, isSave:Boolean = true, roles:Array = null) : void
      {
         var i:Object;
         if(CoreStarup.testRole)
         {
            roles = [CoreStarup.testRole];
            DataCore.assetsRole.removeRole(CoreStarup.testRole);
         }
         if(CoreStarup.testRoles)
         {
            roles = CoreStarup.testRoles;
            for(i in roles)
            {
               DataCore.assetsRole.removeRole(roles[i]);
            }
         }
         if(!url)
         {
            url = currentWorld.targetName + ".tmx";
         }
         if(!roles)
         {
            roles = _roleAssets;
         }
         if(currentWorld)
         {
            currentWorld.discarded();
         }
         dispatchEventWith("world_loading_start",false,url);
         DataCore.assetsMap.loadMap(DataCore.webAssetsPath + _loadHeader + "tmx/" + url,function(code:int):void
         {
            trace("地图加载情况：",code);
            createWorld(url.substr(0,url.lastIndexOf(".")),target,roles);
         },roles);
         if(isSave)
         {
            DataCore.updateValue("saveMap",url);
            DataCore.updateValue("saveMapTarget",target);
            DataCore.save();
         }
      }
      
      public function createWorld(mapName:String, targetName:String, roles:Array) : void
      {
         if(currentWorld)
         {
            currentWorld.clearKeyLient();
         }
         var xml:XML = DataCore.assetsMap.assets.getXml(mapName);
         var classWorld:Class = World.defalutClass;
         log("世界类:",xml.@world);
         if(xml.@world != undefined && String(xml.@world) != "<null>")
         {
            try
            {
               classWorld = this.baseDisplay.loaderInfo.applicationDomain.getDefinition(xml.@world) as Class;
            }
            catch(e:Error)
            {
               throw new Error("世界类" + xml.@world + "未定义");
            }
         }
         else
         {
            log("世界类:no find!");
         }
         if(classWorld == null)
         {
            classWorld = World.defalutClass;
         }
         var game2:World = new classWorld(mapName,targetName);
         game2.createRole(roles ? roles : _roleAssets);
         if(roles)
         {
            _roleAssets = roles;
         }
         game2.scale = World.worldScale;
         game2.touchable = false;
         currentWorld = game2;
         SceneCore.replaceScene(game2);
         if(_world)
         {
            this.dispatchEventWith("world_created");
         }
      }
      
      private function onRootCreated(e:Event) : void
      {
         if(this.profile != "baselineExtended" && this.profile != "standardExtended")
         {
            SuperTextureAtlas.support = true;
         }
         SceneCore.init(this.root as starling.display.Sprite);
         Swf.init(this.root as starling.display.Sprite);
         DataCore.init(baseDisplay);
         scriptCore = new ScriptCore();
         scriptCore.initScript(baseDisplay as flash.display.Sprite);
         if(_configPath)
         {
            DataCore.assetsSwf.enqueueOtherAssets(_configPath);
            DataCore.assetsSwf.loadQueue(function(num:Number):void
            {
               var loadarrs:Vector.<String>;
               var i:Object;
               if(num == 1)
               {
                  DataCore.setConfig(DataCore.getXml("project"));
                  loadarrs = DataCore.config.getLoads();
                  for(i in loadarrs)
                  {
                     log("GameCore Data:",loadarrs[i]);
                     DataCore.assetsSwf.enqueueOtherAssets(loadarrs[i]);
                  }
                  DataCore.assetsSwf.loadQueue(function(num:Number):void
                  {
                     if(num == 1)
                     {
                        dispatchEventWith("file_loaded");
                        DataCore.initData();
                        CoreStarup.restoreTextureUtils.clearBitmap();
                        dispatchEventWith("gameCoreInitComplete");
                     }
                     dispatchEventWith("load_number",true,num);
                  });
               }
            });
         }
         else
         {
            setTimeout(function():void
            {
               DataCore.initData();
               dispatchEventWith("gameCoreInitComplete");
            },0.5);
         }
      }
      
      public function set napeDebug(bool:Boolean) : void
      {
         Debug.IS_DRAW_DEBUG_NAPE = bool;
      }
      
      public function clearSaveData() : void
      {
         Debug.IS_UNSAVE = true;
      }
      
      public function getClass(className:String) : Class
      {
         var pclass:Class = null;
         try
         {
            pclass = GameCore.currentCore.baseDisplay.loaderInfo.applicationDomain.getDefinition(className) as Class;
            if(pclass)
            {
               log("自定义类",className);
               return pclass;
            }
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function get loadHeader() : String
      {
         return _loadHeader ? _loadHeader : "";
      }
      
      public function set loadHeader(str:String) : void
      {
         _loadHeader = str;
      }
      
      public function removeWorld() : void
      {
         if(currentWorld)
         {
            currentWorld.discarded();
            _world = null;
         }
      }
      
      public function gc() : void
      {
         try
         {
            new LocalConnection().connect("foo");
            new LocalConnection().connect("foo");
            trace("尝试释放内存2：",System.totalMemory);
         }
         catch(e:*)
         {
            trace("尝试释放内存：",System.totalMemory);
         }
      }
   }
}

