package game.item
{
   import feathers.controls.Label;
   import starling.display.Image;
   import starling.text.TextFormat;
   import zygame.core.DataCore;
   import zygame.display.BaseItem;
   
   public class RoleStateItem extends BaseItem
   {
      
      private var _icon:Image;
      
      private var _lable:Label;
      
      public function RoleStateItem()
      {
         super();
         this.width = 100;
         this.height = 20;
         var bg:Image = new Image(DataCore.getTextureAtlas("hpmp").getTexture("state.png"));
         this.addChild(bg);
         _lable = new Label();
         _lable.fontStyles = new TextFormat("mini",16,16777215);
         _lable.x = 24;
         _lable.y = 3;
         _lable.width = bg.width - 26;
         this.addChild(_lable);
      }
      
      override public function set data(value:Object) : void
      {
         if(value)
         {
            if(!_icon)
            {
               _icon = new Image(DataCore.getTextureAtlas("hpmp").getTexture(value.icon));
               this.addChild(_icon);
               _icon.width = 20;
               _icon.height = 20;
               _icon.x = 2;
               _icon.y = 2;
            }
            else
            {
               _icon.texture = DataCore.getTextureAtlas("hpmp").getTexture(value.icon);
            }
            _lable.text = value.msg is cint ? value.msg.value : value.msg;
         }
      }
   }
}

