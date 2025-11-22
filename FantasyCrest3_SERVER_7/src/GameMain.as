package
{
   import game.data.Ai2;
   import game.data.BGConfig;
   import game.data.ForceData;
   import game.data.Game;
   import game.display.GameMessage;
   import game.role.GameRole;
   import game.uilts.GameFont;
   import game.uilts.Phone;
   import game.view.GameStartMain;
   import game.view.GameStateView;
   import game.world.WorldInduce;
   import game.world._1VSB;
   import game.world._1VStory;
   import parser.Script;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.utils.EncodeAssets;
   import zygame.core.CoreStarup;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   import zygame.core.PoltSystem;
   import zygame.core.SceneCore;
   import zygame.display.BaseRole;
   import zygame.display.DisplayObjectContainer;
   import zygame.display.World;
   import zygame.tmx.Map;
   
   public class GameMain extends DisplayObjectContainer
   {
      
      private var _pro:TextField;
      
      public function GameMain()
      {
         super();
         WorldInduce;
         if(!Phone.isPhone())
         {
            EncodeAssets.COMPRESSEDS = ["effect/"];
            EncodeAssets.KEEP = ["kuangzhanshi","my","my10","kuangzhanshi3","kuangzhanshi2","kuangzhanshi1","lanquan12","kuangzhanshi_nuqi2","kuangzhanshi5","kuangzhanshi6","kuangzhanshi_nu","kuangzhanshi7","you1","you2","you3","kuwu3","jh20","YSS","YSQQ","YSQ1","YSQ2","YSQ3","YSQ4","YSQ5","YSQ6","YS1","YS2","YS3","YS4","YS5","YS6","YS7","YS8","YS9","YS10","YS11","cike9","xiaomeiyandaodan","youguanche","mlsPinzi","haws5","guijianxue","guijianxue1","hamama","KO","defense","MRSI","MRWI","MRWU","Narutohesnhin","NarutoQB","Z1","xigausui","wsyy","Usopp","longquan","lock_skill","kuangzhanshi_zhan","shitou1","shitou2","longchuan"];
         }
         Starling.current.skipUnchangedFrames = false;
         DataCore.assetsSwf.otherAssets.disableEncode = false;
         DataCore.assetsSwf.otherAssets.textureFormat = "bgraPacked4444";
         GameCore.currentCore.addEventListener("gameCoreInitComplete",onInitComplete);
         if(true)
         {
            Starling.current.statsDisplay.visible = false;
         }
      }
      
      private function onLoadPro(e:Event) : void
      {
         _pro.text = "正在载入 " + int(Number(e.data) * 100) + "%";
      }
      
      private function onInitComplete(e:Event) : void
      {
         Game.initData();
         Starling.current.antiAliasing = 0;
         GameCore.soundCore.bgvolume = 0.4;
         PoltSystem.defaultDialogClass = GameMessage;
         trace("Game Start");
         BaseRole.defalutSpriteRoleClass = GameRole;
         GameCore.currentCore.clearSaveData();
         DataCore.assetsRole.textureFormat = Phone.isPhone() ? "bgraPacked4444" : "compressedAlpha";
         DataCore.assetsSwf.otherAssets.textureFormat = Phone.isPhone() ? "bgraPacked4444" : "compressedAlpha";
         DataCore.assetsMap.backgroundConfig = BGConfig;
         DisplayObjectContainer.disableIFMustDraw = true;
         GameCore.currentCore.addEventListener("world_created",onWorldCreate);
         Map.drawType = "jojn_draw";
         Script.vm.AI2 = Ai2;
         GameCore.currentCore.unSkip = true;
         Game.forceData = new ForceData();
         var isHW:Boolean = Starling.context.driverInfo.toLowerCase().indexOf("software") == -1;
         Starling.current.nativeStage.frameRate = 60;
         GameCore.currentCore.runderType = "high";
         if(Phone.isPhone())
         {
            GameCore.currentCore.runderType = "medium";
         }
         if(isHW)
         {
            GameCore.currentCore.runderType = "high";
         }
         else
         {
            GameCore.currentCore.runderType = "low";
         }
         if(false)
         {
            GameCore.currentCore.runderType = "low";
         }
         onRoleDataLoaded(1);
      }
      
      override public function onInit() : void
      {
         GameCore.currentCore.addEventListener("load_number",onLoadPro);
         _pro = new TextField(stage.stageWidth,32,"正在载入 0%",new TextFormat(GameFont.FONT_NAME,12,16777215));
         this.addChild(_pro);
         _pro.y = stage.stageHeight / 2 - 16;
      }
      
      private function onRoleDataLoaded(n:Number) : void
      {
         var view:GameStartMain = null;
         if(n == 1)
         {
            if(CoreStarup.testRole)
            {
               World.defalutClass = _1VSB;
               if(World.defalutClass == _1VStory)
               {
                  CoreStarup.testRoles = [CoreStarup.testRole];
               }
               else
               {
                  CoreStarup.testRoles = [CoreStarup.testRole,CoreStarup.testRole];
               }
               GameCore.currentCore.initTMXMap("",CoreStarup.testPath ? CoreStarup.testPath : "map1.tmx",null,null);
            }
            else
            {
               view = new GameStartMain();
               SceneCore.replaceScene(view);
            }
         }
      }
      
      private function onWorldCreate(e:Event) : void
      {
         var stateView:GameStateView = new GameStateView();
         GameCore.currentWorld.addStateContent(stateView);
      }
      
      private function onMapLoadComplete(i:int) : void
      {
         trace("Map Loaded!");
         GameCore.currentCore.createWorld("zl0",null,[CoreStarup.testRole ? CoreStarup.testRole : "jianxin"]);
      }
   }
}

