package game.skill
{
   import fight.effect.ColorQuad;
   import flash.geom.Point;
   import zygame.display.BaseRole;
   
   public class YanDi extends SuperBall
   {
      
      public function YanDi(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
         _cxTime = 180;
      }
      
      override public function onFrame() : void
      {
         if(isGo && role.targetName == "AS")
         {
            if(role.actionName == "大炎戒·炎帝" && role.currentFrame < 27)
            {
               role.go(27);
            }
         }
         if(!this.isGo)
         {
            this.posy += 2;
         }
         if(this.currentFrame == 12)
         {
            this.go(9);
         }
         super.onFrame();
      }
      
      override public function onEffect() : void
      {
         var r:BaseRole = null;
         new ColorQuad(16777215).create();
         for(var i in world.getRoleList())
         {
            r = world.getRoleList()[i];
            if(r.troopid != role.troopid)
            {
               r.hurtNumber(r.attribute.hpmax * (0.12 * (cScale / 5)),beHitData,new Point(r.x,r.y));
            }
         }
      }
   }
}

