package zygame.display
{
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.textures.RenderTexture;
   import zygame.core.GameCore;
   
   public class FogSystem extends Image
   {
      
      private var _fogs:Vector.<FogSprite> = new Vector.<FogSprite>();
      
      private var _render:RenderTexture;
      
      public var _spr:Sprite = new Sprite();
      
      private var _alpha:Number = 0.9;
      
      public function FogSystem()
      {
         trace(GameCore.currentCore.stage.stageWidth,GameCore.currentCore.stage.stageHeight);
         _render = new RenderTexture(1624,1024);
         update();
         super(_render);
      }
      
      public function addFog(ref:DisplayObjectContainer, sx:Number, sy:Number) : void
      {
         var fogSprite:FogSprite = new FogSprite(ref,sx,sy);
         fogSprite.scale = 0;
         this._fogs.push(fogSprite);
         _spr.addChild(fogSprite);
         fogSprite.x = ref.x;
         fogSprite.y = ref.y;
         ref.setFogSprite(fogSprite);
      }
      
      public function update() : void
      {
         for(var i in _fogs)
         {
            _fogs[i].onFrame();
         }
         _render.clear(0,1 - _alpha);
         _render.draw(_spr);
         _spr.x = -this.x;
         _spr.y = -this.y;
         this.blendMode = "mask";
      }
      
      override public function set alpha(value:Number) : void
      {
         _alpha = value;
      }
      
      override public function dispose() : void
      {
         _render.dispose();
         super.dispose();
      }
   }
}

