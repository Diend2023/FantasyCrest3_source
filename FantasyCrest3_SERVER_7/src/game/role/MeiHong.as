package game.role
{
   import zygame.data.RoleAttributeData;
   import zygame.data.RoleFrameGroup;
   import zygame.display.World;
   
   public class MeiHong extends FlyRole
   {
      
      private var isCanReset:Boolean = true;
      
      public function MeiHong(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function dieEffect() : void
      {
         if(isCanReset && this.currentMp.value > 0)
         {
            isCanReset = false;
            this.attribute.hp = this.attribute.hpmax * (0.05 * this.currentMp.value);
            this.currentMp.value = 0;
            this.attribute.updateCD("焰符*【凯风快晴飞翔踢】",9999);
            this.attribute.updateCD("焰符*【火焰大旋风】",9999);
            this.attribute.updateCD("焰符*【不死鸟之怒】",0);
            this.attribute.updateCD("[Resurrection]",9999);
            this.clearDebuffMove();
            this.goldenTime = 6;
            this.breakAction();
            this.runLockAction("[Resurrection]");
         }
         else
         {
            super.dieEffect();
         }
      }
      
      override public function isOSkill() : Boolean
      {
         if(actionName == "*这样的世道就烧个精光吧*")
         {
            return true;
         }
         return super.isOSkill();
      }
      
      override public function playSkill(target:String) : void
      {
         if(isCanReset == false)
         {
            if(target == "*不死鸟之怒*" && currentMp.value >= 3)
            {
               super.playSkill("*这样的世道就烧个精光吧*");
               this.attribute.updateCD("*不死鸟之怒*",999);
            }
            else
            {
               super.playSkill(target);
            }
         }
         else
         {
            super.playSkill(target);
         }
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         var key:String = null;
         var exGroup:RoleFrameGroup = null;
         var group:RoleFrameGroup = this.roleXmlData.getGroupAt(str);
         if(group)
         {
            if(group.key && group.key != "" && group.name != "瞬步")
            {
               if(!isCanReset)
               {
                  key = group.key;
                  key = key.toLocaleLowerCase();
                  key = "EX" + key;
                  exGroup = this.roleXmlData.getGroupAt(key);
                  if(exGroup)
                  {
                     str = exGroup.name;
                  }
               }
            }
         }
         if(str == "普通攻击" && !isCanReset)
         {
            str = "不死*自燃攻击";
         }
         super.runLockAction(str,canBreak);
      }
      
      override public function copyData() : Object
      {
         var ob:Object = super.copyData();
         ob.isCanReset = isCanReset;
         return ob;
      }
      
      override public function setData(value:Object) : void
      {
         if(isCanReset && !value.isCanReset)
         {
            this.attribute.updateCD("焰符*【凯风快晴飞翔踢】",9999);
            this.attribute.updateCD("焰符*【火焰大旋风】",9999);
            this.attribute.updateCD("焰符*【不死鸟之怒】",0);
            this.attribute.updateCD("[Resurrection]",9999);
         }
         isCanReset = value.isCanReset;
         super.setData(value);
      }
   }
}

