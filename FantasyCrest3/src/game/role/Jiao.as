package game.role
{
   import game.world.BaseGameWorld;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class Jiao extends GameRole
   {
      
      public var m:cint = new cint();
      
      public function Jiao(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onFrame() : void
      {
         if(!this.isLock && !this.isInjured())
         {
            this.cardFrame = 0;
         }
         super.onFrame();
         for(var i in this.world.getRoleList())
         {
            if(BaseGameWorld.DATA["hpmax_" + this.world.getRoleList()[i].name])
            {
               this.world.getRoleList()[i].attribute.hpmax = BaseGameWorld.DATA["hpmax_" + this.world.getRoleList()[i].name];
               if(this.world.getRoleList()[i].attribute.hp > this.world.getRoleList()[i].attribute.hpmax)
               {
                  this.world.getRoleList()[i].attribute.hp = this.world.getRoleList()[i].attribute.hpmax;
               }
            }
         }
         if(inFrame("破蛹成碟",2))
         {
            m.value = currentMp.value;
            this.usePoint(currentMp.value);
         }
         if(actionName != "破蛹成碟")
         {
            m.value = 0;
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         var hpscale:Number = NaN;
         var hpnum:int = 0;
         if(actionName == "破蛹成碟")
         {
            beData.armorScale *= 1.5 * (m.value / 10);
            beData.magicScale *= 1.5 * (m.value / 10);
         }
         super.onHitEnemy(beData,enemy);
         if(actionName == "魂之归宿" && currentFrame >= 16 && currentFrame < 20)
         {
            hpscale = this.currentMp.value * 0.03;
            if(hpscale > 0)
            {
               usePoint(this.currentMp.value);
               hpnum = enemy.attribute.hpmax * hpscale;
               enemy.attribute.hp -= hpnum;
               enemy.attribute.hpmax -= hpnum;
               this.attribute.hpmax += hpnum;
               this.attribute.hp += hpnum;
               BaseGameWorld.DATA["hpmax_" + enemy.name] = enemy.attribute.hpmax;
               BaseGameWorld.DATA["hpmax_" + this.name] = this.attribute.hpmax;
            }
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

