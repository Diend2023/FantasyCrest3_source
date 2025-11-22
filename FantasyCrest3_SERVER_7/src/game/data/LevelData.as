package game.data
{
   import zygame.core.DataCore;
   import zygame.data.RoleAttributeData;
   
   public class LevelData
   {
      
      public var array:Array;
      
      private var _selectCount:int = 0;
      
      public function LevelData(count:int)
      {
         var xmllist:XMLList = null;
         var pxml:XML = null;
         var rootName:String = null;
         var isVisible:Boolean = false;
         var isCoin:Boolean = false;
         var is4399:Boolean = false;
         var i2:int = 0;
         var index:int = 0;
         array = [];
         super();
         _selectCount = count;
         var arr:Array = [];
         var figth:XML = DataCore.getXml("fight");
         if(figth)
         {
            xmllist = figth.children();
            for(var i in xmllist)
            {
               pxml = xmllist[i] as XML;
               rootName = pxml.localName();
               if(rootName != "init" && rootName != "weizhi")
               {
                  isVisible = Boolean(pxml.@visible);
                  isCoin = int(pxml.@coin) > 0;
                  is4399 = String(pxml.@in4399) == "true";
                  if(String(pxml.@profession).indexOf("BOSS") == -1 && String(pxml.@profession).indexOf("小怪") == -1)
                  {
                     if(true)
                     {
                        arr.push(rootName);
                     }
                     else if(isVisible && !isCoin || is4399)
                     {
                        trace("纳入",rootName,isVisible,isCoin,is4399);
                        arr.push(rootName);
                     }
                  }
               }
            }
         }
         i2 = 0;
         while(i2 < 10)
         {
            index = arr.length * Math.random();
            array.push(arr[index]);
            arr.splice(index,1);
            i2++;
         }
         trace("挑战顺序：",array);
      }
      
      public function getAttributeFormName(target:String) : RoleAttributeData
      {
         var attr:RoleAttributeData = new RoleAttributeData(target);
         DataCore.fightData.initAttribute(attr);
         return attr;
      }
      
      public function nextFight() : Boolean
      {
         var i:int = 0;
         for(i = 0; i < _selectCount; )
         {
            array.shift();
            i++;
         }
         if(array.length == 0)
         {
            return false;
         }
         return true;
      }
      
      public function get currentFightArray() : Array
      {
         var i:int = 0;
         var arr:Array = [];
         for(i = 0; i < _selectCount; )
         {
            arr.push(array[i]);
            i++;
         }
         return arr;
      }
   }
}

