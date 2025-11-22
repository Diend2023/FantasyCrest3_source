package game.role
{
   import feathers.data.ListCollection;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class HuaMuLan extends GameRole
   {
      
      public var time:cint = new cint();
      
      public var maxTime:int = 0;
      
      public var unskill:Array = ["安能辨我是雄雌","关山度若飞","万里赴戎机"];
      
      public function HuaMuLan(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"liliang.png",
            "msg":0
         }]);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(inFrame("普通攻击",22))
         {
            if(time.value < 5)
            {
               time.value++;
            }
         }
         if(inFrame("安能辨我是雄雌",10) && time.value > 0)
         {
            time.value--;
            this.scaleX = this.scaleX > 0 ? -1 : 1;
            go(6);
         }
         else if((inFrame("关山度若飞",4) || inFrame("万里赴戎机",3)) && time.value > 0 && maxTime < 3)
         {
            time.value--;
            maxTime++;
            this.scaleX = this.scaleX > 0 ? -1 : 1;
            go(0);
         }
         this.listData.getItemAt(0).msg = time;
         this.listData.updateItemAt(0);
      }
      
      override public function playSkill(target:String) : void
      {
         super.playSkill(target);
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         var key:String = roleXmlData.getGroupAt(str).key;
         if(str != "瞬步" && key != null && key != "" && unskill.indexOf(str) == -1)
         {
            time.value++;
            if(time.value > 5)
            {
               time.value = 5;
            }
         }
         maxTime = 0;
         super.runLockAction(str,canBreak);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         if(this.actionName == "对镜贴花黄")
         {
            beData.isBreakDam = true;
         }
         super.onHitEnemy(beData,enemy);
      }
   }
}

