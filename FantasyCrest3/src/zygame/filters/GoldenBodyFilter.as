package zygame.filters
{
   import starling.filters.FragmentFilter;
   import starling.rendering.FilterEffect;
   import zygame.effect.GoldenBodyEffect;
   
   public class GoldenBodyFilter extends FragmentFilter
   {
      
      public function GoldenBodyFilter()
      {
         super();
      }
      
      override protected function createEffect() : FilterEffect
      {
         return new GoldenBodyEffect();
      }
   }
}

