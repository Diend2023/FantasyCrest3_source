package game.display
{
   import feathers.controls.List;
   import feathers.layout.HorizontalLayout;
   import flash.geom.Point;
   import game.item.RoleStateItem;
   import game.role.GameRole;
   import starling.display.Image;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.display.BaseRole;
   import zygame.display.BatchContainer;
   import zygame.display.DisplayObjectContainer;
   
   public class HPMP extends DisplayObjectContainer
   {
      
      private var _point:Point = new Point();
      
      private var _jitterIntensity:int;
      
      public var hp:Image;
      
      public var mp:Image;
      
      public var hpbg:Image;
      
      public var currentHp:int;
      
      public var currentMp:int;
      
      private var _role:BaseRole;
      
      private var _mpSprites:Vector.<MpSprite> = new Vector.<MpSprite>();
      
      private var _cdSprites:Vector.<CdSprite> = new Vector.<CdSprite>();
      
      private var _jitterTime:int = 0;
      
      public var winNum:int;
      
      private var headImage:Image;
      
      public var stateList:List;
      
      public var hptext:TextField;
      
      public var wifi:WifiSprite;
      
      private var _cdSprite:BatchContainer;
      
      private var _showCD:Boolean = false;
      
      private var _hpnum:TextField;
      
      public var hpbgScaleX:Number = 1;
      
      public function HPMP(showCD:Boolean)
      {
         _showCD = showCD;
         super();
      }
      
      public function set role(r:BaseRole) : void
      {
         _role = r;
         if(r == null)
         {
            return;
         }
         currentHp = _role.attribute.hp;
         (_role as GameRole).currentMp.value = this.currentMp;
         if(r is GameRole)
         {
            (r as GameRole).hpmpDisplay = this;
         }
         if(stateList)
         {
            stateList.dataProvider = null;
            stateList.removeFromParent(true);
            stateList = null;
         }
         initList();
         stateList.dataProvider = _showCD ? (r as GameRole).listData : null;
         stateList.visible = _showCD;
         try
         {
            if(!headImage)
            {
               headImage = new Image(DataCore.getTextureAtlas("role_head").getTextures(r.targetName)[0]);
               this.addChild(headImage);
               headImage.x = 5;
               headImage.y = 5;
               headImage.width = 42;
               headImage.height = 42;
               headImage.setVertexPosition(2,0,0.75 * headImage.texture.height);
               headImage.setVertexPosition(3,headImage.texture.width,0.75 * headImage.texture.height);
               headImage.setTexCoords(2,0,0.75);
               headImage.setTexCoords(3,1,0.75);
            }
            else
            {
               headImage.texture = DataCore.getTextureAtlas("role_head").getTextures(r.targetName)[0];
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function get role() : BaseRole
      {
         return _role;
      }
      
      override public function onInit() : void
      {
         var i:int = 0;
         var mpSpr:MpSprite = null;
         var key:Array = null;
         var cdSprGourp:BatchContainer = null;
         var k:int = 0;
         var cdSpr:CdSprite = null;
         _point.x = this.x;
         _point.y = this.y;
         var textureAtlas:TextureAtlas = DataCore.getTextureAtlas("hpmp");
         var image:Image = new Image(textureAtlas.getTexture("frame_hp.png"));
         this.addChild(image);
         hp = new Image(textureAtlas.getTexture("frame_hp_line.png"));
         hpbg = new Image(hp.texture);
         this.addChild(hpbg);
         hpbg.color = 16711680;
         this.addChild(hp);
         hp.x = 50;
         hp.y = 9;
         hpbg.x = hp.x;
         hpbg.y = hp.y;
         var mpframe:Image = new Image(textureAtlas.getTexture("mpframe.png"));
         var mpline:Image = new Image(textureAtlas.getTexture("mpline.png"));
         this.addChild(mpline);
         this.addChild(mpframe);
         mpframe.y = image.height;
         mpline.x = 7;
         mpline.y = image.height + 1;
         mpline.scaleX = 0;
         mp = mpline;
         for(i = 0; i < 10; )
         {
            mpSpr = new MpSprite();
            mpSpr.x = 80 + (mpSpr.width + 15) * i;
            mpSpr.y = 24;
            this.addChild(mpSpr);
            _mpSprites.push(mpSpr);
            i++;
         }
         if(_showCD)
         {
            key = ["J","L","U","I","O","P"];
            cdSprGourp = new BatchContainer();
            this.addChild(cdSprGourp);
            cdSprGourp.x = -75;
            cdSprGourp.y = 10;
            for(k = 0; k < key.length; )
            {
               cdSpr = new CdSprite(key[k]);
               cdSprGourp.addChild(cdSpr);
               cdSpr.x = 95 + (cdSpr.width * 0.7 + 3) * k;
               cdSpr.y = 65;
               cdSpr.scaleX *= this.scaleX;
               cdSpr.scaleX *= 0.9;
               cdSpr.scaleY *= 0.9;
               _cdSprites.push(cdSpr);
               cdSpr.hpmp = this;
               k++;
            }
            _cdSprite = cdSprGourp;
         }
         wifi = new WifiSprite();
         this.addChild(wifi);
         wifi.x = hpbg.x + hpbg.width + 15;
         wifi.y = hpbg.y + 4;
         wifi.scale = 24 / wifi.width;
         var hpnum:TextField = new TextField(76,32,"999999",new TextFormat("mini",16,16777215));
         this.addChild(hpnum);
         hpnum.alignPivot();
         hpnum.x = image.x + image.width - hpnum.width / 2;
         hpnum.y = 19;
         hpnum.scaleX = this.scaleX > 0 ? 1 : -1;
         _hpnum = hpnum;
      }
      
      public function initList() : void
      {
         var state:List = new List();
         this.addChild(state);
         state.width = 350;
         state.height = 32;
         state.x = 5;
         state.y = 92;
         state.itemRendererType = RoleStateItem;
         stateList = state;
         stateList.layout = new HorizontalLayout();
         stateList.scaleX = this.scaleX > 0 ? 1 : -1;
         if(stateList.scaleX == -1)
         {
            stateList.x = 5 + stateList.width - 26;
            (stateList.layout as HorizontalLayout).horizontalAlign = "right";
            (stateList.layout as HorizontalLayout).paddingRight = 0;
         }
         stateList.touchable = false;
      }
      
      public function pushWin() : void
      {
         var textures:TextureAtlas = DataCore.getTextureAtlas("hpmp");
         var win:Image = new Image(textures.getTexture("win.png"));
         this.addChild(win);
         win.scale = 0.7;
         win.x = 316 - win.width * (winNum + 1);
         win.y = 35;
         winNum++;
      }
      
      private function MPchange() : void
      {
         var i:int = 0;
         currentMp = (role as GameRole).currentMp.value;
         for(i = 0; i < _mpSprites.length; )
         {
            _mpSprites[i].available = (role as GameRole).currentMp.value > i;
            _mpSprites[i].visible = (role as GameRole).mpMax > i;
            i++;
         }
      }
      
      public function jitter() : void
      {
         _jitterTime = 12;
      }
      
      override public function onChange() : void
      {
         var hscale:Number = NaN;
         var cd:int = 0;
         if(_jitterTime > 0)
         {
            _jitterTime--;
            this.x = _point.x + Math.random() * _jitterIntensity - _jitterIntensity * 0.5;
            this.y = _point.y + Math.random() * _jitterIntensity - _jitterIntensity * 0.5;
         }
         else
         {
            this.x = _point.x;
            this.y = _point.y;
         }
         if(role)
         {
            mp.scaleX = (role as GameRole).mpPoint.value / 10;
            hscale = role.attribute.hp / role.attribute.hpmax;
            if(hscale == 1)
            {
               hp.scaleX = 1;
            }
            hp.setVertexPosition(1,hscale * hp.texture.width,0);
            hp.setVertexPosition(3,hscale * hp.texture.width,hp.texture.height);
            hp.setTexCoords(1,hscale,0);
            hp.setTexCoords(3,hscale,1);
            _hpnum.text = role.attribute.hp.toFixed();
            if(!role.isInjured())
            {
               hpbgScaleX += (hscale - hpbgScaleX) * 0.2;
               hpbg.setVertexPosition(1,hpbgScaleX * hp.texture.width,0);
               hpbg.setVertexPosition(3,hpbgScaleX * hp.texture.width,hp.texture.height);
               hpbg.setTexCoords(1,hpbgScaleX,0);
               hpbg.setTexCoords(3,hpbgScaleX,1);
            }
            if(_cdSprite)
            {
               for(cd = 0; cd < _cdSprites.length; )
               {
                  _cdSprites[cd].update(role);
                  cd++;
               }
               _cdSprite.updateDisplay();
            }
            MPchange();
         }
         else
         {
            hp.scaleX = 0;
         }
      }
      
      override public function dispose() : void
      {
         _point = null;
         hp = null;
         mp = null;
         hpbg = null;
         this._cdSprite = null;
         this._cdSprites.splice(0,this._cdSprites.length);
         this._mpSprites.splice(0,this._mpSprites.length);
         this._cdSprites = null;
         this._mpSprites = null;
         this._role = null;
         super.dispose();
      }
   }
}

