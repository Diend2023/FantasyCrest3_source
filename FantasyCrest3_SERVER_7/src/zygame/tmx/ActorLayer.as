package zygame.tmx
{
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   
   public class ActorLayer extends Sprite
   {
      
      private var _array:Vector.<DisplayObject>;
      
      public function ActorLayer()
      {
         super();
         _array = new Vector.<DisplayObject>();
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         if(_array.indexOf(child) == -1)
         {
            _array.push(child);
         }
         return super.addChild(child);
      }
      
      override public function removeChild(child:DisplayObject, dispose:Boolean = false) : DisplayObject
      {
         var i:int = 0;
         if(_array)
         {
            i = int(_array.indexOf(child));
            if(i != -1)
            {
               _array.removeAt(i);
            }
         }
         return super.removeChild(child,dispose);
      }
      
      public function mathIndex() : void
      {
      }
      
      override public function dispose() : void
      {
         if(this._array)
         {
            this._array.splice(0,this._array.length);
         }
         this._array = null;
         super.dispose();
      }
   }
}

