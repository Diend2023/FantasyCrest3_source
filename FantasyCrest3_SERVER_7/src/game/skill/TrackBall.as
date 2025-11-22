package game.skill
{
   import zygame.display.BaseRole;
   
   public class TrackBall extends UDPSkill
   {
      
      private var _lockRole:BaseRole;
      
      private var _moveY:int = 0;
      
      private var _hited:Boolean = false;
      
      public function TrackBall(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
      }
      
      public function trackRole(prole:BaseRole) : void
      {
         _lockRole = prole;
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(_lockRole)
         {
            xMove(_hited ? 3 : 15);
            if(_lockRole.y > this.y)
            {
               _moveY++;
            }
            else
            {
               _moveY--;
            }
            if(_moveY > 15)
            {
               _moveY = 15;
            }
            else if(_moveY < -15)
            {
               _moveY = -15;
            }
            yMove(_hited ? (_moveY > 0 ? 1 : -1) : _moveY);
         }
      }
      
      override public function xMove(xz:Number) : void
      {
         super.xMove(xz * (this.scaleX > 0 ? 1 : -1));
      }
      
      override public function onHitRole(role:BaseRole) : void
      {
         _hited = true;
         if(continuousTime > 1 && _lockRole)
         {
            continuousTime = 1;
         }
         super.onHitRole(role);
      }
   }
}

