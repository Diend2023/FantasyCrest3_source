package zygame.run
{
   import starling.display.DisplayObject;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   import zygame.display.RefRole;
   import zygame.display.World;
   
   public class DefalutRunModel implements IRunModel
   {
      
      public function DefalutRunModel()
      {
         super();
      }
      
      public function message(world:World, data:Object) : void
      {
         switch(data.target)
         {
            case "keyDown":
               world.getRoleFormName(data.role).onDown(data.key);
               break;
            case "keyUp":
               world.getRoleFormName(data.role).onUp(data.key);
         }
      }
      
      public function onDown(key:int) : Boolean
      {
         return false;
      }
      
      public function onUp(key:int) : Boolean
      {
         return false;
      }
      
      public function onFrame() : Boolean
      {
         return false;
      }
      
      public function onKillRole(role:BaseRole) : Boolean
      {
         return false;
      }
      
      public function onHurt(role:BaseRole, hurt:int) : Boolean
      {
         return false;
      }
      
      public function onMiss(role:BaseRole) : Boolean
      {
         return false;
      }
      
      public function onAddChild(child:DisplayObject) : void
      {
      }
      
      public function onRoleFrame(role:RefRole) : Boolean
      {
         return false;
      }
      
      public function onEffectPasing(arr:Array) : Boolean
      {
         return false;
      }
      
      public function onEffectFrame(display:EffectDisplay) : Boolean
      {
         return false;
      }
      
      public function onFrameOver() : Boolean
      {
         return false;
      }
      
      public function onCDChange(role:BaseRole, skillName:String) : void
      {
      }
   }
}

