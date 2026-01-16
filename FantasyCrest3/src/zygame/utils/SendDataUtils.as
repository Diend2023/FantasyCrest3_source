package zygame.utils
{
   import zygame.server.Service;
   
   public class SendDataUtils
   {
      
      public function SendDataUtils()
      {
         super();
      }
      
      public static function handData(name:String, code:String) : Object
      {
         return {
            "type":"hand",
            "userName":name,
            "userCode":code
         };
      }
      
      public static function userData(data:Object) : Object
      {
         return {
            "type":"user_data",
            "data":data
         };
      }
      
      public static function messageData(msg:String, target:String) : Object
      {
         return {
            "type":"message",
            "msg":msg,
            "target":target
         };
      }
      
      public static function roomList(list:Array) : Object
      {
         return {
            "type":"room_list",
            "list":list
         };
      }
      
      public static function createRoom(mode:String, count:int, code:String) : Object
      {
         return {
            "type":"create_room",
            "mode":mode,
            "count":count,
            "code":code
         };
      }
      
      public static function joinRoom(roomid:int, code:String) : Object
      {
         return {
            "type":"join_room",
            "id":roomid,
            "code":code
         };
      }
      
      public static function exitRoom(roomid:int) : Object
      {
         return {
            "type":"exit_room",
            "id":roomid
         };
      }
      
      public static function setRoleData(data:Object) : Object
      {
         return {
            "type":"set_room_player_data",
            "data":data
         };
      }
      
      public static function getRoleData() : Object
      {
         return {"type":"get_room_player_data"};
      }
      
      public static function changeRole(target:String) : Object
      {
         Service.client.type = target;
         return {
            "type":"change_role",
            "change":target
         };
      }
   }
}

