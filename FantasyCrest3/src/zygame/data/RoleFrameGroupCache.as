package zygame.data
{
   import flash.utils.Dictionary;
   
   public class RoleFrameGroupCache
   {
      
      public static var cache:RoleFrameGroupCache = new RoleFrameGroupCache();
      
      public var roleCache:Dictionary;
      
      public function RoleFrameGroupCache()
      {
         super();
         roleCache = new Dictionary();
      }
      
      public function getRoleFrameGroup(roleTarget:String) : RoleFrameGroupActions
      {
         return roleCache[roleTarget];
      }
      
      public function pushRoleFrameGroup(roleTarget:String, roleFrameGroup:RoleFrameGroupActions) : void
      {
         roleCache[roleTarget] = roleFrameGroup;
      }
      
      public function clearAll() : void
      {
         for(var i in roleCache)
         {
            (roleCache[i] as RoleFrameGroupActions).clear();
            delete roleCache[i];
         }
      }
   }
}

