package game.world
{
   import game.data.Game;
   import game.data.OverTag;
   import game.role.GameRole;
   import game.view.GameOverView;
   import game.view.GameStartMain;
   import game.view.GameVSView;
   import zygame.core.DataCore;
   import zygame.core.SceneCore;
   
   public class _2V2LEVEL extends _2V2COM
   {
      
      public function _2V2LEVEL(mapName:String, toName:String)
      {
         super(mapName,toName);
      }
      
      override public function initRole() : void
      {
         super.initRole();
         this.isDoublePlayer = true;
         this.getRoleList()[1].ai = false;
         p2 = this.getRoleList()[1];
         changeRoleView.visible = false;
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
               SceneCore.replaceScene(new GameVSView(null,[loadRoles[0],loadRoles[1]],Game.levelData.currentFightArray));
            }
            else
            {
               SceneCore.replaceScene(new GameStartMain());
            }
         };
      }
      
      override public function replaceRole(prole:GameRole) : void
      {
      }
   }
}

