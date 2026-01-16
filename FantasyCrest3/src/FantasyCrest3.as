package
{
   import flash.display.Loader;
   import flash.events.Event;
   import game.data.Game;
   import game.data.Game4399Tools;
   import game.data.PrivateTest;
   import game.role.GameRole;
   import game.role.RoleInclude;
   import game.skill.Skills;
   import game.uilts.DecodeFightXML;
   import game.uilts.GameFont;
   import starling.utils.EncodeAssets;
   import starling.utils.SystemUtil;
   import zygame.core.CoreStarup;
   import zygame.debug.Debug;
   import zygame.display.BaseRole;
   import zygame.utils.ServerUtils;
   import zygame.utils.SuperTextureAtlas;
   
   public class FantasyCrest3 extends CoreStarup
   {
      
      public static var serviceHold:* = null;
      
      public var _4399_function_rankList_id:String = "69f52ab6eb1061853a761ee8c26324ae";
      
      public var _4399_function_store_id:String = "3885799f65acec467d97b4923caebaae";
      
      public var fontSwf:Loader;
      
      public function FantasyCrest3()
      {
         super();
         this.addEventListener("addedToStage",onInit);
         Game.game4399Tools = new Game4399Tools();
         if(false)
         {
         }
         EncodeAssets.addXmlConversion = function(xml:XML):XML
         {
            trace("转换");
            if(xml.localName() == "map" || xml.localName() == "TextureAtlas" || xml.localName() == "font")
            {
               return xml;
            }
            return DecodeFightXML.decode(xml);
         };
      }
      
      public function setHold(hold:*) : void
      {
         serviceHold = hold;
         Game.game4399Tools.serviceHold = hold;
      }
      
      private function onInit(e:Event) : void
      {
         Game.game4399Tools.main = this.stage;
         if(true || SystemUtil.isWindows)
         {
            GameFont.FONT_NAME = "Verdana";
         }
         RoleInclude;
         Skills;
         stage.color = 0;
         PrivateTest.isPrivate = false;
         this.initStarling("project.xml",GameMain,480,true,!SystemUtil.isAIR,"auto",true,"auto");
         SuperTextureAtlas.support = true;
         Debug.UNAI = true;
         BaseRole.defalutSpriteRoleClass = GameRole;
         ServerUtils.ip = "123.56.28.204";
      }
      
      override public function set uesRole(str:String) : void
      {
         super.uesRole = str;
         if(str)
         {
            testRoles = [str,str];
         }
      }
   }
}

