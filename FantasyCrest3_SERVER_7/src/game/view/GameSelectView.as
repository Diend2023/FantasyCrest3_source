package game.view
{
   import feathers.controls.List;
   import feathers.layout.HorizontalLayout;
   import game.data.Game;
   import game.data.SelectGroupConfig;
   import game.display.HighGameSelectGroup;
   import game.display.SelectRole;
   import game.uilts.GameFont;
   import game.view.item.FBMapItem;
   import game.view.item.MapItem;
   import game.world._1VFB;
   import game.world._1VSB;
   import game.world._2V2LEVEL;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.core.SceneCore;
   import zygame.display.KeyDisplayObject;
   import zygame.display.World;
   
   public class GameSelectView extends KeyDisplayObject
   {
      
      private static var _config:SelectGroupConfig;
      
      private static var _class:Class;
      
      private static var _isSelfMode:Boolean;
      
      private static var _isDoublePlayer2:Boolean;
      
      private var _mapList:List;
      
      private var _1p:SelectRole;
      
      private var _2p:SelectRole;
      
      private var _tips1p:Image;
      
      private var _tips2p:Image;
      
      private var _tips3:Image;
      
      private var _loadingText:TextField;
      
      private var _isDoublePlayer:Boolean = true;
      
      public var isSelfMode:Boolean = false;
      
      public var worldClass:Class = null;
      
      public var is1PSelect:Boolean = true;
      
      public function GameSelectView(pconfig:SelectGroupConfig, pworldClass:Class)
      {
         super();
         _config = pconfig;
         _class = pworldClass;
         worldClass = pworldClass;
         if(worldClass)
         {
            World.defalutClass = worldClass;
         }
         // this.addEventListener("removedFromStage",onRemove);
         this.addEventListener("removedFromStage",onRemoveForClearKey); // 修复函数名称重复的问题
         is1PSelect = Math.random() > 0.5;
      }
      
      public static function get currentSelectView() : GameSelectView
      {
         var view:GameSelectView = new GameSelectView(_config,_class);
         view.isSelfMode = _isSelfMode;
         view.isDoublePlayer = _isDoublePlayer2;
         return view;
      }
      
      // public function onRemove(e:Event) : void
      public function onRemoveForClearKey(e:Event) : void //修复函数名称重复的问题
      {
         this.clearKey();
      }
      
      override public function onInit() : void
      {
         _isSelfMode = isSelfMode;
         var textureAtlas:TextureAtlas = DataCore.getTextureAtlas("select_role");
         super.onInit();
         var bg:Image = new Image(DataCore.getTexture("select_role_bg"));
         this.addChild(bg);
         bg.x = stage.stageWidth / 2;
         bg.y = stage.stageHeight / 2;
         bg.scaleX = -1;
         bg.alignPivot();
         var tips:Image = new Image(textureAtlas.getTexture("1p2p"));
         this.addChild(tips);
         tips.x = stage.stageWidth / 2;
         tips.alignPivot("center","top");
         tips.y = -5;
         var wbg:Image = new Image(textureAtlas.getTexture("bg"));
         this.addChild(wbg);
         wbg.alignPivot();
         wbg.x = stage.stageWidth / 2;
         wbg.y = stage.stageHeight / 2 - 12;
         wbg.scale = 0.5;
         wbg.alpha = 0.5;
         _1p = new SelectRole(255,_config);
         this.addChild(_1p);
         _2p = new SelectRole(16711680,_config);
         this.addChild(_2p);
         _2p.scaleX = -1;
         _2p.x = stage.stageWidth;
         _1p.call = onSelectCall;
         _2p.call = onSelectCall;
         var state:Image = new Image(textureAtlas.getTexture("use"));
         this.addChild(state);
         state.scale = 0.5;
         state.x = stage.stageWidth / 2;
         state.y = 76;
         state.alignPivot("center","top");
         state.name = "state";
         if(_config.highGame || World.defalutClass == _2V2LEVEL || worldClass == _2V2LEVEL)
         {
            _1p.shareSelectRole = _2p;
            _2p.shareSelectRole = _1p;
         }
         var cbg:Image = new Image(textureAtlas.getTexture("nameframe"));
         this.addChild(cbg);
         cbg.alignPivot("center","top");
         cbg.x = stage.stageWidth / 2;
         cbg.width = 6;
         cbg.height = 268;
         cbg.y = 113;
         var loadingText:TextField = new TextField(300,100,"0%",new TextFormat(GameFont.FONT_NAME,24,16777215));
         this.addChild(loadingText);
         loadingText.x = stage.stageWidth / 2 - loadingText.width / 2;
         loadingText.y = stage.stageHeight - loadingText.height;
         _loadingText = loadingText;
         _loadingText.visible = false;
         this.openKey();
         var exit:Button = new Button(textureAtlas.getTexture("exit"));
         this.addChild(exit);
         exit.alignPivot("center","top");
         exit.x = tips.x;
         exit.y = tips.y - 5;
         exit.addEventListener("triggered",onTriggered);
         if(_config.elect)
         {
            _tips1p = new Image(textureAtlas.getTexture("huxuan_1p"));
            this.addChild(_tips1p);
            _tips2p = new Image(textureAtlas.getTexture("huxuan_2p"));
            this.addChild(_tips2p);
            _tips1p.y = 80;
            _tips2p.y = 80;
            _tips2p.x = stage.stageWidth - _tips2p.width;
         }
         else if(_config.highGame)
         {
            _tips1p = new Image(textureAtlas.getTexture("gaoduan_1p"));
            this.addChild(_tips1p);
            _tips2p = new Image(textureAtlas.getTexture("gaoduan_2p"));
            this.addChild(_tips2p);
            _tips1p.y = 80;
            _tips2p.y = 80;
            _tips2p.x = stage.stageWidth - _tips2p.width;
            _tips3 = new Image(textureAtlas.getTexture("gaoduan_tips"));
            this.addChild(_tips3);
            _tips3.alignPivot();
            updateHighState();
         }
         isDoublePlayer = _isDoublePlayer;
      }
      
      private function updateHighState() : void
      {
         var textureAtlas:TextureAtlas = DataCore.getTextureAtlas("select_role");
         _tips3.x = stage.stageWidth / 2 - stage.stageWidth / 4 * (!is1PSelect ? 1 : -1);
         _tips3.y = stage.stageHeight / 2;
         _tips1p.texture = textureAtlas.getTexture((_1p.group as HighGameSelectGroup).isBaned ? "gaoduan_1p_use" : "gaoduan_1p");
         _tips2p.texture = textureAtlas.getTexture((_2p.group as HighGameSelectGroup).isBaned ? "gaoduan_2p_use" : "gaoduan_2p");
      }
      
      private function onTriggered(e:Event) : void
      {
         if(_1p)
         {
            _1p.dispose();
         }
         if(_2p)
         {
            _2p.dispose();
         }
         this.removeFromParent(true);
         SceneCore.replaceScene(new GameStartMain());
      }
      
      private function onLoadNumber(e:Event) : void
      {
         _loadingText.text = int(Number(e.data) * 100) + "%";
      }
      
      public function onSelectCall() : void
      {
         var selectMap:Image;
         var mapList:List;
         if(_1p.group.isSelected && _2p.group.isSelected)
         {
            trace("可以开始游戏");
            if(_config.selectMap)
            {
               selectMap = new Image(DataCore.getTextureAtlas("select_role").getTexture("map_select"));
               this.addChild(selectMap);
               selectMap.y = stage.stageHeight - selectMap.height;
               mapList = new List();
               mapList.height = 100;
               mapList.width = stage.stageWidth - selectMap.width;
               mapList.itemRendererType = worldClass == _1VFB ? FBMapItem : MapItem;
               mapList.layout = new HorizontalLayout();
               this.addChild(mapList);
               mapList.x = selectMap.width;
               mapList.y = stage.stageHeight - mapList.height + 3;
               mapList.dataProvider = worldClass == _1VFB ? Game.getFBMapData() : Game.getMapData();
               mapList.selectedIndex = 0;
               mapList.addEventListener("triggered",function(e:Event):void
               {
                  var index:int = mapList.selectedIndex;
                  callLate(function():void
                  {
                     if(mapList.selectedIndex == index)
                     {
                        onDown(74);
                     }
                  });
               });
               _mapList = mapList;
            }
            else
            {
               startGame(null);
            }
         }
         else
         {
            trace("还有未准备的玩家");
            if(_config.highGame)
            {
               is1PSelect = !is1PSelect;
               this.updateHighState();
            }
         }
      }
      
      public function startGame(mapName:String) : void
      {
         if(mapName)
         {
            Game.lastTimeMap = mapName;
         }
         Starling.juggler.delayCall(function():void
         {
            if(World.defalutClass == _1VFB)
            {
               SceneCore.replaceScene(new GameVSView(mapName,_1p.group.array.concat(_2p.group.array),Game.getFBRoleData(mapName),false,true));
            }
            else if(World.defalutClass == _1VSB)
            {
               SceneCore.replaceScene(new GameVSView(mapName,_1p.group.array,_1p.group.array.concat()));
            }
            else if(World.defalutClass == _2V2LEVEL)
            {
               SceneCore.replaceScene(new GameVSView(mapName,_1p.group.array.concat(_2p.group.array),Game.levelData.currentFightArray));
            }
            else
            {
               SceneCore.replaceScene(new GameVSView(mapName,_1p.group.array,_2p.group.array));
            }
         },1);
      }
      
      override public function onDown(key:int) : void
      {
         switch(key)
         {
            case 65:
               if(_mapList)
               {
                  if(_mapList.selectedIndex > 0)
                  {
                     _mapList.selectedIndex--;
                  }
                  break;
               }
            case 68:
               if(_mapList)
               {
                  if(_mapList.selectedIndex < _mapList.dataProvider.length - 1)
                  {
                     _mapList.selectedIndex++;
                  }
                  break;
               }
            case 87:
            case 83:
            case 74:
               if(_mapList)
               {
                  Starling.juggler.tween(_mapList,0.25,{"alpha":0});
                  startGame(_mapList.selectedItem.target);
                  _mapList = null;
               }
            case 75:
            case 85:
               if(_config.highGame && !is1PSelect)
               {
                  break;
               }
               if(isSelfMode && _1p.isSelected)
               {
                  if(key == 65)
                  {
                     key = 68;
                  }
                  else if(key == 68)
                  {
                     key = 65;
                  }
                  _2p.onDown(key);
                  break;
               }
               if(_config.elect)
               {
                  if(key == 65)
                  {
                     key = 68;
                  }
                  else if(key == 68)
                  {
                     key = 65;
                  }
                  _2p.onDown(key);
                  break;
               }
               _1p.onDown(key);
               break;
            case 37:
            case 39:
            case 38:
            case 40:
            case 49:
            case 97:
            case 50:
            case 98:
            case 52:
            case 100:
               if(_config.highGame && is1PSelect)
               {
                  break;
               }
               if(_2p.alpha == 1)
               {
                  if(_config.elect)
                  {
                     if(key == 37)
                     {
                        key = 39;
                     }
                     else if(key == 39)
                     {
                        key = 37;
                     }
                     _1p.onDown(key);
                     break;
                  }
                  _2p.onDown(key);
               }
         }
      }
      
      override public function onUp(key:int) : void
      {
      }
      
      public function get isDoublePlayer() : Boolean
      {
         return _isDoublePlayer;
      }
      
      public function set isDoublePlayer(b:Boolean) : void
      {
         _isDoublePlayer = b;
         _isDoublePlayer2 = b;
         if(_2p)
         {
            if(!_isDoublePlayer)
            {
               _2p.visible = false;
               _1p.showAll();
               this.getChildByName("state").visible = false;
            }
            if(!b)
            {
               _2p.group.maxSelectNum = 0;
            }
            else
            {
               _2p.group.maxSelectNum = _config.selectCount;
            }
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._1p = null;
         this._2p = null;
         this._tips1p = null;
         this._tips2p = null;
         this._loadingText = null;
         this._mapList = null;
         this.worldClass = null;
      }
   }
}

