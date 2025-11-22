package game.view
{
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import game.display.CommonButton;
   import game.uilts.GameFont;
   import game.view.item.OnlineRoomItem;
   import starling.display.Image;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   import zygame.core.SceneCore;
   import zygame.display.DisplayObjectContainer;
   import zygame.server.Service;
   import zygame.utils.SendDataUtils;
   
   public class GameOnlineRoomListView extends DisplayObjectContainer
   {
      
      public static const curIP:String = "120.79.155.18";
      
      public static var _userName:String = "rainy";
      
      public static var _userCode:String = "rainy";
      
      public static var _userId:int = Math.random() * 9999;
      
      private var _list:List;
      
      private var _ip:String;
      
      private var _msg:TextField;
      
      public function GameOnlineRoomListView(ip:String = "120.79.155.18")
      {
         super();
         _ip = ip;
      }
      
      override public function onInit() : void
      {
         var ip:String;
         var msg:TextField;
         var textures:TextureAtlas = DataCore.getTextureAtlas("start_main");
         var bg:Image = new Image(textures.getTexture("bg"));
         this.addChild(bg);
         bg.alignPivot();
         bg.x = stage.stageWidth / 2;
         bg.y = stage.stageHeight / 2 + 32;
         if(Service.client && Service.client.connected)
         {
            showList();
            Service.send({"type":"room_list"});
         }
         else
         {
            ip = _ip;
            Service.startService(ip,4888,function():void
            {
               SceneCore.replaceScene(new GameStartMain());
               SceneCore.pushView(new GameTipsView("连接服务器失败"));
               trace("连接失败");
            },true);
            Service.client.handFunc = function():void
            {
               SceneCore.pushView(new GameTipsView("成功登录服务器"));
               Service.client.send(SendDataUtils.handData(_userName,_userCode));
               Service.client.userName = _userName;
               Service.client.userCode = _userCode;
               showList();
            };
            Service.client.closeFunc = function():void
            {
               SceneCore.replaceScene(new GameStartMain());
               SceneCore.pushView(new GameTipsView("连接服务器失败"));
               trace("连接失败");
            };
         }
         Service.client.messageFunc = onMessage;
         Service.client.roomlistFunc = onRoomList;
         Service.client.createRoom = onCreateRoom;
         Service.client.userDataFunc = onUserData;
         msg = new TextField(stage.stageWidth,32,"在线人数：0",new TextFormat(GameFont.FONT_NAME,12,16776960,"left"));
         this.addChild(msg);
         msg.x = msg.y = 5;
         _msg = msg;
      }
      
      private function onUserData(data:Object) : void
      {
         trace("用户数据：",JSON.stringify(data));
      }
      
      private function onCreateRoom(data:Object) : void
      {
         if(GameCore.currentWorld == null || GameCore.currentWorld.parent == null)
         {
            SceneCore.replaceScene(new GameOnlineRoomView(data));
         }
      }
      
      private function onRoomList(data:Object) : void
      {
         trace(JSON.stringify(data));
         _list.dataProvider = new ListCollection(data.list);
         _msg.text = "在线人数：" + data.count;
      }
      
      private function onMessage(data:Object) : void
      {
         trace(JSON.stringify(data));
      }
      
      public function showList() : void
      {
         var textures:TextureAtlas = DataCore.getTextureAtlas("start_main");
         var bg:Image = new Image(textures.getTexture("oline_bg"));
         this.addChild(bg);
         bg.x = stage.stageWidth / 2;
         bg.y = stage.stageHeight / 2;
         bg.alignPivot();
         var create:CommonButton = new CommonButton("oline_create","start_main");
         this.addChild(create);
         create.x = bg.x + bg.width / 2 - create.width / 2 - 15;
         create.y = bg.y - bg.height / 2 + create.height / 2 + 15;
         create.callBack = createRoom;
         var exit:CommonButton = new CommonButton("btn_style_1","start_main","返回");
         this.addChild(exit);
         exit.x = create.x - exit.width - 10;
         exit.y = create.y;
         exit.callBack = onExit;
         _list = new List();
         this.addChild(_list);
         _list.x = bg.x - bg.width / 2 + 35;
         _list.y = bg.y - bg.height / 2 + 80;
         _list.width = bg.width;
         _list.height = 300;
         _list.itemRendererType = OnlineRoomItem;
         _list.addEventListener("change",onChange);
      }
      
      public function onExit(target:String) : void
      {
         Service.client.close();
         Service.client = null;
         SceneCore.replaceScene(new GameStartMain());
      }
      
      private function onChange(e:Event) : void
      {
         if(_list.selectedItem)
         {
            if(_list.selectedItem.code != "")
            {
               SceneCore.pushView(new JoinCodeView(_list.selectedItem.id));
            }
            else
            {
               Service.client.send(SendDataUtils.joinRoom(_list.selectedItem.id,""));
            }
            _list.selectedIndex = -1;
         }
      }
      
      private function createRoom() : void
      {
         SceneCore.pushView(new OnlineCreateRoom());
      }
   }
}

