package game.role
{
   import fight.effect.ColorQuad;
   import game.skill.ROOM;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class Luo extends GameRole
   {
      
      private var cd:cint = new cint();
      
      public function Luo(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(cd.value > 0)
         {
            cd.value--;
         }
         if(inFrame("ROOM 指挥棒",3))
         {
            roomFight(0,40);
         }
         else if(actionName == "ROOM 屠宰场" && currentFrame >= 4)
         {
            if(cd.value <= 0)
            {
               cd.value = 5;
               roomFight(0,25,60);
            }
         }
         else if(inFrame("ROOM 伽马刀",6))
         {
            roomFight(0,25,60);
         }
      }
      
      public function roomFight(mx:int, my:int, time:int = 0) : void
      {
         var effect:ROOM = this.world.getEffectFormName("room",this) as ROOM;
         if(effect)
         {
            effect.fight(mx,my);
            if(time != 0)
            {
               effect.continuousTime = time;
            }
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         var i:int = 0;
         if(cd.value <= 0)
         {
            cd.value = 10;
            roomFight(beData.moveX,beData.moveY);
            i = this.attribute.getCD("ROOM");
            if(i > 0)
            {
               this.attribute.updateCD("ROOM",i / 60 - 1);
            }
            if(actionName == "ROOM 伽马刀")
            {
               this.posx = enemy.posx;
               this.posy = enemy.posy;
               new ColorQuad(16777215,0.3,0.3).create();
            }
         }
         super.onHitEnemy(beData,enemy);
      }
   }
}

