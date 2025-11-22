package zygame.display
{
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.core.DataCore;
   import zygame.style.GreyStyle;
   
   public class NumberFeedback extends FeedbackDisplay
   {
      
      public var hurtNumber:int = 0;
      
      public var crit:Boolean = false;
      
      public var type:String;
      
      public var fontName:String = "fCount";
      
      public var fontSprite:Sprite;
      
      public function NumberFeedback(hurt:int, hurtType:String = "", isBJ:Boolean = false)
      {
         super(null);
         hurtNumber = hurt;
         crit = isBJ;
         type = hurtType;
      }
      
      override public function onInit() : void
      {
         var i:int = 0;
         var image:Image = null;
         super.onInit();
         var color:* = 16777215;
         if(crit && "self" == type)
         {
            color = 16711680;
         }
         fontSprite = TextField.getBitmapFont(fontName).createSprite(100,100,String(hurtNumber),new TextFormat("Verdana",36,color));
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
            if(DataCore.assetsSwf.otherAssets.getTextureAtlas("fightState"))
            {
               image = new Image(DataCore.assetsSwf.otherAssets.getTextureAtlas("fightState").getTextures("暴击")[0]);
               this.addChild(image);
               image.scale = 0.2;
               image.skewX = 0.25;
               image.alignPivot();
               image.y = 16;
               if("self" != type)
               {
                  image.style = new GreyStyle();
               }
            }
         }
      }
   }
}

