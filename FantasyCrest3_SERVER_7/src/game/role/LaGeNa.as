package game.role
{
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class LaGeNa extends GameRole
   {
      
      private var _isP:Boolean = false;
      
      private var _time:cint = new cint();
      
      public function LaGeNa(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         var hurt:int = beData.getHurt(this.attribute);
         this.attribute.hp += hurt * (_isP ? 0.5 : 0.05);
         if(this.attribute.hp > this.attribute.hpmax)
         {
            this.attribute.hp = this.attribute.hpmax;
         }
         super.onHitEnemy(beData,enemy);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(inFrame("血珂因子",12))
         {
            _isP = true;
            _time.value = 10;
         }
         if(_time.value > 0)
         {
            _time.value--;
         }
         _isP = _time.value > 0;
      }
   }
}

