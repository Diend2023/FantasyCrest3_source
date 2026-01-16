package game.world
{
   public class _2V2COM extends _2V2
   {
      
      public function _2V2COM(mapName:String, toName:String)
      {
         super(mapName,toName);
      }
      
      override public function initRole() : void
      {
         super.initRole();
         this.getRoleList()[2].ai = true;
         this.isDoublePlayer = false;
      }
   }
}

