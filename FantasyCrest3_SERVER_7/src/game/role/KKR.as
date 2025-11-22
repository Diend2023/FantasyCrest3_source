package game.role
{
   import zygame.data.RoleAttributeData;
   import zygame.data.RoleFrameGroup;
   import zygame.display.World;
   
   public class KKR extends GameRole
   {
      
      private var xuliKey:String = "";
      
      public function KKR(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function playSkillFormKey(key:String) : void
      {
         var isCanPlay:Boolean = false;
         var group:RoleFrameGroup = roleXmlData.getFrameGroupFromKey(key);
         if(group && cheakCanPlay(key) && mandatorySkill > 0 && this.attribute.getCD(group.name) == 0)
         {
            isCanPlay = true;
         }
         super.playSkillFormKey(key);
         if(isCanPlay)
         {
            if(key.indexOf("J") != -1 || key.indexOf("P") != -1)
            {
               xuliKey = key;
               this.mandatorySkill = 1;
            }
         }
         else if(isLock && xuliKey != "")
         {
            this.goldenTime = 0.5;
            playSkill(xuliKey + " " + key);
            xuliKey = "";
            if(key.indexOf("U") != -1)
            {
               this.mandatorySkill = 1;
            }
         }
      }
   }
}

