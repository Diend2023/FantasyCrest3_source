package game.role
{
   import flash.geom.Point;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class ShaLu extends GameRole
   {
      
      public var startBuff:Boolean = false;
      
      public var getHpTime:int = 300;
      
      public function ShaLu(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(startBuff && getHpTime > 0 && this.attribute.hp > 0)
         {
            getHpTime--;
            this.attribute.hp += this.attribute.hpmax * 0.0006666666666666668;
            if(!this.isInjured())
            {
               this.goldenTime = 2;
            }
         }
      }
      
      override public function hurtNumber(beHurt:int, beData:BeHitData, pos:Point) : void
      {
         super.hurtNumber(beHurt,beData,pos);
         if(!startBuff && this.attribute.hp <= this.attribute.hpmax * 0.1)
         {
            startBuff = true;
         }
      }
   }
}

