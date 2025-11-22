package game.role
{
   import flash.geom.Point;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class AnHeiMoLong extends GameRole
   {
      
      private var _die:int = 600;
      
      public function AnHeiMoLong(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onFrame() : void
      {
         var i:int = 0;
         var r:BaseRole = null;
         super.onFrame();
         _die--;
         if(_die == 0)
         {
            _die = 600;
            for(i = 0; i < this.world.getRoleList().length; )
            {
               r = this.world.getRoleList()[i];
               if(r.troopid != this.troopid)
               {
                  r.hurtNumber(r.attribute.hpmax * 0.05,null,new Point(r.x,r.y));
               }
               i++;
            }
            this.world.getRoleList();
         }
         this.golden = 6;
      }
   }
}

