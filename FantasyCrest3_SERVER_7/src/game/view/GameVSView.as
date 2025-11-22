package game.view
{
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import feathers.layout.HorizontalLayout;
   import game.data.Game;
   import game.uilts.GameFont;
   import game.view.item.VSItem;
   import game.world._2VFBOnline;
   import starling.display.Image;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.TextureAtlas;
   import starling.utils.AssetManager;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   import zygame.display.World;
   import zygame.server.Service;
   
   public class GameVSView extends OnlineView
   {
      
      public var mapName:String;
      
      private var _array1:Array;
      
      private var _array2:Array;
      
      private var _loading:Image;
      
      private var _isOnline:Boolean;
      
      private var _mapName:String;
      
      private var _roles:Array;
      
      private var _ready:int = 0;
      
      private var _list1:List;
      
      private var _list2:List;
      
      private var _isNoLoad2P:Boolean = false;
      
      public function GameVSView(map:String, array1:Array, array2:Array, isOnline:Boolean = false, isNoLoad2P:Boolean = false)
      {
         var arr:Array = null;
         super();
         mapName = map;
         if(mapName == null)
         {
            arr = Game.getMapData().data as Array;
            mapName = arr[int(arr.length * Math.random())].target;
         }
         _array1 = array1;
         _array2 = array2;
         _isOnline = isOnline;
         _isNoLoad2P = isNoLoad2P;
      }
      
      override public function onInit() : void
      {
         var tips:Image;
         var wbg:Image;
         var loadingBottom:Image;
         var loadingMask:Image;
         var loadingText:TextField;
         var list:List;
         var list2:List;
         var vs:Image;
         var textureAtlas:TextureAtlas = DataCore.getTextureAtlas("select_role");
         var bg:Image = new Image(DataCore.getTexture("select_role_bg"));
         this.addChild(bg);
         bg.x = stage.stageWidth / 2;
         bg.y = stage.stageHeight / 2;
         bg.scaleX = -1;
         bg.alignPivot();
         tips = new Image(textureAtlas.getTexture("1p2p"));
         this.addChild(tips);
         tips.x = stage.stageWidth / 2;
         tips.alignPivot("center","top");
         tips.y = -5;
         wbg = new Image(textureAtlas.getTexture("bg"));
         this.addChild(wbg);
         wbg.alignPivot();
         wbg.x = stage.stageWidth / 2;
         wbg.y = stage.stageHeight / 2 - 12;
         wbg.scale = 0.5;
         wbg.alpha = 0.5;
         loadingBottom = new Image(textureAtlas.getTexture("loading_bottom"));
         this.addChild(loadingBottom);
         loadingBottom.x = stage.stageWidth / 2 - loadingBottom.width / 2;
         loadingBottom.y = stage.stageHeight - 60;
         loadingMask = new Image(textureAtlas.getTexture("loading_mask"));
         this.addChild(loadingMask);
         loadingMask.x = stage.stageWidth / 2 - loadingBottom.width / 2 - 6;
         loadingMask.y = stage.stageHeight - 60 - 6;
         _loading = loadingBottom;
         _loading.scaleX = 0;
         loadingText = new TextField(300,64,"正在加载",new TextFormat(GameFont.FONT_NAME,12,16777215,"left"));
         this.addChild(loadingText);
         loadingText.x = loadingMask.x + 10;
         loadingText.y = loadingMask.y;
         list = new List();
         list.itemRendererType = VSItem;
         list.layout = new HorizontalLayout();
         (list.layout as HorizontalLayout).horizontalAlign = "center";
         this.addChild(list);
         list.dataProvider = new ListCollection(_array1);
         list.width = stage.stageWidth / 2;
         list.height = wbg.height + 32;
         list.y = 80;
         list2 = new List();
         list2.itemRendererType = VSItem;
         list2.layout = new HorizontalLayout();
         (list2.layout as HorizontalLayout).horizontalAlign = "center";
         this.addChild(list2);
         list2.dataProvider = new ListCollection(_array2);
         list2.width = stage.stageWidth / 2;
         list2.height = wbg.height + 32;
         list2.x = stage.stageWidth / 2;
         list2.y = list.y;
         list.touchable = false;
         list2.touchable = false;
         _list1 = list;
         _list2 = list2;
         vs = new Image(textureAtlas.getTexture("vs"));
         this.addChild(vs);
         vs.alignPivot();
         vs.x = stage.stageWidth / 2;
         vs.y = stage.stageHeight / 2;
         vs.scale = 0.8;
         DataCore.assetsMap.addEventListener("load_number",onLoadNumber);
         GameCore.currentCore.initTMXMap("",mapName + ".tmx",null,loadArray(_array1,_array2),_isOnline ? create : null);
         if(_isOnline)
         {
            Service.client.messageFunc = onMessage;
         }
         AssetManager.onLoadName = function(pname:String):void
         {
            if(pname.indexOf("<null>") != -1)
            {
               trace("???");
            }
            loadingText.text = "加载[" + pname + "]";
         };
      }
      
      public function loadArray(arr1:Array, arr2:Array) : Array
      {
         var arr:Array = [];
         for(var a1 in arr1)
         {
            arr.push(arr1[a1] is String ? arr1[a1] as String : arr1[a1].target);
         }
         if(!_isNoLoad2P)
         {
            for(var a2 in arr2)
            {
               arr.push(arr2[a2] is String ? arr2[a2] as String : arr2[a2].target);
            }
         }
         return arr;
      }
      
      override public function onMessage(data:Object) : void
      {
         switch(data.action)
         {
            case "loading":
               if(World.defalutClass == _2VFBOnline)
               {
                  _list1.dataProvider.getItemAt(Service.client.type == "master" ? 1 : 0).pro = int(data.pro);
                  _list1.dataProvider.updateAll();
                  break;
               }
               (Service.client.type == "master" ? _list2 : _list1).dataProvider.getItemAt(0).pro = int(data.pro);
               (Service.client.type == "master" ? _list2 : _list1).dataProvider.updateItemAt(0);
               break;
            case "loaded":
               cheakStart();
               (Service.client.type == "master" ? _list2 : _list1).dataProvider.getItemAt(0).pro = 100;
               (Service.client.type == "master" ? _list2 : _list1).dataProvider.updateItemAt(0);
         }
      }
      
      public function create(mapName2:String, targetName:String, roles:Array) : void
      {
         _mapName = mapName2;
         _roles = roles;
         cheakStart();
      }
      
      private function onLoadNumber(e:Event) : void
      {
         _loading.scaleX = e.data as Number;
         if(Service.client && Service.client.connected)
         {
            try
            {
               (Service.client.type == "master" ? _list1 : _list2).dataProvider.getItemAt(0).pro = int((e.data as Number) * 100);
               (Service.client.type == "master" ? _list1 : _list2).dataProvider.updateItemAt(0);
            }
            catch(e:Error)
            {
            }
         }
         if(e.data == 1)
         {
            action("loaded");
         }
         else
         {
            action("loading",{"pro":int((e.data as Number) * 100)});
         }
      }
      
      public function cheakStart() : void
      {
         _ready++;
         if(_ready >= Service.client.roomPlayerList.length)
         {
            GameCore.currentCore.createWorld(_mapName,null,_roles);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._array1 = null;
         this._array2 = null;
         this._list1 = null;
         this._list2 = null;
         this._loading = null;
         this._roles = null;
         DataCore.assetsMap.removeEventListener("load_number",onLoadNumber);
      }
   }
}

