package lzm.starling.swf.display
{
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.textures.SubTexture;
   import starling.textures.Texture;
   
   public class SwfScale9Image extends Sprite
   {
      
      public var classLink:String;
      
      private var _texture:Texture;
      
      private var _scale9Grid:Rectangle;
      
      private var _images:Vector.<Image>;
      
      private var _width:Number;
      
      private var _height:Number;
      
      public function SwfScale9Image(texture:Texture, scale9Grid:Rectangle)
      {
         super();
         this._scale9Grid = scale9Grid;
         trace("_scale9Grid",scale9Grid);
         this._texture = texture;
         this._width = this._texture.width;
         this._height = this._texture.height;
         init();
      }
      
      protected function init() : void
      {
         var i:int = 0;
         _images = new Vector.<Image>();
         var texture:Texture = new SubTexture(_texture,new Rectangle(0,0,_scale9Grid.x,_scale9Grid.y));
         var image:Image = new Image(texture);
         _images.push(image);
         texture = new SubTexture(_texture,new Rectangle(_scale9Grid.x,0,_scale9Grid.width,_scale9Grid.y));
         image = new Image(texture);
         image.x = _scale9Grid.x;
         _images.push(image);
         texture = new SubTexture(_texture,new Rectangle(_scale9Grid.x + _scale9Grid.width,0,_texture.width - _scale9Grid.x - _scale9Grid.width,_scale9Grid.y));
         image = new Image(texture);
         image.x = _scale9Grid.x + _scale9Grid.width;
         _images.push(image);
         texture = new SubTexture(_texture,new Rectangle(0,_scale9Grid.y,_scale9Grid.x,_scale9Grid.height));
         image = new Image(texture);
         image.y = _scale9Grid.y;
         _images.push(image);
         texture = new SubTexture(_texture,new Rectangle(_scale9Grid.x,_scale9Grid.y,_scale9Grid.width,_scale9Grid.height));
         image = new Image(texture);
         image.x = _scale9Grid.x;
         image.y = _scale9Grid.y;
         _images.push(image);
         texture = new SubTexture(_texture,new Rectangle(_scale9Grid.x + _scale9Grid.width,_scale9Grid.y,_texture.width - _scale9Grid.x - _scale9Grid.width,_scale9Grid.height));
         image = new Image(texture);
         image.x = _scale9Grid.x + _scale9Grid.width;
         image.y = _scale9Grid.y;
         _images.push(image);
         texture = new SubTexture(_texture,new Rectangle(0,_scale9Grid.y + _scale9Grid.height,_scale9Grid.x,_texture.height - _scale9Grid.y - _scale9Grid.height));
         image = new Image(texture);
         image.y = _scale9Grid.y + _scale9Grid.height;
         _images.push(image);
         texture = new SubTexture(_texture,new Rectangle(_scale9Grid.x,_scale9Grid.y + _scale9Grid.height,_scale9Grid.width,_texture.height - _scale9Grid.y - _scale9Grid.height));
         image = new Image(texture);
         image.x = _scale9Grid.x;
         image.y = _scale9Grid.y + _scale9Grid.height;
         _images.push(image);
         texture = new SubTexture(_texture,new Rectangle(_scale9Grid.x + _scale9Grid.width,_scale9Grid.y + _scale9Grid.height,_texture.width - _scale9Grid.x - _scale9Grid.width,_texture.height - _scale9Grid.y - _scale9Grid.height));
         image = new Image(texture);
         image.x = _scale9Grid.x + _scale9Grid.width;
         image.y = _scale9Grid.y + _scale9Grid.height;
         _images.push(image);
         for(i = 0; i < 9; )
         {
            addChild(_images[i]);
            i++;
         }
      }
      
      override public function set width(value:Number) : void
      {
         _width = value;
         var _w:Number = _width - _scale9Grid.x - _images[2].width;
         var _x:Number = _scale9Grid.x + _w;
         _images[1].width = _images[4].width = _images[7].width = _w;
         _images[2].x = _images[5].x = _images[8].x = _x;
      }
      
      override public function get width() : Number
      {
         return _width;
      }
      
      override public function set height(value:Number) : void
      {
         _height = value;
         var _h:Number = _height - _scale9Grid.y - _images[6].height;
         var _y:Number = _scale9Grid.y + _h;
         _images[3].height = _images[4].height = _images[5].height = _h;
         _images[6].y = _images[7].y = _images[8].y = _y;
      }
      
      override public function get height() : Number
      {
         return _height;
      }
      
      public function get texture() : Texture
      {
         return _texture;
      }
   }
}

