package game.buff
{
   import zygame.buff.BuffRef;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   
   public class AttributeChangeBuff extends BuffRef
   {
      
      private var _changeData:RoleAttributeData;
      
      public function AttributeChangeBuff(buffName:String, role:BaseRole, time:int, changeData:RoleAttributeData, effectName:String = null)
      {
         _changeData = changeData;
         super(buffName,role,time,effectName);
      }
      
      override public function getAttributeBonus(pname:String) : int
      {
         try
         {
            if(_changeData[pname])
            {
               return _changeData[pname];
            }
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public function get changeData() : RoleAttributeData
      {
         return _changeData;
      }
   }
}

