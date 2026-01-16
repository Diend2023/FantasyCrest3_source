package zygame.display
{
   import flash.events.KeyboardEvent;
   import starling.text.TextField;
   import zygame.core.GameCore;
   import zygame.data.RoleAttributeData;
   import zygame.event.GameAgentEvent;
   
   public class WorldState extends KeyDisplayObject
   {
      
      private var _logs:Vector.<String>;
      
      private var _isNeedDraw:Boolean = false;
      
      private var _time:int = 0;
      
      public function WorldState()
      {
         super();
         _logs = new Vector.<String>();
      }
      
      public function onGoldUpdate(e:GameAgentEvent) : void
      {
      }
      
      public function onKey(key:int, touchType:String) : void
      {
         switch(touchType)
         {
            case "began":
               GameCore.currentCore.nativeStage.dispatchEvent(new KeyboardEvent("keyDown",true,false,0,key));
               break;
            case "ended":
               GameCore.currentCore.nativeStage.dispatchEvent(new KeyboardEvent("keyUp",true,false,0,key));
         }
      }
      
      public function onRoleStateUpdate(roleAttritude:RoleAttributeData) : void
      {
      }
      
      public function pushLog(str:String) : void
      {
         _logs.push(str);
         if(_logs.length > 5)
         {
            _logs.shift();
         }
         _isNeedDraw = true;
         _time = 5;
      }
      
      override public function onFrame() : void
      {
      }
      
      override public function onSUpdate() : void
      {
         if(_time > 0)
         {
            _time--;
         }
         if(_time <= 0)
         {
            if(_logs.length > 0)
            {
               _logs.splice(0,_logs.length);
            }
         }
      }
      
      public function updateTextLog(text:TextField) : void
      {
         text.text = "";
         var i:int = 0;
         if(_logs.length < 5)
         {
            for(i = 0; i < _logs.length; )
            {
               text.text += _logs[i] + "\n";
               i++;
            }
         }
         else
         {
            for(i = _logs.length - 5; i < _logs.length; )
            {
               text.text += _logs[i] + "\n";
               i++;
            }
         }
      }
      
      override public function onInit() : void
      {
         GameCore.scriptCore.addEventListener("gold_update",onGoldUpdate);
      }
   }
}

