package zygame.utils
{
   import flash.display.DisplayObject;
   import starling.utils.SystemUtil;
   
   public class RUtils
   {
      
      public function RUtils()
      {
         super();
      }
      
      public static function annotationText(str:String) : String
      {
         if(str.indexOf("#") != -1)
         {
            return str.substr(str.indexOf("#") + 1);
         }
         return str;
      }
      
      public static function isLocalGame(d:DisplayObject) : Boolean
      {
         if(SystemUtil.isAIR || SystemUtil.isDesktop)
         {
            return true;
         }
         return false;
      }
      
      public static function getPathName(path:String) : String
      {
         path = path.substr(path.lastIndexOf("/") + 1);
         return path.substr(0,path.lastIndexOf("."));
      }
   }
}

