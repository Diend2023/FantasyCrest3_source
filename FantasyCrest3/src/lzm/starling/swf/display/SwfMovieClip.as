package lzm.starling.swf.display
{
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.blendmode.SwfBlendMode;
   import starling.display.DisplayObject;
   import starling.text.TextField;
   
   [Event(name="complete",type="starling.events.Event")]
   public class SwfMovieClip extends SwfSprite implements ISwfAnimation
   {
      
      public static const ANGLE_TO_RADIAN:Number = 0.017453292519943295;
      
      private var _ownerSwf:Swf;
      
      private var _frames:Array;
      
      private var _labels:Array;
      
      private var _frameEvents:Object;
      
      private var _labelStrings:Array;
      
      private var _displayObjects:Object;
      
      private var _startFrame:int;
      
      private var _endFrame:int;
      
      private var _currentFrame:int;
      
      private var _currentLabel:String;
      
      private var _isPlay:Boolean = false;
      
      private var _loop:Boolean = true;
      
      private var _completeFunction:Function = null;
      
      private var _hasCompleteListener:Boolean = false;
      
      private var _autoUpdate:Boolean = true;
      
      private var __frameInfos:Array;
      
      public function SwfMovieClip(frames:Array, labels:Array, displayObjects:Object, ownerSwf:Swf, frameEvents:Object = null)
      {
         super();
         _frames = frames;
         _labels = labels;
         _displayObjects = displayObjects;
         _frameEvents = frameEvents;
         _startFrame = 0;
         _endFrame = _frames.length - 1;
         _ownerSwf = ownerSwf;
         _currentFrame = -1;
         currentFrame = 0;
         play();
      }
      
      public function update() : void
      {
         var isReturn:Boolean = false;
         if(!_isPlay)
         {
            return;
         }
         if(_currentFrame >= _endFrame)
         {
            isReturn = false;
            if(!_loop || _startFrame == _endFrame)
            {
               if(_ownerSwf)
               {
                  stop(false);
               }
               isReturn = true;
            }
            if(_completeFunction != null)
            {
               _completeFunction(this);
            }
            if(_hasCompleteListener)
            {
               dispatchEventWith("complete");
            }
            if(isReturn)
            {
               return;
            }
            _currentFrame = _startFrame;
         }
         else
         {
            _currentFrame++;
         }
         currentFrame = _currentFrame;
      }
      
      public function set currentFrame(frame:int) : void
      {
         var data:Array = null;
         var display:DisplayObject = null;
         var useIndex:int = 0;
         var i:int = 0;
         var textFiled:TextField = null;
         clearChild();
         _currentFrame = frame;
         __frameInfos = _frames[_currentFrame];
         var length:int = int(__frameInfos.length);
         for(i = 0; i < length; )
         {
            data = __frameInfos[i];
            useIndex = int(data[10]);
            display = _displayObjects[data[0]][useIndex];
            display.setRequiresRedraw();
            display.skewX = data[6] * 0.017453292519943295;
            display.skewY = data[7] * 0.017453292519943295;
            display.alpha = data[8];
            display.name = data[9];
            if(data[1] == "particle")
            {
               display["setPostion"](data[2],data[3]);
            }
            else
            {
               display.x = data[2];
               display.y = data[3];
            }
            switch(data[1])
            {
               case "s9":
                  display.width = data[11];
                  display.height = data[12];
                  SwfBlendMode.setBlendMode(display,data[13]);
                  break;
               case "shapeImg":
                  display["setSize"](data[11],data[12]);
                  SwfBlendMode.setBlendMode(display,data[13]);
                  break;
               case "text":
                  textFiled = display as TextField;
                  textFiled.width = data[11];
                  textFiled.height = data[12];
                  textFiled.format.font = data[13];
                  textFiled.format.color = data[14];
                  textFiled.format.size = data[15];
                  textFiled.format.horizontalAlign = data[16];
                  textFiled.format.italic = data[17];
                  textFiled.format.bold = data[18];
                  if(data[19] && data[19] != "\r" && data[19] != "")
                  {
                     textFiled.text = data[19];
                  }
                  SwfBlendMode.setBlendMode(display,data[20]);
                  break;
               default:
                  display.scaleX = data[4];
                  display.scaleY = data[5];
                  SwfBlendMode.setBlendMode(display,data[11]);
            }
            this.addChild(display);
            i++;
         }
         if(_frameEvents != null && _frameEvents[_currentFrame] != null)
         {
            dispatchEventWith(_frameEvents[_currentFrame]);
         }
      }
      
      public function get currentFrame() : int
      {
         return _currentFrame;
      }
      
      public function play(rePlayChildMovie:Boolean = false) : void
      {
         var k:String = null;
         var arr:Array = null;
         var l:int = 0;
         var i:int = 0;
         _isPlay = true;
         if(_currentFrame >= _endFrame)
         {
            _currentFrame = _startFrame;
         }
         if(_autoUpdate)
         {
            _ownerSwf.swfUpdateManager.addSwfAnimation(this);
         }
         if(!rePlayChildMovie)
         {
            return;
         }
         for(k in _displayObjects)
         {
            if(k.indexOf("mc") == 0)
            {
               arr = _displayObjects[k];
               l = int(arr.length);
               for(i = 0; i < l; )
               {
                  if(rePlayChildMovie)
                  {
                     (arr[i] as SwfMovieClip).currentFrame = 0;
                  }
                  (arr[i] as SwfMovieClip).play(rePlayChildMovie);
                  i++;
               }
            }
         }
      }
      
      public function stop(stopChild:Boolean = true) : void
      {
         var k:String = null;
         var arr:Array = null;
         var l:int = 0;
         var i:int = 0;
         _isPlay = false;
         _ownerSwf.swfUpdateManager.removeSwfAnimation(this);
         if(!stopChild)
         {
            return;
         }
         for(k in _displayObjects)
         {
            if(k.indexOf("mc") == 0)
            {
               arr = _displayObjects[k];
               l = int(arr.length);
               for(i = 0; i < l; )
               {
                  (arr[i] as SwfMovieClip).stop(stopChild);
                  i++;
               }
            }
         }
      }
      
      public function gotoAndStop(frame:Object, stopChild:Boolean = true) : void
      {
         goTo(frame);
         stop(stopChild);
      }
      
      public function gotoAndPlay(frame:Object, rePlayChildMovie:Boolean = false) : void
      {
         goTo(frame);
         play(rePlayChildMovie);
      }
      
      private function goTo(frame:*) : void
      {
         var labelData:Array = null;
         if(frame is String)
         {
            labelData = getLabelData(frame);
            _currentLabel = labelData[0];
            _currentFrame = _startFrame = labelData[1];
            _endFrame = labelData[2];
         }
         else if(frame is int)
         {
            _currentFrame = _startFrame = frame;
            _endFrame = _frames.length - 1;
         }
         currentFrame = _currentFrame;
      }
      
      private function getLabelData(label:String) : Array
      {
         var labelData:Array = null;
         var i:int = 0;
         var length:int = int(_labels.length);
         for(i = 0; i < length; )
         {
            labelData = _labels[i];
            if(labelData[0] == label)
            {
               return labelData;
            }
            i++;
         }
         return null;
      }
      
      public function get isPlay() : Boolean
      {
         return _isPlay;
      }
      
      public function get loop() : Boolean
      {
         return _loop;
      }
      
      public function set loop(value:Boolean) : void
      {
         _loop = value;
      }
      
      public function set completeFunction(value:Function) : void
      {
         _completeFunction = value;
      }
      
      public function get completeFunction() : Function
      {
         return _completeFunction;
      }
      
      public function get totalFrames() : int
      {
         return _frames.length;
      }
      
      public function get currentLabel() : String
      {
         return _currentLabel;
      }
      
      public function get labels() : Array
      {
         var i:int = 0;
         if(_labelStrings != null)
         {
            return _labelStrings;
         }
         _labelStrings = [];
         var length:int = int(_labels.length);
         for(i = 0; i < length; )
         {
            _labelStrings.push(_labels[i][0]);
            i++;
         }
         return _labelStrings;
      }
      
      override public function set color(value:uint) : void
      {
         var len:int = 0;
         var i:int = 0;
         _color = value;
         for each(var displayArray in _displayObjects)
         {
            len = int(displayArray.length);
            for(i = 0; i < len; )
            {
               setDisplayColor(displayArray[i],_color);
               i++;
            }
         }
      }
      
      public function hasLabel(label:String) : Boolean
      {
         return labels.indexOf(label) != -1;
      }
      
      override public function addEventListener(type:String, listener:Function) : void
      {
         super.addEventListener(type,listener);
         _hasCompleteListener = hasEventListener("complete");
      }
      
      override public function removeEventListener(type:String, listener:Function) : void
      {
         super.removeEventListener(type,listener);
         _hasCompleteListener = hasEventListener("complete");
      }
      
      override public function removeEventListeners(type:String = null) : void
      {
         super.removeEventListeners(type);
         _hasCompleteListener = hasEventListener("complete");
      }
      
      public function set autoUpdate(value:Boolean) : void
      {
         _autoUpdate = value;
         if(_autoUpdate)
         {
            _ownerSwf.swfUpdateManager.addSwfAnimation(this);
         }
         else
         {
            _ownerSwf.swfUpdateManager.removeSwfAnimation(this);
         }
      }
      
      public function get autoUpdate() : Boolean
      {
         return _autoUpdate;
      }
      
      public function set startFrame(value:int) : void
      {
         _startFrame = value < 0 ? 0 : value;
         _startFrame = _startFrame > _endFrame ? _endFrame : _startFrame;
      }
      
      public function get startFrame() : int
      {
         return _startFrame;
      }
      
      public function set endFrame(value:int) : void
      {
         _endFrame = value > _frames.length - 1 ? _frames.length - 1 : value;
         _endFrame = _endFrame < _startFrame ? _startFrame : _endFrame;
      }
      
      public function get endFrame() : int
      {
         return _endFrame;
      }
      
      override public function dispose() : void
      {
         var len:int = 0;
         var i:int = 0;
         if(!_ownerSwf)
         {
            return;
         }
         _ownerSwf.swfUpdateManager.removeSwfAnimation(this);
         _ownerSwf = null;
         for each(var array in _displayObjects)
         {
            len = int(array.length);
            for(i = 0; i < len; )
            {
               (array[i] as DisplayObject).removeFromParent(true);
               i++;
            }
         }
         super.dispose();
      }
   }
}

