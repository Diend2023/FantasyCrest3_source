package game.role
{
   import feathers.data.ListCollection;
   import flash.geom.Point;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class Cike extends GameRole
   {
      
      private var _time:int = 0;
      
      private var _isBJ:Boolean = false;
      
      private var _lockRole:Vector.<BaseRole>;
      
      public function Cike(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"sudu.png",
            "msg":"0"
         }]);
         _lockRole = new Vector.<BaseRole>();
      }
      
      override public function hurtNumber(beHurt:int, beData:BeHitData, pos:Point) : void
      {
         super.hurtNumber(beHurt,beData,pos);
         _time = 0;
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         _time = 0;
         if((actionName == "绝命瞬狱杀" || actionName == "月轮舞") && enemy.isInjured())
         {
            _lockRole.push(enemy);
         }
      }
      
      override public function playSkill(target:String) : void
      {
         if(target == "绝命瞬狱杀")
         {
            _isBJ = _time / 60 >= 1.5;
         }
         super.playSkill(target);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         _time++;
         var i:Number = _time / 60;
         if(i >= 1.5)
         {
            this.display.alpha = 0.5;
            this.attribute.dodgeRate = 50;
            this.attribute.crit = 100;
            this.listData.getItemAt(0).msg = "Auto";
         }
         else
         {
            if(isLock)
            {
               _time = 0;
            }
            this.display.alpha = 1;
            this.attribute.dodgeRate = 1;
            this.attribute.crit = 0;
            this.listData.getItemAt(0).msg = (_time / 60).toFixed(1);
         }
         if(actionName == "绝命瞬狱杀" && _isBJ)
         {
            this.attribute.crit = 100;
         }
         this.listData.updateItemAt(0);
         switch(actionName)
         {
            case "月轮舞":
            case "绝命瞬狱杀":
               onLockSkill();
         }
      }
      
      override public function get hitEffectName() : String
      {
         return "chop";
      }
      
      private function onLockSkill() : void
      {
         if(inFrame(actionName,0))
         {
            _lockRole.splice(0,_lockRole.length);
         }
         else
         {
            for(var i in _lockRole)
            {
               _lockRole[i].posx = this.x;
               _lockRole[i].posy = this.y;
            }
         }
      }
   }
}

