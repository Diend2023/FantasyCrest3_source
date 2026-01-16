package game.skill
{
   import flash.geom.Point;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   
   public class PointTrackBall extends UDPSkill
   {
      
      private var _point:Point;
      
      public function PointTrackBall(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
      }
      
      public function lockPoint(point:Point) : void
      {
         _point = point;
      }
      
      override public function onFrame() : void
      {
         var data:Object = null;
         var boom:BreakSkill = null;
         super.onFrame();
         this.continuousTime = 60;
         if(_point)
         {
            this.posy += (_point.y - this.posy) * 0.2;
            if(Math.abs(this.posy - _point.y) < 50 && Math.abs(this.posx - _point.x) < 50)
            {
               data = EffectDisplay.getBaseObject();
               data.hitY = 0;
               data.hitX = 5;
               data.stiff = 120;
               boom = new BreakSkill("kuaisubaozha",data,role);
               boom.x = this.x - 170;
               boom.y = this.y - 170;
               world.addChild(boom);
               this.discarded();
            }
         }
      }
   }
}

