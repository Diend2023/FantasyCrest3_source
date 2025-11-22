package zygame.utils
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.System;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   
   public class SuperTextureAtlas extends TextureAtlas
   {
      
      public static var support:Boolean = false;
      
      public static var maxWH:int = 2048;
      
      public static var size:int = 1024;
      
      private var _maxPack:Vector.<Object>;
      
      private var _textureAtlas:Vector.<TextureAtlas>;
      
      private var _separationCount:int = 0;
      
      private var _separationIndex:int = 0;
      
      private var _bitmapData:BitmapData;
      
      private var _xml:XMLList;
      
      private var _length:int = 0;
      
      private var _count:int = 0;
      
      public function SuperTextureAtlas(bitmapData:BitmapData, xml:XML, textureType:String = "bgra")
      {
         var c:int = 0;
         var textureAtlas:TextureAtlas = null;
         _bitmapData = bitmapData;
         _xml = xml.children();
         for(var i in _xml)
         {
            if(int(_xml[i].@width) == 0 || int(_xml[i].@height) == 0)
            {
               delete _xml[i];
            }
         }
         _length = _xml.length();
         _textureAtlas = new Vector.<TextureAtlas>();
         _maxPack = new Vector.<Object>();
         _separationCount = 1;
         while(_maxPack.length < _separationCount)
         {
            _maxPack.push(separation());
         }
         trace("最终分解长度：",xml.@imagePath,_separationCount);
         super(Texture.fromBitmapData(_maxPack[0].bitmapData),_maxPack[0].xml);
         for(c = 0; c < _maxPack.length; )
         {
            if(c != 0)
            {
               textureAtlas = new TextureAtlas(Texture.fromBitmapData(_maxPack[c].bitmapData,false,false,1,textureType),_maxPack[c].xml);
               _textureAtlas.push(textureAtlas);
            }
            _maxPack[c].bitmapData = null;
            System.disposeXML(_maxPack[c].xml);
            _maxPack[c].xml = null;
            _maxPack[c] = null;
            c++;
         }
         _bitmapData.dispose();
         _bitmapData = null;
      }
      
      private function separation() : Object
      {
         var i:int = 0;
         var w:int = 0;
         var h:int = 0;
         var rect:Rectangle = null;
         var u:int = 0;
         var childxml:XML = null;
         var childrect:Rectangle = null;
         var w2:int = 0;
         var h2:int = 0;
         var nodeXML:XML = null;
         var psize:int = _separationCount == 1 ? 2048 : size;
         var bitmapData:BitmapData = new BitmapData(psize,psize,true,0);
         var pack:MaxRectsBinPack = new MaxRectsBinPack(psize,psize,false);
         for(i = _separationIndex; i < _length; )
         {
            w = int(_xml[i].@width);
            h = int(_xml[i].@height);
            if(w != 0 && h != 0)
            {
               rect = pack.insert(w,h,3);
               if(rect.width == 0 || rect.height == 0)
               {
                  _separationCount++;
                  break;
               }
            }
            else
            {
               pack.insert(0,0,0);
            }
            _count++;
            i++;
         }
         var newXML:XML = <xml></xml>;
         for(u = 0; u < pack.usedRectangles.length; )
         {
            childxml = _xml[_separationIndex + u];
            childrect = pack.usedRectangles[u];
            w2 = int(childxml.@width);
            h2 = int(childxml.@height);
            if(!(w2 == 0 || h2 == 0))
            {
               bitmapData.copyPixels(_bitmapData,new Rectangle(int(childxml.@x),int(childxml.@y),w2,h2),new Point(childrect.x,childrect.y));
               nodeXML = childxml.copy();
               nodeXML.@x = childrect.x;
               nodeXML.@y = childrect.y;
               nodeXML.@width = childrect.width;
               nodeXML.@height = childrect.height;
               newXML.appendChild(nodeXML);
            }
            u++;
         }
         trace("分解-" + i,newXML.toXMLString());
         _separationIndex = i;
         return {
            "bitmapData":bitmapData,
            "xml":newXML
         };
      }
      
      override public function getTexture(name:String) : Texture
      {
         var i:int = 0;
         var texture:Texture = super.getTexture(name);
         if(texture)
         {
            return texture;
         }
         i = 0;
         while(i < _textureAtlas.length)
         {
            texture = _textureAtlas[i].getTexture(name);
            if(texture)
            {
               return texture;
            }
            i++;
         }
         return null;
      }
      
      override public function getFrame(name:String) : Rectangle
      {
         var i:int = 0;
         var rect:Rectangle = super.getFrame(name);
         if(rect)
         {
            return rect;
         }
         i = 0;
         while(i < _textureAtlas.length)
         {
            rect = _textureAtlas[i].getFrame(name);
            if(rect)
            {
               return rect;
            }
            i++;
         }
         return null;
      }
      
      override public function getRegion(name:String) : Rectangle
      {
         var i:int = 0;
         var rect:Rectangle = super.getRegion(name);
         if(rect)
         {
            return rect;
         }
         i = 0;
         while(i < _textureAtlas.length)
         {
            rect = _textureAtlas[i].getRegion(name);
            if(rect)
            {
               return rect;
            }
            i++;
         }
         return null;
      }
      
      override public function getRotation(name:String) : Boolean
      {
         var i:int = 0;
         var bool:Boolean = super.getRotation(name);
         if(bool)
         {
            return true;
         }
         i = 0;
         while(i < _textureAtlas.length)
         {
            bool = Boolean(_textureAtlas[i].getRegion(name));
            if(bool)
            {
               return true;
            }
            i++;
         }
         return false;
      }
      
      override public function getNames(prefix:String = "", out:Vector.<String> = null) : Vector.<String>
      {
         var i:int = 0;
         var vec:Vector.<String> = super.getNames(prefix,out);
         if(vec)
         {
            return vec;
         }
         i = 0;
         while(i < _textureAtlas.length)
         {
            vec = _textureAtlas[i].getNames(prefix,out);
            if(vec)
            {
               return vec;
            }
            i++;
         }
         return null;
      }
      
      override public function getTextures(prefix:String = "", out:Vector.<Texture> = null) : Vector.<Texture>
      {
         var i:int = 0;
         var vec:Vector.<Texture> = super.getTextures(prefix,out);
         if(vec && vec.length > 0)
         {
            return vec;
         }
         i = 0;
         while(i < _textureAtlas.length)
         {
            vec = _textureAtlas[i].getTextures(prefix,out);
            if(vec && vec.length > 0)
            {
               return vec;
            }
            i++;
         }
         return vec;
      }
      
      override public function dispose() : void
      {
         var c:int = 0;
         var i:int = 0;
         for(c = 0; c < _textureAtlas.length; )
         {
            _textureAtlas[c].dispose();
            c++;
         }
         if(_maxPack)
         {
            for(i = 0; i < _maxPack.length; )
            {
               if(_maxPack[i])
               {
                  if(_maxPack[i].bitmapData)
                  {
                     (_maxPack[i].bitmapData as BitmapData).dispose();
                  }
                  System.disposeXML(_maxPack[i].xml as XML);
               }
               i++;
            }
            _maxPack.splice(0,_maxPack.length);
            _maxPack = null;
         }
         super.dispose();
      }
   }
}

