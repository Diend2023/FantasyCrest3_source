package zygame.data
{
   import flash.utils.Dictionary;
   
   public class EncryptCEData
   {
      
      private var _datas:Dictionary;
      
      public var setCall:Function;
      
      public function EncryptCEData()
      {
         super();
         _datas = new Dictionary();
      }
      
      public function setValue(key:String, i:int) : void
      {
         var c:cint = _datas[key];
         if(!c)
         {
            c = new cint(i);
            _datas[key] = c;
         }
         else
         {
            c.value = i;
         }
         if(setCall != null)
         {
            setCall();
         }
      }
      
      public function getValue(key:String) : int
      {
         var c:cint = _datas[key];
         if(c)
         {
            return c.value;
         }
         return 0;
      }
      
      public function hasKey(key:String) : Boolean
      {
         return _datas[key] != null;
      }
      
      public function gc() : void
      {
         for(var i in _datas)
         {
            delete _datas[i];
         }
         _datas = null;
      }
      
      public function toObject() : Object
      {
         var ob:Object = {};
         for(var i in _datas)
         {
            ob[i] = _datas[i].value;
         }
         return ob;
      }
   }
}

