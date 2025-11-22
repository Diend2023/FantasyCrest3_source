package game.data
{
   import flash.utils.Dictionary;
   import zygame.utils.Base64;
   
   public class OnlineFightData
   {
      
      public var dict:Dictionary = new Dictionary();
      
      public function OnlineFightData(data:Object)
      {
         super();
         if(data)
         {
            if(data is String)
            {
               data = JSON.parse(Base64.decode(data as String));
            }
            for(var i in data)
            {
               dict[i] = new OnlineRoleFightData(data[i]);
            }
         }
      }
      
      public function pushWin(target:String, timeFight:int) : void
      {
         var data:OnlineRoleFightData = getData(target);
         data.fightTime.value += timeFight;
         data.win.value++;
         data.inWin.value++;
         if(data.highInWin.value < data.inWin.value)
         {
            data.highInWin.value = data.inWin.value;
         }
         data.isGetUp = false;
      }
      
      public function pushOver(target:String, timeFight:int) : void
      {
         var data:OnlineRoleFightData = getData(target);
         data.fightTime.value += timeFight;
         data.over.value++;
         data.inWin.value = 0;
         data.isGetUp = false;
      }
      
      public function getData(target:String) : OnlineRoleFightData
      {
         var data:OnlineRoleFightData = dict[target];
         if(!data)
         {
            data = new OnlineRoleFightData();
            dict[target] = data;
         }
         return data;
      }
      
      public function toSaveData() : Object
      {
         var ob:Object = {};
         for(var i in dict)
         {
            ob[i] = (dict[i] as OnlineRoleFightData).toSaveData();
         }
         return Base64.encode(JSON.stringify(ob));
      }
   }
}

