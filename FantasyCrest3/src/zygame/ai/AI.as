package zygame.ai
{
   import zygame.display.BaseRole;
   
   public class AI
   {
      
      public function AI()
      {
         super();
      }
      
      public static function troop(me:BaseRole, xz:int, yz:int) : Boolean
      {
         var r:BaseRole = null;
         var list:Vector.<BaseRole> = me.world.getRoleList();
         for(var i in list)
         {
            r = list[i];
            if(r != me && r.troopid == me.troopid && Math.abs(r.x - me.x) < xz && Math.abs(r.y - me.y) < yz)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function enemy(me:BaseRole, xz:int, yz:int, wz:int = -1, hz:int = -1, isIntersection:Boolean = false) : Boolean
      {
         var r:BaseRole = null;
         if(!me || !me.world)
         {
            return false;
         }
         if(wz != -1 && hz != -1)
         {
            xz = me.posx + xz * me.scaleX;
            yz = me.posy + yz;
         }
         var list:Vector.<BaseRole> = me.world.getRoleList();
         for(var i in list)
         {
            r = list[i];
            if(r != me && r.troopid != me.troopid)
            {
               if(wz == -1 || hz == -1)
               {
                  if(Math.abs(r.x - me.x) < xz && Math.abs(r.y - me.y) < yz)
                  {
                     return true;
                  }
               }
               else if(xz < r.x && yz < r.y && xz + wz > r.x && yz + hz > r.y)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function attack(me:BaseRole, attackName:String = "普通攻击") : Boolean
      {
         if(me.isInjured())
         {
            return false;
         }
         if(Math.random() * 100 > me.attribute.desire + int(me.getHateDict()[me.getHateRole()]))
         {
            return false;
         }
         var role:BaseRole = me.getHateRole();
         if(role)
         {
            me.scaleX = role.x > me.x ? 1 : -1;
         }
         me.playSkill(attackName);
         return true;
      }
      
      public static function hp(me:BaseRole, num:Number) : Boolean
      {
         return me.attribute.hp < me.attribute.hpmax * num;
      }
      
      public static function canFight(me:BaseRole) : Boolean
      {
         var role:BaseRole = me.getHateRole();
         if(role && me.attribute.fight >= role.attribute.fight)
         {
            return true;
         }
         return false;
      }
      
      public static function escape(me:BaseRole, px:int) : Boolean
      {
         var role:BaseRole = me.getHateRole();
         if(role && Math.abs(me.x - role.x) < px)
         {
            if(me.x < role.x)
            {
               me.move(me.x < 100 ? "right" : "left");
            }
            else
            {
               me.move(me.x > me.world.map.getWidth() - 100 ? "left" : "right");
            }
            return true;
         }
         return false;
      }
      
      public static function follow(me:BaseRole, px:int) : Boolean
      {
         var role:BaseRole = null;
         var list:Vector.<BaseRole> = me.world.getRoleList();
         for(var i in list)
         {
            if(list[i].troopid == me.troopid && list[i] != me)
            {
               role = list[i];
               break;
            }
         }
         if(role && Math.abs(me.x - role.x) > px)
         {
            if(me.x < role.x)
            {
               me.move("right");
            }
            else
            {
               me.move("left");
            }
            return true;
         }
         return false;
      }
      
      public static function hate(me:BaseRole) : Boolean
      {
         if(me.getHateRole())
         {
            return true;
         }
         return false;
      }
      
      public static function chase(me:BaseRole) : Boolean
      {
         var role:BaseRole = me.getHateRole();
         if(role)
         {
            if(Math.random() > 0.5)
            {
               if(me.x < role.x)
               {
                  me.move("right");
               }
               else
               {
                  me.move("left");
               }
            }
            else
            {
               me.move("wait");
            }
            return true;
         }
         return false;
      }
      
      public static function move(me:BaseRole) : Boolean
      {
         var unleft:Boolean = false;
         var unright:Boolean = false;
         if(me.liveRect)
         {
            if(me.x < me.liveRect.x + 50)
            {
               unleft = true;
            }
            else if(me.x > me.liveRect.x + me.liveRect.width - 50)
            {
               unright = true;
            }
         }
         if(Math.random() > 0.5)
         {
            me.move("wait");
         }
         else if(me.x > me.world.map.getWidth() - 100 || unright)
         {
            me.move("left");
         }
         else if(me.x < 100 || unleft)
         {
            me.move("right");
         }
         else if(!unright && !unleft)
         {
            me.move(Math.random() > 0.5 ? "left" : "right");
         }
         else
         {
            me.move("wait");
         }
         return true;
      }
      
      public static function troopHP(me:BaseRole, hp:Number) : Boolean
      {
         var list:Vector.<BaseRole> = me.world.getRoleList();
         for(var i in list)
         {
            if(list[i].troopid == me.troopid && list[i] != me)
            {
               if(list[i].attribute.hp / list[i].attribute.hpmax < hp)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function enemyHP(me:BaseRole, hp:Number) : Boolean
      {
         var list:Vector.<BaseRole> = me.world.getRoleList();
         for(var i in list)
         {
            if(list[i].troopid != me.troopid && list[i] != me)
            {
               if(list[i].attribute.hp / list[i].attribute.hpmax < hp)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function random(i:int) : Boolean
      {
         return Math.random() * 100 > i;
      }
   }
}

