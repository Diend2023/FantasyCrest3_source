package game.role
{
   import game.buff.AttributeChangeBuff;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class SuoLong extends GameRole
   {
      
      private var _buff:AttributeChangeBuff;
      
      public function SuoLong(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onInit() : void
      {
         super.onInit();
         _buff = new AttributeChangeBuff("SuoLongBuff",this,-1,new RoleAttributeData());
         this.addBuff(_buff);
         _buff.changeData.dodgeRate = 3;
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
      }
      
      override public function get hitEffectName() : String
      {
         return "chop";
      }
      
      override public function onMiss(beData:BeHitData) : void
      {
         super.onMiss(beData);
         this.goldenTime = 0.5;
      }
   }
}

