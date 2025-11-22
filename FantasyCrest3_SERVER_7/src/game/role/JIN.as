package game.role
{
   import feathers.data.ListCollection;
   import game.server.AccessRun3Model;
   import game.server.HostRun2Model;
   import game.skill.BingDong;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class JIN extends GameRole
   {
      
      public var cd:cint = new cint();
      
      public function JIN(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"mofa.png",
            "msg":"auto"
         }]);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(cd.value > 0)
         {
            cd.value--;
            this.listData.getItemAt(0).msg = (cd.value / 60).toFixed(1);
         }
         else
         {
            this.listData.getItemAt(0).msg = "auto";
         }
         this.listData.updateAll();
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         if(this.mandatorySkill == 0)
         {
            if(world.runModel is AccessRun3Model)
            {
               return;
            }
            if(cd.value <= 0 && Math.random() > 0.5)
            {
               cd.value = 600;
               bing(enemy.x,enemy.y);
            }
         }
      }
      
      public function bing(xz:int, yz:int) : void
      {
         var bd:BingDong = new BingDong("Bing",null,this,1.5,1.5);
         bd.x = xz;
         bd.y = yz - 60;
         bd.continuousTime = roleXmlData.targetName == "DSL" ? 120 : 85;
         this.world.addChild(bd);
         if(world.runModel is HostRun2Model)
         {
            (world.runModel as HostRun2Model).doFunc(this.name,"bing",xz,yz);
         }
      }
   }
}

