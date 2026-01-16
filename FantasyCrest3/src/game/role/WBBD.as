package game.role
{
   import feathers.data.ListCollection;
   import zygame.data.RoleAttributeData;
   import zygame.data.RoleFrameGroup;
   import zygame.display.World;
   
   public class WBBD extends GameRole
   {
      
      private var _pan:cint = new cint();
      
      private var _cd:cint = new cint();
      
      public function WBBD(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"mofa.png",
            "msg":0
         }]);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(_cd.value > 0)
         {
            _cd.value--;
         }
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         var group:RoleFrameGroup = this.roleXmlData.getGroupAt(str);
         if(group && _cd.value <= 0)
         {
            if(group.key && group.key != "" && group.name != "瞬步")
            {
               _pan.value++;
               if(_pan.value > 9)
               {
                  _pan.value = 0;
                  _cd.value = 300;
               }
               this.listData.getItemAt(0).msg = _pan.value;
               this.listData.updateItemAt(0);
            }
         }
         super.runLockAction(str,canBreak);
         if(_cd.value > 0 && !isOSkill())
         {
            delete this.attribute.cdData[str];
         }
      }
   }
}

