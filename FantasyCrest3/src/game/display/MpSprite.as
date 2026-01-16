package game.display
{
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.display.DisplayObjectContainer;
   
   public class MpSprite extends DisplayObjectContainer
   {
      
      private var _available:Boolean = false;
      
      private var _mpspr:Image;
      
      private var _textureAtlas:TextureAtlas;
      
      public function MpSprite()
      {
         super();
      }
      
      override public function onInit() : void
      {
         _textureAtlas = DataCore.getTextureAtlas("hpmp");
         var top:Image = new Image(_textureAtlas.getTexture("mptop.png"));
         this.addChild(top);
         top.alignPivot("center","top");
         var spr:Image = new Image(_textureAtlas.getTexture("mpspr.png"));
         this.addChild(spr);
         spr.alignPivot("center","top");
         spr.y = top.height;
         _mpspr = spr;
         _mpspr.visible = false;
      }
      
      public function set available(b:Boolean) : void
      {
         var m:MovieClip;
         if(_available && !b)
         {
            m = new MovieClip(_textureAtlas.getTextures("use_"));
            this.parent.addChild(m);
            m.x = this.x;
            m.y = this.y + 4 + this.height * 0.5;
            m.scale *= 2;
            m.alignPivot();
            m.blendMode = "add";
            m.fps = 12;
            m.addEventListener("complete",function():void
            {
               m.removeFromParent();
            });
            Starling.juggler.add(m);
         }
         _mpspr.visible = b;
         _available = b;
      }
      
      public function get available() : Boolean
      {
         return _available;
      }
      
      override public function dispose() : void
      {
         this._mpspr = null;
         this._textureAtlas = null;
         super.dispose();
      }
   }
}

