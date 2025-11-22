package game.view
{
   import feathers.controls.TextInput;
   import game.display.CommonButton;
   import game.uilts.GameFont;
   import starling.display.Quad;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.server.Service;
   import zygame.utils.SendDataUtils;
   
   public class JoinCodeView extends OnlineView
   {
      
      private var roomid:int = 0;
      
      public function JoinCodeView(id:int)
      {
         super();
         roomid = id;
      }
      
      override public function onInit() : void
      {
         var q:Quad;
         var text:TextField;
         var textInput:TextInput;
         var ok:CommonButton;
         super.onInit();
         q = new Quad(stage.stageWidth,stage.stageHeight,0);
         q.alpha = 0.7;
         this.addChild(q);
         text = new TextField(200,64,"输入密码：",new TextFormat(GameFont.FONT_NAME,32,16777215));
         this.addChild(text);
         text.x = stage.stageWidth / 2 - 300;
         text.y = stage.stageHeight / 2 - 32;
         textInput = new TextInput();
         this.addChild(textInput);
         textInput.x = text.x + 200;
         textInput.y = text.y;
         textInput.width = 300;
         textInput.height = 64;
         textInput.restrict = "0-9a-zA-Z";
         textInput.maxChars = 10;
         textInput.fontStyles = new TextFormat(GameFont.FONT_NAME,32,16777215,"left");
         ok = new CommonButton("btn_style_1","start_main","完成");
         this.addChild(ok);
         ok.x = stage.stageWidth / 2 - ok.width / 2;
         ok.y = 330;
         ok.alignPivot("left","top");
         ok.callBack = function():void
         {
            Service.client.send(SendDataUtils.joinRoom(roomid,textInput.text));
            removeFromParent(true);
         };
      }
   }
}

