package game.view.item
{
   import starling.display.Image;
   import zygame.core.DataCore;
   import zygame.display.BaseItem;
   
   public class ModeItem extends BaseItem
   {
      
      private var _img:Image;
      
      private var _tips:Image;
      
      public function ModeItem()
      {
         super();
         this.width = 525;
         this.height = 136;
      }
      
      override public function set data(value:Object) : void
      {
         var img:Image = null;
         super.data = value;
         if(value)
         {
            if(!_tips && String(value).indexOf("_com") != -1)
            {
               _tips = new Image(DataCore.getTextureAtlas("start_main").getTexture("电脑模式标示"));
               this.addChild(_tips);
               _tips.x = 140;
               _tips.y = 90;
            }
            else if(_tips)
            {
               _tips.visible = String(value).indexOf("_com") != -1;
            }
            if(!_img)
            {
               img = new Image(DataCore.getTextureAtlas("start_main").getTexture((value as String).replace("_com","")));
               this.addChildAt(img,0);
               _img = img;
            }
            else
            {
               _img.texture = DataCore.getTextureAtlas("start_main").getTexture((value as String).replace("_com",""));
            }
         }
      }
   }
}

