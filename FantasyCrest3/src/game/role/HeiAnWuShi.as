package game.role
{
   import feathers.data.ListCollection;
   import zygame.buff.AttributeChangeBuff;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class HeiAnWuShi extends GameRole
   {
      
      public var buff:RoleAttributeData;
      
      public var times:int = 10;
      
      public var cd:int = 0;
      
      public function HeiAnWuShi(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         buff = new RoleAttributeData();
         this.listData = new ListCollection([{
            "icon":"liliang.png",
            "msg":0
         },{
            "icon":"mofa.png",
            "msg":0
         }]);
         this.addBuff(new AttributeChangeBuff("guijianshi",this,-1,buff));
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(cd > 0)
         {
            cd--;
         }
         else if(buff.power != 0)
         {
            buff.power = 0;
            buff.magic = 0;
            times = 10;
            this.listData.getItemAt(0).msg = buff.power;
            this.listData.getItemAt(1).msg = buff.power;
            this.listData.updateAll();
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         if(times > 0)
         {
            times--;
            cd = 300;
            buff.power += enemy.attribute.power * 0.05;
            buff.magic += enemy.attribute.magic * 0.05;
            this.listData.getItemAt(0).msg = buff.power;
            this.listData.getItemAt(1).msg = buff.magic;
            this.listData.updateAll();
         }
      }
   }
}

