package flash
{
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public dynamic class Boot extends MovieClip
   {
      
      public static var tf:TextField;
      
      public static var lines:Array;
      
      public static var lastError:Error;
      
      public static var skip_constructor:Boolean = false;
      
      public function Boot()
      {
         super();
      }
      
      public static function enum_to_string(param1:Object) : String
      {
         var _loc5_:* = null;
         if(param1.params == null)
         {
            return param1.tag;
         }
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         var _loc4_:Array = param1.params;
         while(_loc3_ < int(_loc4_.length))
         {
            _loc5_ = _loc4_[_loc3_];
            (++_loc2_).push(Boot.__string_rec(_loc5_,""));
         }
         return param1.tag + "(" + _loc2_.join(",") + ")";
      }
      
      public static function __instanceof(param1:*, param2:*) : Boolean
      {
         var _loc4_:* = null;
         try
         {
            if(param2 == Dynamic)
            {
               return true;
            }
            return param1 is param2;
         }
         catch(_loc_e_:*)
         {
         }
      }
      
      public static function __clear_trace() : void
      {
         if(Boot.tf == null)
         {
            return;
         }
         Boot.tf.parent.removeChild(Boot.tf);
         Boot.tf = null;
         Boot.lines = null;
      }
      
      public static function __set_trace_color(param1:uint) : void
      {
         var _loc2_:TextField = Boot.getTrace();
         _loc2_.textColor = param1;
         _loc2_.filters = [];
      }
      
      public static function getTrace() : TextField
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null as TextFormat;
         var _loc1_:MovieClip = Lib.current;
         if(Boot.tf == null)
         {
            Boot.tf = new TextField();
            _loc2_ = 16777215;
            _loc3_ = 0;
            if(_loc1_.stage != null)
            {
               _loc3_ = int(_loc1_.stage.color);
               _loc2_ = 16777215 - _loc3_;
            }
            Boot.tf.textColor = _loc2_;
            Boot.tf.filters = [new GlowFilter(_loc3_,1,2,2,20)];
            _loc4_ = Boot.tf.getTextFormat();
            _loc4_.font = "_sans";
            Boot.tf.defaultTextFormat = _loc4_;
            Boot.tf.selectable = false;
            if(_loc1_.stage == null)
            {
               Boot.tf.width = 800;
            }
            else
            {
               Boot.tf.width = _loc1_.stage.stageWidth;
            }
            Boot.tf.autoSize = TextFieldAutoSize.LEFT;
            Boot.tf.mouseEnabled = false;
         }
         if(_loc1_.stage == null)
         {
            _loc1_.addChild(Boot.tf);
         }
         else
         {
            _loc1_.stage.addChild(Boot.tf);
         }
         return Boot.tf;
      }
      
      public static function __trace(param1:*, param2:Object) : void
      {
         var _loc4_:* = null as String;
         var _loc6_:int = 0;
         var _loc7_:* = null as Array;
         var _loc8_:* = null;
         var _loc3_:TextField = Boot.getTrace();
         if(param2 == null)
         {
            _loc4_ = "(null)";
         }
         else
         {
            _loc4_ = param2.fileName + ":" + int(param2.lineNumber);
         }
         if(Boot.lines == null)
         {
            Boot.lines = [];
         }
         var _loc5_:String = _loc4_ + ": " + Boot.__string_rec(param1,"");
         if(param2 != null && param2.customParams != null)
         {
            _loc6_ = 0;
            _loc7_ = param2.customParams;
            while(_loc6_ < int(_loc7_.length))
            {
               _loc8_ = _loc7_[_loc6_];
               _loc5_ = ++_loc5_ + ("," + Boot.__string_rec(_loc8_,""));
            }
         }
         Boot.lines = Boot.lines.concat(_loc5_.split("\n"));
         _loc3_.text = Boot.lines.join("\n");
         var _loc9_:Stage = Lib.current.stage;
         if(_loc9_ == null)
         {
            return;
         }
         while(int(Boot.lines.length) > 1 && _loc3_.height > _loc9_.stageHeight)
         {
            Boot.lines.shift();
            _loc3_.text = Boot.lines.join("\n");
         }
      }
      
      public static function __string_rec(param1:*, param2:String) : String
      {
         var _loc5_:* = null as String;
         var _loc6_:* = null as Array;
         var _loc7_:* = null as Array;
         var _loc8_:* = 0;
         var _loc9_:* = null;
         var _loc10_:* = null as String;
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:* = null as String;
         var _loc4_:String;
         _loc5_ = _loc4_ = getQualifiedClassName(param1);
         if(_loc5_ == "Object")
         {
            _loc8_ = 0;
            _loc7_ = [];
            _loc9_ = param1;
            for(_loc8_ in _loc9_)
            {
               _loc7_.push(_loc8_);
            }
            _loc6_ = _loc7_;
            _loc10_ = "{";
            _loc11_ = true;
            _loc8_ = 0;
            _loc12_ = int(_loc6_.length);
            while(_loc8_ < _loc12_)
            {
               _loc13_ = _loc8_++;
               _loc14_ = _loc6_[_loc13_];
               if(_loc14_ == "toString")
               {
                  try
                  {
                     return param1.toString();
                  }
                  catch(_loc_e_:*)
                  {
                  }
               }
               if(_loc11_)
               {
                  _loc11_ = false;
               }
               else
               {
                  _loc10_ += ",";
               }
               _loc10_ += " " + _loc14_ + " : " + Boot.__string_rec(param1[_loc14_],param2);
            }
            if(!_loc11_)
            {
               _loc10_ += " ";
            }
            return _loc10_ + "}";
         }
         if(_loc5_ == "Array")
         {
            if(param1 == Array)
            {
               return "#Array";
            }
            _loc10_ = "[";
            _loc11_ = true;
            _loc6_ = param1;
            _loc8_ = 0;
            _loc12_ = int(_loc6_.length);
            while(_loc8_ < _loc12_)
            {
               _loc13_ = _loc8_++;
               if(_loc11_)
               {
                  _loc11_ = false;
               }
               else
               {
                  _loc10_ += ",";
               }
               _loc10_ += Boot.__string_rec(_loc6_[_loc13_],param2);
            }
            return _loc10_ + "]";
         }
         _loc10_ = _loc5_ = typeof param1;
         if(_loc10_ == "function")
         {
            return "<function>";
         }
         if(_loc10_ == "undefined")
         {
            return "null";
         }
         return new String(param1);
      }
      
      public static function __unprotect__(param1:String) : String
      {
         return param1;
      }
      
      public function start() : void
      {
         var _loc3_:* = null;
         var _loc2_:MovieClip = Lib.current;
         try
         {
            if(_loc2_ == this && _loc2_.stage != null && _loc2_.stage.align == "")
            {
               _loc2_.stage.align = "TOP_LEFT";
            }
         }
         catch(_loc_e_:*)
         {
            if(_loc2_.stage == null)
            {
               _loc2_.addEventListener(Event.ADDED_TO_STAGE,doInitDelay);
            }
            else if(_loc2_.stage.stageWidth == 0 || _loc2_.stage.stageHeight == 0)
            {
               setTimeout(start,1);
            }
            else
            {
               init();
            }
            return;
         }
      }
      
      public function init() : void
      {
         Boot.lastError = new Error();
         throw "assert";
      }
      
      public function doInitDelay(param1:*) : void
      {
         Lib.current.removeEventListener(Event.ADDED_TO_STAGE,doInitDelay);
         start();
      }
   }
}

Array.prototype;
_loc1_.setPropertyIsEnumerable("copy",false);
_loc1_.setPropertyIsEnumerable("insert",false);
_loc1_.setPropertyIsEnumerable("remove",false);
_loc1_.setPropertyIsEnumerable("iterator",false);
_loc1_["filter"] = function(param1:Function):Array
{
   var _loc2_:Array = [];
   var _loc3_:int = 0;
   var _loc4_:int = int(this.length);
   while(_loc3_ < _loc4_)
   {
      if(param1(this[_loc3_]))
      {
         _loc2_.push(this[_loc3_]);
      }
      _loc3_++;
   }
   return _loc2_;
};
_loc1_["map"] = function(param1:Function):Array
{
   var _loc2_:Array = [];
   var _loc3_:int = 0;
   var _loc4_:int = int(this.length);
   while(_loc3_ < _loc4_)
   {
      _loc2_.push(param1(this[_loc3_]));
      _loc3_++;
   }
   return _loc2_;
};
_loc1_.setPropertyIsEnumerable("map",false);
_loc1_.setPropertyIsEnumerable("filter",false);

