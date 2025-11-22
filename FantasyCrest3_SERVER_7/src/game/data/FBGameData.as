package game.data
{
   import lzm.util.Base64;
   import zygame.data.EncryptCEData;
   
   public class FBGameData
   {
      
      public var data:EncryptCEData;
      
      public function FBGameData(data2:Object = null)
      {
         var dataFight:Object = null;
         super();
         data = new EncryptCEData();
         if(data2)
         {
            dataFight = data2.fbs;
            if(dataFight)
            {
               dataFight = Base64.decode(dataFight as String);
               dataFight = JSON.parse(dataFight as String);
               for(var i in dataFight)
               {
                  data.setValue(i as String,dataFight[i]);
               }
            }
         }
      }
      
      public function getWinTimes(target:String) : int
      {
         return data.getValue(target);
      }
      
      public function addWinTimes(target:String) : void
      {
         data.setValue(target,data.getValue(target) + 1);
      }
      
      public function pushData(data2:FBGameData) : void
      {
         var value:int = 0;
         var ob:Object = data2.data.toObject();
         for(var i in ob)
         {
            value = data.getValue(i as String);
            value += int(ob[i]);
            if(value < 0)
            {
               value = 0;
            }
            data.setValue(i as String,value);
         }
      }
      
      public function toSaveData() : String
      {
         var str:String = JSON.stringify(data.toObject());
         return Base64.encode(str);
      }
   }
}

