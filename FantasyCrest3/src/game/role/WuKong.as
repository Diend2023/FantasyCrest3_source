package game.role
{
   import feathers.data.ListCollection;
   import flash.geom.Rectangle;
   import game.skill.SuperBall;
   import game.skill.YuanQiYu;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class WuKong extends SuperFlyRole
   {
      
      public function WuKong(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"liliang.png",
            "msg":0
         }]);
      }
      
      override public function onFrame() : void
      {
         var effect:YuanQiYu = null;
         var role:BaseRole = null;
         if(inFrame("元气弹",13))
         {
            if(!isKeyDown(74))
            {
               go(10);
            }
            else
            {
               effect = this.world.getEffectFormName("yuanqiyu",this) as YuanQiYu;
               if(effect)
               {
                  effect.isGo = true;
               }
            }
         }
         else if(inFrame("元气弹",30) && this.world.getEffectFormName("yuanqiyu",this) as YuanQiYu)
         {
            go(21);
         }
         else if(inFrame("瞬间移动",4))
         {
            role = this.findRole(new Rectangle(0,0,world.map.getWidth(),world.map.getHeight()));
            if(role)
            {
               this.posx = role.x - 100 * role.scaleX;
               this.posy = role.y;
               this.scaleX = role.scaleX > 0 ? 1 : -1;
            }
         }
         else if(inFrame("超级赛亚人",7))
         {
            this.roleXmlData.parsingAction("wukongS");
            this.breakAction();
            this.runLockAction("待机",true);
         }
         super.onFrame();
         var jc:int = this.hit * 2;
         if(jc > 50)
         {
            jc = 50;
         }
         this.listData.getItemAt(0).msg = jc + "%";
         this.listData.updateAll();
      }
      
      override public function hitDataBuff(beData:BeHitData) : void
      {
         var jc:int = this.hit * 2;
         if(jc > 50)
         {
            jc = 50;
         }
         if(beData.armorScale == 0 && beData.magicScale == 0)
         {
            beData.armorScale = 1;
         }
         beData.armorScale += jc / 100;
         if(beData.bodyParent is YuanQiYu && !(beData.bodyParent as SuperBall).isGo)
         {
            beData.armorScale = 0;
            beData.magicScale = 0.1;
            beData.moveY = -5;
         }
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

