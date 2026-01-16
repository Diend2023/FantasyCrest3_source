package game.view.item
{
   import game.data.Game;
   import game.uilts.GameFont;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.Texture;
   import zygame.core.DataCore;
   import zygame.display.BaseItem;
   
   public class VSItem extends BaseItem
   {
      
      private var _fightNumber:TextField;
      
      public function VSItem()
      {
         super();
      }
      
      public function img(texture:Texture) : void
      {
         var image:Image = new Image(texture);
         this.addChildAt(image,0);
         image.scale = 0.8;
         var mask:Quad = new Quad(this.width,this.height);
         this.addChild(mask);
         mask.alpha = 0.5;
         image.x -= (image.width - this.width) / 2;
         image.mask = mask;
         var maskImg:Image = new Image(DataCore.getTextureAtlas("select_role").getTexture("vs_frame"));
         this.addChildAt(maskImg,1);
         maskImg.width = this.width;
      }
      
      override public function set data(value:Object) : void
      {
         var target:String = null;
         var playerName:String = null;
         var xml:XML = null;
         var nameText:TextField = null;
         var fightNumber:TextField = null;
         var online:Image = null;
         var onlineText:TextField = null;
         super.data = value;
         if(value)
         {
            if(!_fightNumber)
            {
               this.width = stage.stageWidth / 2 / 3;
               this.height = 260;
               target = value is String ? value as String : value.target;
               playerName = value is String ? null : value.name;
               xml = Game.getXMLData(target as String);
               nameText = new TextField(this.width,32,xml.@name,new TextFormat(GameFont.FONT_NAME,14,16777215));
               this.addChild(nameText);
               nameText.y = 230;
               fightNumber = new TextField(this.width,32,String(Game.forceData ? Game.forceData.getData(target as String) : 0),new TextFormat(GameFont.FONT_NAME,14,16777215));
               this.addChild(fightNumber);
               fightNumber.y = 275;
               _fightNumber = fightNumber;
               if(playerName)
               {
                  online = new Image(DataCore.getTextureAtlas("select_role").getTexture("online_name"));
                  this.addChild(online);
                  online.width = this.width;
                  online.y = nameText.y - online.height;
                  onlineText = new TextField(online.width - 5,online.height,playerName,new TextFormat(GameFont.FONT_NAME,12,0));
                  this.addChild(onlineText);
                  onlineText.x = online.x;
                  onlineText.y = online.y;
                  fightNumber.text = "0%";
               }
               Game.getRoleImage(target,img);
            }
            else if(!(value is String))
            {
               _fightNumber.text = value.pro + "%";
            }
         }
      }
   }
}

