package game.role
{
   import feathers.data.ListCollection;
   import zygame.buff.AttributeChangeBuff;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class TeLanKeSi extends FlyRole
   {
      
      private var _cdTime:int = 0;
      
      private var buff:RoleAttributeData = new RoleAttributeData();
      
      public function TeLanKeSi(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.addBuff(new AttributeChangeBuff("telankesi",this,-1,buff));
         this.listData = new ListCollection([{
            "icon":"sudu.png",
            "msg":0
         }]);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(_cdTime > 0)
         {
            _cdTime--;
         }
         if(_cdTime <= 0)
         {
            buff.dodgeRate = 0;
         }
         this.listData.getItemAt(0).msg = buff.dodgeRate;
         this.listData.updateAll();
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         _cdTime = 120;
         if(buff.dodgeRate < 30)
         {
            buff.dodgeRate += 2;
         }
      }
   }
}

