package game.view.item
{
   import game.display.CommonButton;
   import game.uilts.GameFont;
   import game.view.GameOnlineRoomListView;
   import starling.display.Image;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.core.DataCore;
   import zygame.display.BaseItem;
   import zygame.server.Service;
   import zygame.utils.SendDataUtils;
   
   public class RoomPayerItem extends BaseItem
   {
      
      private var _text:TextField;
      
      private var _icon:Image;
      
      private var _button:CommonButton;
      
      public function RoomPayerItem()
      {
         var button:CommonButton;
         super();
         _text = new TextField(200,32,"测试",new TextFormat(GameFont.FONT_NAME,12,16777215,"left"));
         this.addChild(_text);
         this.width = 200;
         this.height = 32;
         _text.x = 26;
         button = new CommonButton("button_syste_2","start_main","观战");
         this.addChild(button);
         button.x = 200 - button.width;
         button.alignPivot("left","top");
         button.textBind.format = new TextFormat(GameFont.FONT_NAME,12,0);
         button.callBack = function():void
         {
            trace("切换");
         };
         _button = button;
      }
      
      public function change() : void
      {
         if(data.name == GameOnlineRoomListView._userName)
         {
            if(_button && _button.visible && _button.textBind.text != "已准备")
            {
               switch(_button.textBind.text)
               {
                  case "观战":
                     Service.send(SendDataUtils.changeRole("watching"));
                     break;
                  case "出战":
                     Service.send(SendDataUtils.changeRole("player"));
               }
            }
         }
      }
      
      override public function set data(value:Object) : void
      {
         super.data = value;
         if(value)
         {
            if(!_icon)
            {
               _icon = new Image(DataCore.getTextureAtlas("start_main").getTexture("home"));
               this.addChild(_icon);
               _icon.y = 8;
               _icon.x = 8;
            }
            _button.visible = true;
            switch(value.type)
            {
               case "master":
                  _button.visible = false;
                  _icon.texture = DataCore.getTextureAtlas("start_main").getTexture("home");
                  break;
               case "watching":
                  _icon.texture = DataCore.getTextureAtlas("start_main").getTexture("player_eye");
                  _button.textBind.text = "出战";
                  break;
               case "player":
                  _button.textBind.text = "观战";
            }
            if(value.type == "player")
            {
               _icon.visible = false;
            }
            else if(value.type == "watching")
            {
               _icon.visible = true;
            }
            if(value.name != GameOnlineRoomListView._userName)
            {
               _button.textBind.text = "等待";
            }
            _text.text = value.nickName;
            if(value.isReady)
            {
               _button.textBind.text = "已准备";
            }
         }
      }
   }
}

