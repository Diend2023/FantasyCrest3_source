package game.world
{
   import game.data.Game;
   import game.data.OverTag;
   import game.server.AccessRun3Model;
   import game.server.HostRun2Model;
   import game.view.GameOnlineRoomView;
   import game.view.GameOverView;
   import game.view.GameStateView;
   import zygame.ai.AiHeart;
   import zygame.core.DataCore;
   import zygame.core.SceneCore;
   import zygame.display.BaseRole;
   import zygame.server.Service;
   
   public class _2VFBOnline extends _FBBaseWorld
   {
      
      private var _isInit:Boolean = false;
      
      public function _2VFBOnline(mapName:String, toName:String)
      {
         super(mapName,toName);
      }
      
      override public function initRole() : void
      {
         var c:int;
         var num:int;
         var i:int;
         var p3:BaseRole;
         var attr:* = function(r:BaseRole):void
         {
            var a:int = 0;
            var value:Number = NaN;
            for(a = 0; a < xmllist.length(); )
            {
               if(r.targetName == String((xmllist[a] as XML).localName()))
               {
                  if(xmllist[a].@scale != undefined)
                  {
                     r.contentScale = Number(xmllist[a].@scale);
                  }
                  if(xmllist[a].@level != undefined)
                  {
                     value = Number(xmllist[a].@level);
                     r.attribute.hpmax *= value;
                     r.attribute.hp *= value;
                     r.attribute.power *= value;
                     r.attribute.magic *= value;
                  }
                  break;
               }
               a++;
            }
         };
         var xmllist:XMLList = DataCore.getXml("fuben").children();
         for(c = 0; c < xmllist.length(); )
         {
            if(String(xmllist[c].@target) == targetName)
            {
               xmllist = (xmllist[c] as XML).children();
               break;
            }
            c++;
         }
         num = int(this.getRoleList().length);
         for(i = num - 3; i >= 0; )
         {
            this.getRoleList()[i].troopid = 1;
            this.getRoleList()[i].ai = true;
            attr(this.getRoleList()[i]);
            i--;
         }
         p1 = this.getRoleList()[this.getRoleList().length - 2];
         p2 = this.getRoleList()[this.getRoleList().length - 1];
         (state as GameStateView).bind(0,p1);
         (state as GameStateView).bind(1,p2);
         p1.troopid = 0;
         p2.troopid = 0;
         p2.ai = false;
         p2.setAi(new AiHeart(p2,DataCore.getXml("ordinary")));
         bindXY(p1,"1p");
         bindXY(p2,"2p");
         role = p1;
         hitNumber.role = role;
         p2.scaleX = -1;
         mathCenterPos();
         moveMap(1);
         this.isDoublePlayer = false;
         p1.troopid == p2.troopid;
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
         if(!_isInit)
         {
            _isInit = true;
         }
         founcDisplay = p1;
         lockOnline = true;
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
      }
      
      override public function end() : void
      {
         over();
      }
      
      override public function cheakGameOver() : int
      {
         var arr:Array = [];
         for(var i in getRoleList())
         {
            if(arr.indexOf(getRoleList()[i].troopid) == -1)
            {
               arr.push(getRoleList()[i].troopid);
            }
         }
         if(arr.indexOf(0) == -1)
         {
            return arr[0];
         }
         return arr.length <= 1 ? arr[0] : -1;
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
         if(id == 0)
         {
            tag = OverTag.GAME_WIN;
            Game.fbData.addWinTimes(targetName);
         }
         else
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

