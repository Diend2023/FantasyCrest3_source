package zygame.display
{
   import starling.display.Image;
   import starling.filters.ColorMatrixFilter;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   
   public class BackgroundSprite extends DisplayObjectContainer
   {
      
      private var _data:Array;
      
      private var _color:ColorMatrixFilter;
      
      private var _num:Number = 0;
      
      private var _centerX:int = 0;
      
      public var constantWidth:int = 2048;
      
      private var _constantX:Number = 1;
      
      public function BackgroundSprite(bgConfig:Array = null)
      {
         _data = bgConfig;
         this.touchable = false;
         super();
      }
      
      override public function onInit() : void
      {
         var i:int = 0;
         var _bg:Image = null;
         var currentMoveX:int = 0;
         if(!_data)
         {
            return;
         }
         _constantX = (world.map.getWidth() * World.worldScale - stage.stageWidth) / (constantWidth - stage.stageWidth);
         for(i = 0; i < _data.length; )
         {
            if(_data[i].type == "sound")
            {
               GameCore.soundCore.playBGSound(_data[i].name);
            }
            else
            {
               _bg = new Image(DataCore.getTexture(_data[i].name));
               this.addChild(_bg);
               _bg.scale = _data[i].scale ? _data[i].scale : 1;
               if(_data[i].scaleMode)
               {
                  var _loc4_:* = _data[i].scaleMode.type;
                  if("height" === _loc4_)
                  {
                     _bg.scale = stage.stageHeight / _bg.height * _data[i].scaleMode.value;
                  }
               }
               currentMoveX = _bg.width - stage.stageWidth;
               _data[i].centerX = (_bg.width - _data[i].move - stage.stageWidth) * 0.5;
               _data[i].mapMoveXWidth = -(world.map.getWidth() * World.worldScale - stage.stageWidth);
               _data[i].mapMoveYWidth = -(world.map.getHeight() * World.worldScale - stage.stageHeight);
               _data[i].bg = _bg;
               if(currentMoveX < _data[i].move * _constantX)
               {
                  _data[i].moveX = _data[i].move;
               }
               else
               {
                  _data[i].moveX = _data[i].move * _constantX;
               }
               switch(_data[i].align)
               {
                  case "top":
                     _data[i].minY = 0;
                     break;
                  case "center":
                     _data[i].minY = (stage.stageHeight - _bg.height * this.scale) / 2;
                     break;
                  case "bottom":
                     _data[i].minY = stage.stageHeight - _bg.height * this.scale;
               }
               if(_data[i].blendMode)
               {
                  _bg.blendMode = _data[i].blendMode;
               }
               if(_data[i].alpha)
               {
                  _bg.alpha = _data[i].alpha;
               }
            }
            i++;
         }
      }
      
      override public function onFrame() : void
      {
         var i:int = 0;
         for(i = 0; i < _data.length; )
         {
            if(_data[i].bg)
            {
               _data[i].bg.x = -_data[i].centerX + -_data[i].moveX * (world.x / _data[i].mapMoveXWidth);
               _data[i].bg.y = _data[i].minY + int(_data[i].moveY) * (1 - world.y / _data[i].mapMoveYWidth);
               if(_data[i].bg.x > 0)
               {
                  _data[i].bg.x = 0;
               }
               else if(_data[i].bg.x < -_data[i].bg.width + stage.stageWidth)
               {
                  _data[i].bg.x = -_data[i].bg.width + stage.stageWidth;
               }
               if(isNaN(_data[i].bg.y))
               {
                  _data[i].bg.y = 0;
               }
               if(_data[i].bg.y < _data[i].minY)
               {
                  _data[i].bg.y = _data[i].minY;
               }
               else if(_data[i].maxY < _data[i].bg.y)
               {
                  _data[i].bg.y = _data[i].maxY;
               }
            }
            i++;
         }
      }
   }
}

