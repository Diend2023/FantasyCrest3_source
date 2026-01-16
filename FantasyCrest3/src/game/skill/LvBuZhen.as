package game.skill
{
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   
   public class LvBuZhen extends EffectDisplay
   {
      
      public function LvBuZhen(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
      }
      
      override public function onFrame() : void
      {
         var prole:BaseRole = null;
         super.onFrame();
         if(role)
         {
            role.golden = 3;
            for(var i in this.world.roles)
            {
               prole = this.world.roles[i];
               if(prole.troopid != this.role.troopid)
               {
                  prole.speedScale = Math.abs(prole.x - (this.x + this.width / 2 * (this.scaleX > 0 ? 1 : -1))) < this.width / 2 * 0.8 && this.bounds.intersects(prole.bounds) ? 0.25 : 1;
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         var prole:BaseRole = null;
         for(var i in this.world.roles)
         {
            prole = this.world.roles[i];
            if(!this.role || prole.troopid != this.role.troopid)
            {
               prole.speedScale = 1;
            }
         }
         super.dispose();
      }
   }
}

