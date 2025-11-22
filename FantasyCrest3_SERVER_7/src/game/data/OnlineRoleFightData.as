package game.data
{
   public class OnlineRoleFightData
   {
      
      public var win:cint = new cint();
      
      public var over:cint = new cint();
      
      public var fightTime:cint = new cint();
      
      public var times:cint = new cint();
      
      public var inWin:cint = new cint();
      
      public var highInWin:cint = new cint();
      
      public var isGetUp:Boolean = false;
      
      public function OnlineRoleFightData(data:Object = null)
      {
         super();
         if(data)
         {
            win.value = data.win;
            over.value = data.over;
            fightTime.value = data.allFigth;
            times.value = data.times4;
            inWin.value = data.isGetUp ? 0 : data.inWin;
            highInWin.value = data.highInWin;
         }
      }
      
      public function toSaveData() : Object
      {
         return {
            "win":win.value,
            "over":over.value,
            "allFigth":fightTime.value,
            "times4":times.value,
            "inWin":inWin.value,
            "isGetUp":isGetUp,
            "highInWin":highInWin.value
         };
      }
      
      public function get odds() : int
      {
         return win.value / fightTimes * 100;
      }
      
      public function get fightTimes() : int
      {
         if(times.value > allFightCount)
         {
            return times.value;
         }
         return allFightCount;
      }
      
      public function addFightTimes() : void
      {
         if(times.value < allFightCount)
         {
            times.value = allFightCount;
         }
         times.value++;
      }
      
      public function get getup() : int
      {
         if(times.value > allFightCount)
         {
            return times.value - allFightCount;
         }
         return 0;
      }
      
      public function get fight() : int
      {
         return fightTime.value / allFightCount;
      }
      
      public function get allFightCount() : int
      {
         return win.value + over.value;
      }
      
      public function get winCount() : int
      {
         return win.value;
      }
      
      public function get overCount() : int
      {
         return over.value;
      }
      
      public function getString() : String
      {
         return "场次：" + fightTimes + " (" + inWin.value + "连胜)  胜率：" + odds + "%  每秒伤害：" + fight + "  逃走：" + getup;
      }
   }
}

