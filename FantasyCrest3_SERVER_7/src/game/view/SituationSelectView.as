package game.view
{
   import game.display.CommonButton;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.display.DisplayObjectContainer;
   
   public class SituationSelectView extends DisplayObjectContainer
   {
      
      public var callBack:Function;
      
      public function SituationSelectView()
      {
         super();
      }
      
      override public function onInit() : void
      {
         super.onInit();
         var q:Quad = new Quad(stage.stageWidth,stage.stageHeight,0);
         this.addChild(q);
         q.alpha = 0.5;
         var textures:TextureAtlas = DataCore.getTextureAtlas("start_main");
         var bg:Image = new Image(textures.getTexture("选择对战局模式"));
         this.addChild(bg);
         bg.alignPivot();
         bg.x = stage.stageWidth / 2;
         bg.y = stage.stageHeight / 2 + 24;
         var putongju:CommonButton = new CommonButton("普通局");
         this.addChild(putongju);
         putongju.x = stage.stageWidth / 2;
         putongju.y = stage.stageHeight / 2 - putongju.height / 2;
         putongju.callBack = onTriggered;
         var gaoduan:CommonButton = new CommonButton("高端局");
         this.addChild(gaoduan);
         gaoduan.x = stage.stageWidth / 2;
         gaoduan.y = stage.stageHeight / 2 + gaoduan.height / 2 + 16;
         gaoduan.callBack = onTriggered;
         var huxuan:CommonButton = new CommonButton("互选局");
         this.addChild(huxuan);
         huxuan.x = gaoduan.x;
         huxuan.y = gaoduan.y + huxuan.height + 16;
         huxuan.callBack = onTriggered;
         var close:CommonButton = new CommonButton("关闭");
         this.addChild(close);
         close.x = stage.stageWidth / 2 + bg.width / 2 - close.width / 2;
         close.y = stage.stageHeight / 2 - bg.height / 2 + close.height / 2 + 24;
         close.callBack = removeFromParent;
      }
      
      private function onTriggered(target:String) : void
      {
         if(callBack != null)
         {
            callBack(target);
         }
         this.removeFromParent();
      }
   }
}

