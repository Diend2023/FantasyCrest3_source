package game.view
{
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import feathers.layout.VerticalLayout;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import game.data.SelectGroupConfig;
   import game.display.CommonButton;
   import game.display.SelectRole;
   import game.view.item.SkillMessageItem;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.textures.TextureAtlas;
   import starling.utils.AssetManager;
   import starling.utils.EncodeAssets;
   import zygame.core.DataCore;
   import zygame.core.SceneCore;
   import zygame.display.KeyDisplayObject;
   
   public class GameHeroView extends KeyDisplayObject
   {
      
      public var removeButton:CommonButton;
      
      private var _select:SelectRole;
      
      private var _list:List;
      
      private var _loaded:Dictionary;
      
      public function GameHeroView()
      {
         super();
         _loaded = new Dictionary();
      }
      
      override public function onInit() : void
      {
         var q:Quad;
         var config:SelectGroupConfig;
         var selectRole:SelectRole;
         var skillList:List;
         var layout:VerticalLayout;
         var remove:CommonButton;
         var textureAtlas:TextureAtlas = DataCore.getTextureAtlas("select_role");
         var bg:Image = new Image(DataCore.getTexture("select_role_bg"));
         this.addChild(bg);
         bg.x = stage.stageWidth / 2;
         bg.y = stage.stageHeight / 2;
         bg.scaleX = -1;
         bg.alignPivot();
         q = new Quad(stage.stageWidth / 2,32,0);
         this.addChild(q);
         q.x = stage.stageWidth / 2;
         q.y = stage.stageHeight - 32;
         config = new SelectGroupConfig();
         config.selectCount = 1;
         config.showFight = true;
         config.showActhor = true;
         config.showOnlineRoleData = true;
         selectRole = new SelectRole(255,config);
         this.addChild(selectRole);
         selectRole.onSelectChange = this.ask;
         _select = selectRole;
         skillList = new List();
         layout = new VerticalLayout();
         layout.gap = 5;
         layout.verticalAlign = "top";
         skillList.layout = layout;
         this.addChild(skillList);
         skillList.x = stage.stageWidth / 2 + 10;
         skillList.y = 0;
         skillList.width = stage.stageWidth;
         skillList.height = stage.stageHeight - 32;
         skillList.itemRendererType = SkillMessageItem;
         skillList.dataProvider = new ListCollection([1,4,2,7,5,6,3]);
         _list = skillList;
         selectRole.onlineText.x = stage.stageWidth / 2;
         selectRole.onlineText.y = stage.stageHeight - 35 - 32;
         remove = new CommonButton("关闭");
         this.addChild(remove);
         remove.x = 76;
         remove.y = remove.height / 2 + 7;
         remove.callBack = function():void
         {
            clearKey();
            SceneCore.replaceScene(new GameStartMain());
         };
         removeButton = remove;
         this.openKey();
         this.ask();
      }
      
      public function onBuy() : void
      {
         trace("购买：",_select.currentSelectItem);
      }
      
      override public function onDown(key:int) : void
      {
         switch(key)
         {
            case 65:
            case 68:
            case 87:
            case 83:
               _select.onDown(key);
               ask();
               break;
            case 85:
               _select.onDown(key);
         }
      }
      
      public function ask() : void
      {
         var path:String;
         var url:URLLoader;
         var str:String = _select.currentSelectItem.target;
         if(!_loaded[str])
         {
            _list.dataProvider = null;
            if(Boolean(AssetManager.onLoadRawAssetOverride))
            {
               AssetManager.onLoadRawAssetOverride("role/" + str + ".data",function(byte:ByteArray):void
               {
                  onComplete(byte.toString(),str);
               },null);
            }
            else
            {
               path = DataCore.webAssetsPath + "role/" + str + ".data";
               if(Boolean(EncodeAssets.loadPathConversion))
               {
                  path = EncodeAssets.loadPathConversion(path);
               }
               url = new URLLoader(new URLRequest(path));
               url.addEventListener("complete",function(e:Event):void
               {
                  onComplete(e.target.data,str);
               });
               url.addEventListener("ioError",onError);
            }
         }
         else
         {
            reset();
         }
      }
      
      public function onComplete(roleData:String, str:String) : void
      {
         var url:URLLoader;
         var xmlData:* = function(bindXmlData:String = null):void
         {
            var bindXml:XML = bindXmlData ? new XML(bindXmlData) : null;
            var array:Array = [];
            if(EncodeAssets.addXmlConversion && bindXml)
            {
               bindXml = EncodeAssets.addXmlConversion(bindXml);
            }
            pushArray(array,xmlRoot);
            pushArray(array,bindXml,1);
            _loaded[str] = new ListCollection(array);
            reset();
            trace("加载成功");
         };
         var pushArray:* = function(arr:Array, xml2:XML, state:int = 0):void
         {
            var xml:XML = null;
            var other:Object = null;
            var otherarr:Array = null;
            var data:Object = null;
            if(!xml2)
            {
               return;
            }
            var xmllist:XMLList = xml2.action.child("act");
            for(var i in xmllist)
            {
               xml = xmllist[i];
               if(xml.@key != undefined && String(xml.@key) != "")
               {
                  other = {};
                  if(String(xml.@other).indexOf("[") != -1)
                  {
                     otherarr = JSON.parse(xml.@other) as Array;
                     for(var i3 in otherarr)
                     {
                        other[otherarr[i3].id] = otherarr[i3].value;
                     }
                  }
                  data = {
                     "target":str,
                     "actionName":xmllist[i].@name + (state == 1 ? " [形态2]" : ""),
                     "key":xmllist[i].@key,
                     "msg":xmllist[i].@msg,
                     "type":xmllist[i].@type,
                     "cd":int(xmllist[i].@cd),
                     "mp":other.mp,
                     "noc":other.noc
                  };
                  arr.push(data);
               }
            }
         };
         var xmlRoot:XML = new XML(roleData);
         if(Boolean(EncodeAssets.addXmlConversion))
         {
            xmlRoot = EncodeAssets.addXmlConversion(xmlRoot);
         }
         if(xmlRoot.bind.@path != undefined)
         {
            trace("加载绑定角色资料");
            if(!_loaded[str])
            {
               if(Boolean(AssetManager.onLoadRawAssetOverride))
               {
                  AssetManager.onLoadRawAssetOverride(xmlRoot.bind.@path,function(byte:ByteArray):void
                  {
                     xmlData(byte.toString());
                  });
               }
               else
               {
                  url = new URLLoader(new URLRequest(DataCore.webAssetsPath + xmlRoot.bind.@path));
                  url.addEventListener("complete",function(e:Event):void
                  {
                     xmlData(e.target.data);
                  });
                  url.addEventListener("ioError",onError);
               }
            }
            else
            {
               reset();
            }
         }
         else
         {
            xmlData();
         }
      }
      
      public function reset() : void
      {
         var str:String = _select.currentSelectItem.target;
         if(_loaded[str])
         {
            _list.dataProvider = _loaded[str];
         }
      }
      
      private function onError(e:IOErrorEvent) : void
      {
         trace("加载失败");
      }
      
      override public function dispose() : void
      {
         this.clearKey();
         super.dispose();
      }
   }
}

