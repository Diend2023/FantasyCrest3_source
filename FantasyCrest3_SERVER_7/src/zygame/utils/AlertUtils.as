package zygame.utils
{
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   
   public class AlertUtils
   {
      
      public function AlertUtils()
      {
         super();
      }
      
      public static function show(message:String, title:String) : void
      {
         Alert.show(message,title,new ListCollection([{"label":"确定"}]));
      }
   }
}

