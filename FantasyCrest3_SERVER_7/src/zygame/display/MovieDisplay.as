package zygame.display
{
   import flash.geom.Rectangle;
   import lzm.starling.swf.FPSUtil;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   
   public class MovieDisplay extends BodyDisplayObject
   {
      
      private var _fps:FPSUtil;
      
      private var _frame:int = 0;
      
      private var _textures:TextureAtlas;
      
      private var _frameNames:Vector.<String>;
      
      private var _allFrameNames:Vector.<String>;
      
      private var _xml:XML;
      
      private var _list:XMLList;
      
      private var _image:Image;
      
      private var _isPlay:Boolean = false;
      
      private var _startFrame:int = 0;
      
      private var _endFrame:int = -1;
      
      private var _targetFrames:Vector.<int>;
      
      public function MovieDisplay(target:String, fps:int = 24)
      {
         super();
         targetName = target;
         if(!target)
         {
            return;
         }
         _xml = DataCore.getXml(target);
         _list = _xml.children();
         _textures = DataCore.getTextureAtlas(target);
         if(!_textures)
         {
            throw new Error("无法创建MovieDisplay，因为精灵表" + target + "不存在！");
         }
         _frameNames = _textures.getNames();
         _allFrameNames = _textures.getNames();
         _image = new Image(_textures.getTexture(_frameNames[0]));
         _image.x = int(_xml.@px);
         _image.y = int(_xml.@py);
         _fps = new FPSUtil(fps);
         this.addChild(_image);
         _isPlay = fps > 0;
         if(_xml.@startFrame != undefined)
         {
            startFrame = int(_xml.@startFrame);
         }
         if(_xml.@endFrame != undefined)
         {
            endFrame = int(_xml.@endFrame);
         }
         else
         {
            endFrame = _frameNames.length;
         }
      }
      
      public function setTarget(target:String) : void
      {
         _xml = DataCore.assetsSwf.otherAssets.getXml(target);
         _textures = DataCore.assetsSwf.otherAssets.getTextureAtlas(target);
         _frameNames = _textures.getNames();
         _image.x = int(_xml.@px);
         _image.y = int(_xml.@py);
         draw(true);
      }
      
      public function addTargetFrame(i:int) : void
      {
         if(!this._targetFrames)
         {
            this._targetFrames = new Vector.<int>();
         }
         this._targetFrames.push(i);
      }
      
      public function removeTargetFrame(i:int) : void
      {
         if(this._targetFrames)
         {
            this._targetFrames.removeAt(_targetFrames.indexOf(i));
         }
      }
      
      public function get xml() : XML
      {
         return _xml;
      }
      
      override public function draw(bool:Boolean = false) : void
      {
         if(!bool)
         {
            if(!_isPlay)
            {
               return;
            }
            if(!_fps.update())
            {
               return;
            }
            _frame++;
         }
         if(_frame >= _endFrame)
         {
            this.dispatchEventWith("played");
            _frame = _startFrame;
         }
         _image.texture = _textures.getTexture(_frameNames[_frame]);
         var frame:Rectangle = _textures.getFrame(_frameNames[_frame]);
         if(!frame)
         {
            frame = _textures.getRegion(_frameNames[_frame]);
         }
         _image.width = frame.width;
         _image.height = frame.height;
         this.dispatchEventWith("draw_frame");
         if(_targetFrames && _targetFrames.indexOf(_frame) != -1)
         {
            this.dispatchEventWith("target_frame");
         }
      }
      
      public function gotoAndPlay(i:int) : void
      {
         _frame = i;
         play();
         draw(true);
      }
      
      public function gotoAndStop(i:int) : void
      {
         _frame = i;
         stop();
         draw(true);
      }
      
      public function gotoNameAndPlay(pname:String, i:int = 0) : void
      {
         _frameNames = _textures.getNames(pname);
         gotoAndPlay(i);
      }
      
      public function gotoNameAndStop(pname:String, i:int = 0) : void
      {
         _frameNames = _textures.getNames(pname);
         gotoAndStop(i);
      }
      
      public function stop() : void
      {
         _isPlay = false;
      }
      
      public function play() : void
      {
         _isPlay = true;
      }
      
      public function get length() : int
      {
         return _frameNames.length;
      }
      
      override public function discarded() : void
      {
         super.discarded();
      }
      
      public function set startFrame(i:int) : void
      {
         _startFrame = i;
         _frame = i;
      }
      
      public function set endFrame(i:int) : void
      {
         _endFrame = i;
      }
      
      public function get frame() : int
      {
         return _frame;
      }
      
      public function get currentDrawFrame() : int
      {
         return _frameNames.indexOf(currentTextureName);
      }
      
      public function get currentXmlDrawFrame() : int
      {
         return _allFrameNames.indexOf(_frameNames[currentDrawFrame]);
      }
      
      public function get display() : DisplayObject
      {
         return _image;
      }
      
      public function get currentTexture() : Texture
      {
         return _image.texture;
      }
      
      public function get currentTextureAlast() : TextureAtlas
      {
         return _textures;
      }
      
      public function get currentTextureName() : String
      {
         return _frameNames[_frame];
      }
   }
}

