package game.view.item
{
   import game.data.Game;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.display.BaseItem;
   
   public class OverItem extends BaseItem
   {
      
      public var headImage:Image;
      
      private var shows:Array;
      
      private var _addText:TextField;
      
      private var _hbg:Quad;
      
      public function OverItem()
      {
         var i:int = 0;
         var show:OverHurtItem = null;
         shows = [];
         super();
         this.height = 60;
         var textureAtlas:TextureAtlas = DataCore.getTextureAtlas("select_role");
         var bg:Image = new Image(textureAtlas.getTexture("nameframe"));
         this.addChild(bg);
         bg.scaleX = 2;
         var head:Image = new Image(DataCore.getTextureAtlas("role_head").getTextures()[0]);
         head.alignPivot();
         head.scale = 0.9;
         head.x = 30;
         head.y = 30;
         this.addChild(head);
         headImage = head;
         var arr:Array = ["allhurt","behurt","timehurt"];
         for(i = 0; i < arr.length; )
         {
            show = new OverHurtItem(arr[i]);
            this.addChild(show);
            show.x = 60 + (-25 + show.width) * i;
            show.y = 5;
            shows.push(show);
            i++;
         }
         var hbg:Quad = new Quad(head.width,16,0);
         hbg.alpha = 0.5;
         this.addChild(hbg);
         hbg.x = 3;
         hbg.y = 3 + head.height - hbg.height;
         _hbg = hbg;
         _addText = new TextField(hbg.width,hbg.height,"+99",new TextFormat("mini",12,65280));
         this.addChild(_addText);
         _addText.x = hbg.x;
         _addText.y = hbg.y;
      }
      
      override public function set data(value:Object) : void
      {
         super.data = value;
         if(value)
         {
            (shows[0] as OverHurtItem).strData = String(value.hurt);
            (shows[1] as OverHurtItem).strData = String(value.beHurt);
            (shows[2] as OverHurtItem).strData = String(value.timeHurt);
            _addText.text = (value.score < 0 ? "" : "+") + value.score;
            if(value.score == null)
            {
               _hbg.visible = false;
               _addText.visible = false;
            }
            _addText.format = new TextFormat("mini",12,value.score < 0 ? 16776960 : 65280);
            headImage.texture = Game.getHeadImage(value.target);
         }
      }
   }
}

