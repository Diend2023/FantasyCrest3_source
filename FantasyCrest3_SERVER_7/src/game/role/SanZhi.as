package game.role
{
   import feathers.data.ListCollection;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class SanZhi extends GameRole
   {
      
      public function SanZhi(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.jumpTimeMax = 2;
         listData = new ListCollection([{
            "icon":"sudu.png",
            "msg":3
         }]);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         listData.getItemAt(0).msg = this.jumpTime;
         listData.updateItemAt(0);
         if(actionName == "恶魔风脚·画龙点睛 SHOT" && frameAt(0,5) && hitRole())
         {
            this.go(6);
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
      }
      
      override public function onSUpdate() : void
      {
         super.onSUpdate();
      }
      
      override public function jump(hv:int = -1, foc:Boolean = false, jumpEff:Boolean = false) : void
      {
         super.jump(hv,foc,jumpEff);
      }
      
      override public function jumpOff() : void
      {
         super.jumpOff();
      }
   }
}

