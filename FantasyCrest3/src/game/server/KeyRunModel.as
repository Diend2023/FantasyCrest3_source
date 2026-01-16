package game.server
{
   import game.role.GameRole;
   import zygame.core.GameCore;
   import zygame.display.BaseRole;
   import zygame.run.DefalutRunModel;
   import zygame.server.Service;
   
   public class KeyRunModel extends DefalutRunModel
   {
      
      public var target:String;
      
      public var globalFrame:int = 0;
      
      public var serverFrame:int = 0;
      
      private var _array:Array = [];
      
      private var _keys:Array = [];
      
      public var currentLevel:int = 2;
      
      public function KeyRunModel(roleTarget:String)
      {
         target = roleTarget;
         super();
      }
      
      override public function onFrame() : Boolean
      {
         return true;
      }
      
      public function doFunc(roleTarget:String, func:String, ... ret) : void
      {
         Service.radioUDP({
            "type":"radio",
            "data":{
               "target":"func",
               "role":roleTarget,
               "func":func,
               "ret":ret
            }
         });
      }
      
      public function sendKey() : void
      {
         Service.radioUDP({
            "type":(this is AccessRun3Model ? "radio" : "back"),
            "data":{
               "key":_keys,
               "role":target,
               "target":"keys"
            }
         });
      }
      
      override public function onDown(key:int) : Boolean
      {
         if(Service.client.type == "watching")
         {
            return true;
         }
         if(_keys.indexOf(key) == -1)
         {
            _keys.push(key);
            sendKey();
         }
         return true;
      }
      
      override public function onUp(key:int) : Boolean
      {
         if(Service.client.type == "watching")
         {
            return true;
         }
         if(_keys.indexOf(key) != -1)
         {
            _keys.removeAt(_keys.indexOf(key));
            sendKey();
         }
         return true;
      }
      
      public function sendWifiLevel(i:int) : void
      {
         var wifirole:BaseRole = null;
         currentLevel = i;
         if(GameCore.currentWorld)
         {
            wifirole = GameCore.currentWorld.getRoleFormName(target);
            if(wifirole)
            {
               (wifirole as GameRole).hpmpDisplay.wifi.updateLevel(i);
               Service.radioUDP({
                  "type":"radio",
                  "data":{
                     "target":"wifi",
                     "level":i,
                     "id":target
                  }
               });
            }
         }
      }
   }
}

