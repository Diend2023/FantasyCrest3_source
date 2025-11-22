package game.role
{
   import feathers.data.ListCollection;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class JianXin extends GameRole
   {
      
      public function JianXin(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         listData = new ListCollection([{
            "icon":"liliang.png",
            "msg":"Auto"
         }]);
      }
      
      override public function onInit() : void
      {
         super.onInit();
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         listData.getItemAt(0).msg = isMandatorySkill ? "Auto" : "Off";
         listData.updateItemAt(0);
      }
      
      private function dragonFlash() : void
      {
         if(actionName == "龙鸣闪·始" && this.frameAt(1,6) && hitRole())
         {
            this.go(7);
         }
      }
      
      override public function get hitEffectName() : String
      {
         return "chop";
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      override public function hitDataBuff(beData:BeHitData) : void
      {
         if(isMandatorySkill)
         {
            if(beData.armorScale == 0)
            {
               beData.armorScale = 1.5;
            }
            else
            {
               beData.armorScale += 0.5;
            }
            trace("大约伤害",beData.armorScale);
         }
      }
   }
}

