package starling.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.FileReference;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.system.System;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.events.EventDispatcher;
   import starling.text.BitmapFont;
   import starling.text.TextField;
   import starling.textures.AtfData;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   import starling.textures.TextureOptions;
   import zygame.utils.SuperTextureAtlas;
   
   [Event(name="texturesRestored",type="starling.events.Event")]
   [Event(name="ioError",type="starling.events.Event")]
   [Event(name="securityError",type="starling.events.Event")]
   [Event(name="parseError",type="starling.events.Event")]
   public class AssetManager extends EventDispatcher
   {
      
      private static const HTTP_RESPONSE_STATUS:String = "httpResponseStatus";
      
      public static var onLoadName:Function;
      
      public static var onLoadRawAssetOverride:Function;
      
      private static var sNames:Vector.<String> = new Vector.<String>(0);
      
      private static const NAME_REGEX:RegExp = /([^\?\/\\]+?)(?:\.([\w\-]+))?(?:\?.*)?$/;
      
      private var _starling:Starling;
      
      private var _numLostTextures:int;
      
      private var _numRestoredTextures:int;
      
      private var _numLoadingQueues:int;
      
      private var _defaultTextureOptions:TextureOptions;
      
      private var _checkPolicyFile:Boolean;
      
      private var _keepAtlasXmls:Boolean;
      
      private var _keepFontXmls:Boolean;
      
      private var _numConnections:int;
      
      private var _verbose:Boolean;
      
      private var _queue:Array;
      
      private var _textures:Dictionary;
      
      private var _atlases:Dictionary;
      
      private var _sounds:Dictionary;
      
      private var _xmls:Dictionary;
      
      private var _objects:Dictionary;
      
      private var _byteArrays:Dictionary;
      
      private var _bitmapAtlases:Dictionary;
      
      public function AssetManager(scaleFactor:Number = 1, useMipmaps:Boolean = false)
      {
         super();
         _defaultTextureOptions = new TextureOptions(scaleFactor,useMipmaps);
         _textures = new Dictionary();
         _atlases = new Dictionary();
         _sounds = new Dictionary();
         _xmls = new Dictionary();
         _objects = new Dictionary();
         _byteArrays = new Dictionary();
         _bitmapAtlases = new Dictionary();
         _numConnections = 3;
         _verbose = false;
         _queue = [];
      }
      
      public function dispose() : void
      {
         for(var i in _textures)
         {
            _textures[i].dispose();
            delete _textures[i];
         }
         for(var i2 in _atlases)
         {
            _atlases[i2].dispose();
            delete _atlases[i2];
         }
         for(var i3 in _xmls)
         {
            System.disposeXML(_xmls[i3]);
            delete _xmls[i3];
         }
         for(var i4 in _byteArrays)
         {
            _byteArrays[i4].clear();
            delete _byteArrays[i4];
         }
         for(var i5 in _bitmapAtlases)
         {
            removeBitmapAtlases(i5);
         }
      }
      
      public function getTexture(name:String) : Texture
      {
         var texture:Texture = null;
         if(name in _textures)
         {
            return _textures[name];
         }
         for each(var atlas in _atlases)
         {
            texture = atlas.getTexture(name);
            if(texture)
            {
               return texture;
            }
         }
         return null;
      }
      
      public function getTextures(prefix:String = "", out:Vector.<Texture> = null) : Vector.<Texture>
      {
         if(out == null)
         {
            out = new Vector.<Texture>(0);
         }
         for each(var name in getTextureNames(prefix,sNames))
         {
            out[out.length] = getTexture(name);
         }
         sNames.length = 0;
         return out;
      }
      
      public function getTextureNames(prefix:String = "", out:Vector.<String> = null) : Vector.<String>
      {
         out = getDictionaryKeys(_textures,prefix,out);
         for each(var atlas in _atlases)
         {
            atlas.getNames(prefix,out);
         }
         out.sort(1);
         return out;
      }
      
      public function getTextureAtlas(name:String) : TextureAtlas
      {
         return _atlases[name] as TextureAtlas;
      }
      
      public function getTextureAtlasNames(prefix:String = "", out:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(_atlases,prefix,out);
      }
      
      public function getSound(name:String) : Sound
      {
         return _sounds[name];
      }
      
      public function getSoundNames(prefix:String = "", out:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(_sounds,prefix,out);
      }
      
      public function playSound(name:String, startTime:Number = 0, loops:int = 0, transform:SoundTransform = null) : SoundChannel
      {
         if(name in _sounds)
         {
            return getSound(name).play(startTime,loops,transform);
         }
         return null;
      }
      
      public function getXml(name:String) : XML
      {
         return _xmls[name];
      }
      
      public function getXmlNames(prefix:String = "", out:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(_xmls,prefix,out);
      }
      
      public function getObject(name:String) : Object
      {
         return _objects[name];
      }
      
      public function getObjectNames(prefix:String = "", out:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(_objects,prefix,out);
      }
      
      public function getByteArray(name:String) : ByteArray
      {
         return _byteArrays[name];
      }
      
      public function getByteArrayNames(prefix:String = "", out:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(_byteArrays,prefix,out);
      }
      
      public function addTexture(name:String, texture:Texture) : void
      {
         trace("Adding texture \'" + name + "\'");
         if(name in _textures)
         {
            log("Warning: name was already in use; the previous texture will be replaced.");
            _textures[name].dispose();
         }
         _textures[name] = texture;
      }
      
      public function addTextureAtlas(name:String, atlas:TextureAtlas) : void
      {
         trace("Adding texture atlas \'" + name + "\'");
         if(name in _atlases)
         {
            log("Warning: name was already in use; the previous atlas will be replaced.");
            _atlases[name].dispose();
         }
         _atlases[name] = atlas;
      }
      
      public function addSound(name:String, sound:Sound) : void
      {
         log("Adding sound \'" + name + "\'");
         if(name in _sounds)
         {
            log("Warning: name was already in use; the previous sound will be replaced.");
         }
         _sounds[name] = sound;
      }
      
      public function addXml(name:String, xml:XML) : void
      {
         log("Adding XML \'" + name + "\'");
         if(name in _xmls)
         {
            log("Warning: name was already in use; the previous XML will be replaced.");
            System.disposeXML(_xmls[name]);
         }
         _xmls[name] = xml;
      }
      
      public function addObject(name:String, object:Object) : void
      {
         trace("Adding object \'" + name + "\'");
         if(name in _objects)
         {
            log("Warning: name was already in use; the previous object will be replaced.");
         }
         _objects[name] = object;
      }
      
      public function addByteArray(name:String, byteArray:ByteArray) : void
      {
         log("Adding byte array \'" + name + "\'");
         if(name in _byteArrays)
         {
            log("Warning: name was already in use; the previous byte array will be replaced.");
            _byteArrays[name].clear();
         }
         _byteArrays[name] = byteArray;
      }
      
      public function addBitmapAtlases(name:String, bitmapData:BitmapData) : void
      {
         if(_bitmapAtlases[name])
         {
            (_bitmapAtlases[name] as BitmapData).dispose();
         }
         _bitmapAtlases[name] = bitmapData;
      }
      
      public function getBitmapAtlases(name:String) : BitmapData
      {
         return _bitmapAtlases[name];
      }
      
      public function removeBitmapAtlases(name:String) : void
      {
         if(_bitmapAtlases[name])
         {
            (_bitmapAtlases[name] as BitmapData).dispose();
            delete _bitmapAtlases[name];
         }
      }
      
      public function cheak() : void
      {
         trace("---------------------");
         for(var i in _textures)
         {
            trace(i,_textures[i]);
         }
         for(var i2 in _atlases)
         {
            trace(i2,_atlases[i2]);
         }
         trace("---------------------");
      }
      
      public function removeTexture(name:String, dispose:Boolean = true) : void
      {
         trace("Removing texture \'" + name + "\'");
         if(dispose && name in _textures)
         {
            _textures[name].dispose();
         }
         delete _textures[name];
      }
      
      public function removeTextureAtlas(name:String, dispose:Boolean = true) : void
      {
         if(dispose && name in _atlases)
         {
            _atlases[name].dispose();
         }
         delete _atlases[name];
      }
      
      public function removeSound(name:String) : void
      {
         log("Removing sound \'" + name + "\'");
         delete _sounds[name];
      }
      
      public function removeXml(name:String, dispose:Boolean = true) : void
      {
         log("Removing xml \'" + name + "\'");
         if(dispose && name in _xmls)
         {
            System.disposeXML(_xmls[name]);
         }
         delete _xmls[name];
      }
      
      public function removeObject(name:String) : void
      {
         log("Removing object \'" + name + "\'");
         delete _objects[name];
      }
      
      public function removeByteArray(name:String, dispose:Boolean = true) : void
      {
         log("Removing byte array \'" + name + "\'");
         if(dispose && name in _byteArrays)
         {
            _byteArrays[name].clear();
         }
         delete _byteArrays[name];
      }
      
      public function purgeQueue() : void
      {
         _queue.length = 0;
         dispatchEventWith("cancel");
      }
      
      public function purge() : void
      {
         log("Purging all assets, emptying queue");
         purgeQueue();
         dispose();
         _textures = new Dictionary();
         _atlases = new Dictionary();
         _sounds = new Dictionary();
         _xmls = new Dictionary();
         _objects = new Dictionary();
         _byteArrays = new Dictionary();
      }
      
      public function enqueue(... rawAssets) : void
      {
         var typeXml:XML = null;
         var childNode:* = null;
         for each(var rawAsset in rawAssets)
         {
            if(rawAsset is Array)
            {
               enqueue.apply(this,rawAsset);
            }
            else if(rawAsset is Class)
            {
               typeXml = describeType(rawAsset);
               if(_verbose)
               {
                  log("Looking for static embedded assets in \'" + typeXml.@name.split("::").pop() + "\'");
               }
               for each(childNode in typeXml.constant.(@type == "Class"))
               {
                  enqueueWithName(rawAsset[childNode.@name],childNode.@name);
               }
               for each(childNode in typeXml.variable.(@type == "Class"))
               {
                  enqueueWithName(rawAsset[childNode.@name],childNode.@name);
               }
            }
            else if(getQualifiedClassName(rawAsset) == "flash.filesystem::File")
            {
               if(!rawAsset["exists"])
               {
                  log("File or directory not found: \'" + rawAsset["url"] + "\'");
               }
               else if(!rawAsset["isHidden"])
               {
                  if(rawAsset["isDirectory"])
                  {
                     enqueue.apply(this,rawAsset["getDirectoryListing"]());
                  }
                  else
                  {
                     enqueueWithName(rawAsset);
                  }
               }
            }
            else if(rawAsset is String || rawAsset is URLRequest)
            {
               enqueueWithName(rawAsset);
            }
            else
            {
               log("Ignoring unsupported asset type: " + getQualifiedClassName(rawAsset));
            }
         }
      }
      
      public function enqueueWithName(asset:Object, name:String = null, options:TextureOptions = null) : String
      {
         var filename:String = null;
         if(getQualifiedClassName(asset) == "flash.filesystem::File")
         {
            filename = asset["name"];
            asset = decodeURI(asset["url"]);
         }
         if(name == null)
         {
            name = getName(asset);
         }
         if(options == null)
         {
            options = _defaultTextureOptions.clone();
         }
         else
         {
            options = options.clone();
         }
         log("Enqueuing \'" + (filename || name) + "\'");
         _queue.push({
            "name":name,
            "asset":asset,
            "options":options
         });
         return name;
      }
      
      public function loadQueue(onProgress:Function) : void
      {
         var PROGRESS_PART_ASSETS:Number;
         var PROGRESS_PART_XMLS:Number;
         var i:int;
         var canceled:Boolean;
         var xmls:Vector.<XML>;
         var assetInfos:Array;
         var assetCount:int;
         var assetProgress:Array;
         var assetIndex:int;
         var loadNextQueueElement:* = function():void
         {
            var index:int = 0;
            if(assetIndex < assetInfos.length)
            {
               index = assetIndex++;
               loadQueueElement(index,assetInfos[index]);
            }
         };
         var loadQueueElement:* = function(index:int, assetInfo:Object):void
         {
            var onElementProgress:Function;
            var onElementLoaded:Function;
            if(canceled)
            {
               return;
            }
            onElementProgress = function(progress:Number):void
            {
               updateAssetProgress(index,progress * 0.8);
            };
            onElementLoaded = function():void
            {
               updateAssetProgress(index,1);
               assetCount--;
               if(assetCount > 0)
               {
                  loadNextQueueElement();
               }
               else
               {
                  processXmls();
               }
            };
            processRawAsset(assetInfo.name,assetInfo.asset,assetInfo.options,xmls,onElementProgress,onElementLoaded);
         };
         var updateAssetProgress:* = function(index:int, progress:Number):void
         {
            assetProgress[index] = progress;
            var sum:Number = 0;
            var len:int = int(assetProgress.length);
            for(i = 0; i < len; )
            {
               sum += assetProgress[i];
               i = i + 1;
            }
            onProgress(sum / len * 0.9);
         };
         var processXmls:* = function():void
         {
            xmls.sort(function(a:XML, b:XML):int
            {
               return a.localName() == "TextureAtlas" ? -1 : 1;
            });
            setTimeout(processXml,1,0);
         };
         var processXml:* = function(index:int):void
         {
            var name:String = null;
            var texture:Texture = null;
            var bitmapData:BitmapData = null;
            var textureAtlas:SuperTextureAtlas = null;
            if(canceled)
            {
               return;
            }
            if(index == xmls.length)
            {
               finish();
               return;
            }
            var xml:XML = xmls[index];
            var rootNode:String = xml.localName();
            var xmlProgress:Number = (index + 1) / (xmls.length + 1);
            if(rootNode == "TextureAtlas")
            {
               name = getName(xml.@imagePath.toString());
               texture = getTexture(name);
               if(!texture)
               {
                  bitmapData = getBitmapAtlases(name);
                  if(bitmapData)
                  {
                     trace("File " + name + ": More than " + SuperTextureAtlas.maxWH + " texture resolution processing");
                     textureAtlas = new SuperTextureAtlas(bitmapData,xml,textureFormat);
                     addTextureAtlas(name,textureAtlas);
                     if(_keepAtlasXmls)
                     {
                        addXml(name,xml);
                     }
                     else
                     {
                        System.disposeXML(xml);
                     }
                     removeBitmapAtlases(name);
                  }
                  else
                  {
                     log("Cannot create atlas: texture \'" + name + "\' is missing.");
                  }
               }
               else
               {
                  addTextureAtlas(name,new TextureAtlas(texture,xml));
                  removeTexture(name,false);
                  if(_keepAtlasXmls)
                  {
                     addXml(name,xml);
                  }
                  else
                  {
                     System.disposeXML(xml);
                  }
               }
            }
            else
            {
               if(rootNode != "font")
               {
                  throw new Error("XML contents not recognized: " + rootNode);
               }
               name = getName(xml.pages.page.@file.toString());
               texture = getTexture(name);
               if(texture)
               {
                  log("Adding bitmap font \'" + name + "\'");
                  TextField.registerCompositor(new BitmapFont(texture,xml),name);
                  removeTexture(name,false);
                  if(_keepFontXmls)
                  {
                     addXml(name,xml);
                  }
                  else
                  {
                     System.disposeXML(xml);
                  }
               }
               else
               {
                  log("Cannot create bitmap font: texture \'" + name + "\' is missing.");
               }
            }
            onProgress(0.9 + 0.09999999999999998 * xmlProgress);
            setTimeout(processXml,1,index + 1);
         };
         var cancel:* = function():void
         {
            removeEventListener("cancel",cancel);
            _numLoadingQueues--;
            canceled = true;
         };
         var finish:* = function():void
         {
            setTimeout(function():void
            {
               if(!canceled)
               {
                  cancel();
                  onProgress(1);
               }
            },1);
         };
         if(onProgress == null)
         {
            throw new ArgumentError("Argument \'onProgress\' must not be null");
         }
         if(_queue.length == 0)
         {
            onProgress(1);
            return;
         }
         _starling = Starling.current;
         if(_starling == null || _starling.context == null)
         {
            throw new Error("The Starling instance needs to be ready before assets can be loaded.");
         }
         canceled = false;
         xmls = new Vector.<XML>(0);
         assetInfos = _queue.concat();
         assetCount = int(_queue.length);
         assetProgress = [];
         assetIndex = 0;
         for(i = 0; i < assetCount; )
         {
            assetProgress[i] = 0;
            i = i + 1;
         }
         for(i = 0; i < _numConnections; )
         {
            loadNextQueueElement();
            i = i + 1;
         }
         _queue.length = 0;
         _numLoadingQueues++;
         addEventListener("cancel",cancel);
      }
      
      private function processRawAsset(name:String, rawAsset:Object, options:TextureOptions, xmls:Vector.<XML>, onProgress:Function, onComplete:Function) : void
      {
         var canceled:Boolean;
         var process:* = function(asset:Object):void
         {
            var texture:Texture;
            var bytes:ByteArray;
            var object:Object = null;
            var xml:XML = null;
            _starling.makeCurrent();
            if(!canceled)
            {
               if(asset == null)
               {
                  onComplete();
               }
               else if(asset is Sound)
               {
                  addSound(name,asset as Sound);
                  onComplete();
               }
               else if(asset is XML)
               {
                  xml = asset as XML;
                  if(xml.localName() == "TextureAtlas" || xml.localName() == "font")
                  {
                     xmls.push(xml);
                  }
                  else
                  {
                     addXml(name,xml);
                  }
                  onComplete();
               }
               else
               {
                  if(_starling.context.driverInfo == "Disposed")
                  {
                     log("Context lost while processing assets, retrying ...");
                     setTimeout(process,1,asset);
                     return;
                  }
                  if(asset is Bitmap)
                  {
                     trace("支持情况：",SuperTextureAtlas.support,asset.width,asset.height,SuperTextureAtlas.maxWH);
                     if(SuperTextureAtlas.support && (asset.width > SuperTextureAtlas.maxWH || asset.height > SuperTextureAtlas.maxWH))
                     {
                        addBitmapAtlases(name,asset.bitmapData);
                        onComplete();
                     }
                     else
                     {
                        texture = Texture.fromData(asset,options);
                        texture.root.onRestore = function():void
                        {
                           _numLostTextures++;
                           loadRawAsset(rawAsset,null,function(asset:Object):void
                           {
                              try
                              {
                                 if(asset == null)
                                 {
                                    throw new Error("Reload failed");
                                 }
                                 texture.root.uploadBitmap(asset as Bitmap);
                                 asset.bitmapData.dispose();
                              }
                              catch(e:Error)
                              {
                                 log("Texture restoration failed for \'" + name + "\': " + e.message);
                              }
                              _numRestoredTextures++;
                              Starling.current.stage.setRequiresRedraw();
                              if(_numLostTextures == _numRestoredTextures)
                              {
                                 dispatchEventWith("texturesRestored");
                              }
                           });
                        };
                        if(asset is Bitmap)
                        {
                           asset.bitmapData.dispose();
                        }
                        addTexture(name,texture);
                        onComplete();
                     }
                  }
                  else if(asset is ByteArray)
                  {
                     bytes = asset as ByteArray;
                     if(AtfData.isAtfData(bytes))
                     {
                        options.onReady = prependCallback(options.onReady,function():void
                        {
                           addTexture(name,texture);
                           onComplete();
                        });
                        texture = Texture.fromData(bytes,options);
                        texture.root.onRestore = function():void
                        {
                           _numLostTextures++;
                           loadRawAsset(rawAsset,null,function(asset:Object):void
                           {
                              try
                              {
                                 if(asset == null)
                                 {
                                    throw new Error("Reload failed");
                                 }
                                 texture.root.uploadAtfData(asset as ByteArray,0,false);
                                 asset.clear();
                              }
                              catch(e:Error)
                              {
                                 log("Texture restoration failed for \'" + name + "\': " + e.message);
                              }
                              _numRestoredTextures++;
                              Starling.current.stage.setRequiresRedraw();
                              if(_numLostTextures == _numRestoredTextures)
                              {
                                 dispatchEventWith("texturesRestored");
                              }
                           });
                        };
                        bytes.clear();
                     }
                     else if(byteArrayStartsWith(bytes,"{") || byteArrayStartsWith(bytes,"["))
                     {
                        try
                        {
                           object = JSON.parse(bytes.readUTFBytes(bytes.length));
                        }
                        catch(e:Error)
                        {
                           log("Could not parse JSON: " + e.message);
                           dispatchEventWith("parseError",false,name);
                        }
                        if(object)
                        {
                           addObject(name,object);
                        }
                        bytes.clear();
                        onComplete();
                     }
                     else if(byteArrayStartsWith(bytes,"<"))
                     {
                        try
                        {
                           xml = new XML(bytes);
                        }
                        catch(e:Error)
                        {
                           log("Could not parse XML: " + e.message);
                           dispatchEventWith("parseError",false,name);
                        }
                        process(xml);
                        bytes.clear();
                     }
                     else
                     {
                        addByteArray(name,bytes);
                        onComplete();
                     }
                  }
                  else
                  {
                     addObject(name,asset);
                     onComplete();
                  }
               }
            }
            asset = null;
            bytes = null;
            removeEventListener("cancel",cancel);
         };
         var progress:* = function(ratio:Number):void
         {
            if(!canceled)
            {
               onProgress(ratio);
            }
         };
         var cancel:* = function():void
         {
            canceled = true;
         };
         if(Boolean(onLoadName))
         {
            onLoadName(rawAsset);
         }
         canceled = false;
         addEventListener("cancel",cancel);
         loadRawAsset(rawAsset,progress,process);
      }
      
      protected function loadRawAsset(rawAsset:Object, onProgress:Function, onComplete:Function) : void
      {
         var loadAsset:* = function():void
         {
            urlRequest = rawAsset as URLRequest || new URLRequest(rawAsset as String);
            url = urlRequest.url;
            if(url.indexOf("ai_") != -1)
            {
               trace("加载资源！");
            }
            extension = getExtensionFromUrl(url);
            urlLoader = new URLLoader();
            urlLoader.dataFormat = "binary";
            urlLoader.addEventListener("ioError",onIoError);
            urlLoader.addEventListener("securityError",onSecurityError);
            urlLoader.addEventListener("httpResponseStatus",onHttpResponseStatus);
            urlLoader.addEventListener("progress",onLoadProgress);
            urlLoader.addEventListener("complete",onUrlLoaderComplete);
            urlLoader.load(urlRequest);
         };
         var onIoError:* = function(event:IOErrorEvent):void
         {
            log("IO error: " + event.text);
            dispatchEventWith("ioError",false,url);
            complete(null);
         };
         var onSecurityError:* = function(event:SecurityErrorEvent):void
         {
            log("security error: " + event.text);
            dispatchEventWith("securityError",false,url);
            complete(null);
         };
         var onHttpResponseStatus:* = function(event:HTTPStatusEvent):void
         {
            var headers:Array = null;
            var contentType:String = null;
            if(extension == null)
            {
               headers = event["responseHeaders"];
               contentType = getHttpHeader(headers,"Content-Type");
               if(contentType && /(audio|image)\//.exec(contentType))
               {
                  extension = contentType.split("/").pop();
               }
            }
         };
         var onLoadProgress:* = function(event:ProgressEvent):void
         {
            if(onProgress != null && event.bytesTotal > 0)
            {
               onProgress(event.bytesLoaded / event.bytesTotal);
            }
         };
         var onUrlLoaderComplete:* = function(event:Object):void
         {
            assetComplete(transformData(urlLoader.data as ByteArray,url));
         };
         var assetComplete:* = function(bytes:ByteArray):void
         {
            var sound:Sound = null;
            var loaderContext:LoaderContext = null;
            var loader:Loader = null;
            if(bytes == null)
            {
               complete(null);
               return;
            }
            if(extension)
            {
               extension = extension.toLowerCase();
            }
            switch(extension)
            {
               case "mpeg":
               case "mp3":
                  sound = new Sound();
                  sound.loadCompressedDataFromByteArray(bytes,bytes.length);
                  bytes.clear();
                  complete(sound);
                  break;
               case "jpg":
               case "jpeg":
               case "png":
               case "gif":
                  loaderContext = new LoaderContext(_checkPolicyFile);
                  loader = new Loader();
                  loaderContext.imageDecodingPolicy = "onLoad";
                  loaderInfo = loader.contentLoaderInfo;
                  loaderInfo.addEventListener("ioError",onIoError);
                  loaderInfo.addEventListener("complete",onLoaderComplete);
                  loader.loadBytes(bytes,loaderContext);
                  break;
               default:
                  complete(bytes);
            }
         };
         var onLoaderComplete:* = function(event:Object):void
         {
            if(urlLoader)
            {
               urlLoader.data.clear();
            }
            complete(event.target.content);
         };
         var complete:* = function(asset:Object):void
         {
            if(urlLoader)
            {
               urlLoader.removeEventListener("ioError",onIoError);
               urlLoader.removeEventListener("securityError",onSecurityError);
               urlLoader.removeEventListener("httpResponseStatus",onHttpResponseStatus);
               urlLoader.removeEventListener("progress",onLoadProgress);
               urlLoader.removeEventListener("complete",onUrlLoaderComplete);
            }
            if(loaderInfo)
            {
               loaderInfo.removeEventListener("ioError",onIoError);
               loaderInfo.removeEventListener("complete",onLoaderComplete);
            }
            if(SystemUtil.isDesktop)
            {
               onComplete(asset);
            }
            else
            {
               SystemUtil.executeWhenApplicationIsActive(onComplete,asset);
            }
         };
         var extension:String = null;
         var loaderInfo:LoaderInfo = null;
         var urlLoader:URLLoader = null;
         var urlRequest:URLRequest = null;
         var url:String = null;
         if(rawAsset is Class)
         {
            setTimeout(complete,1,new rawAsset());
         }
         else if(rawAsset is String || rawAsset is URLRequest)
         {
            if(Boolean(onLoadRawAssetOverride))
            {
               onLoadRawAssetOverride(rawAsset,function(byte:ByteArray):void
               {
                  if(byte == null)
                  {
                     loadAsset();
                  }
                  else
                  {
                     url = rawAsset as String;
                     extension = getExtensionFromUrl(url);
                     assetComplete(byte);
                  }
               },loadAsset);
            }
            else
            {
               loadAsset();
            }
         }
      }
      
      protected function getName(rawAsset:Object) : String
      {
         var name:String = null;
         if(rawAsset is String)
         {
            name = rawAsset as String;
         }
         else if(rawAsset is URLRequest)
         {
            name = (rawAsset as URLRequest).url;
         }
         else if(rawAsset is FileReference)
         {
            name = (rawAsset as FileReference).name;
         }
         if(name)
         {
            name = name.replace(/%20/g," ");
            name = getBasenameFromUrl(name);
            if(name)
            {
               return name;
            }
            throw new ArgumentError("Could not extract name from String \'" + rawAsset + "\'");
         }
         name = getQualifiedClassName(rawAsset);
         throw new ArgumentError("Cannot extract names for objects of type \'" + name + "\'");
      }
      
      protected function transformData(data:ByteArray, url:String) : ByteArray
      {
         return data;
      }
      
      protected function log(message:String) : void
      {
         trace("[AssetManager]",message);
      }
      
      private function byteArrayStartsWith(bytes:ByteArray, char:String) : Boolean
      {
         var i:* = 0;
         var byte:int = 0;
         var start:int = 0;
         var length:int = int(bytes.length);
         var wanted:int = int(char.charCodeAt(0));
         if(length >= 4 && (bytes[0] == 0 && bytes[1] == 0 && bytes[2] == 254 && bytes[3] == 255) || bytes[0] == 255 && bytes[1] == 254 && bytes[2] == 0 && bytes[3] == 0)
         {
            start = 4;
         }
         else if(length >= 3 && bytes[0] == 239 && bytes[1] == 187 && bytes[2] == 191)
         {
            start = 3;
         }
         else if(length >= 2 && (bytes[0] == 254 && bytes[1] == 255) || bytes[0] == 255 && bytes[1] == 254)
         {
            start = 2;
         }
         for(i = start; i < length; )
         {
            byte = int(bytes[i]);
            if(!(byte == 0 || byte == 10 || byte == 13 || byte == 32))
            {
               return byte == wanted;
            }
            i++;
         }
         return false;
      }
      
      private function getDictionaryKeys(dictionary:Dictionary, prefix:String = "", out:Vector.<String> = null) : Vector.<String>
      {
         if(out == null)
         {
            out = new Vector.<String>(0);
         }
         for(var name in dictionary)
         {
            if(name.indexOf(prefix) == 0)
            {
               out[out.length] = name;
            }
         }
         out.sort(1);
         return out;
      }
      
      private function getHttpHeader(headers:Array, headerName:String) : String
      {
         if(headers)
         {
            for each(var header in headers)
            {
               if(header.name == headerName)
               {
                  return header.value;
               }
            }
         }
         return null;
      }
      
      protected function getBasenameFromUrl(url:String) : String
      {
         var matches:Array = NAME_REGEX.exec(url);
         if(matches && matches.length > 0)
         {
            return matches[1];
         }
         return null;
      }
      
      protected function getExtensionFromUrl(url:String) : String
      {
         var matches:Array = NAME_REGEX.exec(url);
         if(matches && matches.length > 1)
         {
            return matches[2];
         }
         return null;
      }
      
      private function prependCallback(oldCallback:Function, newCallback:Function) : Function
      {
         if(oldCallback == null)
         {
            return newCallback;
         }
         if(newCallback == null)
         {
            return oldCallback;
         }
         return function():void
         {
            newCallback();
            oldCallback();
         };
      }
      
      protected function get queue() : Array
      {
         return _queue;
      }
      
      public function get numQueuedAssets() : int
      {
         return _queue.length;
      }
      
      public function get verbose() : Boolean
      {
         return false;
      }
      
      public function set verbose(value:Boolean) : void
      {
         _verbose = value;
      }
      
      public function get isLoading() : Boolean
      {
         return _numLoadingQueues > 0;
      }
      
      public function get useMipMaps() : Boolean
      {
         return _defaultTextureOptions.mipMapping;
      }
      
      public function set useMipMaps(value:Boolean) : void
      {
         _defaultTextureOptions.mipMapping = value;
      }
      
      public function get scaleFactor() : Number
      {
         return _defaultTextureOptions.scale;
      }
      
      public function set scaleFactor(value:Number) : void
      {
         _defaultTextureOptions.scale = value;
      }
      
      public function get textureFormat() : String
      {
         return _defaultTextureOptions.format;
      }
      
      public function set textureFormat(value:String) : void
      {
         _defaultTextureOptions.format = value;
      }
      
      public function get forcePotTextures() : Boolean
      {
         return _defaultTextureOptions.forcePotTexture;
      }
      
      public function set forcePotTextures(value:Boolean) : void
      {
         _defaultTextureOptions.forcePotTexture = value;
      }
      
      public function get checkPolicyFile() : Boolean
      {
         return _checkPolicyFile;
      }
      
      public function set checkPolicyFile(value:Boolean) : void
      {
         _checkPolicyFile = value;
      }
      
      public function get keepAtlasXmls() : Boolean
      {
         return _keepAtlasXmls;
      }
      
      public function set keepAtlasXmls(value:Boolean) : void
      {
         _keepAtlasXmls = value;
      }
      
      public function get keepFontXmls() : Boolean
      {
         return _keepFontXmls;
      }
      
      public function set keepFontXmls(value:Boolean) : void
      {
         _keepFontXmls = value;
      }
      
      public function get numConnections() : int
      {
         return _numConnections;
      }
      
      public function set numConnections(value:int) : void
      {
         _numConnections = value;
      }
   }
}

