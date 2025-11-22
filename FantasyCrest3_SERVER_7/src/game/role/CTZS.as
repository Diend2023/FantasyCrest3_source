package game.role
{
   import feathers.data.ListCollection;
   import zygame.buff.AttributeChangeBuff;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class CTZS extends GameRole
   {
      
      public var baojixing:cint = new cint(15);
      
      private var buff:AttributeChangeBuff;
      
      private var attr:RoleAttributeData;
      
      private var isSR:Boolean = false;
      
      public function CTZS(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         attr = new RoleAttributeData();
         buff = new AttributeChangeBuff("baojixing",this,-1,attr);
         listData = new ListCollection([{
            "icon":"liliang.png",
            "msg":0
         }]);
         addBuff(buff);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         if(baojixing.value > 30)
         {
            baojixing.value--;
         }
         else if(Math.random() > 0.5 && baojixing.value < 30)
         {
            baojixing.add(1);
         }
         super.onHitEnemy(beData,enemy);
      }
      
      override public function onBeHit(beData:BeHitData) : void
      {
         if(baojixing.value > 0)
         {
            baojixing.add(-1);
         }
         super.onBeHit(beData);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(inFrame("弱受爆发",4))
         {
            baojixing.value = 40;
            this.attribute.hp -= this.attribute.hp * 0.25;
            isSR = true;
         }
         attr.crit = baojixing.value;
         attr.critHurt = baojixing.value * 3;
         listData.getItemAt(0).msg = baojixing.value;
         listData.updateAll();
         if(isSR)
         {
            this.attribute.updateCD("弱受爆发",999);
         }
      }
      
      override public function copyData() : Object
      {
         var ob:Object = super.copyData();
         ob.isSR = isSR;
         return ob;
      }
      
      override public function setData(value:Object) : void
      {
         isSR = value.isSR;
         super.setData(value);
      }
   }
}

