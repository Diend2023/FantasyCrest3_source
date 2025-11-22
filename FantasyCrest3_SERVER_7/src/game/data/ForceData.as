package game.data
{
   import game.view.GameTipsView;
   import lzm.util.Base64;
   import zygame.core.SceneCore;
   import zygame.data.EncryptCEData;
   
   public class ForceData
   {
      
      public var _forces:EncryptCEData;
      
      public function ForceData(data:Object = null)
      {
         var dataFight:Object = null;
         super();
         _forces = new EncryptCEData();
         SceneCore.pushView(new GameTipsView("数据读取完成"));
         if(data)
         {
            dataFight = data.fight;
            if(dataFight)
            {
               dataFight = Base64.decode(dataFight as String);
               dataFight = JSON.parse(dataFight as String);
               for(var i in dataFight)
               {
                  _forces.setValue(i as String,dataFight[i]);
               }
            }
         }
      }
      
      public function pushData(data:ForceData) : void
      {
         var value:int = 0;
         var ob:Object = data._forces.toObject();
         for(var i in ob)
         {
            value = _forces.getValue(i as String);
            value += int(ob[i]);
            if(value < 0)
            {
               value = 0;
            }
            _forces.setValue(i as String,value);
         }
      }
      
      public function getData(name:String) : int
      {
         var score:int = _forces.getValue(name);
         return score + getOnlineData(name);
      }
      
      public function getOnlineData(name:String) : int
      {
         var score:int = 0;
         var fightData:OnlineRoleFightData = Game.onlineData.getData(name);
         return int(score + fightData.fight / 10 * fightData.fightTimes * fightData.odds / 100);
      }
      
      public function addForce(pname:String, i:int) : int
      {
         if(i > 999)
         {
            return 0;
         }
         var value:int = _forces.getValue(pname) + i;
         if(value < 0)
         {
            value = 0;
         }
         _forces.setValue(pname,value);
         return value;
      }
      
      public function get allFight() : int
      {
         var i:int = 0;
         var data:Object = _forces.toObject();
         for(var i2 in data)
         {
            i += int(data[i2]);
         }
         return i;
      }
      
      public function get allOnlineFight() : int
      {
         var i:int = 0;
         var data:Object = Game.onlineData.dict;
         for(var i2 in data)
         {
            i += getOnlineData(i2);
         }
         return i;
      }
      
      public function get highRoleTargetName() : String
      {
         var target:String = null;
         var curFight:int = 0;
         var data:Object = _forces.toObject();
         for(var i2 in data)
         {
            if(data[i2] > curFight)
            {
               curFight = int(data[i2]);
               target = i2 as String;
            }
         }
         return target;
      }
      
      public function toSaveData() : String
      {
         var str:String = JSON.stringify(_forces.toObject());
         return Base64.encode(str);
      }
   }
}

