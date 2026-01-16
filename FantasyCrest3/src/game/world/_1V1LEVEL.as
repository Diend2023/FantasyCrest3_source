package game.world
{
   import game.data.Game;
   import game.data.OverTag;
   import game.view.GameOverView;
   import game.view.GameStartMain;
   import game.view.GameVSView;
   import zygame.core.DataCore;
   import zygame.core.SceneCore;
   
   public class _1V1LEVEL extends _1V1COM
   {
      
      public function _1V1LEVEL(mapName:String, toName:String)
      {
         super(mapName,toName);
      }
      
      override public function over() : void
      {
         var id:int = cheakGameOver();
         var gameOver:GameOverView = new GameOverView(fightData.data1,fightData.data2,id == 0 ? OverTag.GAME_WIN : OverTag.GAME_OVER);
         SceneCore.replaceScene(gameOver);
         gameOver.callBack = function():void
         {
            if(id == 0 && Game.levelData.nextFight())
            {
               DataCore.clearMapRoleData();
               SceneCore.replaceScene(new GameVSView(null,[loadRoles[0]],Game.levelData.currentFightArray));
            }
            else
            {
               SceneCore.replaceScene(new GameStartMain());
            }
         };
      }
   }
}

