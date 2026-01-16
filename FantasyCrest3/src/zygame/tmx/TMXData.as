package zygame.tmx
{
   public class TMXData
   {
      
      public function TMXData()
      {
         super();
      }
      
      public static function repair(str:String) : XML
      {
         var ob:Object = null;
         var xml:XML = new XML(str);
         var xmllist:XMLList = xml.properties.child("property");
         for(var i in xmllist)
         {
            if(xmllist[i].@name == "extend")
            {
               ob = JSON.parse(xmllist[i].@value);
               repairObject(ob);
               xmllist[i].@value = JSON.stringify(ob);
            }
         }
         return xml;
      }
      
      private static function repairObject(ob:Object) : void
      {
         for(var i in ob)
         {
            if(String(i) == "path")
            {
               ob[i] = (ob[i] as String).split("\\").join("/");
            }
            else if(ob[i] is Object || ob[i] is Array)
            {
               repairObject(ob[i]);
            }
         }
      }
   }
}

