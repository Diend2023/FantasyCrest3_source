package
{
   import flash.Boot;
   
   public class Std
   {
      
      public function Std()
      {
      }
      
      public static function string(param1:*) : String
      {
         return Boot.__string_rec(param1,"");
      }
   }
}

