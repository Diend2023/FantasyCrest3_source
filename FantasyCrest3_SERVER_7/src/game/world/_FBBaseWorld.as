package game.world
{
   import game.view.GameStateView;
   import zygame.display.WorldState;
   
   public class _FBBaseWorld extends _1V1
   {
      
      public var lockOnline:Boolean = false;
      
      public function _FBBaseWorld(mapName:String, toName:String)
      {
         super(mapName,toName);
      }
      
      override public function onDown(key:int) : void
      {
         super.onDown(key);
         if(key == 74 && poltSystem.isRuning)
         {
            poltSystem.quick();
         }
      }
      
      override public function createFrameBody() : void
      {
         if(!lockOnline)
         {
            super.createFrameBody();
         }
      }
      
      override public function moveMap(speed:Number) : void
      {
         if(!lockOnline || poltSystem.isRuning)
         {
            super.moveMap(speed);
         }
         else
         {
            if(p1 && p1.attribute)
            {
               founcDisplay = p1;
            }
            else if(p2 && p2.attribute)
            {
               founcDisplay = p2;
            }
            super.moveMap(speed);
         }
      }
      
      override public function addStateContent(pstate:WorldState) : void
      {
         super.addStateContent(pstate);
         (pstate as GameStateView).createFBHPState();
      }
      
      override public function mathCenterPos() : void
      {
         if(!lockOnline && !poltSystem.isRuning)
         {
            super.mathCenterPos();
         }
         else
         {
            worldScale = !poltSystem.isRuning ? 0.9 : 1.1;
         }
      }
   }
}

