package game.skill
{
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   
   public class HPCure extends EffectDisplay
   {
      
      public function HPCure(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
      }
      
      override public function onFrame() : void
      {
         var prole:BaseRole = null;
         super.onFrame();
         if(role)
         {
            for(var i in this.world.roles)
            {
               prole = this.world.roles[i];
               if(prole.troopid == this.role.troopid)
               {
                  if(Math.abs(prole.x - (this.x + this.width / 2 * (this.scaleX > 0 ? 1 : -1))) < this.width / 2 * 0.8 && this.bounds.intersects(prole.bounds))
                  {
                     prole.attribute.hp += prole.attribute.hpmax * 0.0002;
                     if(prole.attribute.hp > prole.attribute.hpmax)
                     {
                        prole.attribute.hp = prole.attribute.hpmax;
                     }
                  }
               }
            }
         }
      }
   }
}

