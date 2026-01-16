package zygame.utils
{
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.utils.EncodeAssets;
   import zygame.core.DataCore;
   import zygame.tmx.TMXData;
   
   public class MapAssestManage extends EventDispatcher
   {
      
      public var backgroundConfig:Object;
      
      public var assets:EncodeAssets;
      
      private var _isLoading:Boolean = false;
      
      private var _mapLoads:Array;
      
      private var _otherLoads:Array;
      
      private var _loadHead:String;
      
      private var _currentLoadMapName:String;
      
      private var _roleAssets:Array;
      
      private var _roleLoads:Array;
      
      private var _back:Function;
      
      private var _inAssets:Array;
      
      public function MapAssestManage()
      {
         super();
         _mapLoads = [];
         _otherLoads = [];
         _inAssets = [];
         assets = new EncodeAssets();
         assets.keepAtlasXmls = true;
         assets.addEventListener("ioError",onError);
      }
      
      private function onError(e:Event) : void
      {
      }
      
      public function loadMaps(mapPaths:Array, backFunc:Function, needRoles:Array = null) : void
      {
         for(var i in mapPaths)
         {
            loadMap(mapPaths[i],backFunc,needRoles);
         }
      }
      
      public function loadMap(mapPath:String, backFunc:Function = null, needRoles:Array = null) : void
      {
         if(_isLoading)
         {
            _mapLoads.push(mapPath);
            return;
         }
         _loadHead = mapPath.substr(0,mapPath.indexOf("tmx"));
         _currentLoadMapName = mapPath;
         _currentLoadMapName = _currentLoadMapName.substr(0,_currentLoadMapName.lastIndexOf("."));
         _currentLoadMapName = _currentLoadMapName.substr(_currentLoadMapName.lastIndexOf("/") + 1);
         _isLoading = true;
         if(needRoles != null)
         {
            _roleAssets = needRoles;
            _roleLoads = needRoles ? needRoles.concat() : [];
         }
         if(backFunc != null)
         {
            _back = backFunc;
         }
         log("load map:",mapPath);
         assets.enqueue(mapPath);
         assets.loadQueue(onLoadMapAssest);
      }
      
      public function onLoadMapAssest(num:Number) : void
      {
         var mapXML:XML = null;
         var child:XMLList = null;
         var bgObject:Object = null;
         var assetsList:XMLList = null;
         var pngPath:String = null;
         var i:int = 0;
         var ob:Object = null;
         var layers:Array = null;
         var layerOb:Object = null;
         var pngPath3:String = null;
         if(num == 1)
         {
            _inAssets = [];
            mapXML = assets.getXml(_currentLoadMapName);
            if(!mapXML)
            {
               AlertUtils.show("地图不存在","错误");
               _isLoading = false;
               return;
            }
            mapXML = TMXData.repair(mapXML.toXMLString());
            child = mapXML.properties.children();
            if(mapXML.@bg != undefined && backgroundConfig)
            {
               bgObject = backgroundConfig[String(mapXML.@bg)];
               if(bgObject)
               {
                  for(var bg in bgObject)
                  {
                     if(bgObject[bg].type != "sound")
                     {
                        enqueueAssets(_loadHead + "bg/" + bgObject[bg].name + ".png");
                     }
                     else
                     {
                        enqueueAssets(_loadHead + "bgm/" + bgObject[bg].name + ".mp3");
                     }
                  }
               }
            }
            if(mapXML.@texture != undefined && mapXML.@texture != "<null>")
            {
               enqueueAssets(_loadHead + mapXML.@texture + ".xml",_loadHead + mapXML.@texture + ".png");
            }
            assetsList = mapXML.assets.children();
            for(var i3 in assetsList)
            {
               pngPath = assetsList[i3].@path;
               enqueueAssets(_loadHead + pngPath);
            }
            for(i = 0; i < child.length(); )
            {
               if(child[i].@name == "extend")
               {
                  ob = JSON.parse(child[i].@value);
                  if(ob.version)
                  {
                     layers = ob.layers;
                     for(var layeri in layers)
                     {
                        layerOb = layers[layeri];
                        if(layerOb.type == "npc")
                        {
                           loadNpcAssets(ob[layerOb.id]);
                        }
                     }
                  }
                  else
                  {
                     loadNpcAssets(ob.npc);
                  }
                  for(var i4 in ob.scenery)
                  {
                     pngPath3 = ob.scenery[i4].path;
                     pngPath3 = pngPath3.substr(0,pngPath3.indexOf("."));
                     pngPath3 += ".png";
                     enqueueAssets(_loadHead + ob.scenery[i4].path,_loadHead + pngPath3);
                  }
               }
               i++;
            }
            if(_inAssets.length > 0)
            {
               assets.loadQueue(onMapAssets);
            }
            else
            {
               nextMap();
            }
            trace("加载资源",_inAssets);
         }
      }
      
      private function nextMap() : void
      {
         _isLoading = false;
         if(_mapLoads.length > 0)
         {
            loadMap(_mapLoads[0]);
            _mapLoads.shift();
         }
         else
         {
            onAssestEd();
         }
      }
      
      private function onAssestEd() : void
      {
         var i:Object;
         if(_roleLoads && _roleLoads.length > 0)
         {
            DataCore.assetsRole.clear(_roleLoads);
            for(i in _roleLoads)
            {
               DataCore.assetsRole.load(_loadHead + "role/" + _roleLoads[i] + ".data");
            }
            DataCore.assetsRole.start(function(num:Number):void
            {
               dispatchEventWith("load_number",false,0.5 + num * 0.5);
               if(num == 1)
               {
                  DataCore.parsingDragons();
                  _back(0);
               }
            });
         }
         else
         {
            DataCore.parsingDragons();
            _back(0);
         }
      }
      
      private function onMapAssets(num:Number) : void
      {
         this.dispatchEventWith("load_number",false,num / (_mapLoads.length + 1) * 0.5);
         if(num == 1)
         {
            nextMap();
         }
      }
      
      private function loadNpcAssets(npcData:Object) : void
      {
         var npcOb:Object = null;
         var isDragon:* = false;
         var pngPath2:String = null;
         var dragonName:* = null;
         for(var i2 in npcData)
         {
            npcOb = npcData[i2];
            if(!DataCore.fightData.hasData(npcOb.name))
            {
               isDragon = npcOb.path.indexOf("_tex") != -1;
               pngPath2 = npcOb.path;
               pngPath2 = pngPath2.substr(0,pngPath2.indexOf("."));
               if(!isDragon)
               {
                  enqueueAssets(_loadHead + npcOb.path,_loadHead + pngPath2 + ".png");
               }
               else
               {
                  dragonName = pngPath2;
                  dragonName = dragonName.substr(pngPath2.lastIndexOf("/") + 1);
                  enqueueAssets(_loadHead + pngPath2.replace("_tex","_ske") + ".json",_loadHead + pngPath2 + ".json",_loadHead + pngPath2 + ".png");
                  DataCore.pushDragon(dragonName.substr(0,dragonName.lastIndexOf("_")));
               }
            }
            else
            {
               _roleLoads.push(npcOb.name);
            }
         }
      }
      
      public function enqueueAssets(... ret) : void
      {
         var ext:String = null;
         var pname:String = null;
         var isLoad:* = false;
         for(var i in ret)
         {
            isLoad = true;
            ext = String(ret[i]).substr(String(ret[i]).lastIndexOf(".") + 1);
            pname = String(ret[i]).substr(String(ret[i]).lastIndexOf("/") + 1);
            pname = pname.substr(0,pname.lastIndexOf("."));
            switch(ext)
            {
               case "xml":
                  isLoad = assets.getXml(pname) == null;
                  break;
               case "png":
                  isLoad = assets.getTexture(pname) == null;
                  if(isLoad)
                  {
                     isLoad = assets.getTextureAtlas(pname) == null;
                  }
                  break;
               case "json":
                  isLoad = assets.getObject(pname) == null;
            }
            if(isLoad)
            {
               _inAssets.push(ret[i]);
               assets.enqueue(ret[i]);
            }
         }
      }
      
      public function clearAllMapData() : void
      {
         assets.dispose();
         _mapLoads = [];
         _otherLoads = [];
         _inAssets = [];
      }
   }
}

