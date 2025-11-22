package starling.utils
{
   import flash.utils.Dictionary;
   import lzm.util.Base64;
   
   public class EncodeAssets extends AssetManager
   {
      
      public static var loadPathConversion:Function;
      
      public static var addXmlConversion:Function;
      
      public static var COMPRESSEDS:Array = [];
      
      public static var COMPRESSED_ALPHA:Array = [];
      
      public static var KEEP:Array = [];
      
      private var _encodeXML:Dictionary;
      
      public var disableEncode:Boolean = true;
      
      public function EncodeAssets(scaleFactor:Number = 1, useMipmaps:Boolean = false)
      {
         super(scaleFactor,useMipmaps);
         _encodeXML = new Dictionary();
      }
      
      override public function addXml(name:String, xml:XML) : void
      {
         if(Boolean(addXmlConversion))
         {
            xml = addXmlConversion(xml);
         }
         if(!disableEncode)
         {
            _encodeXML[name] = Base64.encode(xml.toXMLString());
         }
         super.addXml(name,xml);
      }
      
      override public function getXml(name:String) : XML
      {
         var xml:XML = super.getXml(name);
         if(disableEncode)
         {
            return xml;
         }
         if(xml)
         {
            if(_encodeXML[name] == undefined || _encodeXML[name] == Base64.encode(xml.toXMLString()))
            {
               return xml;
            }
         }
         return null;
      }
      
      override public function enqueue(... rawAssets) : void
      {
         var type:String = this.textureFormat;
         for(var i in rawAssets)
         {
            trace("enqueue:",rawAssets[i]);
            ruleFile(rawAssets[i]);
            if(loadPathConversion != null)
            {
               rawAssets[i] = loadPathConversion(rawAssets[i]);
            }
            super.enqueue(rawAssets[i]);
            this.textureFormat = type;
         }
      }
      
      private function ruleFile(url:String) : void
      {
         for(var i in KEEP)
         {
            if(url.indexOf(KEEP[i]) != -1)
            {
               return;
            }
         }
         for(i in COMPRESSEDS)
         {
            if(url.indexOf(COMPRESSEDS[i]) != -1)
            {
               this.textureFormat = "compressed";
               return;
            }
         }
         for(i in COMPRESSED_ALPHA)
         {
            if(url.indexOf(COMPRESSED_ALPHA[i]) != -1)
            {
               this.textureFormat = "compressedAlpha";
               return;
            }
         }
      }
      
      override public function dispose() : void
      {
         var count:int = 0;
         for(var i in _encodeXML)
         {
            count++;
         }
         trace("Encode count:",count);
         super.dispose();
      }
   }
}

