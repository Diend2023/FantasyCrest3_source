package game.view
{
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import feathers.layout.VerticalLayout;
   import game.data.Game;
   import game.display.CommonButton;
   import game.view.item.RankItem;
   import starling.display.Image;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.display.DisplayObjectContainer;
   
   public class GameRankView extends DisplayObjectContainer
   {
      
      private var _list:List;
      
      private var _page:TextField;
      
      private var _index:int = 0;
      
      private var _rank:TextField;
      
      private var _score:TextField;
      
      public function GameRankView()
      {
         super();
      }
      
      override public function onInit() : void
      {
         var textures:TextureAtlas;
         var bg:Image;
         var right:Image;
         var list:List;
         var layout:VerticalLayout;
         var close:CommonButton;
         var next:CommonButton;
         var last:CommonButton;
         super.onInit();
         textures = DataCore.getTextureAtlas("start_main");
         bg = new Image(textures.getTexture("rank_bg"));
         this.addChild(bg);
         bg.x = stage.stageWidth / 2 - 60;
         bg.y = stage.stageHeight / 2;
         bg.alignPivot();
         right = new Image(textures.getTexture("rank_right"));
         this.addChild(right);
         right.alignPivot();
         right.x = bg.x + bg.width / 2 + 10 + right.width / 2;
         right.y = bg.y;
         _rank = new TextField(100,32,"1",new TextFormat("mini",16,16777215));
         this.addChild(_rank);
         _rank.x = right.x;
         _rank.y = right.y - right.height / 2 + 50;
         _rank.alignPivot();
         _score = new TextField(100,32,"999999",new TextFormat("mini",16,16777215));
         this.addChild(_score);
         _score.x = right.x;
         _score.y = right.y - right.height / 2 + 117;
         _score.alignPivot();
         list = new List();
         this.addChild(list);
         list.width = 500;
         list.height = 300;
         layout = new VerticalLayout();
         layout.gap = 5;
         list.layout = layout;
         list.x = bg.x;
         list.y = bg.y + 10;
         list.alignPivot();
         list.itemRendererType = RankItem;
         _list = list;
         Game.game4399Tools.getRankList(Game.rankid,6,_index + 1);
         Game.game4399Tools.onRankList = onRankList;
         Game.game4399Tools.onRankSelf = onRankSelf;
         Game.game4399Tools.getRankSelfData(Game.rankid);
         close = new CommonButton("关闭");
         this.addChild(close);
         close.x = bg.x + bg.width / 2 - close.width / 2;
         close.y = bg.y - bg.height / 2 + close.height / 2;
         close.callBack = function():void
         {
            Game.game4399Tools.onRankList = null;
            removeFromParent();
         };
         next = new CommonButton("next_last");
         this.addChild(next);
         next.x = bg.x + 80;
         next.y = bg.y + bg.height / 2 - next.height / 2 - 10;
         next.callBack = function():void
         {
            if(_list.dataProvider.length < 6)
            {
               return;
            }
            _index++;
            _page.text = (_index + 1).toString();
            Game.game4399Tools.getRankList(Game.rankid,6,_index + 1);
         };
         _page = new TextField(100,60,"1",new TextFormat("mini",18,16777215));
         this.addChild(_page);
         _page.x = bg.x;
         _page.y = next.y;
         _page.alignPivot();
         last = new CommonButton("next_last");
         this.addChild(last);
         last.x = bg.x - 80;
         last.y = bg.y + bg.height / 2 - next.height / 2 - 10;
         last.scaleX = -1;
         last.callBack = function():void
         {
            if(_index == 0)
            {
               return;
            }
            _index--;
            _page.text = (_index + 1).toString();
            Game.game4399Tools.getRankList(Game.rankid,6,_index + 1);
         };
         _score.text = "none";
         _rank.text = "none";
      }
      
      public function onRankSelf(data:Array) : void
      {
         if(data && data.length > 0)
         {
            _score.text = data[0].score;
            _rank.text = data[0].rank;
         }
         else
         {
            _score.text = "none";
            _rank.text = "none";
         }
      }
      
      public function onRankList(arr:Array) : void
      {
         _list.dataProvider = new ListCollection(arr);
      }
   }
}

