package zygame.display
{
   import flash.events.KeyboardEvent;
   import zygame.core.GameCore;
   
   public class KeyDisplayObject extends TouchDisplayObject
   {
      
      public static var doubleKeyTime:int = 20;
      
      private var _key:int = 0;
      
      private var _downkey:Array = [];
      
      private var _doubleKeyTime:int = 20;
      
      private var _doubleKeys:Vector.<int>;
      
      public function KeyDisplayObject()
      {
         super();
         _doubleKeys = new Vector.<int>();
      }
      
      public function onDown(key:int) : void
      {
         pushKey(key);
      }
      
      public function pushKey(key:int) : void
      {
         if(_downkey.indexOf(key) == -1)
         {
            _doubleKeys.push(key);
            _doubleKeyTime = doubleKeyTime;
            _downkey.push(key);
         }
      }
      
      public function removeKey(key:int) : void
      {
         var i:int = int(_downkey.indexOf(key));
         if(i != -1)
         {
            _downkey.removeAt(i);
            if(_doubleKeyTime <= 0)
            {
               clearDoubleKey();
            }
         }
      }
      
      public function clearDoubleKey() : void
      {
         _doubleKeys.splice(0,_doubleKeys.length);
      }
      
      public function onUp(key:int) : void
      {
         removeKey(key);
      }
      
      public function openKey() : void
      {
         GameCore.keyCore.addKeyEvent(this);
      }
      
      public function clearKey() : void
      {
         GameCore.keyCore.removeKeyEvent(this);
      }
      
      public function onKeyDown(e:KeyboardEvent) : void
      {
         if(_key != e.keyCode)
         {
            _key = e.keyCode;
            onDown(_key);
         }
      }
      
      public function onKeyUp(e:KeyboardEvent) : void
      {
         if(_key == e.keyCode)
         {
            _key = -1;
         }
         onUp(e.keyCode);
      }
      
      override public function discarded() : void
      {
         super.discarded();
         clearKey();
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(this is BaseRole)
         {
            if(_doubleKeyTime > 0)
            {
               _doubleKeyTime--;
            }
         }
      }
      
      public function isKeyDown(key:int) : Boolean
      {
         return _downkey.indexOf(key) != -1;
      }
      
      public function isKeyDoubleDown(key:int) : Boolean
      {
         if(_doubleKeys.length > 1)
         {
            return _doubleKeys[_doubleKeys.length - 1] == key && _doubleKeys[_doubleKeys.length - 2] == key;
         }
         return false;
      }
      
      public function isKeyUp(key:int) : Boolean
      {
         return _downkey.indexOf(key) == -1;
      }
      
      public function getDownKeys() : Array
      {
         return this._downkey;
      }
      
      public function stopAllKey() : void
      {
         this.onUp(83);
         this.onUp(87);
         this.onUp(65);
         this.onUp(68);
         _downkey = [];
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.clearKey();
      }
   }
}

