package zygame.run
{
   import starling.display.DisplayObject;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   import zygame.display.RefRole;
   import zygame.display.World;
   
   public interface IRunModel
   {
      
      function message(param1:World, param2:Object) : void;
      
      function onDown(param1:int) : Boolean;
      
      function onUp(param1:int) : Boolean;
      
      function onFrame() : Boolean;
      
      function onFrameOver() : Boolean;
      
      function onKillRole(param1:BaseRole) : Boolean;
      
      function onAddChild(param1:DisplayObject) : void;
      
      function onRoleFrame(param1:RefRole) : Boolean;
      
      function onEffectPasing(param1:Array) : Boolean;
      
      function onEffectFrame(param1:EffectDisplay) : Boolean;
      
      function onMiss(param1:BaseRole) : Boolean;
      
      function onHurt(param1:BaseRole, param2:int) : Boolean;
      
      function onCDChange(param1:BaseRole, param2:String) : void;
   }
}

