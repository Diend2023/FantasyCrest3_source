package game.role
{
   import flash.geom.Point;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class LvBu extends GameRole
   {
      
      public function LvBu(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onFrame() : void
      {
         var prole:BaseRole = null;
         this.cardFrame = 0;
         super.onFrame();
         if(isLock && this.currentFrame > 3)
         {
            this.golden = 5;
         }
         if(actionName == "斩！" && frameAt(7,13))
         {
            for(var i in this.world.roles)
            {
               prole = this.world.roles[i];
               if(prole.troopid != this.troopid)
               {
                  if(prole.posx > this.posx)
                  {
                     prole.posx -= 3;
                  }
                  else
                  {
                     prole.posx += 3;
                  }
               }
            }
         }
      }
      
      override public function getPoltPos() : Point
      {
         return super.getPoltPos().add(new Point(0,100));
      }
   }
}

