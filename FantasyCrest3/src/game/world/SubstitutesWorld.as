package game.world
{
   import game.role.GameRole;
   
   public class SubstitutesWorld extends AssistWorld
   {
      
      public function SubstitutesWorld(mapName:String, toName:String)
      {
         super(mapName,toName);
      }
      
      override public function overCheak() : void
      {
         var id:int = cheakGameOver();
         if(id != -1)
         {
            trace("战斗结束，胜利队伍：",id);
            gameOver();
         }
      }
      
      override public function replaceRole(prole:GameRole) : void
      {
         var id:int = prole.troopid + 1;
         var arr:Array = this["p" + id + "assist"];
         if(arr.length > 0)
         {
            this["p" + id] = arr[0];
            arr[0].ai = false;
            prole.ai = true;
            arr.shift();
            arr.push(prole);
            role = this["p" + id];
            if(changeRoleView)
            {
               changeRoleView.update();
            }
         }
      }
   }
}

