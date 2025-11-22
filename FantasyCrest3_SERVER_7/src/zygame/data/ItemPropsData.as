package zygame.data
{
   import parser.Script;
   
   public class ItemPropsData
   {
      
      public static var ItemMaxCount:int = 99;
      
      private var _xml:XML;
      
      private var _count:cint = new cint();
      
      private var _extendData:Object;
      
      public function ItemPropsData(xml:XML, count:int, extendData:Object)
      {
         super();
         _count.value = count;
         _xml = xml;
         _extendData = extendData;
      }
      
      public function get type() : String
      {
         if(_xml.parent() == undefined)
         {
            return null;
         }
         return _xml.parent().localName();
      }
      
      public function get xmlData() : XML
      {
         return _xml;
      }
      
      public function get name() : String
      {
         return _xml.@id;
      }
      
      public function get message() : String
      {
         var str:String = "";
         var list:XMLList = _xml.children();
         for(var i in list)
         {
            str += list[i].@info + "\n";
         }
         return str == "" ? "无" : str;
      }
      
      public function get info() : String
      {
         return _xml.@info;
      }
      
      public function get count() : int
      {
         return _count.value;
      }
      
      public function set count(i:int) : void
      {
         _count.value = i;
      }
      
      public function toString() : String
      {
         return null;
      }
      
      public function extendsData() : Object
      {
         return _extendData;
      }
      
      public function get maxCount() : int
      {
         if(type == "crest")
         {
            return 1;
         }
         if(_xml.@maxCount == undefined)
         {
            return ItemMaxCount;
         }
         return _xml.@maxCount;
      }
      
      public function useProps() : void
      {
         var list:XMLList = _xml.child("effect");
         for(var i in list)
         {
            if(String(list[i].@action) != "")
            {
               Script.execute(String(list[i].@action));
            }
         }
      }
      
      public function getData() : Object
      {
         return {
            "id":this.name,
            "num":this.count,
            "extendData":this.extendsData()
         };
      }
   }
}

