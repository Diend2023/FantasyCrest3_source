package game.world
{
   import game.data.Game;
   import game.data.LevelData;
   import game.data.OverTag;
   import game.view.GameOverView;
   import zygame.core.SceneCore;
   import zygame.display.BaseRole;
   
   public class _3V1 extends _2V2
   {
      
      public function _3V1(mapName:String, toName:String)
      {
         super(mapName,toName);
      }
      
      override public function initRole() : void
      {
         super.initRole();
         this.getRoleList()[2].troopid = 0;
         this.getRoleList()[2].scaleX = 1;
         this.getRoleList()[2].ai = true;
         bindXY(this.getRoleList()[2],"1p");
         this.getRoleList()[2].addX(-200);
         var boss:BaseRole = this.getRoleList()[3];
         boss.contentScale += 0.5;
         var value:Number = 5;
         boss.attribute.hpmax *= value;
         boss.attribute.hp *= value;
         boss.attribute.power *= value;
         boss.attribute.magic *= value;
         this.p1assist.splice(0,this.p1assist.length);
         this.p2assist.splice(0,this.p2assist.length);
         this.p1assist.push(this.getRoleList()[1],this.getRoleList()[2]);
         this.changeRoleView.update();
      }
      
      override public function over() : void
      {
         var id:int = cheakGameOver();
         var gameOver:GameOverView = new GameOverView(fightData.data1,fightData.data2,id == 0 ? OverTag.GAME_WIN : OverTag.GAME_OVER);
         SceneCore.replaceScene(gameOver);
         Game.levelData = new LevelData(1);
      }
   }
}

