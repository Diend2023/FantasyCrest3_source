package zygame.data
{
   import nape.geom.Vec2;
   import zygame.utils.NapeUtils;
   
   public class RoleFrame
   {
      
      private var _xmlData:XML;
      
      public var name:String;
      
      public var group:RoleFrameGroup;
      
      public var isStop:Boolean = false;
      
      public var effects:Array;
      
      public var soundName:String = "";
      
      public var gox:int = 0;
      
      public var goy:int = 0;
      
      public var isGoPoint:Boolean;
      
      public var nextGox:int = 0;
      
      public var nextGoy:int = 0;
      
      public var at:int = 0;
      
      public var hitPoint:Vector.<Vec2>;
      
      public var hitX:int = 0;
      
      public var hitY:int = 0;
      
      public var live:int = 0;
      
      public var interval:int = 0;
      
      public var mScale:Number;
      
      public var wScale:Number;
      
      public var straight:int = 0;
      
      public var isHitMapGoOn:Boolean = false;
      
      public var vibration:Boolean = false;
      
      public var cardFrame:int = 0;
      
      public var golden:int = 0;
      
      public var hitVibrationSize:int = 0;
      
      public var mapVibrationSize:int = 0;
      
      public var mapVibrationTime:int = 0;
      
      public var hitEffectName:String = null;
      
      public function RoleFrame(xml:XML)
      {
         super();
         _xmlData = xml;
         name = xml.@name;
         if(xml.@effects != undefined && xml.@effects != "")
         {
            effects = JSON.parse(xml.@effects) as Array;
            for(var i in effects)
            {
               effects[i] = JSON.parse(effects[i]);
            }
         }
         else
         {
            effects = [];
         }
         isStop = String(xml.@stop) == "stop" || String(xml.@asA) == "stop";
         soundName = xml.@soundName;
         isGoPoint = String(xml.@isApplyGoPoint) == "true";
         gox = int(xml.@gox);
         goy = int(xml.@goy);
         hitX = int(xml.@hitX);
         hitY = int(xml.@hitY);
         live = int(xml.@hitEffect);
         interval = int(xml.@hitInterval);
         mScale = int(xml.@mFight) / 100;
         wScale = int(xml.@wFight) / 100;
         straight = int(xml.@straight);
         vibration = String(xml.@vibration) == "true";
         isHitMapGoOn = String(xml.@isHitMapGoOn) == "true";
         cardFrame = int(xml.@cardFrame);
         hitVibrationSize = int(xml.@vibrationSize);
         mapVibrationSize = int(xml.@mapVibrationSize);
         mapVibrationTime = int(xml.@mapVibrationTime);
         if(xml.@hitEffectName != undefined)
         {
            hitEffectName = xml.@hitEffectName;
         }
         if(hitEffectName == "")
         {
            hitEffectName = null;
         }
         golden = Number(xml.@golden) * 60;
         if(xml.@hitPoint != undefined && xml.@hitPoint != "")
         {
            hitPoint = NapeUtils.parsingPoint(String(xml.@hitPoint));
         }
      }
      
      public function get turn() : Boolean
      {
         return int(_xmlData.@turn) == 1;
      }
      
      public function clear() : void
      {
         _xmlData = null;
         if(effects)
         {
            effects.splice(0,effects.length);
         }
         effects = null;
         group = null;
         if(hitPoint)
         {
            hitPoint.splice(0,hitPoint.length);
         }
         hitPoint = null;
      }
   }
}

