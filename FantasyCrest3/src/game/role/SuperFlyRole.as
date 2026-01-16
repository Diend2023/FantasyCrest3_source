package game.role
{
   import game.buff.AttributeChangeBuff;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class SuperFlyRole extends FlyRole
   {
      
      private var buff:RoleAttributeData;
      
      public function SuperFlyRole(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         buff = new RoleAttributeData();
         var buff2:AttributeChangeBuff = new AttributeChangeBuff("TeLanKeSi",this,-1,buff);
         this.addBuff(buff2);
      }
      
      override public function onFrame() : void
      {
         var ry:int = getRoundPx();
         if(isKeyDoubleDown(87))
         {
            this.isFly = true;
            this.yMove(-10);
         }
         super.onFrame();
         if(actionName == "行走" && this.isFly && (isKeyDown(87) || isKeyDown(83)))
         {
            buff.speed = 3;
         }
         else if(this.isFly && (!isJump() || ry < 32 && !isKeyDown(87) || ry > 230))
         {
            this.isFly = false;
            buff.speed = 0;
            if(!isKeyDown(87))
            {
               this.clearDoubleKey();
            }
         }
         if(actionName == "待机")
         {
            this.xMove(0);
         }
      }
      
      override public function set action(str:String) : void
      {
         if(this.isFly && (str == "跳跃" || str == "降落"))
         {
            str = isKeyDown(65) || isKeyDown(68) ? "行走" : "降落";
         }
         super.action = str;
      }
      
      override public function onJumpEffect() : void
      {
         super.onJumpEffect();
         this.isFly = false;
      }
   }
}

