package game.skill
{
   import zygame.display.BaseRole;
   
   public class SuperBall extends UDPSkill
   {
      
      protected var speed:Number = 0.02;
      
      protected var cScale:Number = 1;
      
      protected var _fx:Number = 0;
      
      protected var maxScale:Number = 5;
      
      protected var _cxTime:int = 360;
      
      protected var _isGo:Boolean = false;
      
      public function SuperBall(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
         _fx = pScaleX;
         this.continuousTime = 99999;
      }
      
      public function set isGo(b:Boolean) : void
      {
         _isGo = b;
         _cxTime *= cScale / 5;
      }
      
      public function get isGo() : Boolean
      {
         return cScale >= maxScale || _isGo;
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(!isGo)
         {
            if(this.body)
            {
               this.body.scaleShapes((cScale + speed) / cScale,(cScale + speed) / cScale);
            }
            cScale += speed;
            this.posy -= 4;
            this.scale = cScale;
         }
         else
         {
            this.posx += 5 * (1.5 - cScale / 5) * _fx;
            this.posy += 5 * (1.5 - cScale / 5);
            _cxTime--;
         }
         if(_cxTime < 0 || role.isInjured() || role.attribute.hp <= 0)
         {
            world.mapVibrationTime = 60;
            world.vibrationSize = 32;
            this.onEffect();
            this.discarded();
         }
         if(role)
         {
            role.goldenTime = 0.1;
         }
      }
      
      override public function updateBody() : void
      {
         super.updateBody();
         this.live = 999999;
      }
      
      public function onEffect() : void
      {
      }
      
      override public function copyData() : Object
      {
         var ob:Object = super.copyData();
         ob.isGo = this.isGo;
         ob.cxTime = this._cxTime;
         return ob;
      }
      
      override public function setData(data:Object) : void
      {
         this._isGo = data.isGo;
         this._cxTime = data.cxTime;
         super.setData(data);
      }
   }
}

