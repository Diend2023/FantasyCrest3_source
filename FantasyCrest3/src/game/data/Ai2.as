package game.data
{
   import flash.utils.Dictionary;
   import zygame.data.RoleFrameGroup;
   import zygame.display.BaseRole;
   
   public class Ai2
   {
      
      public function Ai2()
      {
         super();
      }
      
      public static function skill(role:BaseRole, skillName:String = null) : Boolean
      {
         var group:RoleFrameGroup = null;
         if(role.isInjured() && (role.isLock && Math.random() < 0.97))
         {
            return false;
         }
         if(skillName)
         {
            group = role.roleXmlData.getGroupAt(skillName);
            if(group.name == "普通攻击")
            {
               role.playSkill(role.isJump() ? "空中攻击" : "普通攻击");
               return role.actionName == role.isJump() ? "空中攻击" : "普通攻击";
            }
            role.playSkillFormKey(group.key);
            return role.actionName == skillName;
         }
         if(role.isJump())
         {
            return randomSkill(role,role.roleXmlData.airActions);
         }
         return randomSkill(role,role.roleXmlData.landActions);
      }
      
      public static function defense(role:BaseRole) : Boolean
      {
         if(role.isLock)
         {
            return false;
         }
         role.stopAllKey();
         var gorole:BaseRole = getRandomRole(role);
         if(gorole && gorole.isLock)
         {
            if(role.scaleX == 1 && gorole.x > role.x)
            {
               role.onDown(83);
            }
            else if(role.scaleX == -1 && gorole.x < role.x)
            {
               role.onDown(83);
            }
            return true;
         }
         return false;
      }
      
      public static function getRandomRole(role:BaseRole) : BaseRole
      {
         var gorole:BaseRole = role.getHateRole();
         if(gorole)
         {
            return gorole;
         }
         var array:Vector.<BaseRole> = role.world.getRoleList();
         for(var i in array)
         {
            if(role.troopid != array[i].troopid && Math.random() > 0.5)
            {
               gorole = array[i];
               break;
            }
         }
         return gorole;
      }
      
      public static function move(role:BaseRole) : Boolean
      {
         var gorole:BaseRole = getRandomRole(role);
         if(gorole)
         {
            role.stopAllKey();
            if(gorole.x > role.x)
            {
               role.move("right");
            }
            else
            {
               role.move("left");
            }
            if(gorole.y < role.y && Math.random() > 0.8)
            {
               role.jump();
            }
         }
         else
         {
            role.move("wait");
         }
         return true;
      }
      
      private static function randomSkill(role:BaseRole, dict:Dictionary) : Boolean
      {
         var key:String = null;
         var group:RoleFrameGroup = null;
         if(role.isLock && Math.random() < 0.8)
         {
            return false;
         }
         role.stopAllKey();
         for(var i in dict)
         {
            key = String(i);
            if(key != "")
            {
               group = role.roleXmlData.getFrameGroupFromKey(key);
               if(group.name != "瞬步" && Math.random() > 0.5)
               {
                  role.playSkillFormKey(group.key);
                  if(role.actionName == group.name)
                  {
                     return true;
                  }
               }
            }
         }
         role.playSkill(role.isJump() ? "空中攻击" : "普通攻击");
         return true;
      }
   }
}

