package game.role
{
   import feathers.data.ListCollection;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.data.RoleFrameGroup;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class Marisa extends GameRole
   {
      
      private var star:cint = new cint();
      
      public function Marisa(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
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
         if(actionName == "瞬步" && frameAt(3,10))
         {
            if(isKeyDown(74))
            {
               attribute.updateCD("瞬步",6);
               this.playSkill("*God Speed Smash*");
            }
         }
      }
      
      override public function onMove() : void
      {
         super.onMove();
         if(actionName == "恋符·【Measter Spark】" && currentFrame > 17)
         {
            if(isKeyDown(87))
            {
               yMove(-5);
            }
            else if(isKeyDown(83))
            {
               yMove(5);
            }
            else
            {
               yMove(0);
            }
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         if(actionName == "Super Theft")
         {
            (enemy as GameRole).currentMp.value--;
            if((enemy as GameRole).currentMp.value < 0)
            {
               (enemy as GameRole).currentMp.value = 0;
            }
         }
         else if(actionName == "EXp")
         {
            (enemy as GameRole).currentMp.value = 0;
         }
         else if(actionName == "彗星·【Blazing Star】" && currentFrame > 12 && !enemy.isDefense())
         {
            enemy.posx = this.posx;
            enemy.posy = this.posy;
         }
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         var key:String = null;
         var exGroup:RoleFrameGroup = null;
         var group:RoleFrameGroup = this.roleXmlData.getGroupAt(str);
         if(group)
         {
            if(group.key && group.key != "" && group.name != "瞬步")
            {
               star.value++;
               if(star.value > 3)
               {
                  star.value = 0;
                  key = group.key;
                  key = key.toLocaleLowerCase();
                  key = "EX" + key;
                  exGroup = this.roleXmlData.getGroupAt(key);
                  if(exGroup)
                  {
                     str = exGroup.name;
                  }
               }
               this.listData.getItemAt(0).msg = star.value;
               this.listData.updateItemAt(0);
            }
         }
         super.runLockAction(str,canBreak);
      }
   }
}

