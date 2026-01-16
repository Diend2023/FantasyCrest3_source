package game.role
{
   import feathers.data.ListCollection;
   import game.buff.AttributeChangeBuff;
   import game.world.BaseGameWorld;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class BuLuoLi extends SuperFlyRole
   {
      
      private var _buff:AttributeChangeBuff;
      
      public function BuLuoLi(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         listData = new ListCollection([{
            "icon":"liliang.png",
            "msg":0
         }]);
      }
      
      override public function onInit() : void
      {
         super.onInit();
         _buff = new AttributeChangeBuff("BuLuoLi",this,-1,new RoleAttributeData());
         this.addBuff(_buff);
      }
      
      override public function onSUpdate() : void
      {
         super.onSUpdate();
         var count:int = (world as BaseGameWorld).frameCount / 60;
         if(count > 100)
         {
            count = 100;
         }
         _buff.changeData.power = (1 - this.attribute.hp / this.attribute.hpmax) * 200 + count * 2;
         listData.getItemAt(0).msg = _buff.changeData.power;
         listData.updateItemAt(0);
      }
   }
}

