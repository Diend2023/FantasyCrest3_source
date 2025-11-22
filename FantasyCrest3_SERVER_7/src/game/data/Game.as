package game.data
{
   import feathers.data.ListCollection;
   import game.view.GameTipsView;
   import starling.textures.Texture;
   import starling.utils.AssetManager;
   import starling.utils.EncodeAssets;
   import zygame.core.DataCore;
   import zygame.core.SceneCore;
   
   public class Game
   {
      
      public static var rankid:int = 1941;
      
      public static var levelData:LevelData;
      
      public static var game4399Tools:Game4399Tools;
      
      public static var forceData:ForceData;
      
      public static var onlineData:OnlineFightData;
      
      public static var lastTimeMap:String;
      
      public static var fbData:FBGameData = new FBGameData();
      
      public static var assets:AssetManager = new AssetManager();
      
      public static var vip:cint = new cint(0);
      
      public function Game()
      {
         super();
      }
      
      public static function getRoleImage(target:String, func:Function) : void
      {
         var texture:Texture = assets.getTexture(target);
         if(texture)
         {
            func(texture);
         }
         else
         {
            assets.enqueue(EncodeAssets.loadPathConversion != null ? EncodeAssets.loadPathConversion("role_image/" + target + ".png") : "role_image/" + target + ".png");
            assets.verbose = true;
            assets.loadQueue(function(num:Number):void
            {
               if(num == 1)
               {
                  texture = assets.getTexture(target);
                  if(!texture)
                  {
                     texture = DataCore.getTexture("none");
                  }
                  func(texture);
               }
            });
         }
      }
      
      public static function initData(data:Object = null) : void
      {
         forceData = new ForceData(data);
         fbData = new FBGameData(data);
      }
      
      public static function save() : void
      {
         if(game4399Tools.logInfo)
         {
            SceneCore.pushView(new GameTipsView("测试：" + forceData));
            game4399Tools.onSaveed = submitScore;
            game4399Tools.saveData({
               "allFight":forceData.allFight,
               "fight":forceData.toSaveData(),
               "vip":vip.value,
               "version":String(DataCore.getXml("fight").@version),
               "fbs":fbData.toSaveData()
            },0);
         }
      }
      
      public static function submitScore() : void
      {
         if(game4399Tools.logInfo)
         {
            game4399Tools.submitScore(forceData.allFight,0,rankid,{"highRole":forceData.highRoleTargetName});
         }
      }
      
      public static function addForce(pname:String, i:int) : int
      {
         return forceData.addForce(pname,i);
      }
      
      public static function getXMLData(name:String) : XML
      {
         var xmllist:XMLList = null;
         var rootName:String = null;
         var figth:XML = DataCore.getXml("fight");
         if(figth)
         {
            xmllist = figth.children();
            for(var i in xmllist)
            {
               rootName = (xmllist[i] as XML).localName();
               if(rootName == name)
               {
                  return xmllist[i] as XML;
               }
            }
         }
         return null;
      }
      
      public static function getMapData(old:Boolean = true) : ListCollection
      {
         var arr:Array = [];
         var xml:XMLList = DataCore.getXml("maps").children();
         for(var i in xml)
         {
            if(!old || String(xml[i].@target) != lastTimeMap)
            {
               arr.push({
                  "name":String(xml[i].@name),
                  "target":String(xml[i].@target)
               });
            }
            else
            {
               arr.splice(0,0,{
                  "name":xml[i].@name + "(上次)",
                  "target":String(xml[i].@target)
               });
            }
         }
         return new ListCollection(arr);
      }
      
      public static function getFBMapData(old:Boolean = true) : ListCollection
      {
         var arr:Array = [];
         var xml:XMLList = DataCore.getXml("fuben").children();
         for(var i in xml)
         {
            if(!old || String(xml[i].@target) != lastTimeMap)
            {
               arr.push({
                  "name":String(xml[i].@name),
                  "target":String(xml[i].@target)
               });
            }
            else
            {
               arr.splice(0,0,{
                  "name":xml[i].@name + "(上次)",
                  "target":String(xml[i].@target)
               });
            }
         }
         return new ListCollection(arr);
      }
      
      public static function getFBRoleData(target:String) : Array
      {
         var rxmllist:XMLList = null;
         var arr:Array = [];
         var xml:XMLList = DataCore.getXml("fuben").children();
         for(var i in xml)
         {
            if(String(xml[i].@target) == target)
            {
               rxmllist = xml[i].children();
               for(var r in rxmllist)
               {
                  arr.push((rxmllist[r] as XML).localName());
               }
               break;
            }
         }
         return arr;
      }
      
      public static function getHeadImage(target:String) : Texture
      {
         var arr:Vector.<Texture> = DataCore.getTextureAtlas("role_head").getTextures(target);
         if(arr.length > 0)
         {
            return arr[0];
         }
         return DataCore.getTextureAtlas("role_head").getTexture("none");
      }
   }
}

