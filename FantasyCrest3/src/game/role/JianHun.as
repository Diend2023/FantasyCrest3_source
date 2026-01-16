package game.role
{
   import feathers.data.ListCollection;
   import game.buff.Electrification;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class JianHun extends GameRole
   {
      
      private var gdcd:cint = new cint();
      
      public function JianHun(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"fangyu.png",
            "msg":"auto"
         }]);
      }
      
      override public function onFrame() : void
      {
         this.display.visible = true;
         super.onFrame();
         if(actionName == "极神剑术(破空斩)" && frameAt(14,59))
         {
            this.display.visible = false;
         }
         if(gdcd.value > 0)
         {
            gdcd.value--;
            this.listData.getItemAt(0).msg = gdcd.value == 0 ? "auto" : (gdcd.value / 60).toFixed(1);
            this.listData.updateAll();
         }
      }
      
      override public function onMove() : void
      {
         super.onMove();
         if(actionName == "极神剑术(流星落)" && frameAt(6,79))
         {
            this.display.visible = false;
            if(inFrame(actionName,78))
            {
               this.xMove(280 * (this.scaleX > 0 ? 1 : -1));
            }
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         if(Math.random() > (actionName == "里·鬼剑术" ? 0.5 : 0.9))
         {
            if(!enemy.hasBuff(Electrification))
            {
               enemy.addBuff(new Electrification("gandian",enemy,7,"pj"));
            }
         }
      }
      
      override public function onDefenseEffect() : void
      {
         super.onDefenseEffect();
         if(gdcd.value <= 0)
         {
            this.goldenTime = 1;
            gdcd.value = 300;
         }
      }
      
      override public function isGod() : Boolean
      {
         if(!this.display.visible)
         {
            return true;
         }
         return super.isGod();
      }
      
      override public function breakAction() : void
      {
         var cdb:Number = NaN;
         if(this.getCD(this.actionName) > 0)
         {
            cdb = this.currentFrame / this.currentGroup.frames.length;
            if(cdb != 0)
            {
               this.attribute.updateCD(this.actionName,this.currentGroup.cd * cdb);
            }
         }
         super.breakAction();
      }
   }
}

