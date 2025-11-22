package game.role
{
   import feathers.data.ListCollection;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.data.RoleFrameGroup;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class DaMo extends GameRole
   {
      
      private var _kill:cint = new cint();
      
      private var _isKill:Boolean = false;
      
      private var _fps:int = 60;
      
      public function DaMo(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"liliang.png",
            "msg":0
         }]);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(_isKill)
         {
            this.attribute.speed = 8;
         }
         else
         {
            this.attribute.speed = 4;
         }
         if(inFrame("斩业非斩人",5))
         {
            _isKill = false;
            this.roleXmlData.parsingAction("Damotwo");
         }
         else if(inFrame("杀生为护生",5))
         {
            if(this._kill.value > 0)
            {
               if(this._kill.value > 10)
               {
                  this._kill.value = 10;
               }
               this.listData.getItemAt(0).msg = _kill.value;
               this.listData.updateItemAt(0);
               _fps = 60;
               _isKill = true;
               this.roleXmlData.parsingAction("Damo");
            }
         }
         if(_isKill)
         {
            _fps--;
            if(_fps == 0)
            {
               _fps = 60;
               _kill.value--;
               if(_kill.value < 0)
               {
                  _kill.value = 0;
               }
               this.listData.getItemAt(0).msg = _kill.value;
               this.listData.updateItemAt(0);
            }
            if(_kill.value == 0 && !isLock)
            {
               _isKill = false;
               this.roleXmlData.parsingAction("Damotwo");
            }
         }
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         var group:RoleFrameGroup = this.roleXmlData.getGroupAt(str);
         if(group)
         {
            if(group.key && group.key != "" && group.name != "瞬步")
            {
               if(!_isKill)
               {
                  _kill.value++;
                  if(_kill.value > 10)
                  {
                     _kill.value = 10;
                  }
                  this.listData.getItemAt(0).msg = _kill.value;
                  this.listData.updateItemAt(0);
               }
               if(_isKill)
               {
                  this.goldenTime = 0.2;
               }
            }
         }
         super.runLockAction(str,canBreak);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
      }
   }
}

