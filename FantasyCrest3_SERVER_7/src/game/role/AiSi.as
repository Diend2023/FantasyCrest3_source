package game.role
{
   import game.skill.SuperBall;
   import game.skill.YanDi;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class AiSi extends GameRole
   {
      
      public function AiSi(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onFrame() : void
      {
         var di:BaseRole = null;
         if(actionName == "十字火" && frameAt(24,28))
         {
            if(this.world.getEffectFormName("shizihuo_aisi",this))
            {
               this.world.getEffectFormName("shizihuo_aisi",this).gox = this.world.getEffectFormName("shizihuo_aisi",this).gox + 25;
            }
         }
         else if(inFrame("大炎戒·炎帝",26))
         {
            if(!isKeyDown(74))
            {
               this.go(24);
            }
            else if(this.world.getEffectFormName("aisiyandi",this))
            {
               this.world.getEffectFormName("aisiyandi",this)["isGo"] = true;
            }
         }
         else if(inFrame("大炎戒·炎帝",32) && this.world.getEffectFormName("aisiyandi",this))
         {
            this.go(31);
         }
         else if(actionName == "龙爪手" && frameAt(1,5))
         {
            di = hitRole();
            if(di)
            {
               this.go(6);
               di.goldenTime = 0;
               di.runLockAction("受伤");
               di.posx = this.x + 45 * this.scaleX;
            }
         }
         super.onFrame();
      }
      
      override public function hitDataBuff(beData:BeHitData) : void
      {
         if(beData.bodyParent is YanDi && !(beData.bodyParent as SuperBall).isGo)
         {
            beData.armorScale = 0;
            beData.magicScale = 0.1;
            beData.moveY = -5;
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         (enemy as GameRole).buffColor(16763904);
      }
   }
}

