package zygame.data
{
   import zygame.core.DataCore;
   
   public class GameTroopData
   {
      
      private var _attridute:Vector.<RoleAttributeData>;
      
      public function GameTroopData(targets:Array = null)
      {
         var attr:RoleAttributeData = null;
         super();
         _attridute = new Vector.<RoleAttributeData>();
         for(var i in targets)
         {
            attr = DataCore.getRoleConfig(targets[i]);
            attr.name = targets[i];
            _attridute.push(attr);
         }
      }
      
      public function getAttrudetes() : Vector.<RoleAttributeData>
      {
         return _attridute;
      }
      
      public function getAttrudete(pname:String) : RoleAttributeData
      {
         for(var i in _attridute)
         {
            if(_attridute[i].target == pname)
            {
               return _attridute[i];
            }
         }
         return null;
      }
      
      public function joinAttrudetes(target:String) : void
      {
         var attr:RoleAttributeData = DataCore.getRoleConfig(target);
         _attridute.push(attr);
      }
      
      public function removeAttrudetes(target:String) : void
      {
         for(var i in _attridute)
         {
            if(_attridute[i].target == target)
            {
               _attridute.splice(int(i),1);
               break;
            }
         }
      }
      
      public function reset(arr:Array = null) : void
      {
         var attr:RoleAttributeData = null;
         var clone:* = undefined;
         var attr2:RoleAttributeData = null;
         if(_attridute == null)
         {
            return;
         }
         if(arr != null)
         {
            this._attridute.splice(0,this._attridute.length);
            for(var i2 in arr)
            {
               attr = DataCore.getRoleConfig(arr[i2],true);
               attr.name = arr[i2];
               this._attridute.push(attr);
            }
         }
         else
         {
            clone = this._attridute.concat();
            this._attridute.splice(0,this._attridute.length);
            for(var i in clone)
            {
               attr2 = DataCore.getRoleConfig(clone[i].name,true);
               attr2.name = clone[i].name;
               this._attridute.push(attr2);
            }
         }
      }
   }
}

