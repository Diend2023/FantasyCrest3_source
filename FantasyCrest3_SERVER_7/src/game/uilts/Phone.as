package game.uilts
{
   import flash.filesystem.File;
   
   public class Phone
   {
      
      public function Phone()
      {
         super();
      }
      
      public static function isPhone() : Boolean
      {
         return File.applicationDirectory.resolvePath("phone.xml").exists;
      }
   }
}

