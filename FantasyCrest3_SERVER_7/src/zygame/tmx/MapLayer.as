package zygame.tmx
{
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.display.Mesh;
   import starling.display.MeshBatch;
   import starling.display.Sprite;
   import starling.textures.Texture;
   
   public class MapLayer extends Sprite
   {
      
      private var _spr:Sprite;
      
      private var _dySpr:Sprite;
      
      private var _skin:MeshBatch;
      
      public function MapLayer()
      {
         super();
         _spr = new Sprite();
         _dySpr = new Sprite();
         _skin = new MeshBatch();
         this.addChild(_spr);
         this.addChild(_dySpr);
         this.addChild(_skin);
         _skin.touchable = false;
         _dySpr.touchable = false;
         _spr.touchable = false;
      }
      
      public function removeSylte() : void
      {
         _spr.removeChildren();
         _skin.clear();
      }
      
      public function addCanvas(c:MapCanvas) : void
      {
         if(c.mode == "dynamic_visible")
         {
            _dySpr.addChild(c);
         }
         else
         {
            _spr.addChild(c);
         }
      }
      
      public function addBGTexture(texture:Texture, w:int, h:int) : void
      {
         var i:int = 0;
         var mapCanvas:MapCanvas = null;
         var image:Image = null;
         var dimage:Image = new Image(texture);
         dimage.textureRepeat = true;
         dimage.textureSmoothing = "none";
         dimage.x = _spr.bounds.x;
         dimage.y = _spr.bounds.y;
         dimage.width = _spr.bounds.width;
         dimage.height = _spr.bounds.height;
         dimage.tileGrid = new Rectangle(-dimage.x,-dimage.y);
         dimage.alpha = 1;
         this.addChildAt(dimage,0);
         dimage.mask = _spr;
         for(i = _dySpr.numChildren - 1; i >= 0; )
         {
            mapCanvas = _dySpr.getChildAt(i) as MapCanvas;
            image = new Image(texture);
            image.textureRepeat = true;
            image.textureSmoothing = "none";
            image.width = mapCanvas.bounds.width;
            image.height = mapCanvas.bounds.height;
            image.x = mapCanvas.bounds.x;
            image.y = mapCanvas.bounds.y;
            image.tileGrid = new Rectangle(-image.x,-image.y);
            image.alpha = 1;
            this.addChildAt(image,0);
            image.mask = mapCanvas;
            mapCanvas.image = image;
            i--;
         }
      }
      
      public function addSkin(display:Mesh) : void
      {
         _skin.addMesh(display);
      }
   }
}

