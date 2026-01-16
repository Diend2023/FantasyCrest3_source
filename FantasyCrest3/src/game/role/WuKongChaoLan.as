package game.role
{
   import feathers.data.ListCollection;
   import flash.geom.Rectangle;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class WuKongChaoLan extends SuperFlyRole
   {
      
      public var cd:cint = new cint();
      
      public function WuKongChaoLan(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"fangyu.png",
            "msg":0
         }]);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(cd.value > 0)
         {
            cd.value--;
            this.listData.getItemAt(0).msg = (cd.value / 60).toFixed(1);
         }
         else
         {
            this.listData.getItemAt(0).msg = "auto";
         }
         if(actionName == "格挡起风")
         {
            if(cd.value % 3 == 0)
            {
               createShadow(16711935);
            }
         }
         this.listData.updateAll();
      }
      
      override public function onBeHit(beData:BeHitData) : void
      {
         if(currentGroup.name == "自在意功")
         {
            createShadow(16711935);
            this.posx += Math.random() * 50 - 25;
            this.posy += Math.random() * 50 - 25;
            return;
         }
         super.onBeHit(beData);
         if(cd.value <= 0 && isInjured() && !_blow && !_blow2 && findRole(new Rectangle(this.x - 150,this.y - 150,300,300)))
         {
            this.clearDebuffMove();
            this.breakAction();
            cd.value = 720;
            this.runLockAction("格挡起风",false);
         }
      }
      
      override public function copyData() : Object
      {
         var ob:Object = super.copyData();
         ob.cd = cd.value;
         return ob;
      }
      
      override public function setData(value:Object) : void
      {
         cd.value = value.cd;
         super.setData(value);
      }
   }
}

