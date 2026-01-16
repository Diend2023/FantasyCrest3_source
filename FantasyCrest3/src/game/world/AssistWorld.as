package game.world
{
   import game.role.GameRole;
   import game.view.GameChangeRoleTipsView;
   import game.view.GameStateView;
   import starling.animation.Tween;
   import starling.core.Starling;
   import zygame.display.BaseRole;
   import zygame.display.WorldState;
   
   public class AssistWorld extends BaseGameWorld
   {
      
      public var p1assist:Array;
      
      public var p2assist:Array;
      
      public var p1change:Boolean = false;
      
      public var p2change:Boolean = false;
      
      private var tween:Array = [];
      
      public var changeRoleView:GameChangeRoleTipsView;
      
      public function AssistWorld(mapName:String, toName:String)
      {
         super(mapName,toName);
         p1assist = [];
         p2assist = [];
      }
      
      override public function addStateContent(pstate:WorldState) : void
      {
         super.addStateContent(pstate);
      }
      
      public function createChangeTipsView() : void
      {
         changeRoleView = new GameChangeRoleTipsView(p1assist,p2assist);
         changeRoleView.y = 120;
         state.addChild(changeRoleView);
      }
      
      public function outRole(prole:BaseRole) : void
      {
         var tw:Tween;
         tween.push(prole);
         tw = new Tween(prole,0.5,"easeOut");
         tw.animate("posx",prole.x - 100 * prole.scaleX);
         tw.animate("posy",prole.y - stage.stageHeight);
         tw.onComplete = function():void
         {
            prole.display.alpha = 0;
            tween.removeAt(tween.indexOf(prole));
         };
         Starling.juggler.add(tw);
         prole.body.space = null;
         prole.hitBody.space = null;
         this["p" + (prole.troopid + 1) + "assist"].push(prole);
         this.roles.removeAt(this.roles.indexOf(prole));
      }
      
      public function enterRole(prole:BaseRole) : void
      {
         var tw:Tween;
         var hrole:BaseRole;
         tween.push(prole);
         tw = new Tween(prole,0.5,"easeIn");
         hrole = null;
         if(prole.troopid == 0)
         {
            hrole = p1;
            p1 = prole;
         }
         else
         {
            hrole = p2;
            p2 = prole;
         }
         prole.display.alpha = 1;
         prole.posx = hrole.x - 200 * prole.scaleX;
         prole.posy = hrole.y - stage.stageHeight;
         if(prole.posx < 60)
         {
            prole.posx = 60;
         }
         else if(prole.posx > map.getWidth() - 60)
         {
            prole.posx = map.getWidth() - 60;
         }
         tw.animate("posx",hrole.x);
         tw.animate("posy",hrole.y);
         tw.onComplete = function():void
         {
            prole.body.space = nape;
            prole.hitBody.space = nape;
            tween.removeAt(tween.indexOf(prole));
         };
         Starling.juggler.add(tw);
         roles.push(prole);
         (state as GameStateView).bind(prole.troopid,prole);
         if(prole.troopid == 0)
         {
            role = prole;
         }
      }
      
      override public function overCheak() : void
      {
         var id:int = cheakGameOver();
         if(id != -1)
         {
            if(id == 1 && p1assist.length > 0)
            {
               enterRole(p1assist[0]);
               p1assist.shift();
            }
            else if(id == 0 && p2assist.length > 0)
            {
               enterRole(p2assist[0]);
               p2assist.shift();
            }
            else
            {
               trace("战斗结束，胜利队伍：",id);
               gameOver();
            }
            if(changeRoleView)
            {
               changeRoleView.update();
            }
         }
      }
      
      override public function end() : void
      {
         over();
      }
      
      public function replaceRole(prole:GameRole) : void
      {
         var arr:Array = null;
         if(!prole.isLock && prole.currentMp.value > 0 && tween.indexOf(prole) == -1)
         {
            arr = this["p" + (prole.troopid + 1) + "assist"];
            if(arr.length > 0)
            {
               arr[0].scaleX = prole.currentScaleX > 0 ? 1 : -1;
               (arr[0] as BaseRole).clearDebuffMove();
               enterRole(arr[0]);
               arr.shift();
               outRole(prole);
               prole.move("wait");
               prole.usePoint(1);
               if(changeRoleView)
               {
                  changeRoleView.update();
               }
            }
         }
      }
   }
}

