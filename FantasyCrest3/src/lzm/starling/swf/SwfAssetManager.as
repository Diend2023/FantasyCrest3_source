package lzm.starling.swf
{
   import flash.utils.Dictionary;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfImage;
   import lzm.starling.swf.display.SwfMovieClip;
   import lzm.starling.swf.display.SwfParticleSyetem;
   import lzm.starling.swf.display.SwfScale9Image;
   import lzm.starling.swf.display.SwfShapeImage;
   import lzm.starling.swf.display.SwfSprite;
   import starling.utils.AssetManager;
   import starling.utils.EncodeAssets;
   
   public class SwfAssetManager
   {
      
      protected static const ______otherAssetsTag:String = "______otherAssetsTag";
      
      protected var _verbose:Boolean = false;
      
      protected var _loadQueue:Array;
      
      protected var _loadQueueNames:Array;
      
      protected var _isLoading:Boolean;
      
      protected var _swfs:Dictionary;
      
      protected var _swfNames:Array;
      
      protected var _scaleFactor:Number;
      
      protected var _useMipmaps:Boolean;
      
      protected var _otherAssets:EncodeAssets;
      
      protected var _otherQueue:Array;
      
      public function SwfAssetManager(scaleFactor:Number = 1, useMipmaps:Boolean = false)
      {
         super();
         _loadQueue = [];
         _loadQueueNames = [];
         _isLoading = false;
         _swfs = new Dictionary();
         _swfNames = [];
         _scaleFactor = scaleFactor;
         _useMipmaps = useMipmaps;
         _otherAssets = new EncodeAssets(scaleFactor,useMipmaps);
         _otherQueue = [];
      }
      
      public function enqueue(name:String, resource:Array, fps:int = 24) : void
      {
         if(_isLoading)
         {
            log("正在加载中。请稍后再试");
            return;
         }
         if(getSwf(name) != null)
         {
            log("Swf已经存在");
            return;
         }
         if(_loadQueueNames.indexOf(name) == -1)
         {
            _loadQueueNames.push(name);
            _loadQueue.push([name,resource,fps]);
         }
         else
         {
            log("加载队列中已经有：" + name + ",跳过!");
         }
      }
      
      public function enqueueWithArray(swfs:Array) : void
      {
         var swfAsset:Array = null;
         var i:int = 0;
         if(_isLoading)
         {
            log("正在加载中。请稍后再试");
            return;
         }
         var len:int = int(swfs.length);
         for(i = 0; i < len; )
         {
            swfAsset = swfs[i];
            if(swfAsset.length == 3)
            {
               enqueue(swfAsset[0],swfAsset[1],swfAsset[2]);
            }
            else
            {
               enqueue(swfAsset[0],swfAsset[1]);
            }
            i++;
         }
      }
      
      public function enqueueOtherAssets(... rawAssets) : void
      {
         trace("Other:",rawAssets);
         if(_isLoading)
         {
            log("正在加载中。请稍后再试");
            return;
         }
         for each(var rawAsset in rawAssets)
         {
            _otherQueue.push(rawAsset);
         }
      }
      
      protected function parseOtherAssets() : void
      {
         if(_otherQueue.length > 0)
         {
            enqueue("______otherAssetsTag",_otherQueue.slice());
         }
         _otherQueue = [];
      }
      
      public function loadQueue(onProgress:Function) : void
      {
         var swfAsset:Array;
         var numSwfAsset:int;
         var currentRatio:Number;
         var avgRatio:Number;
         var loadNext:* = function():void
         {
            swfAsset = _loadQueue.shift();
            if(getSwf(swfAsset[0]) != null)
            {
               loadNext();
            }
            else
            {
               load();
            }
         };
         var load:* = function():void
         {
            var assetObject:Object;
            var swfName:String = swfAsset[0];
            var swfResource:Array = swfAsset[1];
            var swfFps:int = int(swfAsset[2]);
            var assetManager:AssetManager = swfName == "______otherAssetsTag" ? _otherAssets : new AssetManager(_scaleFactor,_useMipmaps);
            assetManager.verbose = verbose;
            for each(assetObject in swfResource)
            {
               assetManager.enqueue(assetObject);
            }
            assetManager.loadQueue(function(ratio:Number):void
            {
               if(ratio == 1)
               {
                  if(swfName != "______otherAssetsTag")
                  {
                     addSwf(swfName,new Swf(assetManager.getByteArray(swfName),assetManager,swfFps));
                  }
                  loadComplete();
               }
               else
               {
                  onProgress(currentRatio + avgRatio * ratio);
               }
            });
         };
         var loadComplete:* = function():void
         {
            currentRatio = _loadQueue.length ? 1 - _loadQueue.length / numSwfAsset : 1;
            if(currentRatio == 1)
            {
               _isLoading = false;
            }
            else
            {
               loadNext();
            }
            onProgress(currentRatio);
         };
         if(_isLoading)
         {
            log("正在加载中。请稍后再试");
            return;
         }
         parseOtherAssets();
         _loadQueueNames = [];
         numSwfAsset = int(_loadQueue.length);
         currentRatio = 0;
         avgRatio = 1 / numSwfAsset;
         if(numSwfAsset == 0)
         {
            log("没有需要加载的Swf");
            onProgress(1);
            return;
         }
         _isLoading = true;
         loadNext();
      }
      
      public function getSwf(name:String) : Swf
      {
         return _swfs[name];
      }
      
      public function addSwf(name:String, swf:Swf) : Boolean
      {
         if(getSwf(name) != null)
         {
            log("Swf已经存在");
            return false;
         }
         log("添加Swf:" + name);
         _swfs[name] = swf;
         _swfNames.push(name);
         return true;
      }
      
      public function removeSwf(name:String, dispose:Boolean = false) : void
      {
         var swf:Swf = getSwf(name);
         if(swf)
         {
            log("移除Swf:" + name + "  dispose:" + dispose);
            if(dispose)
            {
               swf.dispose(dispose);
            }
            delete _swfs[name];
            _swfNames.splice(_swfNames.indexOf(name),1);
         }
      }
      
      public function clearSwf() : void
      {
         for each(var swf in _swfs)
         {
            swf.dispose(true);
         }
         _swfs = new Dictionary();
         _swfNames = [];
      }
      
      public function clearAll() : void
      {
         clearSwf();
         _otherAssets.purge();
      }
      
      public function get swfNames() : Array
      {
         return _swfNames.slice();
      }
      
      public function createSprite(name:String) : SwfSprite
      {
         for each(var swf in _swfs)
         {
            if(swf.hasSprite(name))
            {
               return swf.createSprite(name);
            }
         }
         return null;
      }
      
      public function createMovieClip(name:String) : SwfMovieClip
      {
         for each(var swf in _swfs)
         {
            if(swf.hasMovieClip(name))
            {
               return swf.createMovieClip(name);
            }
         }
         return null;
      }
      
      public function createImage(name:String) : SwfImage
      {
         for each(var swf in _swfs)
         {
            if(swf.hasImage(name))
            {
               return swf.createImage(name);
            }
         }
         return null;
      }
      
      public function createButton(name:String) : SwfButton
      {
         for each(var swf in _swfs)
         {
            if(swf.hasButton(name))
            {
               return swf.createButton(name);
            }
         }
         return null;
      }
      
      public function createS9Image(name:String) : SwfScale9Image
      {
         for each(var swf in _swfs)
         {
            if(swf.hasS9Image(name))
            {
               return swf.createS9Image(name);
            }
         }
         return null;
      }
      
      public function createShapeImage(name:String) : SwfShapeImage
      {
         for each(var swf in _swfs)
         {
            if(swf.hasShapeImage(name))
            {
               return swf.createShapeImage(name);
            }
         }
         return null;
      }
      
      public function createComponent(name:String) : *
      {
         for each(var swf in _swfs)
         {
            if(swf.hasComponent(name))
            {
               return swf.createComponent(name);
            }
         }
         return null;
      }
      
      public function createParticle(name:String) : SwfParticleSyetem
      {
         for each(var swf in _swfs)
         {
            if(swf.hasParticle(name))
            {
               return swf.createParticle(name);
            }
         }
         return null;
      }
      
      public function get otherAssets() : EncodeAssets
      {
         return _otherAssets;
      }
      
      public function get verbose() : Boolean
      {
         return false;
      }
      
      public function set verbose(value:Boolean) : void
      {
         _verbose = value;
      }
      
      protected function log(message:String) : void
      {
         if(_verbose)
         {
            trace("SwfAssetManager:" + message);
         }
      }
   }
}

