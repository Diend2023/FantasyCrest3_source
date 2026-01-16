package zygame.display
{
   import flash.geom.Point;
   import lzm.starling.swf.FPSUtil;
   import starling.display.DisplayObject;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.core.DataCore;
   
   public class Dialog extends DisplayObjectContainer
   {
      
      public static const WIDTH:int = 60;
      
      public static const HEIGHT:int = 32;
      
      private var _message:String = "";
      
      protected var _image:DisplayObject;
      
      protected var _text:TextField;
      
      private var _fps:FPSUtil;
      
      protected var _dialogScaleX:int = 1;
      
      private var _autoRemove:Boolean = true;
      
      private var _atuoRemoveTime:int = 180;
      
      private var _followDisplay:DisplayObject;
      
      private var _followPos:Point;
      
      public var backFunc:Function;
      
      public function Dialog(message:String, wz:int = 150, hz:int = 120)
      {
         super();
         _message = message;
         _fps = new FPSUtil(12);
         onCreateSkin(message,wz,hz);
         onDraw();
      }
      
      public function onCreateSkin(message:String, wz:int = 150, hz:int = 120) : void
      {
         _image = DataCore.assetsSwf.createS9Image("s9_message");
         if(_image)
         {
            _image.alpha = 0.8;
            this.addChild(_image);
         }
         var format:TextFormat = new TextFormat("Verdana",24,16777215,"left","bottom");
         _text = new TextField(wz * 2,hz * 2,"",format);
         this.addChild(_text);
         _text.y -= 8;
         _text.scale = 0.5;
      }
      
      override public function onFrame() : void
      {
         if(_followDisplay)
         {
            this.x = _followDisplay.x - _followPos.x;
            this.y = _followDisplay.y - _followPos.y;
         }
         if(_message == "")
         {
            _atuoRemoveTime--;
            if(_autoRemove && _atuoRemoveTime < 0)
            {
               this.alpha -= 0.05;
               if(this.alpha <= 0)
               {
                  if(backFunc != null)
                  {
                     backFunc();
                  }
                  this.removeFromParent();
               }
            }
            return;
         }
         if(!_fps.update())
         {
            return;
         }
         _text.text += _message.charAt(0);
         _message = _message.substr(1);
         onDraw();
      }
      
      public function set autoRemove(b:Boolean) : void
      {
         _autoRemove = b;
      }
      
      public function onDraw() : void
      {
         if(_image)
         {
            _image.width = _text.textBounds.width * _text.scale + 10;
            _image.height = _text.textBounds.height * _text.scale + 24;
            if(_image.width < 60)
            {
               _image.width = 60;
            }
            if(_image.height < 32)
            {
               _image.height = 32;
            }
            _image.y = -int(_image.height);
         }
         _text.y = int(-18 - _text.height);
         if(_dialogScaleX == -1 && _image)
         {
            _text.x = -int(_image.width) + 5;
         }
      }
      
      override public function set scaleX(value:Number) : void
      {
         _dialogScaleX = value < 0 ? -1 : 1;
         if(_image)
         {
            _image.scaleX = _dialogScaleX;
         }
         if(_dialogScaleX == -1 && _image)
         {
            _text.x = -int(_image.width) + 5;
         }
         else
         {
            _text.x = 3;
         }
      }
      
      public function quick() : void
      {
         if(_message != "")
         {
            _text.text += _message;
            _message = "";
            onDraw();
         }
         else
         {
            _atuoRemoveTime = 0;
            autoRemove = true;
         }
      }
      
      public function set autoRemoveTime(i:int) : void
      {
         _atuoRemoveTime = i;
      }
      
      public function set followDisplay(display:DisplayObject) : void
      {
         _followDisplay = display;
         _followPos = new Point(display.x - this.x,display.y - this.y);
      }
   }
}

