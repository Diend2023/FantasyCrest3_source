package zygame.display
{
   import flash.geom.Rectangle;
   import starling.filters.ColorMatrixFilter;
   import zygame.data.BeHitData;
   
   public class DamageActor extends EventActor
   {
      
      public var hp:int = 30;
      
      private var _dieColor:ColorMatrixFilter;
      
      public function DamageActor(target:String, fps:int = 24)
      {
         super(target,fps);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(hp <= 0)
         {
            if(!_dieColor)
            {
               _dieColor = new ColorMatrixFilter();
               _dieColor.adjustBrightness(1);
               this.filter = _dieColor;
            }
            if(this.alpha > 0)
            {
               this.alpha -= 0.1;
            }
            else
            {
               this._dieColor.dispose();
               this.parent.removeChild(this);
               this.world.map.removeActor(this);
               discardedBody();
            }
         }
      }
      
      public function onBeHit(beData:BeHitData) : void
      {
         var pbounds:Rectangle = beData.hitRect;
         beData.role.hit++;
         var skillEffect:EffectDisplay = new EffectDisplay(beData.hitEffectName,null,beData.role);
         skillEffect.x = pbounds.x + pbounds.width * Math.random();
         skillEffect.y = pbounds.y + pbounds.height * Math.random();
         skillEffect.rotation = Math.random() * 3.14;
         world.addChild(skillEffect);
         hp--;
      }
      
      override public function discardedBody() : void
      {
         super.discardedBody();
         this.body.space.bodies.remove(this.body);
      }
   }
}

