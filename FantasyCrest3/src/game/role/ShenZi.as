package game.role
{
   import feathers.data.ListCollection;
   import game.world.BaseGameWorld;
   import zygame.buff.AttributeChangeBuff;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class ShenZi extends GameRole
   {
      
      private var buff:RoleAttributeData;
      
      public function ShenZi(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"mofa.png",
            "msg":0
         }]);
         buff = new RoleAttributeData();
         this.addBuff(new AttributeChangeBuff("shenzi",this,-1,buff));
      }
      
      public function get timeHurt() : int
      {
         return hurt / ((world as BaseGameWorld).frameCount / 60);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         var hurt:int = timeHurt;
         if(hurt > 400)
         {
            hurt = 400;
         }
         if(hurt > 200)
         {
            buff.magic = (hurt - 200) * 1;
         }
         else
         {
            buff.magic = 0;
         }
         this.listData.getItemAt(0).msg = buff.magic;
         this.listData.updateAll();
      }
   }
}

