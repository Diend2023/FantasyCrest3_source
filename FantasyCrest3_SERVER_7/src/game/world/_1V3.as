package game.world
{
   import game.data.Game;
   import game.data.LevelData;
   import game.data.OverTag;
   import game.role.GameRole;
   import game.view.GameOverView;
   import zygame.core.SceneCore;
   
   public class _1V3 extends _2V2
   {
      
      public function _1V3(mapName:String, toName:String)
      {
         super(mapName,toName);
      }
      
      override public function initRole() : void
      {
         super.initRole();
         this.getRoleList()[1].troopid = 1;
         this.getRoleList()[1].scaleX = -1;
         this.getRoleList()[2].ai = true;
         bindXY(this.getRoleList()[1],"2p");
         this.getRoleList()[1].addX(200);
         this.changeRoleView.visible = false;
      }
      
      override public function over() : void
      {
         var id:int = cheakGameOver();
         var gameOver:GameOverView = new GameOverView(fightData.data1,fightData.data2,id == 0 ? OverTag.GAME_WIN : OverTag.GAME_OVER);
         SceneCore.replaceScene(gameOver);
         Game.levelData = new LevelData(3);
      }
      
      override public function replaceRole(prole:GameRole) : void
      {
      }
   }
}

