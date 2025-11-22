package
{
   public class cint
   {
      
      private var a:String;
      
      private var b:String;
      
      private var ar:Array;
      
      private var d:String;
      
      private var tlen:int;
      
      private var nlen:int;
      
      public function cint(val:int = 0)
      {
         super();
         value = val;
         value1 = val;
         value2 = val;
      }
      
      public function get value() : int
      {
         return int(a) + int(b);
      }
      
      public function set value(val:int) : void
      {
         var s:Array = splitVal(val);
         a = String(s[0]);
         b = String(s[1]);
      }
      
      private function splitVal(val:int) : Array
      {
         var maxRange:int = 999999;
         var a1:int = int(a);
         var b1:int = int(b);
         maxRange = 2147483647 - maxRange < a1 ? 2147483647 - a1 : maxRange;
         maxRange = 2147483647 - maxRange < b1 ? 2147483647 - b1 : maxRange;
         var ran:int = Math.random() * maxRange;
         var val1:int = val - ran;
         var val2:int = val - val1;
         return [val1,val2];
      }
      
      public function add(val:int) : void
      {
         var final:int = value + val;
         var s:Array = splitVal(final);
         a = String(s[0]);
         b = String(s[1]);
      }
      
      public function sub(val:int) : void
      {
         var final:int = value - val;
         var s:Array = splitVal(val);
         a = String(s[0]);
         b = String(s[1]);
      }
      
      public function multi(val:int) : void
      {
         var final:int = value * val;
         var s:Array = splitVal(final);
         a = String(s[0]);
         b = String(s[1]);
      }
      
      public function divide(val:int) : void
      {
         var final:int = value / val;
         var s:Array = splitVal(final);
         a = String(s[0]);
         b = String(s[1]);
      }
      
      public function get value1() : int
      {
         var i:int = 0;
         var str:String = "";
         var len:int = int(ar.length);
         for(i = 0; i < len; )
         {
            str += ar[i];
            i++;
         }
         return int(str);
      }
      
      public function set value1(val:int) : void
      {
         ar = splitVal1(val);
         value = val;
         value2 = val;
      }
      
      private function splitVal1(val:int) : Array
      {
         var i:int = 0;
         var str:String = val.toString();
         var len:int = str.length;
         var arr:Array = [];
         for(i = 0; i < len; )
         {
            arr[i] = str.charAt(i);
            i++;
         }
         return arr;
      }
      
      public function get value2() : int
      {
         var i:int = 0;
         return int(d.substr(tlen,nlen));
      }
      
      public function set value2(val:int) : void
      {
         var maxRange:int = 9999;
         var ran:int = Math.random() * maxRange;
         var ran1:int = Math.random() * maxRange;
         tlen = String(ran).length;
         nlen = String(val).length;
         d = String(ran) + String(val) + String(ran1);
      }
      
      public function add1(val:int) : void
      {
         var v1:int = value1;
         var v2:int = val + v1;
         value1 = v2;
      }
   }
}

