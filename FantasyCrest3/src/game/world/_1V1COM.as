package game.world
{
   import zygame.display.WorldState;
   
   public class _1V1COM extends BaseGameWorld
   {
      
      public function _1V1COM(mapName:String, toName:String)
      {
         super(mapName,toName);
      }
      
      override public function addStateContent(pstate:WorldState) : void
      {
         super.addStateContent(pstate);
         getRoleList()[1].ai = true;
      }
   }
}

