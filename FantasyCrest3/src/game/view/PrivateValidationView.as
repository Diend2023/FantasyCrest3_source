package game.view
{
   import game.data.Game;
   import game.data.PrivateTest;
   import game.uilts.GameFont;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.display.DisplayObjectContainer;
   
   public class PrivateValidationView extends DisplayObjectContainer
   {
      
      public var call:Function;
      
      public function PrivateValidationView()
      {
         super();
      }
      
      override public function onInit() : void
      {
         var text:TextField;
         var bg:Quad = new Quad(stage.stageWidth,stage.stageHeight,0);
         this.addChild(bg);
         bg.alpha = 0.8;
         text = new TextField(300,300,"用户[" + Game.game4399Tools.userName + "]验证通信中...",new TextFormat(GameFont.FONT_NAME,12,16776960));
         this.addChild(text);
         text.alignPivot();
         text.x = stage.stageWidth / 2;
         text.y = stage.stageHeight / 2;
         PrivateTest.validation(Game.game4399Tools.userName,function(code:int):void
         {
            if(code == 0)
            {
               if(call != null)
               {
                  call(0);
               }
               removeFromParent();
            }
            else
            {
               text.text = "用户[" + Game.game4399Tools.userName + "]验证失败\n请登录已验证的账号，3秒后关闭窗口。";
               Starling.juggler.delayCall(function():void
               {
                  if(call != null)
                  {
                     call(Game.game4399Tools.userName != null ? 1 : 2);
                  }
                  removeFromParent();
               },3);
            }
         });
      }
   }
}

