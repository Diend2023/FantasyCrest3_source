package game.buff
{
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   
   public class Electrification extends AttributeChangeBuff
   {
      
      public function Electrification(buffName:String, role:BaseRole, time:int, effectName:String = null)
      {
         var att:RoleAttributeData = new RoleAttributeData();
         att.armorDefense = -role.attribute.armorDefense;
         att.magicDefense = -role.attribute.magicDefense;
         super(buffName,role,time,att,effectName);
         role.jumpMath = 0;
      }
   }
}

