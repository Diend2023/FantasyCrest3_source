package game.world
{
   import zygame.data.GameTroopData;
   
   public class _1VStory extends _1VFB
   {
      
      public static var troop:GameTroopData = new GameTroopData();
      
      public function _1VStory(mapName:String, toName:String)
      {
         super(mapName,toName);
      }
      
      override public function cheakGameOver() : int
      {
         return -1;
      }
      
      override public function initRole() : void
      {
         super.initRole();
         if(!troop.getAttrudete(role.targetName))
         {
            troop.joinAttrudetes(role.targetName);
         }
         role.applyAttridute(troop.getAttrudete(role.targetName));
         this.cameraPy = 0.35;
      }
      
      override public function onFrame() : void
      {
         var i:int = 0;
         this.unLockAsk();
         for(i = 0; i < this.roles.length; )
         {
            if(this.roles[i].troopid != role.troopid)
            {
               this.lockAsk();
            }
            i++;
         }
         super.onFrame();
      }
   }
}

