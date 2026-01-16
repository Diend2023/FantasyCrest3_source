package zygame.tmx
{
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   
   public class MapStyle
   {
      
      public var textureAtlas:TextureAtlas;
      
      public var landTexture:Texture;
      
      public var roundedLandTexture:Texture;
      
      public var surfaceTexture:Texture;
      
      public var lineTexture:Texture;
      
      public var offsetY:int;
      
      public var offsetX:int;
      
      private var _name:String;
      
      public function MapStyle(pname:String)
      {
         super();
         _name = pname;
      }
      
      public static function formTextureAtlas(atlasName:String, offsetX:int, offsetY:int) : MapStyle
      {
         var bian:Texture = null;
         atlasName = atlasName.substr(atlasName.lastIndexOf("/") + 1);
         var atlas:TextureAtlas = DataCore.getTextureAtlas(atlasName);
         var map:MapStyle = new MapStyle(atlasName);
         var dipi:Texture = atlas.getTextures("dipi")[0];
         var wenli:Texture = atlas.getTextures("wenli")[0];
         if(atlas.getTextures("bian").length > 0)
         {
            bian = atlas.getTextures("bian")[0];
         }
         if(dipi)
         {
            map.landTexture = dipi;
         }
         if(bian)
         {
            map.roundedLandTexture = bian;
         }
         if(wenli)
         {
            map.surfaceTexture = wenli;
         }
         map.offsetX = offsetX;
         map.offsetY = offsetY;
         map.textureAtlas = atlas;
         return map;
      }
      
      public function get name() : String
      {
         return _name;
      }
   }
}

