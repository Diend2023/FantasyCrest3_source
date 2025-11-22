package zygame.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Stage;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.utils.AssetManager;
   
   public class RestoreTextureUtils
   {
      
      public static var defalutClass:Class = RestoreTextureSprite;
      
      private var _starling:Starling;
      
      private var _root:Stage;
      
      private var _bitmap:Bitmap;
      
      private var _runing:Boolean = false;
      
      private var _restoreTime:int = 0;
      
      private var _assets:Vector.<AssetManager>;
      
      private var _display:RestoreTextureSprite;
      
      public function RestoreTextureUtils(root:Stage, starling:Starling, bmd:BitmapData)
      {
         super();
         _root = root;
         _starling = starling;
         if(bmd)
         {
            _display = new defalutClass();
            _display.utils = this;
            _display.graphics.beginFill(root.color);
            _display.graphics.drawRect(0,0,root.fullScreenWidth,root.fullScreenHeight);
            _display.graphics.endFill();
            _bitmap = new Bitmap(bmd);
            _starling.addEventListener("context3DCreate",onCreate);
            _bitmap.scaleX = root.fullScreenHeight / bmd.height;
            _bitmap.scaleY = root.fullScreenHeight / bmd.height;
            _bitmap.x = -(_bitmap.width - root.fullScreenWidth) / 2;
            _display.addChild(_bitmap);
            _display.init(_bitmap.scaleX);
            showBitmap();
         }
      }
      
      public function initAssetses(arr:Vector.<AssetManager>) : void
      {
         _assets = arr;
         for(var i in _assets)
         {
            _assets[i].addEventListener("texturesRestored",onRestored);
         }
      }
      
      public function clearBitmap() : void
      {
         trace("clearBitmap");
         Starling.current.start();
         if(_display && _display.parent)
         {
            _root.removeChild(_display);
            _display.clear();
         }
      }
      
      public function get display() : RestoreTextureSprite
      {
         return _display;
      }
      
      public function showBitmap() : void
      {
         Starling.current.stop();
         if(_display && !_display.parent)
         {
            _root.addChild(_display);
            _display.show();
         }
      }
      
      private function onCreate(e:Event) : void
      {
         if(_runing)
         {
            trace("CONTEXT3D_CREATE onCreate");
            _restoreTime = 0;
            showBitmap();
         }
         _runing = true;
      }
      
      private function onRestored(e:Event) : void
      {
         var i:int = 0;
         trace("CONTEXT3D_CREATE onRestored");
         for(i = 0; i < _assets.length; )
         {
            if(_assets[i].isLoading)
            {
               return;
            }
            i++;
         }
         clearBitmap();
         Starling.current.dispatchEventWith("texturesRestored",true);
      }
   }
}

