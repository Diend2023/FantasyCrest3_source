package zygame.tmx
{
   public class MapSpriteMode
   {
      
      public static const NOT_PENETRATE:String = "not_penetrate";
      
      public static const VISIBLE_STES:String = "visible_stes";
      
      public static const NOT_VISIBLE_STES:String = "not_visible_stes";
      
      public static const DYNAMIC_VISIBLE:String = "dynamic_visible";
      
      public static const NOT_HIT:String = "not_hit";
      
      public static const NOT_VISIBLE_NOT_PENETRATE:String = "not_visible_not_penetrate";
      
      public function MapSpriteMode()
      {
         super();
      }
      
      public static function getColor(str:String) : uint
      {
         switch(str)
         {
            case "not_penetrate":
               return 65280;
            case "visible_stes":
               return 255;
            case "not_visible_stes":
               return 16711680;
            default:
               return 16777215;
         }
      }
   }
}

