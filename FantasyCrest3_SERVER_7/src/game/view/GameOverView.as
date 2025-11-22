package game.view
{
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import game.data.Game;
   import game.data.OverTag;
   import game.display.CommonButton;
   import game.view.item.OverItem;
   import game.world._1V1LEVEL;
   import game.world._1V1Online;
   import game.world._1V3;
   import game.world._1VFB;
   import game.world._2V2LEVEL;
   import game.world._2VFBOnline;
   import game.world._3V1;
   import starling.display.Image;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.core.SceneCore;
   import zygame.display.DisplayObjectContainer;
   import zygame.display.World;
   import zygame.server.Service;
   import zygame.utils.ServerUtils;
   
   public class GameOverView extends DisplayObjectContainer
   {
      
      private var data1:Array;
      
      private var data2:Array;
      
      public var tag:String;
      
      public var callBack:Function = null;
      
      public function GameOverView(data1p:Array, data2p:Array, overTag:String)
      {
         super();
         data1 = data1p;
         data2 = data2p;
         tag = overTag;
         Game.save();
      }
      
      override public function onInit() : void
      {
         var textureAtlas:TextureAtlas;
         var bg:Image;
         var tips:Image;
         var wbg:Image;
         var list1:List;
         var list2:List;
         var tagImage:Image;
         var close:CommonButton;
         var submit:CommonButton;
         var coin:int;
         var userData:Object;
         super.onInit();
         textureAtlas = DataCore.getTextureAtlas("select_role");
         bg = new Image(DataCore.getTexture("select_role_bg"));
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
         list1 = new List();
         this.addChild(list1);
         list1.y = 80;
         list1.x = 0;
         list1.height = stage.stageHeight - 180;
         list1.width = stage.stageWidth / 2;
         list1.itemRendererType = OverItem;
         list2 = new List();
         this.addChild(list2);
         list2.y = 80;
         list2.x = stage.stageWidth / 2;
         list2.height = stage.stageHeight - 180;
         list2.width = stage.stageWidth / 2;
         list2.itemRendererType = OverItem;
         if(tag == OverTag.GAME_OVER || tag == OverTag.GAME_WIN || tag == OverTag.NONE)
         {
            tagImage = new Image(textureAtlas.getTexture(tag));
            this.addChild(tagImage);
            tagImage.alignPivot();
            tagImage.x = stage.stageWidth / 2;
            tagImage.y = stage.stageHeight - 54;
         }
         list1.dataProvider = new ListCollection(data1);
         list2.dataProvider = new ListCollection(data2);
         close = new CommonButton("continue");
         this.addChild(close);
         close.x = stage.stageWidth - close.width / 2 - 5;
         close.y = stage.stageHeight - close.height / 2 - 17;
         close.callBack = onExit;
         if(!Game.game4399Tools.logInfo && false)
         {
            submit = new CommonButton("submit","select_role");
            this.addChild(submit);
            submit.x = close.x - submit.width - 10;
            submit.y = close.y;
            submit.callBack = onSubmit;
         }
         coin = Math.random() * 14 + 1;
         userData = {
            "fight":Game.forceData.toSaveData(),
            "fbs":Game.fbData.toSaveData()
         };
         if(World.defalutClass == _1V1Online && tag != OverTag.NONE)
         {
            if(tag == OverTag.GAME_OVER)
            {
               if(Service.client.type == "master")
               {
                  Game.onlineData.pushOver(data1[0].target,data1[0].timeHurt);
               }
               else
               {
                  Game.onlineData.pushOver(data2[0].target,data2[0].timeHurt);
               }
            }
            else if(tag == OverTag.GAME_WIN)
            {
               if(Service.client.type == "master")
               {
                  Game.onlineData.pushWin(data1[0].target,data1[0].timeHurt);
               }
               else
               {
                  Game.onlineData.pushWin(data2[0].target,data2[0].timeHurt);
               }
            }
            userData.ofigth = Game.onlineData.toSaveData();
            trace("用户信息：",JSON.stringify(userData.ofigth));
         }
         if(tag == OverTag.GAME_WIN)
         {
            switch(World.defalutClass)
            {
               case _2VFBOnline:
               case _1V1LEVEL:
               case _1V3:
               case _1V1Online:
               case _2V2LEVEL:
               case _3V1:
               case _1VFB:
                  SceneCore.pushView(new GameTipsView("获得金币" + coin + "个"));
                  if(Service.client != null && Service.client.connected == true)
                  {
                     Service.client.send({
                        "type":"update_user_data",
                        "userData":userData
                     });
                     Service.client.send({
                        "type":"addCoin",
                        "coin":coin
                     });
                     break;
                  }
                  ServerUtils.updateRoleData(GameOnlineRoomListView._userName,GameOnlineRoomListView._userCode,userData,function(userData:Object):void
                  {
                     ServerUtils.addCoin(GameOnlineRoomListView._userName,GameOnlineRoomListView._userCode,coin,function(userData:Object):void
                     {
                        Service.userData = userData;
                     });
                  });
                  SceneCore.pushView(new Communication());
            }
         }
      }
      
      public function onSubmit() : void
      {
         if(Game.game4399Tools.serviceHold)
         {
            if(!Game.game4399Tools.logInfo)
            {
               SceneCore.pushView(new GameTipsView("正在提交..."));
               Game.game4399Tools.getData(0);
            }
            else
            {
               SceneCore.pushView(new GameTipsView("已提交"));
            }
         }
         else
         {
            SceneCore.pushView(new GameTipsView("上下文丢失"));
         }
      }
      
      public function onExit() : void
      {
         if(callBack != null)
         {
            callBack();
            callBack = null;
         }
         else
         {
            SceneCore.removeView(this);
            SceneCore.replaceScene(GameSelectView.currentSelectView);
            DataCore.clearMapRoleData();
         }
      }
   }
}

