package zygame.display
{
   import flash.geom.Point;
   import starling.display.Image;
   import zygame.core.DataCore;
   
   public class FogSprite extends DisplayObjectContainer
   {
      
      private var _maxScaleX:Number;
      
      private var _maxScaleY:Number;
      
      public var maxAlpha:Number = 0.8;
      
      private var _point:Point;
      
      private var _ref:DisplayObjectContainer;
      
      private var _isShow:Boolean = false;
      
      public function FogSprite(ref:DisplayObjectContainer, maxScaleX:Number, maxScaleY:Number)
      {
         super();
         _ref = ref;
         var image:Image = new Image(DataCore.assetsSwf.otherAssets.getTexture("fog"));
         this.addChild(image);
         image.alignPivot();
         _maxScaleX = maxScaleX;
         _maxScaleY = maxScaleY;
         this.blendMode = "screen";
         _point = new Point();
         _isShow = true;
      }
      
      override public function onFrame() : void
      {
         var mathScale:Number = Math.random() * 0.1;
         if(_isShow)
         {
            this.scaleX -= (this.scaleX - (_maxScaleX + mathScale)) * 0.1;
            this.scaleY -= (this.scaleY - (_maxScaleY + mathScale)) * 0.1;
            this.alpha -= (this.alpha - maxAlpha) * 0.05;
            this.alpha -= (this.alpha - maxAlpha) * 0.05;
         }
         else
         {
            this.alpha -= (this.alpha - 0) * 0.05;
            this.alpha -= (this.alpha - 0) * 0.05;
         }
         if(_ref && _isShow)
         {
            this.x = _ref.x + _point.x;
            this.y = _ref.y + _point.y;
         }
      }
      
      public function close() : void
      {
         _isShow = false;
      }
      
      public function show() : void
      {
         _isShow = true;
      }
      
      public function setPXY(xz:int, yz:int) : void
      {
         _point.x = xz;
         _point.y = yz;
      }
      
      public function get ref() : DisplayObjectContainer
      {
         return _ref;
      }
   }
}

