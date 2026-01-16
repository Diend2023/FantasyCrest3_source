package game.world
{
   import game.data.Game;
   import game.data.OverTag;
   import game.view.GameOverView;
   import game.view.GameStartMain;
   import game.view.GameStateView;
   import zygame.core.DataCore;
   import zygame.core.SceneCore;
   import zygame.display.BaseRole;
   import zygame.display.EventDisplay;
   
   public class _1VFB extends _FBBaseWorld
   {
      
      public function _1VFB(mapName:String, toName:String)
      {
         super(mapName,toName);
         lockOnline = true;
      }
      
      override public function initRole() : void
      {
         var xmllist:XMLList;
         var c:int;
         var num:int;
         var i:int;
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
         (state as GameStateView).getHPMP(2).visible = false;
         xmllist = DataCore.getXml("fuben").children();
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
         for(i = num - 2; i >= 0; )
         {
            this.getRoleList()[i].troopid = 1;
            this.getRoleList()[i].ai = true;
            attr(this.getRoleList()[i]);
            i--;
         }
         p1 = this.getRoleList()[this.getRoleList().length - 1];
         (state as GameStateView).bind(0,p1);
         p1.troopid = 0;
         bindXY(p1,"1p");
         role = p1;
         hitNumber.role = role;
         mathCenterPos();
         moveMap(1);
         this.isDoublePlayer = false;
         founcDisplay = p1;
      }
      
      override public function onFrame() : void
      {
         auto = !poltSystem.isRuning;
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
         var over:GameOverView;
         var id:int = cheakGameOver();
         var tag:String = OverTag.NONE;
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
            SceneCore.replaceScene(new GameStartMain());
         };
         SceneCore.replaceScene(over);
      }
      
      override public function ready() : void
      {
         var eventDisplay:EventDisplay = getEventFormName("polt");
         if(eventDisplay)
         {
            poltSystem.poltFormXML(eventDisplay.polt);
         }
      }
   }
}

