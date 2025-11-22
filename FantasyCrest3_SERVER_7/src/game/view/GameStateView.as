package game.view
{
   import game.display.CommonButton;
   import game.display.FBHpState;
   import game.display.HPMP;
   import game.uilts.Phone;
   import game.world._1V1;
   import game.world._1V1Online;
   import game.world._2V2ASSIST;
   import game.world._2V2LEVEL;
   import game.world._2VFBOnline;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   import zygame.display.BaseRole;
   import zygame.display.World;
   import zygame.display.WorldState;
   import zygame.server.Service;
   
   public class GameStateView extends WorldState
   {
      
      private var _1p:HPMP;
      
      private var _2p:HPMP;
      
      private var _3p:HPMP;
      
      private var _4p:HPMP;
      
      public var _tips:Vector.<Image>;
      
      private var _tipsText:TextField;
      
      private var _fbhp:FBHpState;
      
      public function GameStateView()
      {
         super();
         _tips = new Vector.<Image>();
      }
      
      public function createFBHPState() : void
      {
         _fbhp = new FBHpState();
         this.addChild(_fbhp);
         _fbhp.x = stage.stageWidth / 2 + 60;
         _fbhp.y = 32;
      }
      
      override public function onInit() : void
      {
         var enter:CommonButton;
         var i:int;
         var s:int;
         var tipsbg:Image;
         var key:VirKeyView;
         _1p = new HPMP(true);
         var p2pshow:Boolean = false;
         if(World.defalutClass == _1V1 || World.defalutClass == _2V2ASSIST || World.defalutClass == _2VFBOnline || World.defalutClass == _2V2LEVEL || World.defalutClass == _1V1Online)
         {
            p2pshow = true;
         }
         _2p = new HPMP(p2pshow);
         _1p.x = 10;
         _1p.y = 10;
         _2p.x = stage.stageWidth - 10;
         _2p.y = 10;
         _2p.scaleX = -1;
         this.addChild(_1p);
         this.addChild(_2p);
         enter = new CommonButton("enter_pause.png","hpmp");
         this.addChild(enter);
         enter.x = stage.stageWidth / 2;
         enter.y = 30;
         enter.callBack = function():void
         {
            if(World.defalutClass != _1V1Online)
            {
               GameCore.currentWorld.onDown(13);
            }
         };
         for(i = 0; i < this.numChildren; )
         {
            s = this.getChildAt(i).scaleX > 0 ? 1 : -1;
            this.getChildAt(i).scaleX = 0.9 * s;
            this.getChildAt(i).scaleY = 0.9;
            i++;
         }
         createTips(1);
         createTips(2);
         tipsbg = new Image(DataCore.getTextureAtlas("hpmp").getTexture("fpstips.png"));
         this.addChild(tipsbg);
         tipsbg.x = stage.stageWidth / 2;
         tipsbg.y = stage.stageHeight;
         tipsbg.alignPivot("center","bottom");
         _tipsText = new TextField(tipsbg.width,tipsbg.height,"fps:60",new TextFormat("mini",12,16777215));
         this.addChild(_tipsText);
         _tipsText.alignPivot("center","bottom");
         _tipsText.x = stage.stageWidth / 2;
         _tipsText.y = stage.stageHeight;
         if(Phone.isPhone())
         {
            key = new VirKeyView();
            key.world = world;
            this.addChild(key);
         }
      }
      
      public function getHPMP(id:int) : HPMP
      {
         return this["_" + id + "p"];
      }
      
      public function createTips(id:int) : void
      {
         var tips:Image = new Image(DataCore.getTextureAtlas("hpmp").getTexture(id + "p.png"));
         world.addChild(tips);
         tips.alignPivot("center","top");
         _tips.push(tips);
      }
      
      public function create3P4PHPMP() : void
      {
         var i:int = 0;
         var s:int = 0;
         _3p = new HPMP(false);
         _3p.x = 10;
         _3p.y = stage.stageHeight - 50;
         this.addChildAt(_3p,0);
         _4p = new HPMP(false);
         _4p.x = _2p.x;
         _4p.y = _3p.y;
         _4p.scaleX = -1;
         this.addChildAt(_4p,0);
         for(i = 0; i < this.numChildren; )
         {
            if(this.getChildAt(i) is HPMP)
            {
               s = this.getChildAt(i).scaleX > 0 ? 1 : -1;
               this.getChildAt(i).scaleX = 0.9 * s;
               this.getChildAt(i).scaleY = 0.9;
            }
            i++;
         }
         createTips(3);
         createTips(4);
      }
      
      public function pushWin(i:int) : void
      {
         this["_" + (i + 1) + "p"].pushWin();
      }
      
      public function bind(id:int, r:BaseRole) : void
      {
         id++;
         this["_" + id + "p"].role = r;
      }
      
      public function set hitFBRole(baseRole:BaseRole) : void
      {
         if(_fbhp)
         {
            _fbhp.role = baseRole;
         }
      }
      
      override public function onFrame() : void
      {
         var i:int = 0;
         var hpmp:HPMP = null;
         var tips:Image = null;
         for(i = 1; i <= 4; )
         {
            hpmp = this["_" + i + "p"] as HPMP;
            if(hpmp)
            {
               hpmp.onChange();
               tips = this._tips[i - 1];
               if(hpmp.role)
               {
                  tips.x += (hpmp.role.x - tips.x) * 0.25;
                  tips.y += (hpmp.role.y - tips.y) * 0.25;
                  tips.visible = hpmp.role.parent != null;
               }
               else
               {
                  tips.visible = false;
               }
            }
            i++;
         }
         if(_fbhp)
         {
            _fbhp.onFrame();
         }
         if(Service.client)
         {
            _tipsText.text = "FPS:" + Starling.current.statsDisplay.fps.toFixed(1) + "/" + Starling.current.nativeStage.frameRate + "\nDEY:" + Service.client.delay + "ms";
         }
         else
         {
            _tipsText.text = "FPS:" + Starling.current.statsDisplay.fps.toFixed(1) + "\nGPU:" + totalGPUMemory;
         }
         if(false)
         {
            _tipsText.text = "FPS:" + Starling.current.statsDisplay.fps.toFixed(1) + "/" + Starling.current.nativeStage.frameRate + "\nGPU:" + totalGPUMemory;
         }
      }
      
      public function get totalGPUMemory() : String
      {
         var num:Number = NaN;
         try
         {
            num = Starling.current.context.totalGPUMemory / 1024 / 1024;
            return num.toFixed(1);
         }
         catch(e:Error)
         {
            var _loc4_:String = "0";
         }
         return _loc4_;
      }
      
      public function get allWinCount() : int
      {
         return _1p.winNum + _2p.winNum;
      }
      
      public function cheakGameWinCount() : int
      {
         var v:int = 0;
         if(_1p.winNum > v)
         {
            v = _1p.winNum;
         }
         if(_2p.winNum > v)
         {
            v = _2p.winNum;
         }
         return v;
      }
      
      override public function dispose() : void
      {
         if(_tips)
         {
            _tips.splice(0,_tips.length);
         }
         _tips = null;
         _1p = null;
         _2p = null;
         _3p = null;
         _4p = null;
         _tipsText = null;
         super.dispose();
      }
   }
}

