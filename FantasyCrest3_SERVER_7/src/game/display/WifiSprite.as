package game.display
{
   import starling.display.Canvas;
   import starling.display.Image;
   import zygame.core.DataCore;
   import zygame.display.DisplayObjectContainer;
   
   public class WifiSprite extends DisplayObjectContainer
   {
      
      private var _wifiImg:Image;
      
      public function WifiSprite()
      {
         super();
      }
      
      override public function onInit() : void
      {
         super.onInit();
         var cr:Canvas = new Canvas();
         cr.beginFill(0,0.7);
         cr.drawCircle(14,12,20);
         this.addChild(cr);
         var wifi:Image = new Image(DataCore.getTextureAtlas("hpmp").getTexture("wifi_3.png"));
         this.addChild(wifi);
         _wifiImg = wifi;
      }
      
      public function updateLevel(i:int) : void
      {
         _wifiImg.texture = DataCore.getTextureAtlas("hpmp").getTexture("wifi_" + (i + 1) + ".png");
         _wifiImg.width = 32;
         _wifiImg.height = 32;
      }
   }
}

