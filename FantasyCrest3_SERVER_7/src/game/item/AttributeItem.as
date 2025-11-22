package game.item
{
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.styles.DistanceFieldStyle;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.display.BaseItem;
   
   public class AttributeItem extends BaseItem
   {
      
      private var _image:Image;
      
      private var _textures:TextureAtlas;
      
      private var _line:Image;
      
      private var _num:TextField;
      
      private var _lable:TextField;
      
      public function AttributeItem()
      {
         super();
         _textures = DataCore.getTextureAtlas("select_role");
         _image = new Image(_textures.getTexture("liliang"));
         this.addChild(_image);
         _image.scale = 0.8;
         this.height = 32;
         var bgframe:Image = new Image(_textures.getTexture("attr_frame"));
         this.addChild(bgframe);
         bgframe.x = 32;
         bgframe.y = 24 - bgframe.height / 2;
         bgframe.scale *= 0.5;
         this.width = bgframe.x + bgframe.width + 32;
         var line:Image = new Image(_textures.getTexture("attr_line"));
         this.addChild(line);
         line.scale *= 0.5;
         line.scaleY *= 0.75;
         line.x = bgframe.x + 2;
         line.y = bgframe.y + 3;
         _line = line;
         var num:TextField = new TextField(20,20,"10",new TextFormat("mini",12,16777215));
         this.addChild(num);
         num.style = new DistanceFieldStyle();
         num.x = 130;
         num.y = 8;
         _num = num;
         var label:TextField = new TextField(80,20,"物理伤害",new TextFormat("Verdana",12,16777215,"left"));
         this.addChild(label);
         label.x = 32;
         label.y = -3;
         _lable = label;
      }
      
      override public function set data(value:Object) : void
      {
         var tw:Tween = null;
         var s:Number = NaN;
         super.data = value;
         if(value)
         {
            _lable.text = value.name;
            switch(value.name)
            {
               case "liliang":
                  _lable.text = "物理伤害";
                  break;
               case "mofa":
                  _lable.text = "魔法伤害";
                  break;
               case "shengcun":
                  _lable.text = "生存能力";
                  break;
               case "sudu":
                  _lable.text = "移动速度";
                  break;
               case "shuijing":
                  _lable.text = "水晶";
            }
            _image.texture = DataCore.getTextureAtlas("select_role").getTexture(value.name);
            tw = new Tween(_line,0.5,"easeOut");
            if(isNaN(_line.scaleX))
            {
               _line.scaleX = 0;
            }
            s = Number(value.pro);
            if(s < 0)
            {
               s = 0;
            }
            else if(s > 1)
            {
               s = 1;
            }
            tw.animate("scaleX",s * 0.5);
            Starling.juggler.add(tw);
            _num.text = (int(10 * s)).toString();
         }
      }
   }
}

