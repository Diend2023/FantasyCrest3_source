package game.view
{
   import game.data.Game;
   import game.data.SelectGroupConfig;
   import game.display.SelectRole;
   import game.world._1V1Online;
   import game.world._2VFBOnline;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.text.TextField;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.core.SceneCore;
   import zygame.display.World;
   import zygame.server.Service;
   
   public class OnlineSelectRoleView extends OnlineView
   {
      
      private var _tips3:Image;
      
      public var IS_HIGH_GAME:Boolean = true;
      
      private var _select:SelectRole;
      
      private var _otherArray:Array = [];
      
      private var _log:TextField;
      
      private var _canSelect:Boolean = true;
      
      private var gameMode:String;
      
      private var _mapTarget:String = "";
      
      public function OnlineSelectRoleView(mode:String, mapTarget:String)
      {
         super();
         _mapTarget = mapTarget;
         World.defalutClass = _1V1Online;
         gameMode = mode;
         Service.client.messageFunc = onMessage;
         switch(gameMode)
         {
            case "英雄之迹":
               IS_HIGH_GAME = true;
               World.defalutClass = _2VFBOnline;
               break;
            case "普通模式":
               IS_HIGH_GAME = false;
               break;
            case "高端模式":
               IS_HIGH_GAME = true;
         }
      }
      
      override public function onMessage(data:Object) : void
      {
         switch(data.action)
         {
            case "select_role":
               data.data.selected = false;
               _select.group.pushSelect(data.data);
               _canSelect = !_canSelect;
               break;
            case "selected":
               if(Service.client.type == "watching")
               {
                  if(data.id == 1)
                  {
                     data.data.selected = false;
                     _select.group.pushSelect(data.data);
                     cheakIsStart();
                     break;
                  }
                  _otherArray = _otherArray.concat(data.list);
                  cheakIsStart();
                  trace("对方已选：",data.list);
                  if(IS_HIGH_GAME)
                  {
                     _canSelect = !_canSelect;
                  }
                  break;
               }
               _otherArray = _otherArray.concat(data.list);
               cheakIsStart();
               trace("对方已选：",data.list);
               if(IS_HIGH_GAME)
               {
                  _canSelect = !_canSelect;
               }
         }
         if(IS_HIGH_GAME && data.data)
         {
            (_select as SelectRole).selectedName(data.data.target);
         }
         if(_tips3)
         {
            _tips3.visible = !_canSelect;
         }
      }
      
      override public function onInit() : void
      {
         var textureAtlas:TextureAtlas;
         var bg:Image;
         var bg2:Quad;
         var config:SelectGroupConfig;
         super.onInit();
         textureAtlas = DataCore.getTextureAtlas("select_role");
         super.onInit();
         bg = new Image(DataCore.getTexture("select_role_bg"));
         this.addChild(bg);
         bg.x = stage.stageWidth / 2;
         bg.y = stage.stageHeight / 2;
         bg.scaleX = -1;
         bg.alignPivot();
         bg2 = new Quad(stage.stageWidth / 2,stage.stageHeight,0);
         this.addChild(bg2);
         bg2.alpha = 0.7;
         bg2.x = stage.stageWidth / 2;
         config = new SelectGroupConfig();
         config.selectCount = 1;
         config.isShowAll = true;
         config.showOnlineRoleData = true;
         if(IS_HIGH_GAME)
         {
            config.highGame = true;
            if(gameMode == "英雄之迹")
            {
               config.banCount = 0;
            }
            else
            {
               config.banCount = 4;
            }
         }
         _select = new SelectRole(255,config);
         this.addChild(_select);
         _select.call = onSelect;
         _select.lockButton.callBack = function():void
         {
            onDown(74);
         };
         if(IS_HIGH_GAME)
         {
            _canSelect = Service.client.type == "master";
            _tips3 = new Image(textureAtlas.getTexture("gaoduan_tips"));
            this.addChild(_tips3);
            _tips3.x = stage.stageWidth / 2 + stage.stageWidth / 4 - _tips3.width / 2;
            _tips3.y = stage.stageHeight / 2 - _tips3.height / 2;
            _tips3.visible = !_canSelect;
         }
         if(Service.client.type == "watching")
         {
            this.touchable = false;
         }
         this.openKey();
      }
      
      override public function onDown(key:int) : void
      {
         super.onDown(key);
         if(_canSelect)
         {
            _select.onDown(key);
         }
      }
      
      public function onSelect(data:Object) : void
      {
         if(_select.isSelected)
         {
            action("selected",{
               "list":_select.group.array,
               "data":data,
               "id":(Service.client.type == "master" ? 0 : 1)
            });
            cheakIsStart();
         }
         else
         {
            _canSelect = !_canSelect;
            action("select_role",{"data":data});
         }
         if(_tips3)
         {
            _tips3.visible = !_canSelect;
         }
      }
      
      public function cheakIsStart() : void
      {
         var arr1:Array = null;
         var arr2:Array = null;
         if(_select.isSelected && _otherArray.length > 0)
         {
            arr1 = [];
            arr2 = [];
            if(Service.client.type == "master")
            {
               arr1[0] = {
                  "name":Service.client.roomPlayerList[0].nickName,
                  "target":_select.group.array[0]
               };
               arr2[0] = {
                  "name":get2PName(),
                  "target":_otherArray[0]
               };
               if(World.defalutClass == _2VFBOnline)
               {
                  SceneCore.replaceScene(new GameVSView(_mapTarget,arr1.concat(arr2),Game.getFBRoleData(_mapTarget),true,true));
               }
               else
               {
                  SceneCore.replaceScene(new GameVSView(_mapTarget,arr1,arr2,true));
               }
            }
            else
            {
               arr2[0] = {
                  "name":Service.client.roomPlayerList[0].nickName,
                  "target":_otherArray[0]
               };
               arr1[0] = {
                  "name":get2PName(),
                  "target":_select.group.array[0]
               };
               if(World.defalutClass == _2VFBOnline)
               {
                  SceneCore.replaceScene(new GameVSView(_mapTarget,arr2.concat(arr1),Game.getFBRoleData(_mapTarget),true,true));
               }
               else
               {
                  SceneCore.replaceScene(new GameVSView(_mapTarget,arr2,arr1,true));
               }
            }
         }
      }
      
      public function get2PName() : String
      {
         for(var i in Service.client.roomPlayerList)
         {
            if(Service.client.roomPlayerList[i].type == "player")
            {
               return Service.client.roomPlayerList[i].nickName;
            }
         }
         return null;
      }
   }
}

