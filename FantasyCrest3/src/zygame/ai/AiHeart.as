package zygame.ai
{
   import flash.utils.Dictionary;
   import parser.Script;
   import zygame.display.BaseRole;
   
   public class AiHeart
   {
      
      public static var allCodeFuncName:Dictionary = new Dictionary();
      
      private var _role:BaseRole;
      
      private var _ai:XML;
      
      private var _aiCache:Dictionary = new Dictionary();
      
      private var _times:Dictionary = new Dictionary();
      
      public function AiHeart(prole:BaseRole, aixml:XML)
      {
         super();
         _role = prole;
         _ai = aixml;
      }
      
      public function onUpdate() : void
      {
         if(_ai)
         {
            or(_ai);
         }
      }
      
      public function or(xml:XML) : Boolean
      {
         var xml2:XML = null;
         var actionid:String = null;
         var list:XMLList = _aiCache[xml];
         if(!list)
         {
            list = xml.children();
            _aiCache[xml] = list;
         }
         for(var i in list)
         {
            xml2 = list[i];
            actionid = String(xml2.@id);
            if(int(_times[actionid]) != 0)
            {
               _times[actionid]--;
               continue;
            }
            switch(xml2.localName())
            {
               case "action":
                  if(action(xml2))
                  {
                     if(xml2.@interval != undefined)
                     {
                        _times[actionid] = int(xml2.@interval);
                     }
                     return true;
                  }
                  break;
               case "and":
                  if(and(xml2))
                  {
                     if(xml2.@interval != undefined)
                     {
                        _times[actionid] = int(xml2.@interval);
                     }
                     return true;
                  }
                  break;
               case "or":
                  if(or(xml2))
                  {
                     if(xml2.@interval != undefined)
                     {
                        _times[actionid] = int(xml2.@interval);
                     }
                     return true;
                  }
            }
         }
         return false;
      }
      
      public function and(xml:XML) : Boolean
      {
         var xml2:XML = null;
         var list:XMLList = _aiCache[xml];
         if(!list)
         {
            list = xml.children();
            _aiCache[xml] = list;
         }
         for(var i in list)
         {
            xml2 = list[i];
            switch(xml2.localName())
            {
               case "action":
                  if(!action(xml2))
                  {
                     return false;
                  }
                  break;
               case "and":
                  if(!and(xml2))
                  {
                     return false;
                  }
                  break;
               case "or":
                  if(!or(xml2))
                  {
                     return false;
                  }
            }
         }
         return true;
      }
      
      public function action(xml:XML) : Boolean
      {
         var code:String = null;
         if(!xml)
         {
            return false;
         }
         Script.vm.role = _role;
         var func:String = String(xml.@id);
         if(allCodeFuncName[func] == null)
         {
            allCodeFuncName[func] = toFunc(Base64.encode(func));
            func = allCodeFuncName[func];
            code = "function " + func + "():Boolean{return " + String(xml.@id) + "}";
            Script.declare(code);
         }
         else
         {
            func = allCodeFuncName[func];
         }
         return Script.getFunc(func)();
      }
      
      public function toFunc(str:String) : String
      {
         return "AS_" + str;
      }
      
      public function clear() : void
      {
         if(_aiCache)
         {
            for(var i in _aiCache)
            {
               _aiCache[i] = null;
            }
         }
         _ai = null;
         _role = null;
         _aiCache = null;
         _times = null;
      }
   }
}

