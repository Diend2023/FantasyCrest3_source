package game.world
{
   public class _2V2ASSIST_COM extends _2V2ASSIST
   {
      
      public function _2V2ASSIST_COM(mapName:String, toName:String)
      {
         super(mapName,toName);
      }
      
      override public function initRole() : void
      {
         super.initRole();
         this.getRoleList()[2].ai = true;
         this.getRoleList()[3].ai = true;
         this.isDoublePlayer = false;
      }
   }
}

