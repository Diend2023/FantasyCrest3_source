package game.role
{
   import feathers.data.ListCollection;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class TongRen extends GameRole
   {
      
      private var _mandatoryCount:cint = new cint();
      
      private var _mandatoryCountTime:int = 120;
      
      public function TongRen(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"sudu.png",
            "msg":3
         },{
            "icon":"shengcun.png",
            "msg":"100%"
         }]);
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         if(str == "星爆气流斩" && attribute.hp <= attribute.hpmax * 0.15)
         {
            str = "日蚀";
         }
         super.runLockAction(str,canBreak);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(inFrame("二刀流",8))
         {
            this.roleXmlData.parsingAction("erdaoliu");
         }
         if(_mandatoryCount.value < 3)
         {
            _mandatoryCountTime--;
            if(_mandatoryCountTime <= 0)
            {
               _mandatoryCountTime = 120;
               _mandatoryCount.value++;
               this.listData.getItemAt(0).msg = _mandatoryCount;
            }
         }
         this.listData.getItemAt(1).msg = int(this.attribute.hp / this.attribute.hpmax * 100) + "%";
         this.listData.updateAll();
      }
      
      override public function set mandatorySkill(i:int) : void
      {
         if(i == 0 && _mandatoryCount.value > 0)
         {
            _mandatoryCount.value--;
         }
         this.listData.getItemAt(0).msg = _mandatoryCount;
         this.listData.updateAll();
         super.mandatorySkill = _mandatoryCount.value > 0 ? 1 : 0;
      }
      
      override public function isOSkill() : Boolean
      {
         if(this.actionName == "日蚀")
         {
            return true;
         }
         return super.isOSkill();
      }
      
      override public function copyData() : Object
      {
         var ob:Object = super.copyData();
         ob.roleTarget = roleXmlData.targetName;
         return ob;
      }
      
      override public function setData(value:Object) : void
      {
         if(value.roleTarget)
         {
            roleXmlData.parsingAction(value.roleTarget);
         }
         super.setData(value);
      }
   }
}

