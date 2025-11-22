package game.skill
{
   import flash.geom.Point;
   import game.role.GameRole;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   
   public class BingDong extends EffectDisplay
   {
      
      private var _role:BaseRole;
      
      private var pos:Point = new Point();
      
      public function BingDong(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
      }
      
      override public function onHitRole(role:BaseRole) : void
      {
         super.onHitRole(role);
         if(!_role)
         {
            _role = role;
            pos.x = _role.posx;
            pos.y = _role.posy;
         }
      }
      
      override public function draw(bool:Boolean = false) : void
      {
         super.draw(bool);
         if(continuousTime > 0)
         {
            this.go(0);
         }
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(_role && !(_role as GameRole).immuneEffect(this))
         {
            _role.clearDebuffMove();
            _role.posx = pos.x;
            _role.posy = pos.y;
            _role.breakAction();
            _role.straight = 30;
            _role.jumpMath = 0;
            _role.runLockAction("受伤");
         }
      }
   }
}

