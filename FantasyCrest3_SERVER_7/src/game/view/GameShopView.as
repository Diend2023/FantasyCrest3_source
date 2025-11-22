package game.view
{
   import game.data.SelectGroupConfig;
   import game.display.CommonButton;
   import game.display.SelectRole;
   import game.uilts.GameFont;
   import game.world.BaseGameWorld;
   import starling.display.Image;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.core.SceneCore;
   import zygame.display.World;
   import zygame.server.Service;
   import zygame.utils.ServerUtils;
   
   public class GameShopView extends OnlineView
   {
      
      private var _select:SelectRole;
      
      private var _coinText:TextField;
      
      private var _crystalText:TextField;
      
      public function GameShopView()
      {
         super();
      }
      
      override public function onInit() : void
      {
         var textureAtlas:TextureAtlas;
         var bg:Image;
         var config:SelectGroupConfig;
         var selectRole:SelectRole;
         var icon:Image;
         var coinText:TextField;
         var cry:Image;
         var remove:CommonButton;
         super.onInit();
         World.defalutClass = BaseGameWorld;
         textureAtlas = DataCore.getTextureAtlas("select_role");
         bg = new Image(DataCore.getTexture("select_role_bg"));
         this.addChild(bg);
         bg.x = stage.stageWidth / 2;
         bg.y = stage.stageHeight / 2;
         bg.scaleX = -1;
         bg.alignPivot();
         config = new SelectGroupConfig();
         config.selectCount = 1;
         config.showFight = true;
         config.showActhor = true;
         config.isShowAll = true;
         config.showCoinRole = true;
         selectRole = new SelectRole(255,config);
         this.addChild(selectRole);
         _select = selectRole;
         _select.lockButton.callBack = onBuy;
         _select.zsongButton.callBack = onZSongBuy;
         _select.onSelectChange = onChange;
         icon = new Image(DataCore.getTextureAtlas("start_main").getTexture("coin"));
         this.addChild(icon);
         icon.x = stage.stageWidth / 2 - 74;
         icon.y = 16;
         coinText = new TextField(100,32,"99999",new TextFormat(GameFont.FONT_NAME,15,16777215));
         this.addChild(coinText);
         coinText.x = stage.stageWidth / 2 - 60;
         coinText.y = 8;
         _coinText = coinText;
         cry = new Image(DataCore.getTextureAtlas("start_main").getTexture("crystal"));
         this.addChild(cry);
         cry.x = stage.stageWidth / 2 - 74;
         cry.y = 40;
         cry.scale = 0.5;
         _crystalText = new TextField(100,32,"0",new TextFormat(GameFont.FONT_NAME,15,16777215));
         this.addChild(_crystalText);
         _crystalText.x = coinText.x;
         _crystalText.y = coinText.y + 24;
         coinText.text = Service.userData.coin;
         _crystalText.text = Service.userData.crystal;
         remove = new CommonButton("关闭");
         this.addChild(remove);
         remove.x = 76;
         remove.y = remove.height / 2 + 7;
         remove.callBack = function():void
         {
            clearKey();
            SceneCore.replaceScene(new GameStartMain());
         };
         this.openKey();
      }
      
      public function onZSongBuy() : void
      {
         var r:XML = getBuyCoin(_select.currentSelectItem.target);
         SceneCore.pushView(new GiveAwayView({
            "roleTarget":_select.currentSelectItem.target,
            "roleName":_select.currentSelectItem.name,
            "xml":r
         }));
      }
      
      public function updateRoleUser(userData:Object) : void
      {
         Service.userData = userData;
         _select.list.dataProvider.updateAll();
         SceneCore.pushView(new GameTipsView("购买成功"));
         _coinText.text = Service.userData.coin;
         _crystalText.text = Service.userData.crystal;
      }
      
      public function onBuy() : void
      {
         var buyType:int;
         var data:XML;
         var coin:int;
         var r:XML;
         if(_select.currentSelectItem.lock)
         {
            buyType = getBuyType(_select.currentSelectItem.target);
            data = getBuyCoin(_select.currentSelectItem.target);
            if(data.@coin == undefined)
            {
               coin = int(buyType == 0 ? data.@coin : data.@crystal);
               ServerUtils.buyRole(GameOnlineRoomListView._userName,GameOnlineRoomListView._userCode,_select.currentSelectItem.name,_select.currentSelectItem.target,-coin,buyType,function(userData:Object):void
               {
                  if(!userData)
                  {
                     SceneCore.pushView(new GameTipsView(buyType == 0 ? "金币不足" : "水晶不足"));
                     return;
                  }
                  updateRoleUser(userData);
               });
            }
            else
            {
               r = getBuyCoin(_select.currentSelectItem.target);
               SceneCore.pushView(new BuyView({
                  "roleTarget":_select.currentSelectItem.target,
                  "roleName":_select.currentSelectItem.name,
                  "xml":r
               },this));
            }
         }
         else
         {
            SceneCore.pushView(new GameTipsView("已购买"));
         }
      }
      
      public function getBuyType(target:String) : int
      {
         var list:XMLList = DataCore.getXml("fight").children();
         for(var i in list)
         {
            if((list[i] as XML).localName() == target)
            {
               if(list[i].@crystal != undefined)
               {
                  return 1;
               }
               return 0;
            }
         }
         return -1;
      }
      
      public function getBuyCoin(target:String) : XML
      {
         var list:XMLList = DataCore.getXml("fight").children();
         for(var i in list)
         {
            if((list[i] as XML).localName() == target)
            {
               return list[i];
            }
         }
         return null;
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
               break;
            case 85:
               _select.onDown(key);
         }
      }
   }
}

