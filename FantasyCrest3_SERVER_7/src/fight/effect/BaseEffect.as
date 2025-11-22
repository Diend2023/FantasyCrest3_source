package fight.effect
{
   import zygame.core.SceneCore;
   import zygame.display.DisplayObjectContainer;
   
   public class BaseEffect extends DisplayObjectContainer
   {
      
      public function BaseEffect()
      {
         super();
      }
      
      public function create() : void
      {
         SceneCore.pushView(this);
      }
      
      public function remove() : void
      {
         this.removeFromParent(true);
      }
   }
}

