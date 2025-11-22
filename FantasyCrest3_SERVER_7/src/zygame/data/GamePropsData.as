package zygame.data
{
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   
   public class GamePropsData
   {
      
      private var _data:Object;
      
      private var _material:Vector.<ItemPropsData>;
      
      private var _consumables:Vector.<ItemPropsData>;
      
      private var _crest:Vector.<ItemPropsData>;
      
      private var _task:Vector.<ItemPropsData>;
      
      private var _type:String = "";
      
      private var _maxSaveCount:int = 21;
      
      public function GamePropsData(data:Object)
      {
         super();
         trace("数据：",JSON.stringify(data));
         _data = data;
         if(_data == null)
         {
            _data = {
               "material":[],
               "consumables":[],
               "crest":[],
               "task":[]
            };
         }
         _material = new Vector.<ItemPropsData>();
         _consumables = new Vector.<ItemPropsData>();
         _crest = new Vector.<ItemPropsData>();
         _task = new Vector.<ItemPropsData>();
         initData(_material,_data.material);
         initData(_consumables,_data.consumables);
         initData(_crest,_data.crest);
         initData(_task,_data.task);
      }
      
      public function queryAll(pname:String) : XML
      {
         var xml:XML = null;
         xml = queryAt(pname);
         if(!xml)
         {
            xml = queryAt(pname,"material");
         }
         if(!xml)
         {
            xml = queryAt(pname,"task");
         }
         if(!xml)
         {
            xml = queryAt(pname,"crest");
         }
         return xml;
      }
      
      public function queryAt(pname:String, type:String = "consumables") : XML
      {
         var xml:XML = DataCore.getXml("propsdata");
         if(!xml)
         {
            return null;
         }
         var list:XMLList = xml[type].children();
         for(var i in list)
         {
            if(String(list[i].@id) == pname)
            {
               return list[i];
            }
         }
         return null;
      }
      
      public function remove(props:ItemPropsData) : Boolean
      {
         var list:* = undefined;
         var num:int = 0;
         var i:int = 0;
         var type:String = props.type;
         if(type)
         {
            list = this[type];
            num = cheakAll(props.name);
            if(num > 0 && props.count <= num)
            {
               for(i = list.length - 1; i >= 0; )
               {
                  if(list[i].name == props.name)
                  {
                     if(list[i].count > props.count)
                     {
                        list[i].count -= props.count;
                        break;
                     }
                     props.count -= list[i].count;
                     list.removeAt(i);
                     if(props.count == 0)
                     {
                        break;
                     }
                  }
                  i--;
               }
               return true;
            }
            return false;
         }
         return false;
      }
      
      public function add(props:ItemPropsData) : Boolean
      {
         var list:* = undefined;
         var z:int = 0;
         var yz:int = 0;
         var type:String = props.type;
         if(type)
         {
            list = this[type];
            if(props.maxCount > 1)
            {
               for(var i in list)
               {
                  if(list[i].name == props.name && list[i].count < list[i].maxCount)
                  {
                     z = list[i].count + props.count;
                     yz = z - props.maxCount;
                     if(yz <= 0)
                     {
                        list[i].count = z;
                        if(GameCore.currentWorld && GameCore.currentWorld.state)
                        {
                           GameCore.currentWorld.state.pushLog("获得了" + props.name + "x" + props.count);
                        }
                        return true;
                     }
                     list[i].count = list[i].maxCount;
                     props.count = yz;
                     if(GameCore.currentWorld && GameCore.currentWorld.state)
                     {
                        GameCore.currentWorld.state.pushLog("获得了" + props.name + "x" + yz);
                     }
                  }
               }
            }
            if(getListLength(list) < _maxSaveCount)
            {
               if(GameCore.currentWorld && GameCore.currentWorld.state)
               {
                  GameCore.currentWorld.state.pushLog("获得了" + props.name + "x" + props.count);
               }
               list.push(props);
               return true;
            }
            trace("道具已满",props.name,props.count);
            return false;
         }
         return false;
      }
      
      private function initData(arr:Vector.<ItemPropsData>, data:Array) : void
      {
         var props:XML = null;
         for(var i in data)
         {
            props = queryAll(data[i].id);
            if(props)
            {
               arr.push(new ItemPropsData(props,data[i].num,data[i].extendData));
            }
         }
      }
      
      public function getSaveArray(arr:Vector.<ItemPropsData>) : Array
      {
         var ret:Array = [];
         for(var i in arr)
         {
            ret.push(arr[i].getData());
         }
         return ret;
      }
      
      public function getSaveData() : Object
      {
         var ob:Object = {
            "material":getSaveArray(material),
            "consumables":getSaveArray(consumables),
            "crest":getSaveArray(crest),
            "task":getSaveArray(task)
         };
         trace("储存",JSON.stringify(ob));
         return ob;
      }
      
      public function get material() : Vector.<ItemPropsData>
      {
         return _material;
      }
      
      public function get consumables() : Vector.<ItemPropsData>
      {
         return _consumables;
      }
      
      public function get crest() : Vector.<ItemPropsData>
      {
         return _crest;
      }
      
      public function get task() : Vector.<ItemPropsData>
      {
         return _task;
      }
      
      public function get allProps() : Vector.<ItemPropsData>
      {
         return _material.concat(_consumables).concat(_crest).concat(_task);
      }
      
      public function cheakAll(target:String) : int
      {
         var xml:XML = queryAll(target);
         if(!xml)
         {
            return 0;
         }
         return cheakAt(target,xml.parent().localName());
      }
      
      public function cheakAt(target:String, type:String) : int
      {
         var i:int = 0;
         var vec:Vector.<ItemPropsData> = this[type] as Vector.<ItemPropsData>;
         var count:int = 0;
         for(i = 0; i < vec.length; )
         {
            if(vec[i].name == target)
            {
               count += vec[i].count;
            }
            i++;
         }
         return count;
      }
      
      public function set savePropsType(str:String) : void
      {
         _type = str;
      }
      
      protected function getListLength(list:Vector.<ItemPropsData>) : int
      {
         if(_type == "one")
         {
            return allLength;
         }
         return list.length;
      }
      
      public function get allLength() : int
      {
         return _consumables.length + _crest.length + _material.length + _task.length;
      }
      
      public function set maxSaveCount(i:int) : void
      {
         _maxSaveCount = i;
      }
   }
}

