package lzm.starling.display
{
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Sprite;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.filters.GlowFilter;
   import starling.text.TextField;
   import starling.text.TextFormat;
   
   public class Button extends DisplayObjectContainer
   {
      
      protected static const MAX_DRAG_DIST:Number = 0;
      
      private var _enabled:Boolean = true;
      
      protected var _skin:DisplayObject;
      
      protected var _disabledSkin:DisplayObject;
      
      protected var _content:Sprite;
      
      protected var _textfield:TextField;
      
      protected var _isDown:Boolean;
      
      protected var _w:Number;
      
      protected var _h:Number;
      
      protected var _textfomat:TextFormat;
      
      public function Button(skin:DisplayObject, text:String = null, textFont:String = null)
      {
         super();
         _content = new Sprite();
         addChild(_content);
         _skin = skin;
         _content.addChild(_skin);
         _w = _skin.width;
         _h = _skin.height;
         if(text != null)
         {
            this.text = text;
         }
         _textfomat = new TextFormat();
         _textfomat.font = textFont;
         addEventListener("touch",onTouch);
      }
      
      protected function resetContents() : void
      {
         _isDown = false;
         _content.x = _content.y = 0;
         _content.scaleX = _content.scaleY = 1;
      }
      
      protected function onTouch(event:TouchEvent) : void
      {
         var buttonRect:Rectangle = null;
         var touch:Touch = event.getTouch(this);
         if(!enabled || touch == null)
         {
            return;
         }
         if(touch.phase == "began" && !_isDown)
         {
            _content.scaleX = _content.scaleY = 0.9;
            _content.x = 0.04999999999999999 * _w;
            _content.y = 0.04999999999999999 * _h;
            _isDown = true;
         }
         else if(touch.phase == "moved" && _isDown)
         {
            buttonRect = getBounds(stage);
            if(touch.globalX < buttonRect.x - 0 || touch.globalY < buttonRect.y - 0 || touch.globalX > buttonRect.x + buttonRect.width + 0 || touch.globalY > buttonRect.y + buttonRect.height + 0)
            {
               resetContents();
            }
         }
         else if(touch.phase == "ended" && _isDown)
         {
            resetContents();
            dispatchEventWith("triggered",true);
         }
      }
      
      protected function createTextfield() : void
      {
         if(_textfield == null)
         {
            _textfomat.color = 16776960;
            _textfomat.verticalAlign = "center";
            _textfomat.horizontalAlign = "center";
            _textfield = new TextField(_w,_h,"",_textfomat);
            _textfield.touchable = false;
            _textfield.filter = new GlowFilter(0);
            _content.addChild(_textfield);
         }
         _textfield.width = _w;
         _textfield.height = _h;
         layoutTextField();
      }
      
      private function layoutTextField() : void
      {
         if(_textfield)
         {
            _textfield.x = _w - _textfield.width >> 1;
            _textfield.y = _h - _textfield.height >> 1;
         }
      }
      
      public function set text(value:String) : void
      {
         createTextfield();
         _textfield.text = value;
      }
      
      public function get text() : String
      {
         if(_textfield)
         {
            return _textfield.text;
         }
         return null;
      }
      
      public function get textField() : TextField
      {
         return _textfield;
      }
      
      public function set textFont(value:String) : void
      {
         if(_textfield)
         {
            _textfomat.font = value;
            _textfield.format = _textfomat;
         }
      }
      
      public function get content() : Sprite
      {
         return _content;
      }
      
      public function get skin() : DisplayObject
      {
         return _skin;
      }
      
      public function set disabledSkin(value:DisplayObject) : void
      {
         _disabledSkin = value;
      }
      
      override public function dispose() : void
      {
         if(_textfield)
         {
            _textfield.removeFromParent();
            _textfield.dispose();
            _textfield = null;
         }
         _skin.removeFromParent();
         _skin.dispose();
         _skin = null;
         if(_disabledSkin)
         {
            _disabledSkin.removeFromParent();
            _disabledSkin.dispose();
            _disabledSkin = null;
         }
         super.dispose();
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function set enabled(value:Boolean) : void
      {
         var setSkin:DisplayObject = null;
         if(_enabled == value)
         {
            return;
         }
         touchable = _enabled = value;
         if(_disabledSkin)
         {
            _content.removeChildAt(0);
            setSkin = _enabled ? _skin : (_disabledSkin ? _disabledSkin : _skin);
            _content.addChildAt(setSkin,0);
            _w = setSkin.width;
            _h = setSkin.height;
            layoutTextField();
         }
         else
         {
            alpha = _enabled ? 1 : 0.5;
         }
      }
   }
}

