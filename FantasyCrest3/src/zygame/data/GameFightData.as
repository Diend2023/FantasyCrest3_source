package zygame.data
{
   import zygame.core.DataCore;
   
   public class GameFightData
   {
      
      public var atrr:Array = ["力量","魔力","物理防御","魔法防御","体力"];
      
      public var data:XML;
      
      public var defalult:Object;
      
      public var names:Object;
      
      public function GameFightData(xml:XML)
      {
         super();
         data = xml;
         initObject();
      }
      
      private function initObject() : void
      {
         var xml:XMLList = null;
         names = {};
         defalult = {};
         if(data)
         {
            xml = data.init.children();
            for(var i in xml)
            {
               defalult[String(xml[i].@id)] = int(xml[i].@value);
               names[String(xml[i].@name)] = String(xml[i].@id);
               log("初始化参数",String(xml[i].@id),xml[i].@value);
            }
         }
      }
      
      private function initAttributeDefalult(roleAttribute:RoleAttributeData) : void
      {
         roleAttribute.hp = 100;
         roleAttribute.hpmax = 100;
         roleAttribute.speed = 6;
         roleAttribute.jump = 20;
         roleAttribute.gravity = 100;
         roleAttribute.dodgeRate = 0;
         roleAttribute.shooting = 100;
         for(var i in defalult)
         {
            roleAttribute.setValue(i as String,defalult[i]);
         }
         roleAttribute.hpmax = roleAttribute.hp;
      }
      
      public function hasData(name:String) : Boolean
      {
         if(!data)
         {
            return false;
         }
         var count:int = int(data.child(name).length());
         if(count > 0)
         {
            return true;
         }
         var list:XMLList = data.children();
         for(var i in list)
         {
            trace("检测",list[i].@contains,list[i].@contains as String);
            if(list[i].@contains != undefined && String(list[i].@contains).indexOf(name) != -1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function initAttribute(roleAttribute:RoleAttributeData) : void
      {
         var pname:String = null;
         initAttributeDefalult(roleAttribute);
         if(!data)
         {
            return;
         }
         var xml:XMLList = data[roleAttribute.target].child("data");
         roleAttribute.roleName = data[roleAttribute.target].@name;
         if(xml && xml.length() > 0)
         {
            for(var i in xml)
            {
               pname = names[String(xml[i].@name)];
               if(atrr.indexOf(String(xml[i].@name)) != -1)
               {
                  roleAttribute.setValue(pname,roleAttribute.getValue(pname) * getAddScale(roleAttribute.lv,Number(xml[i].@value)));
               }
               else
               {
                  roleAttribute.setValue(pname,roleAttribute.getValue(pname) * Number(xml[i].@value));
               }
            }
         }
         roleAttribute.hpmax = roleAttribute.hp;
      }
      
      public function getAddScale(lv:int, scale:Number) : Number
      {
         return scale + scale * 0.1 * (lv * lv);
      }
      
      public function getProps(attridute:RoleAttributeData, attridute2:RoleAttributeData) : Vector.<String>
      {
         var propsXml:XML = null;
         if(!data)
         {
            return null;
         }
         if(!attridute2)
         {
            attridute2 = new RoleAttributeData(null);
         }
         var arr:Vector.<String> = new Vector.<String>();
         var xml:XMLList = data[attridute.target].props.child("item");
         for(var i in xml)
         {
            if(Math.random() < Number(xml[i].@chance) + attridute2.lucky / 100)
            {
               propsXml = DataCore.props.queryAll(xml[i].@id);
               if(propsXml.@most == undefined || DataCore.getStatisticalProps(xml[i].@id) < int(propsXml.@most))
               {
                  arr.push(String(xml[i].@id));
               }
            }
         }
         if(Math.random() < 0.7 + attridute2.lucky / 100)
         {
            arr.push("金币");
         }
         return arr;
      }
   }
}

