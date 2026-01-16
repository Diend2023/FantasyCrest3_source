package game.skill
{
   import fight.effect.ColorQuad;
   import flash.geom.Point;
   import zygame.display.BaseRole;
   
   public class YuanQiYu extends SuperBall
   {
      
      public function YuanQiYu(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
      }
      
      override public function onFrame() : void
      {
         if(isGo && role.targetName == "wukong")
         {
            if(role.actionName == "元气弹" && role.currentFrame < 14)
            {
               role.go(14);
            }
         }
         if(this.currentFrame == 3)
         {
            this.go(0);
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

