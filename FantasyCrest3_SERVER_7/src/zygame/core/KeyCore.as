package zygame.core
{
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import zygame.display.KeyDisplayObject;
   
   public class KeyCore
   {
      
      private var _keys:Vector.<KeyDisplayObject> = new Vector.<KeyDisplayObject>();
      
      private var _keyDown:Array = [];
      
      private var _key:int = -1;
      
      private var _stage:Stage;
      
      public function KeyCore(stage:Stage)
      {
         super();
         _stage = stage;
         stage.addEventListener("keyDown",onKeyDown);
         stage.addEventListener("keyUp",onKeyUp);
      }
      
      public function addKeyEvent(keyDisplay:KeyDisplayObject) : void
      {
         _keys.push(keyDisplay);
      }
      
      public function removeKeyEvent(keyDisplay:KeyDisplayObject) : void
      {
         var index:int = int(_keys.indexOf(keyDisplay));
         if(index != -1)
         {
            _keys.removeAt(index);
         }
      }
      
      public function resetPort() : void
      {
         for(var i in _keyDown)
         {
            for(var i2 in _keys)
            {
               _keys[i2].onDown(_keyDown[i]);
            }
         }
      }
      
      public function onDown(code:int) : void
      {
         _stage.dispatchEvent(new KeyboardEvent("keyDown",false,false,0,code));
      }
      
      public function onUp(code:int) : void
      {
         _stage.dispatchEvent(new KeyboardEvent("keyUp",false,false,0,code));
      }
      
      private function onKeyDown(e:KeyboardEvent) : void
      {
         if(_keyDown.indexOf(e.keyCode) == -1)
         {
            _keyDown.push(e.keyCode);
         }
         for(var i in _keys)
         {
            _keys[i].onKeyDown(e);
         }
      }
      
      private function onKeyUp(e:KeyboardEvent) : void
      {
         var index:int = int(_keyDown.indexOf(e.keyCode));
         if(index != -1)
         {
            _keyDown.removeAt(index);
         }
         for(var i in _keys)
         {
            _keys[i].onKeyUp(e);
         }
      }
   }
}

