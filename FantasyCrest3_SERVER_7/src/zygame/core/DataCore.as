package zygame.core
{
   import dragonBones.starling.StarlingArmatureDisplay;
   import dragonBones.starling.StarlingFactory;
   import flash.display.DisplayObject;
   import flash.media.Sound;
   import flash.net.SharedObject;
   import flash.utils.setTimeout;
   import lzm.util.Base64;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   import starlingbuilder.engine.DefaultAssetMediator;
   import starlingbuilder.engine.UIBuilder;
   import zygame.data.ConfigData;
   import zygame.data.GameFightData;
   import zygame.data.GamePropsData;
   import zygame.data.GameTroopData;
   import zygame.data.RoleAttributeData;
   import zygame.debug.Debug;
   import zygame.utils.MapAssestManage;
   import zygame.utils.RUtils;
   import zygame.utils.RoleAssestManage;
   import zygame.utils.WDAssetsManager;
   
   public class DataCore
   {
      
      public static var saveID:String = "zygame.net.game";
      
      public static var webAssetsPath:String = "";
      
      public static var assetsSwf:WDAssetsManager;
      
      public static var assetsRole:RoleAssestManage;
      
      public static var assetsMap:MapAssestManage;
      
      public static var shareData:SharedObject;
      
      public static var _saveData:Object;
      
      public static var config:ConfigData;
      
      public static var fightData:GameFightData;
      
      public static var props:GamePropsData;
      
      public static var troop:GameTroopData;
      
      public static var progress:IProgress;
      
      public static var uiBuilder:UIBuilder;
      
      private static var _isError:Boolean = false;
      
      private static var _errorMessage:String = "";
      
      public static var delay:int = 100;
      
      private static var _factory:StarlingFactory;
      
      private static var _dragonParsings:Array;
      
      public function DataCore()
      {
         super();
      }
      
      public static function init(display:flash.display.DisplayObject) : void
      {
         if(Debug.IS_UNSAVE)
         {
            shareData.clear();
         }
         shareData = SharedObject.getLocal(saveID);
         backSaveData();
         assetsSwf = new WDAssetsManager(!RUtils.isLocalGame(display));
         assetsSwf.otherAssets.verbose = true;
         assetsSwf.otherAssets.keepAtlasXmls = true;
         assetsMap = new MapAssestManage();
         assetsRole = new RoleAssestManage(assetsMap.assets);
         assetsSwf.otherAssets.addEventListener("ioError",onDataError);
         _dragonParsings = [];
         _factory = new StarlingFactory();
         uiBuilder = new UIBuilder(new DefaultAssetMediator(assetsSwf.otherAssets));
         if(!_saveData.props)
         {
            _saveData.props = {
               "material":[],
               "consumables":[],
               "crest":[],
               "task":[]
            };
         }
         if(!_saveData.roles)
         {
            _saveData.roles = {};
         }
         if(!_saveData.statisticalProps)
         {
            _saveData.statisticalProps = {};
         }
      }
      
      public static function parsingDragons() : void
      {
         for(var i in _dragonParsings)
         {
            parsingDragonAessets(_dragonParsings[i]);
         }
         _dragonParsings.splice(0,_dragonParsings.length);
      }
      
      public static function pushDragon(dragonName:String) : void
      {
         _dragonParsings.push(dragonName);
      }
      
      public static function parsingDragonAessets(dragonName:String) : void
      {
         var ske:Object = null;
         var tex:Object = null;
         trace("新增龙骨资源",dragonName);
         if(!hasDragon(dragonName))
         {
            ske = getJSON(dragonName + "_ske");
            if(ske)
            {
               _factory.removeDragonBonesData(ske.name,true);
               _factory.parseDragonBonesData(ske);
               tex = getJSON(dragonName + "_tex");
               if(tex)
               {
                  _factory.removeTextureAtlasData(tex.name);
                  parsingDragonTexture(dragonName + "_tex");
               }
            }
         }
      }
      
      public static function parsingDragonTexture(target:String) : void
      {
         var tax:Texture = null;
         var tex:Object = getJSON(target);
         if(tex)
         {
            tax = getTexture(target);
            _factory.parseTextureAtlasData(tex,tax);
         }
      }
      
      public static function createDragonMovcilp(dragonName:String, isAuto:Boolean = false) : StarlingArmatureDisplay
      {
         var display:StarlingArmatureDisplay = _factory.buildArmature(dragonName).display as StarlingArmatureDisplay;
         if(isAuto)
         {
            StarlingFactory._clock.add(display.armature);
         }
         return display;
      }
      
      public static function hasDragon(skename:String) : Boolean
      {
         for(var i in _factory.allDragonBonesData)
         {
            for(var i2 in _factory.allDragonBonesData[i].armatureNames)
            {
               if(_factory.allDragonBonesData[i].armatureNames[i2] == skename)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      protected static function onDataError(e:Event) : void
      {
         trace("加载错误：",e.data);
         _isError = true;
         _errorMessage += "Load Error:" + e.data + "\n";
      }
      
      public static function updateValue(key:String, data:Object, child:String = null) : void
      {
         if(child)
         {
            if(!_saveData[child])
            {
               _saveData[child] = {};
            }
            _saveData[child][key] = data;
         }
         else
         {
            _saveData[key] = data;
         }
      }
      
      public static function getInt(key:String, defaultValue:int = 0) : int
      {
         if(_saveData[key] != null)
         {
            return int(_saveData[key]);
         }
         return defaultValue;
      }
      
      public static function getNumber(key:String, defaultNumber:Number = 0) : Number
      {
         if(_saveData[key] != null)
         {
            return Number(_saveData[key]);
         }
         return defaultNumber;
      }
      
      public static function getString(key:String) : String
      {
         return _saveData[key];
      }
      
      public static function getBoolean(key:String) : Boolean
      {
         return _saveData[key];
      }
      
      public static function getArray(key:String, defaultArr:Array = null) : Array
      {
         if(_saveData[key] != null)
         {
            return _saveData[key] as Array;
         }
         return defaultArr;
      }
      
      public static function getObject(key:String) : Object
      {
         return _saveData[key] as Object;
      }
      
      public static function setConfig(xml:XML) : void
      {
         config = new ConfigData(xml);
      }
      
      public static function initData() : void
      {
         props = new GamePropsData(getPropsConfig());
         fightData = new GameFightData(assetsSwf.otherAssets.getXml("fight"));
         troop = new GameTroopData();
      }
      
      public static function statisticalProps(target:String) : void
      {
         if(!_saveData.statisticalProps)
         {
            _saveData.statisticalProps = [];
         }
         if(_saveData.statisticalProps[target])
         {
            _saveData.statisticalProps[target]++;
         }
         else
         {
            _saveData.statisticalProps[target] = 1;
         }
      }
      
      public static function getStatisticalProps(target:String) : int
      {
         if(!_saveData.statisticalProps)
         {
            _saveData.statisticalProps = {};
         }
         return int(_saveData.statisticalProps[target]);
      }
      
      private static function setRoleConfig(data:RoleAttributeData) : void
      {
         if(!_saveData.roles)
         {
            _saveData.roles = {};
         }
         delete _saveData.roles[data.target];
         _saveData.roles[data.target] = data.toObject();
      }
      
      public static function getRoleConfig(target:String, isNew:Boolean = false) : RoleAttributeData
      {
         var roleAttr:RoleAttributeData = null;
         if(troop && !isNew)
         {
            roleAttr = troop.getAttrudete(target);
         }
         if(roleAttr)
         {
            return roleAttr;
         }
         var data:Object = null;
         if(_saveData.roles)
         {
            data = _saveData.roles[target];
         }
         roleAttr = new RoleAttributeData(target);
         for(var i in data)
         {
            roleAttr.setValue(String(i),data[i]);
         }
         return roleAttr;
      }
      
      public static function getRoleData() : Object
      {
         return _saveData.roles;
      }
      
      public static function save() : void
      {
         for(var c in troop.getAttrudetes())
         {
            DataCore.setRoleConfig(troop.getAttrudetes()[c]);
         }
         savePropsDatas();
         for(var i in _saveData)
         {
            shareData.data[i] = JSON.parse(JSON.stringify(_saveData[i]));
         }
         shareData.flush();
      }
      
      public static function savePropsDatas() : void
      {
         delete _saveData.props;
         _saveData.props = props.getSaveData();
      }
      
      public static function getPropsConfig() : Object
      {
         return _saveData.props;
      }
      
      public static function onProgress(num:Number) : Boolean
      {
         if(progress)
         {
            GameCore.currentCore.stage.addChild(progress as starling.display.DisplayObject);
            progress.onPro(num);
            if(num == 1)
            {
               setTimeout(function():void
               {
                  var error:TextField = null;
                  if(_isError)
                  {
                     error = new TextField(800,64,_errorMessage,new TextFormat("Verdana",12,65280,"left"));
                     GameCore.currentCore.stage.addChild(error);
                  }
                  else
                  {
                     (DataCore.progress as starling.display.DisplayObject).removeFromParent();
                  }
               },delay);
            }
         }
         return _isError;
      }
      
      public static function clear() : void
      {
         shareData.clear();
         _saveData = {};
         props = new GamePropsData(null);
         troop.reset();
      }
      
      public static function formBase64(ob:Object) : String
      {
         return Base64.encode(JSON.stringify(ob));
      }
      
      public static function backSaveData() : void
      {
         if(_saveData)
         {
            _saveData = null;
         }
         _saveData = JSON.parse(JSON.stringify(shareData.data));
      }
      
      public static function buildUi(uiName:String, trimLeadingSpace:Boolean = true, bindObject:Object = null) : starling.display.DisplayObject
      {
         var spr:starling.display.DisplayObject = uiBuilder.create(assetsSwf.otherAssets.getObject(uiName),trimLeadingSpace,bindObject) as starling.display.DisplayObject;
         if(bindObject is DisplayObjectContainer)
         {
            (bindObject as DisplayObjectContainer).addChild(spr);
         }
         return spr;
      }
      
      public static function getXml(pname:String) : XML
      {
         var xml:XML = assetsSwf.otherAssets.getXml(pname);
         if(xml)
         {
            return xml;
         }
         return assetsMap.assets.getXml(pname);
      }
      
      public static function getTextureAtlas(pname:String) : TextureAtlas
      {
         var ob:TextureAtlas = assetsSwf.otherAssets.getTextureAtlas(pname);
         if(ob)
         {
            return ob;
         }
         return assetsMap.assets.getTextureAtlas(pname);
      }
      
      public static function getTexture(pname:String) : Texture
      {
         var ob:Texture = assetsSwf.otherAssets.getTexture(pname);
         if(ob)
         {
            return ob;
         }
         ob = assetsMap.assets.getTexture(pname);
         if(ob)
         {
            return ob;
         }
         var ta:TextureAtlas = getTextureAtlas(pname);
         if(ta)
         {
            return ta.texture;
         }
         return null;
      }
      
      public static function getJSON(pname:String) : Object
      {
         var ob:Object = assetsSwf.otherAssets.getObject(pname);
         if(ob)
         {
            return ob;
         }
         return assetsMap.assets.getObject(pname);
      }
      
      public static function getSound(pname:String) : Sound
      {
         var ob:Sound = assetsSwf.otherAssets.getSound(pname);
         if(ob)
         {
            return ob;
         }
         return assetsMap.assets.getSound(pname);
      }
      
      public static function clearMapRoleData() : void
      {
         assetsRole.clearAllRoleData();
         assetsMap.clearAllMapData();
      }
   }
}

