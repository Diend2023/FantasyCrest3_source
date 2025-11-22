package zygame.display
{
   import nape.dynamics.InteractionFilter;
   
   public class DisplayType
   {
      
      public static const ROLE:int = 100;
      
      public static const SKILL:int = 101;
      
      public static const ACTOR:int = 102;
      
      public static const MAP:int = 103;
      
      public static const FIND_ROLE:InteractionFilter = new InteractionFilter(100);
      
      public function DisplayType()
      {
         super();
      }
   }
}

