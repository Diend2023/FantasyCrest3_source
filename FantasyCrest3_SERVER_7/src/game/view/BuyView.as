package game.view
{
   import game.display.CommonButton;
   import game.uilts.GameFont;
   import starling.display.Quad;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.core.SceneCore;
   import zygame.utils.ServerUtils;
   
   public class BuyView extends OnlineView
   {
      
      public var data:Object;
      
      public var shop:GameShopView;
      
      public function BuyView(ob:Object, view:GameShopView)
      {
         super();
         data = ob;
         shop = view;
      }
      
      override public function onInit() : void
      {
         var q:Quad;
         var tips:TextField;
         var ok:CommonButton;
         var ok2:CommonButton;
         var c:CommonButton;
         super.onInit();
         q = new Quad(stage.stageWidth,stage.stageHeight,0);
         q.alpha = 0.7;
         this.addChild(q);
         tips = new TextField(stage.stageWidth,32,"你将购买【" + data.roleName + "】，将花费" + data.xml.@coin + "金币或者" + data.xml.@crystal + "水晶。",new TextFormat(GameFont.FONT_NAME,24,16777215));
         this.addChild(tips);
         tips.y = stage.stageHeight / 2 - 15 - 100;
         ok = new CommonButton("btn_style_1","start_main","金币购买");
         this.addChild(ok);
         ok.x = stage.stageWidth / 2 - ok.width / 2;
         ok.y = 330;
         ok.alignPivot("left","top");
         ok.callBack = function():void
         {
            ServerUtils.buyRole(GameOnlineRoomListView._userName,GameOnlineRoomListView._userCode,data.roleName,data.roleTarget,-int(data.xml.@coin),0,function(userData:Object):void
            {
               if(userData)
               {
                  SceneCore.pushView(new GameTipsView("购买成功"));
                  shop.updateRoleUser(userData);
                  removeFromParent(true);
               }
               else
               {
                  SceneCore.pushView(new GameTipsView("购买失败"));
               }
            });
         };
         ok2 = new CommonButton("btn_style_1","start_main","水晶购买");
         this.addChild(ok2);
         ok2.x = stage.stageWidth / 2 - ok2.width / 2;
         ok2.y = ok.y - ok.height;
         ok2.alignPivot("left","top");
         ok2.callBack = function():void
         {
            trace(data.xml.@crystal,data.xml.@coin,(data.xml as XML).toXMLString());
            ServerUtils.buyRole(GameOnlineRoomListView._userName,GameOnlineRoomListView._userCode,data.roleName,data.roleTarget,-int(data.xml.@crystal),1,function(userData:Object):void
            {
               if(userData)
               {
                  SceneCore.pushView(new GameTipsView("购买成功"));
                  shop.updateRoleUser(userData);
                  removeFromParent(true);
               }
               else
               {
                  SceneCore.pushView(new GameTipsView("购买失败"));
               }
            });
         };
         c = new CommonButton("btn_style_1","start_main","取消");
         this.addChild(c);
         c.x = ok.x;
         c.y = ok.y + c.height;
         c.alignPivot("left","top");
         c.callBack = function():void
         {
            removeFromParent(true);
         };
      }
   }
}

