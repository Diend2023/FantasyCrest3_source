package game.display
{
   import game.uilts.GameFont;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.core.DataCore;
   import zygame.display.NumberFeedback;
   import zygame.style.GreyStyle;
   
   public class FCNumberFeedback extends NumberFeedback
   {
      
      private var _image:Image;
      
      public function FCNumberFeedback(hurt:int, hurtType:String = "", isBJ:Boolean = false)
      {
         super(hurt,hurtType,isBJ);
         this.scale *= 1;
         this.fontName = "hurt_font";
      }
      
      override public function onInit() : void
      {
         var i:int = 0;
         var image:Image = null;
         var color:uint = 16777215;
         if(crit && "self" == type)
         {
            color = 16711680;
         }
         var fontSprite:Sprite = TextField.getBitmapFont(fontName).createSprite(100,100,String(hurtNumber),new TextFormat(GameFont.FONT_NAME,36,color));
         this.addChild(fontSprite);
         fontSprite.alignPivot();
         fontSprite.skewX = 0.25;
         this.scale = 1;
         if("self" != type)
         {
            for(i = 0; i < fontSprite.numChildren; )
            {
               (fontSprite.getChildAt(i) as Image).style = new GreyStyle();
               i++;
            }
         }
         if(crit)
         {
            fontSprite.scale = 1.5;
            image = new Image(DataCore.assetsSwf.otherAssets.getTextureAtlas("fightState").getTextures("暴击")[0]);
            this.addChild(image);
            image.scale = 0.3;
            image.skewX = 0.25;
            image.alignPivot();
            image.y = 16;
            _image = image;
            if("self" != type)
            {
               image.style = new GreyStyle();
            }
         }
      }
      
      override protected function onRemove(e:Event) : void
      {
         super.onRemove(e);
         if(_image)
         {
            _image.dispose();
         }
      }
   }
}

