package game.data
{
   import flash.utils.ByteArray;
   import game.role.GameRole;
   import game.skill.UDPSkill;
   import game.world.BaseGameWorld;
   import zygame.display.BaseRole;
   
   public class WorldRecordData
   {
      
      public var worldDatas:Array;
      
      private var _stop:Boolean = false;
      
      public var worldClass:String;
      
      public function WorldRecordData(byte:ByteArray = null)
      {
         super();
         if(byte)
         {
            worldDatas = byte.readObject();
            byte.clear();
            _stop = true;
         }
         else
         {
            worldDatas = [];
         }
      }
      
      public function initWorld(world:BaseGameWorld) : void
      {
         worldClass = String(world);
      }
      
      public function pushWorld(world:BaseGameWorld) : void
      {
         var arr:Array;
         var curFrame:int;
         var num:int;
         var i:int;
         var skill:UDPSkill;
         if(_stop)
         {
            return;
         }
         arr = [];
         curFrame = (world as BaseGameWorld).frameCount;
         world.getRoleList().forEach(function(role:BaseRole, index:int, v:Vector.<BaseRole>):void
         {
            arr.push({
               "frame":curFrame,
               "target":"role",
               "name":role.targetName,
               "id":role.pid,
               "data":(role as GameRole).copyData()
            });
         });
         num = world.map.roleLayer.numChildren;
         for(i = 0; i < num; )
         {
            skill = world.map.roleLayer.getChildAt(i) as UDPSkill;
            if(skill)
            {
               arr.push({
                  "target":"skill",
                  "frame":curFrame,
                  "data":skill.copyData()
               });
            }
            i++;
         }
         worldDatas.push(arr);
      }
      
      public function playWorld(world:BaseGameWorld) : void
      {
      }
      
      public function get bytes() : ByteArray
      {
         var byte:ByteArray = new ByteArray();
         byte.writeUTFBytes(worldClass);
         byte.writeObject(worldDatas);
         return byte;
      }
      
      public function stop() : void
      {
         _stop = true;
      }
   }
}

