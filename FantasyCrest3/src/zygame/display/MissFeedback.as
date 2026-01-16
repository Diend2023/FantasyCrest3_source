package zygame.display
{
   import starling.display.Image;
   import zygame.core.DataCore;
   import zygame.style.BlackStyle;
   
   public class MissFeedback extends FeedbackDisplay
   {
      
      public function MissFeedback(hurtType:String)
      {
         super(null);
         var image:Image = new Image(DataCore.assetsSwf.otherAssets.getTextureAtlas("fightState").getTextures("闪避")[0]);
         this.addChild(image);
         image.scale = 0.2;
         image.skewX = 0.25;
         image.alignPivot();
         image.y = 16;
         if(hurtType != "self")
         {
            image.style = new BlackStyle();
         }
      }
   }
}

