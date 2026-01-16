package game.view.item
{
   import game.uilts.GameFont;
   import starling.display.Button;
   import starling.display.Image;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.core.DataCore;
   import zygame.display.BaseItem;
   
   public class OnlineRoomItem extends BaseItem
   {
      
      private var _text:TextField;
      
      public var button:Button;
      
      public function OnlineRoomItem()
      {
         super();
         var bg:Image = new Image(DataCore.getTextureAtlas("start_main").getTexture("oline_item_bg"));
         this.addChild(bg);
         _text = new TextField(bg.width,bg.height,"",new TextFormat(GameFont.FONT_NAME,18,16777215,"left"));
         this.addChild(_text);
         _text.x = 10;
         this.width = bg.width;
         this.height = bg.height;
         var btn:Button = new Button(DataCore.getTextureAtlas("start_main").getTexture("oline_btn"));
         this.addChild(btn);
         btn.y = bg.height / 2;
         btn.x = bg.width - btn.width / 2;
         btn.alignPivot();
         button = btn;
      }
      
      override public function set data(value:Object) : void
      {
         super.data = value;
         if(value)
         {
            _text.text = "房号【" + value.id + "】 " + value.mode + " 人数:" + value.num + "/" + value.maxCount + "  " + value.master + (value.code == 1 ? "（需要验证）" : "");
            button.visible = !value.lock;
         }
      }
   }
}

