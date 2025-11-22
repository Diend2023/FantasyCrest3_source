package game.view.item
{
   import game.data.Game;
   import game.uilts.GameFont;
   import starling.text.TextField;
   import starling.text.TextFormat;
   
   public class FBMapItem extends MapItem
   {
      
      private var _win:TextField;
      
      public function FBMapItem()
      {
         super();
         _win = new TextField(this.width,20,"已胜利0局",new TextFormat(GameFont.FONT_NAME,14,16777215));
         this.addChild(_win);
         _win.y = this.height - 28;
      }
      
      override public function set data(value:Object) : void
      {
         super.data = value;
         if(value)
         {
            _win.text = "已胜利" + Game.fbData.getWinTimes(value.target) + "次";
         }
      }
   }
}

