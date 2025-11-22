package game.view
{
   import game.display.CommonButton;
   import starling.display.Quad;
   import zygame.core.GameCore;
   import zygame.core.SceneCore;
   import zygame.display.KeyDisplayObject;
   
   public class GamePauseView extends KeyDisplayObject
   {
      
      public function GamePauseView()
      {
         super();
      }
      
      override public function onInit() : void
      {
         super.onInit();
         var bg:Quad = new Quad(stage.stageWidth,stage.stageHeight,0);
         this.addChild(bg);
         bg.alpha = 0.5;
         createBtn("返回主界面",stage.stageHeight / 2 - 84,69);
         createBtn("出招表",stage.stageHeight / 2 - 42,81);
         createBtn("返回选择",stage.stageHeight / 2 - 0,88);
         createBtn("继续游戏",stage.stageHeight / 2 - -42,13);
         this.openKey();
      }
      
      public function createBtn(target:String, y:int, key:int) : void
      {
         var exit:CommonButton = new CommonButton("btn_style_1","start_main",target);
         this.addChild(exit);
         exit.scale = 100 / exit.width;
         exit.x = stage.stageWidth / 2;
         exit.y = y;
         exit.callBack = function():void
         {
            if(key == 13)
            {
               GameCore.currentWorld.onDown(key);
            }
            else
            {
               onDown(key);
            }
         };
      }
      
      override public function onDown(key:int) : void
      {
         var hero:GameHeroView;
         super.onDown(key);
         switch(key)
         {
            case 69:
               this.clearKey();
               GameCore.currentWorld.discarded();
               SceneCore.replaceScene(new GameStartMain());
               break;
            case 88:
               this.clearKey();
               SceneCore.replaceScene(GameSelectView.currentSelectView);
               break;
            case 81:
               hero = new GameHeroView();
               SceneCore.pushView(hero);
               hero.removeButton.callBack = function():void
               {
                  hero.removeFromParent(true);
               };
         }
      }
   }
}

