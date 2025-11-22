package game.role
{
   import feathers.data.ListCollection;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.data.RoleFrameGroup;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class HeiMain extends GameRole
   {
      
      public static var EXMap:Object = {
         "U":5,
         "WI":2,
         "SU":3,
         "SI":4,
         "SI":1,
         "WU":7,
         "I":8,
         "O":9
      };
      
      private var _exs:Array = [];
      
      private var _isExO:Boolean = false;
      
      public function HeiMain(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"liliang.png",
            "msg":"1off"
         }]);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         var data:int = int(this.listData.getItemAt(0).msg.charAt(0));
         if(++data >= 9)
         {
            data = 1;
         }
         this.listData.getItemAt(0).msg = data + (_exs.indexOf(data) == -1 ? "off" : "on");
         this.listData.updateAll();
      }
      
      override public function playSkillFormKey(key:String) : void
      {
         var data:int = 0;
         var group2:RoleFrameGroup = null;
         var group:RoleFrameGroup = roleXmlData.getFrameGroupFromKey(key);
         if(key == "P")
         {
            if(group && cheakCanPlay(key) && mandatorySkill > 0)
            {
               data = int(this.listData.getItemAt(0).msg.charAt(0));
               if(data > 0 && data < 9 && _exs.indexOf(data) == -1)
               {
                  _exs.push(data);
                  if(_exs.length == 8)
                  {
                     _exs.push(9);
                  }
                  this.listData.getItemAt(0).msg = data + (_exs.indexOf(data) == -1 ? "off" : "on");
                  this.listData.updateAll();
               }
            }
         }
         else if(!_isExO)
         {
            group2 = roleXmlData.getFrameGroupFromKey(key + "2");
            if(group2 && cheakCanPlay(key) && _exs.indexOf(EXMap[key]) != -1)
            {
               this.attribute.updateCD(group.name,group.cd);
               key += "2";
               if(key == "O2")
               {
                  _isExO = true;
               }
            }
         }
         super.playSkillFormKey(key);
      }
      
      override public function copyData() : Object
      {
         var ob:Object = super.copyData();
         ob._exs = _exs;
         ob._isExO = _isExO;
         return ob;
      }
      
      override public function setData(value:Object) : void
      {
         this._exs = value._exs;
         this._isExO = value._isExO;
         super.setData(value);
      }
   }
}

