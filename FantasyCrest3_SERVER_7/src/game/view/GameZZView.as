package game.view
{
   import game.display.CommonButton;
   import starling.display.Image;
   import zygame.core.DataCore;
   import zygame.core.SceneCore;
   import zygame.display.DisplayObjectContainer;
   
   public class GameZZView extends DisplayObjectContainer
   {
      
      public function GameZZView()
      {
         super();
      }
      
      override public function onInit() : void
      {
         var tips:Image = new Image(DataCore.getTexture("zz_tips"));
         this.addChild(tips);
         tips.alignPivot();
         tips.x = stage.stageWidth / 2;
         tips.y = stage.stageHeight / 2;
         tips.scale = 0.5;
         var c:CommonButton = new CommonButton("btn_style_1","start_main","我知道了");
         this.addChild(c);
         c.x = stage.stageWidth / 2;
         c.y = stage.stageHeight - 40;
         c.callBack = exit;
      }
      
      private function exit() : void
      {
         SceneCore.removeView(this);
      }
   }
}

