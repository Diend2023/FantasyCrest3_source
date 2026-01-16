package game.view.item
{
   import game.uilts.GameFont;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.core.DataCore;
   import zygame.display.BaseItem;
   
   public class MapItem extends BaseItem
   {
      
      private var _mapImage:Image;
      
      private var _image:Image;
      
      private var _mask:Quad;
      
      private var _text:TextField;
      
      public function MapItem()
      {
         super();
         _mapImage = new Image(DataCore.getTextureAtlas("select_role").getTexture("map_bg_frame"));
         this.addChild(_mapImage);
         this.width = _mapImage.width;
         this.height = _mapImage.height;
         _mask = new Quad(this.width - 10,this.height - 10,0);
         _mask.x = 5;
         _mask.y = 5;
         this.addChild(_mask);
         var text:TextField = new TextField(this.width,40,"一平之战",new TextFormat(GameFont.FONT_NAME,18,16777215));
         this.addChild(text);
         _text = text;
         this.alpha = 0.5;
      }
      
      override public function set data(value:Object) : void
      {
         super.data = value;
         if(value)
         {
            _text.text = value.name;
            if(!_image)
            {
               if(DataCore.getTextureAtlas("map_image").getTextures(value.target).length > 0)
               {
                  _image = new Image(DataCore.getTextureAtlas("map_image").getTextures(value.target)[0]);
                  _image.scale = (_mapImage.width - 10) / _image.width;
                  _image.x = 5;
                  _image.mask = _mask;
                  this.addChildAt(_image,0);
               }
            }
            else
            {
               _image.texture = DataCore.getTextureAtlas("map_image").getTextures(value.target)[0];
            }
         }
      }
      
      override public function set isSelected(value:Boolean) : void
      {
         super.isSelected = value;
         this.alpha = value ? 1 : 0.5;
      }
   }
}

