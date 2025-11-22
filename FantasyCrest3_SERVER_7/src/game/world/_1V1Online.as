package game.world
{
   import game.data.Game;
   import game.data.OverTag;
   import game.server.AccessRun3Model;
   import game.server.HostRun2Model;
   import game.view.GameOnlineRoomView;
   import game.view.GameOverView;
   import zygame.core.SceneCore;
   import zygame.display.BaseRole;
   import zygame.server.Service;
   
   public class _1V1Online extends _1V1
   {
      
      private var _isInit:Boolean = false;
      
      public function _1V1Online(mapName:String, toName:String)
      {
         super(mapName,toName);
      }
      
      override public function initRole() : void
      {
         var p3:BaseRole = null;
         var roleTarget:String = null;
         var userData:Object = null;
         super.initRole();
         this.isDoublePlayer = false;
         if(Service.client.type == "player" || Service.client.type == "watching")
         {
            p3 = p1;
            p1 = p2;
            p2 = p3;
            role = p1;
            this.runModel = new AccessRun3Model("role1");
            this.auto = false;
         }
         else
         {
            this.runModel = new HostRun2Model("role0");
            this.auto = false;
         }
         founcDisplay = p1;
         if(!_isInit)
         {
            _isInit = true;
            roleTarget = p1.targetName;
            Game.onlineData.getData(roleTarget).addFightTimes();
            Game.onlineData.getData(roleTarget).isGetUp = true;
            userData = {"ofigth":Game.onlineData.toSaveData()};
            Service.client.send({
               "type":"update_user_data",
               "userData":userData
            });
         }
         this.startInitCD();
      }
      
      override public function over() : void
      {
         var i:Object;
         var id:int;
         var tag:String;
         var over:GameOverView;
         for(i in GameOnlineRoomView.roomdata.list)
         {
            GameOnlineRoomView.roomdata.list[i].isReady = false;
         }
         id = cheakGameOver();
         tag = OverTag.NONE;
         if(id == 0 && Service.client.type == "master")
         {
            tag = OverTag.GAME_WIN;
         }
         else if(id == 1 && Service.client.type == "player")
         {
            tag = OverTag.GAME_WIN;
         }
         else if(id == 0 && Service.client.type == "player")
         {
            tag = OverTag.GAME_OVER;
         }
         else if(id == 1 && Service.client.type == "master")
         {
            tag = OverTag.GAME_OVER;
         }
         over = new GameOverView(fightData.data1,fightData.data2,tag);
         over.callBack = function():void
         {
            SceneCore.replaceScene(new GameOnlineRoomView(GameOnlineRoomView.roomdata));
         };
         SceneCore.replaceScene(over);
      }
   }
}

