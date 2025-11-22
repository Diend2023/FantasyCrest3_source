package game.view.item
{
   import game.uilts.GameFont;
   import starling.display.Image;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.core.DataCore;
   import zygame.display.BaseItem;
   
   public class RankItem extends BaseItem
   {
      
      public var _headImage:Image;
      
      public var _msg:TextField;
      
      public function RankItem()
      {
         super();
         var bg:Image = new Image(DataCore.getTextureAtlas("start_main").getTexture("rank_item_bg"));
         this.addChild(bg);
         this.width = bg.width;
         this.height = bg.height;
         bg.blendMode = "multiply";
         _headImage = new Image(DataCore.getTextureAtlas("role_head").getTextures("jianxin")[0]);
         this.addChild(_headImage);
         _headImage.height = bg.height;
         _headImage.width = _headImage.height;
         _msg = new TextField(bg.width - 40,bg.height,"左眼游戏 | 战力:999999",new TextFormat(GameFont.FONT_NAME,12,16777215,"left"));
         this.addChild(_msg);
         _msg.x = 50;
         _msg.y = 0;
      }
      
      override public function set data(value:Object) : void
      {
         super.data = value;
         if(value)
         {
            try
            {
               this.visible = true;
               _msg.text = "[" + value.rank + "] " + value.userName + "(" + value.area + ") |  战力：" + value.score;
               if(value.extra)
               {
                  _headImage.texture = DataCore.getTextureAtlas("role_head").getTextures(value.extra.highRole as String)[0];
               }
            }
            catch(e:Error)
            {
               this.visible = false;
            }
         }
         else
         {
            this.visible = false;
         }
      }
   }
}

