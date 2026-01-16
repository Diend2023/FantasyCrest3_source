package game.view.item
{
   import game.uilts.GameFont;
   import starling.display.Image;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.core.DataCore;
   import zygame.display.BaseItem;
   
   public class SkillMessageItem extends BaseItem
   {
      
      private var _skillName:TextField;
      
      private var _message:TextField;
      
      private var _bg:Image;
      
      public function SkillMessageItem()
      {
         super();
         var bg:Image = new Image(DataCore.getTextureAtlas("hpmp").getTexture("skill_bg.png"));
         this.addChild(bg);
         this.width = bg.width;
         this.height = bg.height;
         _bg = bg;
         _skillName = new TextField(bg.width,28,"技能名 操作",new TextFormat(GameFont.FONT_NAME,14,16777215,"left"));
         this.addChild(_skillName);
         _skillName.x = 5;
         _message = new TextField(bg.width,64,"说明",new TextFormat(GameFont.FONT_NAME,12,16777215,"left","top"));
         this.addChild(_message);
         _message.x = 5;
         _message.y = 28;
      }
      
      override public function set data(value:Object) : void
      {
         super.data = value;
         if(value)
         {
            _message.isHtmlText = true;
            _message.width = stage.stageWidth / 2 < _message.width ? stage.stageWidth / 2 - 10 : _message.width;
            _skillName.text = value.actionName + "  [" + getType(value.type) + "]  " + cKey(value.key,value.type);
            _message.text = "[技能CD：" + value.cd + "秒]  " + (value.mp > 0 ? "<font color=\'#33ffff\' size=\'12\'>[所需水晶：" + value.mp + "]</font>  " : "") + (value.noc ? "<font color=\'#FFCC00\' size=\'12\'>[无法强制]</font>  " : "") + value.msg;
            if(_message.text == "")
            {
               _message.text = "无";
            }
         }
      }
      
      public function getType(str:String) : String
      {
         switch(str)
         {
            case "injured":
               return "受身技";
            case "land":
               return "地面";
            case "air":
               return "空中";
            case "all":
               return "全能";
            default:
               return "全能";
         }
      }
      
      public function cKey(str:String, type:String) : String
      {
         str = str.replace("W","↑ + ");
         str = str.replace("S","↓ + ");
         if(type == "air")
         {
            str = "跳跃键 + " + str;
         }
         if(str.indexOf("B") != -1)
         {
            return "特殊技";
         }
         return str;
      }
   }
}

