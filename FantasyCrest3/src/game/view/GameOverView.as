package game.view
{
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import game.data.Game;
   import game.data.OverTag;
   import game.display.CommonButton;
   import game.view.item.OverItem;
   import starling.display.Image;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.core.SceneCore;
   import zygame.display.DisplayObjectContainer;
   
   public class GameOverView extends DisplayObjectContainer
   {
      
      private var data1:Array;
      
      private var data2:Array;
      
      public var tag:String;
      
      public var callBack:Function = null;
      
      public function GameOverView(data1p:Array, data2p:Array, overTag:String)
      {
         super();
         data1 = data1p;
         data2 = data2p;
         tag = overTag;
         Game.save();
      }
      
      override public function onInit() : void
      {
         var tagImage:Image = null;
         var submit:CommonButton = null;
         super.onInit();
         var textureAtlas:TextureAtlas = DataCore.getTextureAtlas("select_role");
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
         var list1:List = new List();
         this.addChild(list1);
         list1.y = 80;
         list1.x = 0;
         list1.height = stage.stageHeight - 180;
         list1.width = stage.stageWidth / 2;
         list1.itemRendererType = OverItem;
         var list2:List = new List();
         this.addChild(list2);
         list2.y = 80;
         list2.x = stage.stageWidth / 2;
         list2.height = stage.stageHeight - 180;
         list2.width = stage.stageWidth / 2;
         list2.itemRendererType = OverItem;
         if(tag == OverTag.GAME_OVER || tag == OverTag.GAME_WIN || tag == OverTag.NONE)
         {
            tagImage = new Image(textureAtlas.getTexture(tag));
            this.addChild(tagImage);
            tagImage.alignPivot();
            tagImage.x = stage.stageWidth / 2;
            tagImage.y = stage.stageHeight - 54;
         }
         list1.dataProvider = new ListCollection(data1);
         list2.dataProvider = new ListCollection(data2);
         var close:CommonButton = new CommonButton("continue");
         this.addChild(close);
         close.x = stage.stageWidth - close.width / 2 - 5;
         close.y = stage.stageHeight - close.height / 2 - 17;
         close.callBack = onExit;
         if(!Game.game4399Tools.logInfo)
         {
            submit = new CommonButton("submit","select_role");
            this.addChild(submit);
            submit.x = close.x - submit.width - 10;
            submit.y = close.y;
            submit.callBack = onSubmit;
         }
      }
      
      public function onSubmit() : void
      {
         if(Game.game4399Tools.serviceHold)
         {
            if(!Game.game4399Tools.logInfo)
            {
               SceneCore.pushView(new GameTipsView("正在提交..."));
               Game.game4399Tools.getData(0);
            }
            else
            {
               SceneCore.pushView(new GameTipsView("已提交"));
            }
         }
         else
         {
            SceneCore.pushView(new GameTipsView("上下文丢失"));
         }
      }
      
      public function onExit() : void
      {
         if(callBack != null)
         {
            callBack();
            callBack = null;
         }
         else
         {
            SceneCore.removeView(this);
            SceneCore.replaceScene(GameSelectView.currentSelectView);
            DataCore.clearMapRoleData();
         }
      }
   }
}

