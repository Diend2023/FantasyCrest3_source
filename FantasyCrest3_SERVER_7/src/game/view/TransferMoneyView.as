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
   
   public class TransferMoneyView extends OnlineView
   {
      
      public function TransferMoneyView()
      {
         super();
      }
      
      override public function onInit() : void
      {
         var q:Quad;
         var text:TextField;
         var textInput:TextInput;
         var text2:TextField;
         var textInput2:TextInput;
         var ok:CommonButton;
         var cannel:CommonButton;
         super.onInit();
         q = new Quad(stage.stageWidth,stage.stageHeight,0);
         q.alpha = 0.7;
         this.addChild(q);
         text = new TextField(200,64,"转账金额：",new TextFormat(GameFont.FONT_NAME,24,16777215));
         this.addChild(text);
         text.x = stage.stageWidth / 2 - 300;
         text.y = stage.stageHeight / 2 - 32;
         textInput = new TextInput();
         this.addChild(textInput);
         textInput.x = text.x + 170;
         textInput.y = text.y;
         textInput.width = 300;
         textInput.height = 64;
         textInput.restrict = "0-9";
         textInput.maxChars = 10;
         textInput.fontStyles = new TextFormat(GameFont.FONT_NAME,24,16777215,"left");
         text2 = new TextField(200,64,"对方邮箱：",new TextFormat(GameFont.FONT_NAME,24,16777215));
         this.addChild(text2);
         text2.x = stage.stageWidth / 2 - 300;
         text2.y = stage.stageHeight / 2 - 92;
         textInput2 = new TextInput();
         this.addChild(textInput2);
         textInput2.x = text2.x + 170;
         textInput2.y = text2.y;
         textInput2.width = 300;
         textInput2.height = 64;
         textInput2.restrict = "0-9@a-zA-Z.";
         textInput2.fontStyles = new TextFormat(GameFont.FONT_NAME,24,16777215,"left");
         ok = new CommonButton("btn_style_1","start_main","确定转账");
         this.addChild(ok);
         ok.x = stage.stageWidth / 2 - ok.width / 2;
         ok.y = 266;
         ok.alignPivot("left","top");
         ok.callBack = function():void
         {
            ServerUtils.transferMoney(GameOnlineRoomListView._userName,GameOnlineRoomListView._userCode,int(textInput.text),0,textInput2.text,function(userData:Object):void
            {
               if(userData)
               {
                  if(GameStartMain.self)
                  {
                     GameStartMain.self.updateUserData(userData);
                  }
                  removeFromParent(true);
               }
               else
               {
                  SceneCore.pushView(new GameTipsView("转账失败！"));
               }
            });
         };
         cannel = new CommonButton("btn_style_1","start_main","取消");
         this.addChild(cannel);
         cannel.x = stage.stageWidth / 2 - ok.width / 2;
         cannel.y = 316;
         cannel.alignPivot("left","top");
         cannel.callBack = function():void
         {
            removeFromParent(true);
         };
      }
   }
}

