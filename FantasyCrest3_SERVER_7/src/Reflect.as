package
{
   public class Reflect
   {
      
      public function Reflect()
      {
      }
      
      public static function field(param1:*, param2:String) : *
      {
         var _loc4_:* = null;
         try
         {
            return param1[param2];
         }
         catch(_loc_e_:*)
         {
         }
      }
      
      public static function fields(param1:*) : Array
      {
         var _loc4_:* = null as String;
         if(param1 == null)
         {
            return [];
         }
         var _loc3_:Array = [];
         for(_loc4_ in param1)
         {
            if(param1.hasOwnProperty(_loc4_))
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public static function copy(param1:Object) : Object
      {
         var _loc5_:* = null as String;
         var _loc6_:* = null;
         var _loc2_:* = {};
         var _loc3_:int = 0;
         var _loc4_:Array = Reflect.fields(param1);
         while(_loc3_ < int(_loc4_.length))
         {
            _loc5_ = _loc4_[_loc3_];
            _loc3_++;
            _loc6_ = Reflect.field(param1,_loc5_);
            _loc2_[_loc5_] = _loc6_;
         }
         return _loc2_;
      }
   }
}

