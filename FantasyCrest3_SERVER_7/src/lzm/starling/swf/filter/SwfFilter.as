package lzm.starling.swf.filter
{
   import flash.utils.getDefinitionByName;
   import starling.filters.BlurFilter;
   import starling.filters.FragmentFilter;
   
   public class SwfFilter
   {
      
      public static const filters:Array = ["flash.filters::GlowFilter","flash.filters::DropShadowFilter","flash.filters::BlurFilter"];
      
      public function SwfFilter()
      {
         super();
      }
      
      public static function createFilter(filterObjects:Object) : FragmentFilter
      {
         var filterName:String = null;
         var filterData:Object = null;
         var filter:FragmentFilter = null;
         var glow:BlurFilter = null;
         var dropShadow:BlurFilter = null;
         var blur:BlurFilter = null;
         for(filterName in filterObjects)
         {
            filterData = filterObjects[filterName];
            switch(filterName)
            {
               case filters[0]:
                  filter = glow = new BlurFilter(filterData.blurX / 10,filterData.blurY / 10);
                  break;
               case filters[1]:
                  dropShadow = new BlurFilter(filterData.blurX / 10,filterData.blurY / 10);
                  filter = dropShadow;
                  break;
               case filters[2]:
                  filter = blur = new BlurFilter(filterData.blurX / 10,filterData.blurY / 10);
            }
         }
         return filter;
      }
      
      public static function createTextFieldFilter(filterObjects:Object) : Array
      {
         var filter:Object = null;
         var filterName:String = null;
         var filterClazz:Class = null;
         var filters:Array = [];
         for(filterName in filterObjects)
         {
            filterClazz = getDefinitionByName(filterName) as Class;
            filter = new filterClazz();
            setPropertys(filter,filterObjects[filterName]);
            filters.push(filter);
         }
         return filters.length > 0 ? filters : null;
      }
      
      private static function setPropertys(filter:Object, propertys:Object) : void
      {
         for(var key in propertys)
         {
            if(filter.hasOwnProperty(key))
            {
               filter[key] = propertys[key];
            }
         }
      }
   }
}

