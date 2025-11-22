package game.role
{
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   import zygame.event.GameMapHitType;
   
   public class FlyRole extends GameRole
   {
      
      private var _mx:Number = 0;
      
      private var _my:Number = 0;
      
      public var isFly:Boolean = false;
      
      public function FlyRole(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onMove() : void
      {
         if(!isFly || isLock && actionName != "空中攻击")
         {
            super.onMove();
            return;
         }
         if(this.isInjured())
         {
            super.onMove();
            return;
         }
         this.xMove(0);
         this.yMove(0);
         var pmx:Number = 0;
         var pmy:Number = 0;
         if(isKeyDown(87))
         {
            trace(getRoundPx(),~8,-5,2,-7);
            if(!this.isJump() || this.isJump() && getRoundPx() < 200)
            {
               if(mapHitType == GameMapHitType.HIT)
               {
                  pmy = -attribute.speed;
                  _my = pmy;
               }
               else
               {
                  pmy = -attribute.speed;
               }
            }
         }
         else if(this.isKeyDown(83))
         {
            pmy = attribute.speed;
         }
         if(isKeyDown(65))
         {
            pmx = -attribute.speed;
            this.scaleX = -1;
         }
         else if(this.isKeyDown(68))
         {
            pmx = attribute.speed;
            this.scaleX = 1;
         }
         if(!isLock)
         {
            _mx += (pmx - _mx) * 0.2;
            _my += (pmy - _my) * 0.2;
            xMove(_mx);
            yMove(_my);
         }
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(isFly)
         {
            this.canJumpHit = isFly;
         }
      }
      
      override public function set action(str:String) : void
      {
         if(isFly)
         {
            if(str == "跳跃" || str == "降落")
            {
               if(isKeyDown(65) || isKeyDown(68))
               {
                  super.action = "行走";
               }
               else
               {
                  super.action = "待机";
               }
               return;
            }
         }
         super.action = str;
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         super.runLockAction(str,canBreak);
         if(str == "空中攻击")
         {
            attribute.updateCD(str,1);
         }
      }
   }
}

