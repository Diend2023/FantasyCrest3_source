package game.role
{
   import flash.geom.Point;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class ArmorRole extends GameRole
   {
      
      private var _armor:cint = new cint();
      
      public function ArmorRole(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      public function set armor(i:int) : void
      {
         _armor.value = i;
      }
      
      public function get armor() : int
      {
         return _armor.value;
      }
      
      override public function hurtNumber(beHurt:int, beData:BeHitData, pos:Point) : void
      {
         if(armor > 0)
         {
            if(armor > beHurt)
            {
               armor -= beHurt;
               beHurt = 1;
            }
            else
            {
               beHurt -= armor;
               armor = 0;
            }
         }
         super.hurtNumber(beHurt,beData,pos);
      }
   }
}

