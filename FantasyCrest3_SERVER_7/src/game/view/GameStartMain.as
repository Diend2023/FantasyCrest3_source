package game.view
{
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import game.data.FBGameData;
   import game.data.ForceData;
   import game.data.Game;
   import game.data.LevelData;
   import game.data.OnlineFightData;
   import game.data.PrivateTest;
   import game.data.SelectGroupConfig;
   import game.display.CommonButton;
   import game.uilts.GameFont;
   import game.uilts.Phone;
   import game.view.item.ModeItem;
   import game.world._1V1;
   import game.world._1V1COM;
   import game.world._1V1COMCOM;
   import game.world._1V1LEVEL;
   import game.world._1V3;
   import game.world._1VFB;
   import game.world._1VSB;
   import game.world._2V2;
   import game.world._2V2ASSIST;
   import game.world._2V2ASSIST_COM;
   import game.world._2V2COM;
   import game.world._2V2LEVEL;
   import game.world._3V1;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   import zygame.core.SceneCore;
   import zygame.display.TouchDisplayObject;
   import zygame.server.Service;
   import zygame.utils.ServerUtils;
   
   public class GameStartMain extends TouchDisplayObject
   {
      
      public static var ONEC_LOGIN:Boolean = false;
      
      public static var self:GameStartMain;
      
      private var _modeList:List;
      
      private var _mask:Image;
      
      private var _btnspr:Sprite;
      
      private var _back:CommonButton;
      
      private var _loginButton:CommonButton;
      
      private var _rankButton:CommonButton;
      
      private var _tips:Image;
      
      private var _tipsText:TextField;
      
      private var _coinText:TextField;
      
      private var _coinText2:TextField;
      
      private var _mouseTips:Image;
      
      private var _high:Image;
      
      public function GameStartMain()
      {
         super();
         self = this;
      }
      
      override public function onInit() : void
      {
         var textures:TextureAtlas;
         var spr:Sprite;
         var bg:Image;
         var rigthbg2:Image;
         var logo:Image;
         var rolebg:Image;
         var tw:Tween;
         var icon4399:Image;
         var leftbg:Image;
         var leftbg2:Image;
         var leftbg3:Image;
         var coin:Image;
         var coin2:Image;
         var coinText:TextField;
         var coinText2:TextField;
         var zz:CommonButton;
         var zzhang:CommonButton;
         var tips:Image;
         var login:TextField;
         var mouseTips:Image;
         var back:CommonButton;
         var arr:Array;
         var btnspr:Sprite;
         var i:int;
         var iy:int;
         var btn:CommonButton;
         var isHW:Boolean;
         var tispbg:Quad;
         var tips2:TextField;
         var fightText:TextField;
         var music:Button;
         var skin:Texture;
         var button:Button;
         var render:Image;
         var r:int;
         var rBtn:Button;
         var runderTypeChange:* = function(e:Event):void
         {
            GameCore.currentCore.runderType = e.target["name"];
            getChildByName("high").alpha = 0.5;
            getChildByName("medium").alpha = 0.5;
            getChildByName("low").alpha = 0.5;
            e.target["alpha"] = 1;
         };
         super.onInit();
         textures = DataCore.getTextureAtlas("start_main");
         spr = new Sprite();
         this.addChild(spr);
         spr.y = 0;
         bg = new Image(textures.getTexture("bg"));
         spr.addChild(bg);
         bg.alignPivot();
         bg.x = stage.stageWidth / 2;
         bg.y = stage.stageHeight / 2 + 32;
         rigthbg2 = new Image(textures.getTexture("left_bg"));
         this.addChild(rigthbg2);
         rigthbg2.scale = 0.8;
         rigthbg2.x = stage.stageWidth;
         rigthbg2.y = stage.stageHeight - rigthbg2.height * 1;
         rigthbg2.scaleX = -1;
         this.addEventListener("enterFrame",onFrameEvent);
         logo = new Image(textures.getTexture("幻想纹章"));
         this.addChild(logo);
         logo.x = stage.stageWidth / 2 - 330;
         logo.y = 8;
         logo.blendMode = "screen";
         rolebg = new Image(textures.getTexture("bg_role"));
         this.addChild(rolebg);
         rolebg.x = -rolebg.width;
         rolebg.y = stage.stageHeight + 60;
         rolebg.alignPivot("left","bottom");
         tw = new Tween(rolebg,1,"easeOut");
         tw.moveTo(-60,rolebg.y);
         Starling.juggler.add(tw);
         if(!Phone.isPhone() && false)
         {
            icon4399 = new Image(textures.getTexture("djfx"));
            this.addChild(icon4399);
            icon4399.x = stage.stageWidth - 42;
            icon4399.y = stage.stageHeight;
            icon4399.alignPivot("right","bottom");
            icon4399.scale = 0.7;
         }
         leftbg = new Image(textures.getTexture("left_bg"));
         this.addChild(leftbg);
         leftbg.scale = 0.8;
         leftbg.x = -50;
         leftbg.y = stage.stageHeight - leftbg.height;
         leftbg2 = new Image(textures.getTexture("left_bg"));
         this.addChild(leftbg2);
         leftbg2.scale = 0.8;
         leftbg2.x = -50;
         leftbg2.y = stage.stageHeight - leftbg2.height * 2 - 5;
         leftbg3 = new Image(textures.getTexture("left_bg"));
         this.addChild(leftbg3);
         leftbg3.scale = 0.8;
         leftbg3.x = -50;
         leftbg3.y = stage.stageHeight - leftbg2.height * 3 - 10;
         coin = new Image(textures.getTexture("coin"));
         this.addChild(coin);
         coin.x = leftbg2.x + 75;
         coin.y = leftbg2.y + leftbg2.height / 2;
         coin.alignPivot();
         coin2 = new Image(textures.getTexture("crystal"));
         this.addChild(coin2);
         coin2.x = leftbg3.x + 75;
         coin2.y = leftbg3.y + leftbg3.height / 2;
         coin2.alignPivot();
         coin2.scale = 0.5;
         coinText = new TextField(200,32,"0",new TextFormat(GameFont.FONT_NAME,12,16776960,"left"));
         this.addChild(coinText);
         coinText.x = coin.x + 16;
         coinText.y = coin.y - 16;
         _coinText = coinText;
         coinText2 = new TextField(200,32,"0",new TextFormat(GameFont.FONT_NAME,12,16776960,"left"));
         this.addChild(coinText2);
         coinText2.x = coin2.x + 16;
         coinText2.y = coin2.y - 16;
         _coinText2 = coinText2;
         zz = new CommonButton("zz");
         this.addChild(zz);
         zz.scale = 0.5;
         zz.x = leftbg2.x + leftbg2.width - zz.width;
         zz.y = leftbg2.y;
         zz.alignPivot("left","top");
         zz.callBack = function():void
         {
            SceneCore.pushView(new GameZZView(),true);
         };
         zzhang = new CommonButton("button_syste_2","start_main","转账");
         this.addChild(zzhang);
         zzhang.x = zz.x - zzhang.width - 3;
         zzhang.y = zz.y + 3;
         zzhang.alignPivot("left","top");
         zzhang.textBind.format.size = 12;
         zzhang.callBack = function():void
         {
            SceneCore.pushView(new TransferMoneyView());
         };
         zz.visible = true;
         tips = new Image(textures.getTexture("rank_tips"));
         this.addChild(tips);
         tips.scale = 0.8;
         tips.x = 12;
         tips.y = stage.stageHeight - tips.height - 10;
         _tips = tips;
         login = new TextField(tips.width,tips.height * 2,"左眼游戏(15119965102)",new TextFormat(GameFont.FONT_NAME,12,16776960,"left"));
         this.addChild(login);
         login.x = tips.x;
         login.y = tips.y - 9;
         login.visible = false;
         _tipsText = login;
         _modeList = new List();
         this.addChild(_modeList);
         _modeList.width = 525;
         _modeList.height = 408;
         _modeList.itemRendererType = ModeItem;
         _modeList.dataProvider = new ListCollection();
         _modeList.x = stage.stageWidth - _modeList.width;
         _modeList.y = 130;
         _modeList.scale = 0.8421052631578947;
         _modeList.addEventListener("change",onSelect);
         mouseTips = new Image(textures.getTexture("mouse_tips"));
         this.addChild(mouseTips);
         mouseTips.x = _modeList.x - 52;
         mouseTips.y = 200;
         _mouseTips = mouseTips;
         _mouseTips.visible = false;
         back = new CommonButton("back");
         this.addChild(back);
         back.x = _modeList.x - back.width - 10 + 32;
         back.y = _modeList.y + 32;
         back.scale = _modeList.scale;
         back.touchable = false;
         back.alpha = 0;
         back.callBack = onBack;
         _back = back;
         arr = ["闯关模式","对战模式","电脑模式","练习模式","英雄","登陆账号"];
         if(Phone.isPhone())
         {
            arr = ["闯关模式","对战模式","练习模式","英雄","商店"];
         }
         else if(true)
         {
            arr = ["闯关模式","对战模式","电脑模式","练习模式","英雄","商店"];
         }
         btnspr = new Sprite();
         this.addChild(btnspr);
         for(i in arr)
         {
            iy = i / 2;
            btn = new CommonButton(arr[i]);
            btnspr.addChild(btn);
            btn.x = (btn.width * 2 + 60) / 4 + (btn.width + 30) * i - (btn.width + 30) * iy * 2;
            btn.y = stage.stageHeight / 2 - 50 + iy * 70;
            btn.callBack = onBtnEvent;
            btn.name == arr[i];
            if(arr[i] == "登陆账号")
            {
               _loginButton = btn;
               _rankButton = new CommonButton("排行榜");
               btnspr.addChild(_rankButton);
               _rankButton.x = btn.x;
               _rankButton.y = btn.y;
               _rankButton.callBack = onBtnEvent;
               _rankButton.visible = false;
            }
         }
         btnspr.x = (stage.stageWidth - btnspr.width) * 0.5;
         _btnspr = btnspr;
         Game.game4399Tools.onLogined = onLogin;
         Game.game4399Tools.onLoginOut = function():void
         {
            Game.initData();
            ONEC_LOGIN = false;
         };
         if(Game.game4399Tools.logInfo)
         {
            showUserState();
         }
         GameCore.soundCore.playBGSound("main");
         isHW = Starling.context.driverInfo.toLowerCase().indexOf("software") == -1;
         tispbg = new Quad(stage.stageWidth,32,0);
         tispbg.alpha = 0.7;
         tispbg.setVertexAlpha(1,0);
         tispbg.setVertexAlpha(3,0);
         this.addChild(tispbg);
         tips2 = new TextField(stage.stageWidth,32,"  Mode:" + Starling.current.context.driverInfo + (!isHW ? "  当前游戏正在使用软件渲染模式，无法得到最优体验，如何解决？ -->" : ""),new TextFormat(GameFont.FONT_NAME,12,16776960,"left"));
         this.addChild(tips2);
         fightText = new TextField(rigthbg2.width,rigthbg2.height,"",new TextFormat(GameFont.FONT_NAME,12,16776960,"left"));
         this.addChild(fightText);
         fightText.x = rigthbg2.x - rigthbg2.width + 40;
         fightText.y = rigthbg2.y;
         fightText.name = "fightNum";
         music = new Button(DataCore.getTextureAtlas("start_main").getTexture(GameCore.soundCore.volume == 0 ? "sound_close" : "sound_open"));
         this.addChild(music);
         music.x = stage.stageWidth - music.width - 5;
         music.y = stage.stageHeight - music.height - 5;
         music.addEventListener("triggered",function(e:Event):void
         {
            GameCore.soundCore.volume = GameCore.soundCore.volume == 0 ? 1 : 0;
            music.upState = DataCore.getTextureAtlas("start_main").getTexture(GameCore.soundCore.volume == 0 ? "sound_close" : "sound_open");
         });
         if(!Phone.isPhone() && false)
         {
            skin = DataCore.getTextureAtlas("start_main").getTexture("btn_style_1");
            button = new Button(skin,"解决掉帧");
            this.addChild(button);
            button.scale = 0.7;
            button.textFormat.size = 18;
            button.x = stage.stageWidth - button.width - 2;
            button.y = 2;
            button.addEventListener("triggered",function(e:Event):void
            {
               SceneCore.pushView(new GameFPSTipsView());
            });
         }
         ServerUtils.updateRoleData(GameOnlineRoomListView._userName,GameOnlineRoomListView._userCode,{},function(userData:Object):void
         {
            if(!userData)
            {
               SceneCore.pushView(new GameTipsView("无法登陆"));
               return;
            }
            trace(JSON.stringify(userData));
            Game.initData(userData.userData);
            Game.onlineData = new OnlineFightData(userData.userData.ofigth);
            updateUserData(userData);
         });
         SceneCore.pushView(new Communication());
         render = new Image(textures.getTexture("renders"));
         this.addChild(render);
         render.x = stage.stageWidth - render.width;
         render.y = stage.stageHeight - 84;
         for(r = 0; r < 3; )
         {
            rBtn = new Button(textures.getTexture("render_select2"),"",null,textures.getTexture("render_select2"));
            this.addChild(rBtn);
            rBtn.x = render.x + 92 + r * rBtn.width;
            rBtn.y = render.y;
            rBtn.blendMode = "add";
            switch(r)
            {
               case 0:
                  rBtn.name = "high";
                  break;
               case 1:
                  rBtn.name = "medium";
                  break;
               case 2:
                  rBtn.name = "low";
            }
            rBtn.alpha = rBtn.name == GameCore.currentCore.runderType ? 1 : 0.5;
            rBtn.addEventListener("triggered",runderTypeChange);
            r++;
         }
         Game.assets.dispose();
      }
      
      public function updateUserData(userData:Object) : void
      {
         _tips.visible = false;
         _tipsText.visible = true;
         _tipsText.text = userData.nickName;
         _coinText.text = userData.coin;
         _coinText2.text = userData.crystal;
         Service.userData = userData;
         var txt:TextField = this.getChildByName("fightNum") as TextField;
         if(true)
         {
            txt.text = "游戏战力：" + Game.forceData.allFight + "    PVP战力：" + Game.forceData.allOnlineFight;
         }
         else
         {
            txt.text = "游戏战力：" + Game.forceData.allFight;
         }
      }
      
      private function onLogin() : void
      {
         var oldFBData:FBGameData = null;
         var oldData:ForceData = null;
         try
         {
            showUserState();
         }
         catch(e:Error)
         {
         }
         if(!ONEC_LOGIN)
         {
            oldFBData = Game.fbData;
            oldData = Game.forceData;
            Game.initData(Game.game4399Tools.data);
            Game.forceData.pushData(oldData);
            Game.fbData.pushData(oldFBData);
            ONEC_LOGIN = true;
            SceneCore.pushView(new GameTipsView("追加战力！"));
            if(Game.game4399Tools.data)
            {
               Game.vip.value = int(Game.game4399Tools.data.vip);
            }
         }
         Starling.juggler.delayCall(Game.submitScore,3);
      }
      
      private function showUserState() : void
      {
         _loginButton.visible = false;
         _rankButton.visible = true;
         _tips.visible = false;
         _tipsText.visible = true;
         _tipsText.text = Game.game4399Tools.nickName + "(" + Game.game4399Tools.userName + ")";
      }
      
      private function onSelect(e:Event) : void
      {
         trace("onSelect",_modeList.selectedItem);
         if(Service.userData == null)
         {
            return;
         }
         switch(_modeList.selectedItem)
         {
            case "英雄之迹":
               Game.levelData = null;
               createSelectView(false,false,1,_1VFB,false,false,true,true);
               break;
            case "局域网对战":
               SceneCore.pushView(new GameLANModeView());
               break;
            case "网络对战":
               SceneCore.replaceScene(new GameOnlineRoomListView());
               break;
            case "制作组":
               openSelect("左眼","老邪","巅峰","小鸟","虚伪","木姐","RS","菠萝","小研En","妹红","柠七");
               break;
            case "英雄库":
               SceneCore.replaceScene(new GameHeroView());
               break;
            case "1V3挑战模式":
               Game.levelData = new LevelData(3);
               createSelectView(false,false,1,_1V3,false,false,true);
               break;
            case "3V1BOSS模式":
               Game.levelData = new LevelData(1);
               createSelectView(false,false,3,_3V1,false,false,true);
               break;
            case "单人闯关模式":
               Game.levelData = new LevelData(1);
               createSelectView(false,false,1,_1V1LEVEL,false,false,true);
               break;
            case "双人闯关模式":
               Game.levelData = new LevelData(2);
               createSelectView(true,false,1,_2V2LEVEL,false,false,true);
               break;
            case "2V2普通对战":
               openSituationView(true,false,2,_2V2);
               break;
            case "2V2搭档对战":
               openSituationView(true,false,2,_2V2ASSIST);
               break;
            case "1PVS2P_com":
               createSelectView(true,true,1,_1V1COM,false,false,false,true);
               break;
            case "1PVS2P":
               openSituationView(true,false,1,_1V1);
               break;
            case "观战模式":
               createSelectView(true,true,1,_1V1COMCOM,false,false,false,true);
               break;
            case "2V2普通对战_com":
               createSelectView(true,true,2,_2V2COM,false,false,false,true);
               break;
            case "2V2搭档对战_com":
               createSelectView(true,true,2,_2V2ASSIST_COM,false,false,false,true);
         }
         if(_modeList)
         {
            _modeList.selectedIndex = -1;
         }
      }
      
      private function onBtnEvent(label:String) : void
      {
         if(Service.userData == null)
         {
            return;
         }
         switch(label)
         {
            case "商店":
               SceneCore.replaceScene(new GameShopView());
               break;
            case "排行榜":
               SceneCore.pushView(new GameRankView());
               break;
            case "登陆账号":
               if(Game.game4399Tools.serviceHold)
               {
                  Game.game4399Tools.getData(0);
                  break;
               }
               SceneCore.pushView(new GameTipsView("上下文丢失"));
               break;
            case "闯关模式":
               if(Phone.isPhone())
               {
                  openSelect("英雄之迹","单人闯关模式","1V3挑战模式");
                  break;
               }
               if(true)
               {
                  openSelect("英雄之迹","单人闯关模式","双人闯关模式","1V3挑战模式","3V1BOSS模式");
                  break;
               }
               openSelect("英雄之迹","单人闯关模式","双人闯关模式","1V3挑战模式","3V1BOSS模式");
               break;
            case "对战模式":
               if(Phone.isPhone())
               {
                  openSelect("网络对战","局域网对战");
                  break;
               }
               if(true)
               {
                  openSelect("1PVS2P","2V2普通对战","2V2搭档对战","网络对战","局域网对战");
                  break;
               }
               openSelect("1PVS2P","2V2普通对战","2V2搭档对战");
               break;
            case "电脑模式":
               if(Phone.isPhone())
               {
                  openSelect("1PVS2P_com","观战模式");
                  break;
               }
               openSelect("1PVS2P_com","2V2普通对战_com","2V2搭档对战_com","观战模式");
               break;
            case "练习模式":
               createSelectView(false,true,1,_1VSB,false,false,false,!Phone.isPhone());
               break;
            case "英雄":
               openSelect("英雄库","制作组");
         }
      }
      
      private function onBack() : void
      {
         _btnspr.visible = true;
         _mouseTips.visible = false;
         _back.touchable = false;
         _modeList.touchable = false;
         Starling.juggler.tween(_modeList,0.25,{"alpha":0});
         Starling.juggler.tween(_back,0.25,{"alpha":0});
      }
      
      private function openSelect(... ret) : void
      {
         _modeList.dataProvider.removeAll();
         _modeList.dataProvider.addAll(new ListCollection(ret));
         _btnspr.visible = false;
         _back.touchable = true;
         _modeList.touchable = true;
         _modeList.alpha = 0;
         Starling.juggler.tween(_modeList,0.25,{"alpha":1});
         Starling.juggler.tween(_back,0.25,{"alpha":1});
         if(ret.length > 3)
         {
            _mouseTips.visible = true;
         }
      }
      
      private function openSituationView(isDoublePlayer:Boolean, isSelfMode:Boolean, maxSelect:int, classWorld:Class) : void
      {
         var view:SituationSelectView = new SituationSelectView();
         SceneCore.pushView(view);
         view.callBack = function(target:String):void
         {
            createSelectView(isDoublePlayer,isSelfMode,maxSelect,classWorld,target == "高端局",target == "互选局",false,true);
         };
      }
      
      private function createSelectView(isDoublePlayer:Boolean, isSelfMode:Boolean, maxSelect:int, classWorld:Class, isHighGame:Boolean = false, isElect:Boolean = false, showFight:Boolean = false, selectMap:Boolean = false) : void
      {
         var view:PrivateValidationView;
         if(PrivateTest.isPrivate)
         {
            view = new PrivateValidationView();
            view.call = function(code:int):void
            {
               if(code == 0)
               {
                  start(isDoublePlayer,isSelfMode,maxSelect,classWorld,isHighGame,isElect,showFight,selectMap);
               }
               else if(code == 1 && Game.vip.value < 1)
               {
                  SceneCore.pushView(new GameTestView());
               }
            };
            SceneCore.pushView(view);
         }
         else
         {
            start(isDoublePlayer,isSelfMode,maxSelect,classWorld,isHighGame,isElect,showFight,selectMap);
         }
      }
      
      override protected function onRemove(e:Event) : void
      {
         super.onRemove(e);
      }
      
      public function start(isDoublePlayer:Boolean, isSelfMode:Boolean, maxSelect:int, classWorld:Class, isHighGame:Boolean, isElect:Boolean, showFight:Boolean, selectMap:Boolean) : void
      {
         var bg:Quad;
         var tw:Tween;
         this.touchable = false;
         bg = new Quad(stage.stageWidth,stage.stageHeight,0);
         this.addChild(bg);
         bg.alpha = 0;
         tw = new Tween(bg,0.25);
         tw.fadeTo(1);
         Starling.juggler.add(tw);
         tw.onComplete = function():void
         {
            var config:SelectGroupConfig = new SelectGroupConfig();
            config.selectCount = maxSelect;
            config.highGame = isHighGame;
            config.elect = isElect;
            config.showFight = showFight;
            config.selectMap = selectMap;
            var view:GameSelectView = new GameSelectView(config,classWorld);
            SceneCore.replaceScene(view);
            view.isDoublePlayer = isDoublePlayer;
            view.isSelfMode = isSelfMode;
         };
      }
      
      private function onFrameEvent(e:Event) : void
      {
         this.setRequiresRedraw();
      }
      
      override public function dispose() : void
      {
         GameStartMain.self = null;
         this._back = null;
         this._btnspr = null;
         this._coinText = null;
         this._coinText2 = null;
         this._high = null;
         this._loginButton = null;
         this._mask = null;
         this._modeList = null;
         this._rankButton = null;
         this._mouseTips = null;
         this._tips = null;
         this._tipsText = null;
         super.dispose();
      }
   }
}

