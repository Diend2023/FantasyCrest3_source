package game.role
{
   import feathers.data.ListCollection;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class YaSiNa extends GameRole
   {
      
      private var _skill:Array;
      
      private var _skillTime:int = 0;
      
      public function YaSiNa(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.contentScale = 0.8;
         this.listData = new ListCollection([{
            "icon":"liliang.png",
            "msg":"0%"
         }]);
         _skill = [];
      }
      
      override public function hitDataBuff(beData:BeHitData) : void
      {
         if(_skill.indexOf(actionName) == -1)
         {
            _skill.push(actionName);
         }
         _skillTime = 180;
         if(beData.armorScale == 0)
         {
            beData.armorScale = 1;
         }
         beData.armorScale += buffFight;
         super.hitDataBuff(beData);
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         super.runLockAction(str,canBreak);
      }
      
      public function get buffFight() : Number
      {
         if(_skill.length <= 1)
         {
            return 0;
         }
         return (_skill.length - 1) / 10 * 0.5;
      }
      
      override public function get hitEffectName() : String
      {
         return "chop";
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(inFrame("圣母圣咏",26) || inFrame("圣母圣咏",9) || inFrame("圣母圣咏",45))
         {
            this.scaleX = this.scaleX > 0 ? -1 : 1;
         }
         if(_skillTime > 0)
         {
            _skillTime--;
            this.listData.getItemAt(0).msg = int(buffFight * 100) + "%";
         }
         else
         {
            _skill.splice(0,_skill.length);
            this.listData.getItemAt(0).msg = "0%";
         }
         this.listData.updateAll();
      }
   }
}

