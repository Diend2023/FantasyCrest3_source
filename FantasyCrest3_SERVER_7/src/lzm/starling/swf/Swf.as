package lzm.starling.swf
{
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import lzm.starling.swf.blendmode.SwfBlendMode;
   import lzm.starling.swf.components.ComponentConfig;
   import lzm.starling.swf.components.ISwfComponent;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfImage;
   import lzm.starling.swf.display.SwfMovieClip;
   import lzm.starling.swf.display.SwfParticleSyetem;
   import lzm.starling.swf.display.SwfScale9Image;
   import lzm.starling.swf.display.SwfShapeImage;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.filter.SwfFilter;
   import lzm.util.Clone;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.Texture;
   import starling.utils.AssetManager;
   
   public class Swf
   {
      
      public static const dataKey_Sprite:String = "spr";
      
      public static const dataKey_Image:String = "img";
      
      public static const dataKey_MovieClip:String = "mc";
      
      public static const dataKey_TextField:String = "text";
      
      public static const dataKey_Button:String = "btn";
      
      public static const dataKey_Scale9:String = "s9";
      
      public static const dataKey_ShapeImg:String = "shapeImg";
      
      public static const dataKey_Component:String = "comp";
      
      public static const dataKey_Particle:String = "particle";
      
      public static const dataKey_BDClip:String = "bdc";
      
      public static const ANGLE_TO_RADIAN:Number = 0.017453292519943295;
      
      public static var starlingRoot:Sprite;
      
      private static var _isInit:Boolean = false;
      
      public var textureSmoothing:String = "bilinear";
      
		private const createFuns:Object = {
			"img":createImage,
			"spr":createSprite,
			"mc":createMovieClip,
			"text":createTextField,
			"btn":createButton,
			"s9":createS9Image,
			"shapeImg":createShapeImage,
			"comp":createComponent,
			"particle":createParticle,
			"bdc":createMovieClip
		};
      
      private var _assets:AssetManager;
      
      private var _swfDatas:Object;
      
      private var _swfUpdateManager:SwfUpdateManager;
      
      private var _passedTime:Number;
      
      private var _particleXML:Object;
      
      public function Swf(swfData:ByteArray, assets:AssetManager, fps:int = 24)
      {
         // createFuns = {
         //    "img":createImage,
         //    "spr":createSprite,
         //    "mc":createMovieClip,
         //    "text":createTextField,
         //    "btn":createButton,
         //    "s9":createS9Image,
         //    "shapeImg":createShapeImage,
         //    "comp":createComponent,
         //    "particle":createParticle,
         //    "bdc":createMovieClip
         // };
         super();
         if(!_isInit)
         {
            throw new Error("要使用Swf，请先调用Swf.init");
         }
         var bytes:ByteArray = Clone.clone(swfData);
         bytes.uncompress();
         this._swfDatas = JSON.parse(new String(bytes));
         this._assets = assets;
         this._swfUpdateManager = new SwfUpdateManager(fps,starlingRoot);
         this._passedTime = 1000 / fps * 0.001;
         this._particleXML = {};
         bytes.clear();
      }
      
      public static function init(starlingRoot:Sprite) : void
      {
         if(_isInit)
         {
            return;
         }
         _isInit = true;
         Swf.starlingRoot = starlingRoot;
      }
      
      public function get swfData() : Object
      {
         return _swfDatas;
      }
      
      public function get assets() : AssetManager
      {
         return _assets;
      }
      
      public function get swfUpdateManager() : SwfUpdateManager
      {
         return _swfUpdateManager;
      }
      
      public function set fps(value:int) : void
      {
         _passedTime = 1000 / value * 0.001;
         _swfUpdateManager.fps = value;
      }
      
      public function get fps() : int
      {
         return _swfUpdateManager.fps;
      }
      
      public function get passedTime() : Number
      {
         return _passedTime;
      }
      
      public function createDisplayObject(name:String) : DisplayObject
      {
         var fun:Function = null;
         for(var k in createFuns)
         {
            if(_swfDatas[k] && _swfDatas[k][name])
            {
               fun = createFuns[k];
               return fun(name);
            }
         }
         return null;
      }
      
      public function hasSprite(name:String) : Boolean
      {
         return _swfDatas["spr"][name] != null;
      }
      
      public function createSprite(name:String, data:Array = null, sprData:Array = null) : SwfSprite
      {
         var objData:Array = null;
         var display:Object = null;
         var fun:Function = null;
         var i:int = 0;
         if(sprData == null)
         {
            sprData = _swfDatas["spr"][name];
         }
         var sprite:SwfSprite = new SwfSprite();
         var length:int = int(sprData.length);
         for(i = 0; i < length; )
         {
            objData = sprData[i];
            fun = createFuns[objData[1]];
            if(fun != null)
            {
               display = fun(objData[0],objData);
               display.name = objData[9];
               if(display is DisplayObject)
               {
                  display.x = objData[2];
                  display.y = objData[3];
                  if(objData[1] != "s9" && objData[1] != "shapeImg")
                  {
                     display.scaleX = objData[4];
                     display.scaleY = objData[5];
                  }
                  display.skewX = objData[6] * 0.017453292519943295;
                  display.skewY = objData[7] * 0.017453292519943295;
                  display.alpha = objData[8];
                  if(display is ISwfComponent && objData[10] != null)
                  {
                     display.editableProperties = objData[10];
                  }
                  sprite.addChild(display as DisplayObject);
               }
               else if(display is ISwfComponent)
               {
                  sprite.addComponent(display as ISwfComponent);
               }
            }
            i++;
         }
         if(data != null)
         {
            sprite.filter = SwfFilter.createFilter(data[10]);
            SwfBlendMode.setBlendMode(sprite,data[11]);
         }
         sprite.data = data;
         sprite.spriteData = sprData;
         sprite.classLink = name;
         return sprite;
      }
      
      public function hasMovieClip(name:String) : Boolean
      {
         if(_swfDatas["mc"][name] != null)
         {
            return true;
         }
         if(_swfDatas["bdc"] == null)
         {
            return false;
         }
         return _swfDatas["bdc"][name] != null;
      }
      
      public function createMovieClip(name:String, data:Array = null) : SwfMovieClip
      {
         var displayObjectArray:Array = null;
         var type:String = null;
         var count:int = 0;
         var fun:Function = null;
         var i:int = 0;
         var movieClipData:Object = _swfDatas["mc"][name];
         if(movieClipData == null)
         {
            movieClipData = _swfDatas["bdc"][name];
         }
         var objectCountData:Object = movieClipData["objCount"];
         var displayObjects:Object = {};
         for(var objName in objectCountData)
         {
            type = objectCountData[objName][0];
            count = int(objectCountData[objName][1]);
            displayObjectArray = displayObjects[objName] == null ? [] : displayObjects[objName];
            for(i = 0; i < count; )
            {
               fun = createFuns[type];
               if(fun != null)
               {
                  displayObjectArray.push(fun(objName,null));
               }
               i++;
            }
            displayObjects[objName] = displayObjectArray;
         }
         var mc:SwfMovieClip = new SwfMovieClip(movieClipData["frames"],movieClipData["labels"],displayObjects,this,movieClipData["frameEvents"]);
         mc.loop = movieClipData["loop"];
         if(data != null)
         {
            mc.filter = SwfFilter.createFilter(data[10]);
            SwfBlendMode.setBlendMode(mc,data[11]);
         }
         mc.classLink = name;
         return mc;
      }
      
      public function hasImage(name:String) : Boolean
      {
         return _swfDatas["img"][name] != null;
      }
      
      public function createImage(name:String, data:Array = null) : SwfImage
      {
         var texture:Texture = _assets.getTexture(name);
         if(texture == null)
         {
            throw new Error("Texture \"" + name + "\" not exist");
         }
         var imageData:Array = _swfDatas["img"][name];
         var image:SwfImage = new SwfImage(texture);
         image.textureSmoothing = textureSmoothing;
         image.pivotX = imageData[0];
         image.pivotY = imageData[1];
         if(data != null)
         {
            image.filter = SwfFilter.createFilter(data[10]);
            SwfBlendMode.setBlendMode(image,data[11]);
         }
         image.classLink = name;
         return image;
      }
      
      public function hasButton(name:String) : Boolean
      {
         return _swfDatas["btn"][name] != null;
      }
      
      public function createButton(name:String, data:Array = null) : SwfButton
      {
         var sprData:Array = _swfDatas["btn"][name];
         var skin:Sprite = createSprite(null,null,sprData);
         var button:SwfButton = new SwfButton(skin);
         if(data != null)
         {
            button.filter = SwfFilter.createFilter(data[10]);
            SwfBlendMode.setBlendMode(button,data[11]);
         }
         button.classLink = name;
         return button;
      }
      
      public function hasS9Image(name:String) : Boolean
      {
         return _swfDatas["s9"][name] != null;
      }
      
      public function createS9Image(name:String, data:Array = null) : SwfScale9Image
      {
         var scale9Data:Array = _swfDatas["s9"][name];
         var texture:Texture = _assets.getTexture(name);
         var s9image:SwfScale9Image = new SwfScale9Image(texture,new Rectangle(scale9Data[0],scale9Data[1],scale9Data[2],scale9Data[3]));
         if(data != null)
         {
            s9image.width = data[10];
            s9image.height = data[11];
            s9image.filter = SwfFilter.createFilter(data[12]);
            SwfBlendMode.setBlendMode(s9image,data[13]);
         }
         s9image.classLink = name;
         return s9image;
      }
      
      public function hasShapeImage(name:String) : Boolean
      {
         return _swfDatas["shapeImg"][name] != null;
      }
      
      public function createShapeImage(name:String, data:Array = null) : SwfShapeImage
      {
         var imageData:Array = _swfDatas["shapeImg"][name];
         var shapeImage:SwfShapeImage = new SwfShapeImage(_assets.getTexture(name));
         if(data != null)
         {
            shapeImage.filter = SwfFilter.createFilter(data[12]);
            SwfBlendMode.setBlendMode(shapeImage,data[13]);
         }
         shapeImage.classLink = name;
         return shapeImage;
      }
      
      public function createTextField(name:String, data:Array = null) : TextField
      {
         var filters:Array = null;
         var textfield:TextField = new TextField(2,2,"");
         var fomat:TextFormat = new TextFormat();
         if(data != null)
         {
            textfield.width = data[10];
            textfield.height = data[11];
            fomat.font = data[12];
            fomat.color = data[13];
            fomat.size = data[14];
            fomat.horizontalAlign = data[15];
            fomat.italic = data[16];
            fomat.bold = data[17];
            textfield.text = data[18];
            filters = SwfFilter.createTextFieldFilter(data[19]);
            SwfBlendMode.setBlendMode(textfield,data[20]);
         }
         textfield.format = fomat;
         return textfield;
      }
      
      public function hasComponent(name:String) : Boolean
      {
         return _swfDatas["comp"][name] != null;
      }
      
      public function createComponent(name:String, data:Array = null) : *
      {
         var sprData:Array = _swfDatas["comp"][name];
         var conponentContnt:SwfSprite = createSprite(name,data,sprData);
         var componentClass:Class = ComponentConfig.getComponentClass(name);
         if(componentClass == null)
         {
            return conponentContnt;
         }
         var component:ISwfComponent = new componentClass();
         component.initialization(conponentContnt);
         if(data != null)
         {
            if(component is DisplayObject)
            {
               component["filter"] = SwfFilter.createFilter(data[11]);
               SwfBlendMode.setBlendMode(component as DisplayObject,data[12]);
            }
         }
         return component;
      }
      
      public function hasParticle(name:String) : Boolean
      {
         return _swfDatas["particle"][name];
      }
      
      public function createParticle(name:String, data:Array = null) : SwfParticleSyetem
      {
         var particleData:Array = _swfDatas["particle"][name];
         var textureName:String = particleData[1];
         var texture:Texture = _assets.getTexture(textureName);
         if(texture == null)
         {
            throw new Error("Texture \"" + name + "\" not exist");
         }
         var xml:XML = _particleXML[name];
         if(xml == null)
         {
            xml = new XML(particleData[0]);
            _particleXML[name] = xml;
         }
         var particle:SwfParticleSyetem = new SwfParticleSyetem(xml,texture,this);
         particle.classLink = name;
         return particle;
      }
      
      public function mergerSwfData(swfData:Object) : void
      {
         var typeKey:String = null;
         var typeData:Object = null;
         var objectKey:String = null;
         for(typeKey in swfData)
         {
            typeData = swfData[typeKey];
            for(objectKey in typeData)
            {
               this._swfDatas[typeKey][objectKey] = typeData[objectKey];
            }
         }
      }
      
      public function mergerSwfDataBytes(swfDataBytes:ByteArray) : void
      {
         var bytes:ByteArray = Clone.clone(swfDataBytes);
         bytes.uncompress();
         mergerSwfData(JSON.parse(new String(bytes)));
         bytes.clear();
      }
      
      public function dispose(disposeAssets:Boolean) : void
      {
         _swfUpdateManager.dispose();
         if(disposeAssets)
         {
            _assets.purge();
         }
         _assets = null;
         _swfDatas = null;
         _swfUpdateManager = null;
      }
   }
}

