package game.world
{
   import zygame.display.WorldState;
   
   public class _1V1COMCOM extends BaseGameWorld
   {
      
      public function _1V1COMCOM(mapName:String, toName:String)
      {
         super(mapName,toName);
      }
      
      override public function addStateContent(pstate:WorldState) : void
      {
         super.addStateContent(pstate);
         getRoleList()[0].ai = true;
         getRoleList()[1].ai = true;
      }
      
      override public function onDown(key:int) : void
      {
      }
      
      override public function onUp(key:int) : void
      {
      }
   }
}

