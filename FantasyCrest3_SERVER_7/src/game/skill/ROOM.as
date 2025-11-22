package game.skill
{
   import flash.geom.Rectangle;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   
   public class ROOM extends EffectDisplay
   {
      
      public function ROOM(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
      }
      
      override public function onFrame() : void
      {
         var prole:BaseRole = null;
         for(var i in this.world.roles)
         {
            prole = this.world.roles[i];
            if(prole.troopid != this.role.troopid)
            {
               prole.speedScale = Math.abs(prole.x - (this.x + this.width / 2 * (this.scaleX > 0 ? 1 : -1))) < this.width / 2 * 0.8 && this.bounds.intersects(prole.bounds) ? 0.5 : 1;
            }
         }
         super.onFrame();
      }
      
      public function fight(mx:int = 0, my:int = 40) : void
      {
         var prole:BaseRole = null;
         for(var i in this.world.roles)
         {
            prole = this.world.roles[i];
            if(prole.troopid != this.role.troopid && (Math.abs(prole.x - (this.x + this.width / 2 * (this.scaleX > 0 ? 1 : -1))) < this.width / 2 * 0.8 && this.bounds.intersects(prole.bounds)))
            {
               beHitData.moveY = my;
               beHitData.moveX = mx;
               this.beHitData.hitEffect = "meihong7";
               beHitData.armorScale = role.actionName == "ROOM 伽马刀" ? 0.5 : 2;
               beHitData.hitRect = new Rectangle(prole.x - 15,prole.y - 60,30,30);
               prole.onBeHit(beHitData);
            }
         }
      }
      
      override public function dispose() : void
      {
         var prole:BaseRole = null;
         for(var i in this.world.roles)
         {
            prole = this.world.roles[i];
            if(prole.troopid != this.role.troopid)
            {
               prole.speedScale = 1;
            }
         }
         super.dispose();
      }
   }
}

