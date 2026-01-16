package game.view
{
   import feathers.controls.List;
   import feathers.controls.ScrollText;
   import feathers.controls.TextInput;
   import feathers.data.ListCollection;
   import feathers.layout.HorizontalLayout;
   import game.data.Game;
   import game.display.CommonButton;
   import game.uilts.GameFont;
   import game.view.item.FBMapItem;
   import game.view.item.MapItem;
   import game.view.item.RoomPayerItem;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.core.SceneCore;
   import zygame.server.Service;
   import zygame.utils.SendDataUtils;
   
   public class GameOnlineRoomView extends OnlineView
   {
      
      public static var roomdata:Object;
      
      private var _list:List;
      
      private var _readyBtn:CommonButton;
      
      private var _message:ScrollText;
      
      private var _itext:TextInput;
      
      private var _mapList:List;
      
      public function GameOnlineRoomView(data:Object)
      {
         super();
         trace("房间信息：",JSON.stringify(data));
         roomdata = data;
         Service.client.roomPlayerList = data.list as Array;
         Service.client.rolelistFunc = onRoleListFunc;
         Service.client.joinFunc = onJoinFunc;
         Service.client.messageFunc = onMessage;
         Service.client.type = "player";
         for(var i in data.list)
         {
            if(data.list[i].name == GameOnlineRoomListView._userName)
            {
               Service.client.type = data.list[i].type;
            }
         }
      }
      
      override public function onDown(key:int) : void
      {
         if(key == 13)
         {
            if(_itext.text != "")
            {
               action("message",{
                  "msg":_itext.text,
                  "nickName":Service.userData.nickName
               });
               pushMessage(Service.userData.nickName + ":" + _itext.text);
               _itext.text = "";
            }
         }
      }
      
      override public function onInit() : void
      {
         var left:Quad;
         var right:Quad;
         var selectMap:Image;
         var mapList:List;
         var leftText:TextField;
         var btn:CommonButton;
         var exit:CommonButton;
         var message:ScrollText;
         var inputBG:Quad;
         var textInput:TextInput;
         var send:CommonButton;
         var textures:TextureAtlas = DataCore.getTextureAtlas("start_main");
         var bg:Image = new Image(textures.getTexture("bg"));
         this.addChild(bg);
         bg.alignPivot();
         bg.x = stage.stageWidth / 2;
         bg.y = stage.stageHeight / 2 + 32;
         left = new Quad(200,stage.stageHeight,0);
         left.alpha = 0.7;
         right = new Quad(stage.stageWidth - 203,stage.stageHeight,0);
         right.alpha = 0.7;
         this.addChild(left);
         this.addChild(right);
         right.x = 203;
         right.y = 0;
         selectMap = new Image(DataCore.getTextureAtlas("select_role").getTexture("map_select"));
         this.addChild(selectMap);
         selectMap.x = 203;
         mapList = new List();
         mapList.height = 100;
         mapList.width = stage.stageWidth - selectMap.width - 268;
         mapList.itemRendererType = roomdata.mode == "英雄之迹" ? FBMapItem : MapItem;
         mapList.layout = new HorizontalLayout();
         this.addChild(mapList);
         mapList.x = 268;
         mapList.dataProvider = roomdata.mode == "英雄之迹" ? Game.getFBMapData(false) : Game.getMapData(false);
         mapList.selectedIndex = 0;
         mapList.addEventListener("triggered",onMapChange);
         _mapList = mapList;
         if(Service.client.type != "master")
         {
            mapList.touchable = false;
         }
         leftText = new TextField(200,32,"房间成员",new TextFormat(GameFont.FONT_NAME,20,16776960));
         this.addChild(leftText);
         _list = new List();
         this.addChild(_list);
         _list.width = left.width;
         _list.height = left.height;
         _list.y = 32;
         _list.itemRendererType = RoomPayerItem;
         _list.dataProvider = new ListCollection(roomdata.list);
         _list.addEventListener("change",onPlayListChange);
         this.updateList();
         btn = new CommonButton(Service.client.type == "master" ? "oline_play" : "oline_ready");
         this.addChild(btn);
         btn.scale = 100 / btn.width;
         btn.x = 100 + btn.width / 2;
         btn.y = stage.stageHeight - btn.height / 2;
         _readyBtn = btn;
         _readyBtn.callBack = onReady;
         exit = new CommonButton("btn_style_1","start_main","退出房间");
         this.addChild(exit);
         exit.scale = 100 / exit.width;
         exit.x = 50;
         exit.y = stage.stageHeight - btn.height / 2;
         exit.callBack = onExit;
         message = new ScrollText();
         message.text = "欢迎来到实力至上主义的幻想纹章!\n【观战模式测试版：两位对战玩家，其余必须为观战模式，否则无法开始游戏！】";
         message.fontStyles = new TextFormat(GameFont.FONT_NAME,12,16777215,"left","top");
         message.width = right.width - 10;
         message.height = right.height - 64 - 5 - 100;
         this.addChild(message);
         message.x = right.x + 5;
         message.y = 105;
         _message = message;
         inputBG = new Quad(right.width,32,4473924);
         this.addChild(inputBG);
         inputBG.x = right.x;
         inputBG.y = stage.stageHeight - inputBG.height;
         textInput = new TextInput();
         this.addChild(textInput);
         textInput.width = right.width - 100;
         textInput.height = 32;
         textInput.x = right.x + 5;
         textInput.fontStyles = new TextFormat(GameFont.FONT_NAME,12,16777215,"left");
         textInput.y = stage.stageHeight - textInput.height;
         textInput.addEventListener("enter",function(e:Event):void
         {
            onDown(13);
         });
         _itext = textInput;
         send = new CommonButton("btn_style_1","start_main","发送消息");
         this.addChild(send);
         send.scale = 100 / send.width;
         send.x = stage.stageWidth - send.width / 2;
         send.y = stage.stageHeight - send.height / 2;
         send.callBack = function():void
         {
            onDown(13);
         };
         if(Service.client.type == "master")
         {
            Service.send({"type":"unlock"});
         }
      }
      
      public function onMapChange(e:Event) : void
      {
         var list:List = e.target as List;
         callLate(function():void
         {
            trace("地图变更",JSON.stringify(list.selectedItem));
            action("mapChange",{"index":list.selectedIndex});
         });
      }
      
      public function onPlayListChange(e:Event) : void
      {
         var item:RoomPayerItem = _list.itemToItemRenderer(_list.selectedItem) as RoomPayerItem;
         if(item)
         {
            item.change();
         }
         _list.selectedIndex = -1;
      }
      
      public function pushMessage(msg:String) : void
      {
         _message.text += "\n" + msg;
         _message.verticalScrollPosition = _message.maxVerticalScrollPosition + 32;
      }
      
      override public function onMessage(data:Object) : void
      {
         switch(data.action)
         {
            case "mapChange":
               if(data.index == -1)
               {
                  data.index = 0;
               }
               _mapList.selectedIndex = data.index;
               break;
            case "message":
               pushMessage(data.nickName + ":" + data.msg);
               break;
            case "play":
               trace("开始游戏模式",roomdata.mode,JSON.stringify(roomdata));
               SceneCore.replaceScene(new OnlineSelectRoleView(roomdata.mode,_mapList.selectedItem.target));
               Service.client.openUDP();
               Service.send({"type":"lock"});
         }
      }
      
      public function updateList() : void
      {
         _list.dataProvider.updateAll();
      }
      
      private function onExit(target:String) : void
      {
         trace("退出房间");
         Service.send(SendDataUtils.exitRoom(-1));
         SceneCore.replaceScene(new GameOnlineRoomListView());
      }
      
      private function onReady(target:String) : void
      {
         switch(target)
         {
            case "oline_play":
               if(cheakIsCanStart())
               {
                  SceneCore.pushView(new GameTipsView("开始游戏"));
                  action("play");
                  SceneCore.replaceScene(new OnlineSelectRoleView(roomdata.mode,_mapList.selectedItem.target));
                  Service.client.openUDP();
                  break;
               }
               SceneCore.pushView(new GameTipsView("玩家还没有准备"));
               break;
            case "oline_ready":
               _readyBtn.imageTarget = "oline_cannel";
               _readyBtn.imageDisplay.texture = DataCore.getTextureAtlas("start_main").getTexture(_readyBtn.imageTarget);
               isReday = true;
               break;
            case "oline_cannel":
               _readyBtn.imageTarget = "oline_ready";
               _readyBtn.imageDisplay.texture = DataCore.getTextureAtlas("start_main").getTexture(_readyBtn.imageTarget);
               isReday = false;
         }
      }
      
      public function set isReday(b:Boolean) : void
      {
         Service.send({"type":(b ? "ready" : "cannel")});
      }
      
      private function cheakIsCanStart() : Boolean
      {
         var playerCount:int = 0;
         if(isAllReady)
         {
            playerCount = 0;
            for(var i in this._list.dataProvider.data)
            {
               trace("cheak",this._list.dataProvider.data[i].name,this._list.dataProvider.data[i].type);
               if(this._list.dataProvider.data[i].type == "player")
               {
                  playerCount++;
               }
            }
            return playerCount == 1;
         }
         return false;
      }
      
      public function get isAllReady() : Boolean
      {
         for(var i in this._list.dataProvider.data)
         {
            if(this._list.dataProvider.data[i].isReady == false && this._list.dataProvider.data[i].type != "master")
            {
               return false;
            }
         }
         return true;
      }
      
      private function onJoinFunc(data:Object) : void
      {
         trace("加入的玩家",JSON.stringify(data));
      }
      
      private function onRoleListFunc(data:Object) : void
      {
         roomdata = data;
         _list.dataProvider = new ListCollection(data.list);
         updateList();
         if(Service.client.type == "master")
         {
            action("mapChange",{"index":_mapList.selectedIndex});
         }
      }
   }
}

