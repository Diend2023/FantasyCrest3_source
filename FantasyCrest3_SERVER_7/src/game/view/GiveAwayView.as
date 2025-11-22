package game.view
{
   import feathers.controls.TextInput;
   import game.display.CommonButton;
   import game.uilts.GameFont;
   import starling.display.Quad;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.core.SceneCore;
   import zygame.utils.ServerUtils;
   
   public class GiveAwayView extends OnlineView
   {
      
      public var data:Object;
      
      public function GiveAwayView(ob:Object)
      {
         super();
         data = ob;
      }
      
      override public function onInit() : void
      {
         var q:Quad;
         var tips:TextField;
         var text:TextField;
         var textInput:TextInput;
         var ok:CommonButton;
         var ok2:CommonButton;
         var c:CommonButton;
         super.onInit();
         q = new Quad(stage.stageWidth,stage.stageHeight,0);
         q.alpha = 0.7;
         this.addChild(q);
         tips = new TextField(stage.stageWidth,32,"你将赠送【" + data.roleName + "】，将花费" + data.xml.@coin + "金币或者" + data.xml.@crystal + "水晶。",new TextFormat(GameFont.FONT_NAME,24,16777215));
         this.addChild(tips);
         tips.y = stage.stageHeight / 2 - 15;
         text = new TextField(200,64,"赠送账号：",new TextFormat(GameFont.FONT_NAME,32,16777215));
         this.addChild(text);
         text.x = stage.stageWidth / 2 - 300;
         text.y = stage.stageHeight / 2 - 80;
         textInput = new TextInput();
         this.addChild(textInput);
         textInput.x = text.x + 200;
         textInput.y = text.y;
         textInput.width = 300;
         textInput.height = 64;
         textInput.fontStyles = new TextFormat(GameFont.FONT_NAME,24,16777215,"left");
         ok = new CommonButton("btn_style_1","start_main","金币赠送");
         this.addChild(ok);
         ok.x = stage.stageWidth / 2 - ok.width / 2;
         ok.y = 330;
         ok.alignPivot("left","top");
         ok.callBack = function():void
         {
            if(textInput.text.length > 0)
            {
               ServerUtils.buyRole(GameOnlineRoomListView._userName,GameOnlineRoomListView._userCode,data.roleName,data.roleTarget,-int(data.xml.@coin),0,function(userData:Object):void
               {
                  if(userData)
                  {
                     SceneCore.pushView(new GameTipsView("赠送成功"));
                     removeFromParent(true);
                  }
                  else
                  {
                     SceneCore.pushView(new GameTipsView("赠送失败"));
                  }
               },textInput.text);
            }
         };
         ok2 = new CommonButton("btn_style_1","start_main","水晶赠送");
         this.addChild(ok2);
         ok2.x = stage.stageWidth / 2 - ok2.width / 2;
         ok2.y = ok.y - ok.height;
         ok2.alignPivot("left","top");
         ok2.callBack = function():void
         {
            if(textInput.text.length > 0)
            {
               trace(data.xml.@crystal,data.xml.@coin,(data.xml as XML).toXMLString());
               ServerUtils.buyRole(GameOnlineRoomListView._userName,GameOnlineRoomListView._userCode,data.roleName,data.roleTarget,-int(data.xml.@crystal),1,function(userData:Object):void
               {
                  if(userData)
                  {
                     SceneCore.pushView(new GameTipsView("赠送成功"));
                     removeFromParent(true);
                  }
                  else
                  {
                     SceneCore.pushView(new GameTipsView("赠送失败"));
                  }
               },textInput.text);
            }
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

