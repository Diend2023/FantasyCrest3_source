package game.role
{
   import feathers.data.ListCollection;
   import flash.geom.Point;
   import game.skill.PointTrackBall;
   import game.view.GameStateView;
   import game.world.BaseGameWorld;
   import starling.display.Image;
   import zygame.core.DataCore;
   import zygame.data.RoleAttributeData;
   import zygame.data.RoleFrameGroup;
   import zygame.display.World;
   
   public class XiaoMeiYan extends GameRole
   {
      
      private var _lock:Image;
      
      public function XiaoMeiYan(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"liliang.png",
            "msg":"LV1"
         }]);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         var count:int = 1 + ((this.world as BaseGameWorld).state as GameStateView).allWinCount;
         if(count > 3)
         {
            count = 3;
         }
         this.listData.getItemAt(0).msg = "LV" + count;
         this.listData.updateItemAt(0);
         if(this.inFrame("RPG-7",4))
         {
            if(!_lock)
            {
               _lock = new Image(DataCore.getTexture("lock_skill"));
               _lock.alignPivot();
               world.addChild(_lock);
               _lock.x = this.x + 300 * this.scaleX;
               _lock.y = this.y - 100;
            }
         }
         else if(this.inFrame("RPG-7",5))
         {
            this.go(4);
         }
         if(_lock)
         {
            if(this.actionName != "RPG-7")
            {
               _lock.removeFromParent();
               _lock = null;
               return;
            }
            if(isKeyDown(65))
            {
               _lock.x -= 5;
            }
            else if(isKeyDown(68))
            {
               _lock.x += 5;
            }
            if(isKeyDown(87))
            {
               _lock.y -= 5;
            }
            else if(isKeyDown(83))
            {
               _lock.y += 5;
            }
            this.scaleX = _lock.x > this.x ? 1 : -1;
            if(isKeyDown(74) && this.currentFrame < 6)
            {
               this.go(6);
            }
            if(this.world.getEffectFormName("dan",this) as PointTrackBall)
            {
               (this.world.getEffectFormName("dan",this) as PointTrackBall).lockPoint(new Point(_lock.x,_lock.y));
               _lock.removeFromParent();
               _lock = null;
            }
         }
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         var count:int = 0;
         var key:String = null;
         var exGroup:RoleFrameGroup = null;
         var group:RoleFrameGroup = this.roleXmlData.getGroupAt(str);
         if(group)
         {
            if(group.key && group.key != "" && group.name != "瞬步")
            {
               count = 1 + ((this.world as BaseGameWorld).state as GameStateView).allWinCount;
               if(count > 3)
               {
                  count = 3;
               }
               count;
               while(count >= 2)
               {
                  key = group.key;
                  key = key.toLocaleUpperCase();
                  key += count;
                  exGroup = this.roleXmlData.getGroupAt(key);
                  if(exGroup)
                  {
                     str = exGroup.name;
                     trace("强化技能：",str);
                     break;
                  }
                  count--;
               }
            }
         }
         super.runLockAction(str,canBreak);
      }
   }
}

