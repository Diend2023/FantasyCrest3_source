package game.view
{
   import feathers.controls.TextInput;
   import game.display.CommonButton;
   import game.uilts.GameFont;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.server.Service;
   import zygame.utils.SendDataUtils;
   
   public class OnlineCreateRoom extends OnlineView
   {
      
      public var mode:String = "普通模式";
      
      public var count:int = 2;
      
      public var code:String = "";
      
      public function OnlineCreateRoom()
      {
         super();
      }
      
      override public function onInit() : void
      {
         var t:TextField;
         var typeText:TextField;
         var mode1:CommonButton;
         var mode2:CommonButton;
         var mode3:CommonButton;
         var countText:TextField;
         var count1:CommonButton;
         var count2:CommonButton;
         var count3:CommonButton;
         var codeText:TextField;
         var codeInput:TextInput;
         var ok:CommonButton;
         var c:CommonButton;
         var q:Quad = new Quad(stage.stageWidth,stage.stageHeight,0);
         q.alpha = 0.7;
         this.addChild(q);
         t = new TextField(200,64,"- 创建房间 -",new TextFormat(GameFont.FONT_NAME,32,16777215));
         this.addChild(t);
         typeText = new TextField(200,64,"房间类型",new TextFormat(GameFont.FONT_NAME,24,16777215));
         this.addChild(typeText);
         typeText.y = 64;
         mode1 = new CommonButton("btn_style_1","start_main","普通模式");
         this.addChild(mode1);
         mode1.x = 200;
         mode1.y = 74;
         mode1.alignPivot("left","top");
         mode1.callBack = onSelectMode;
         mode1.name = "普通模式";
         mode2 = new CommonButton("btn_style_1","start_main","高端模式");
         this.addChild(mode2);
         mode2.x = 400;
         mode2.y = 74;
         mode2.alignPivot("left","top");
         mode2.callBack = onSelectMode;
         mode2.name = "高端模式";
         mode2.alpha = 0.5;
         mode3 = new CommonButton("btn_style_1","start_main","英雄之迹");
         this.addChild(mode3);
         mode3.x = 600;
         mode3.y = 74;
         mode3.alignPivot("left","top");
         mode3.callBack = onSelectMode;
         mode3.name = "英雄之迹";
         mode3.alpha = 0.5;
         countText = new TextField(200,64,"房间人数",new TextFormat(GameFont.FONT_NAME,24,16777215));
         this.addChild(countText);
         countText.y = 128;
         count1 = new CommonButton("btn_style_1","start_main","2人");
         this.addChild(count1);
         count1.x = 200;
         count1.y = 138;
         count1.alignPivot("left","top");
         count1.callBack = onSelectCount;
         count1.name = "2人";
         count2 = new CommonButton("btn_style_1","start_main","4人");
         this.addChild(count2);
         count2.x = 400;
         count2.y = 138;
         count2.alignPivot("left","top");
         count2.callBack = onSelectCount;
         count2.name = "4人";
         count2.alpha = 0.5;
         count3 = new CommonButton("btn_style_1","start_main","6人");
         this.addChild(count3);
         count3.x = 600;
         count3.y = 138;
         count3.alignPivot("left","top");
         count3.callBack = onSelectCount;
         count3.name = "6人";
         count3.alpha = 0.5;
         codeText = new TextField(200,64,"密码设置",new TextFormat(GameFont.FONT_NAME,24,16777215));
         this.addChild(codeText);
         codeText.y = 192;
         codeInput = new TextInput();
         codeInput.width = 600;
         codeInput.height = 64;
         codeInput.fontStyles = new TextFormat(GameFont.FONT_NAME,32,16777215,"left");
         this.addChild(codeInput);
         codeInput.y = 192;
         codeInput.x = 200;
         codeInput.restrict = "0-9a-zA-Z";
         codeInput.maxChars = 10;
         codeInput.addEventListener("change",onCodeChange);
         ok = new CommonButton("btn_style_1","start_main","完成");
         this.addChild(ok);
         ok.x = 32;
         ok.y = 266;
         ok.alignPivot("left","top");
         ok.callBack = function():void
         {
            trace("创建",mode,count + "人","密码：" + code);
            if(mode == "英雄之迹")
            {
               Service.send(SendDataUtils.createRoom(mode,2,code));
            }
            else
            {
               Service.send(SendDataUtils.createRoom(mode,count,code));
            }
         };
         c = new CommonButton("btn_style_1","start_main","取消");
         this.addChild(c);
         c.x = 232;
         c.y = 266;
         c.alignPivot("left","top");
         c.callBack = function():void
         {
            removeFromParent(true);
         };
      }
      
      public function onCodeChange(e:Event) : void
      {
         code = (e.target as TextInput).text;
      }
      
      public function onSelectMode(str:String) : void
      {
         mode = str;
         this.getChildByName("普通模式").alpha = 0.5;
         this.getChildByName("高端模式").alpha = 0.5;
         this.getChildByName("英雄之迹").alpha = 0.5;
         this.getChildByName(str).alpha = 1;
      }
      
      public function onSelectCount(str:String) : void
      {
         this.getChildByName("2人").alpha = 0.5;
         this.getChildByName("4人").alpha = 0.5;
         this.getChildByName("6人").alpha = 0.5;
         this.getChildByName(str).alpha = 1;
         switch(str)
         {
            case "2人":
               count = 2;
               break;
            case "4人":
               count = 4;
               break;
            case "6人":
               count = 6;
         }
      }
   }
}

