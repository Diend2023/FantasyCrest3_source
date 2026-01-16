package game.role
{
   import feathers.data.ListCollection;
   import fight.effect.ColorQuad;
   import flash.geom.Point;
   import game.skill.TrackBall;
   import zygame.buff.AttributeChangeBuff;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class XiaoLin extends GameRole
   {
      
      public var hujia:cint = new cint();
      
      public var hujiaTime:cint = new cint();
      
      public function XiaoLin(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"fangyu.png",
            "msg":0
         }]);
      }
      
      override public function onFrame() : void
      {
         var isFight:Boolean = false;
         var attack:RoleAttributeData = null;
         super.onFrame();
         if(inFrame("气圆斩",14))
         {
            if(world.getEffectFormName("qiyuanzhan",this))
            {
               isFight = false;
               for(var i in world.getRoleList())
               {
                  if(world.getRoleList()[i].troopid != this.troopid)
                  {
                     (world.getEffectFormName("qiyuanzhan",this) as TrackBall).trackRole(world.getRoleList()[i]);
                     isFight = true;
                     break;
                  }
               }
               if(!isFight)
               {
                  (world.getEffectFormName("qiyuanzhan",this) as TrackBall).continuousTime = 0;
               }
            }
         }
         else if(inFrame("百倍太阳拳",10))
         {
            new ColorQuad(16777215).create();
            for(i in world.getRoleList())
            {
               if(!world.getRoleList()[i].isGod() && world.getRoleList()[i].troopid != this.troopid)
               {
                  world.getRoleList()[i].breakAction();
                  world.getRoleList()[i].straight = world.getRoleList()[i].isDefense() ? 60 : 120;
                  attack = new RoleAttributeData();
                  attack.power = 100;
                  this.addBuff(new AttributeChangeBuff("liliang",this,5,attack));
               }
            }
         }
         else if(inFrame("气力盔甲",3))
         {
            this.goldenTime = 3;
            hujia.value = this.attribute.hpmax * 0.05;
            hujiaTime.value = 420;
            this.listData.getItemAt(0).msg = hujia.value;
            this.listData.updateItemAt(0);
         }
         if(hujiaTime.value > 0)
         {
            hujiaTime.value--;
            if(hujiaTime.value == 0)
            {
               hujia.value = 0;
               this.listData.getItemAt(0).msg = 0;
               this.listData.updateItemAt(0);
            }
         }
      }
      
      override public function hurtNumber(beHurt:int, beData:BeHitData, pos:Point) : void
      {
         if(hujia.value > 0)
         {
            if(hujia.value > beHurt)
            {
               hujia.value -= beHurt;
               this.listData.getItemAt(0).msg = hujia.value;
               this.listData.updateItemAt(0);
               super.hurtNumber(1,beData,pos);
            }
            else
            {
               beHurt -= hujia.value;
               hujia.value = 0;
               this.listData.getItemAt(0).msg = hujia.value;
               this.listData.updateItemAt(0);
               super.hurtNumber(beHurt,beData,pos);
            }
         }
         else
         {
            super.hurtNumber(beHurt,beData,pos);
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         if(this.hit == 12)
         {
            if(this.attribute.cdData["气力盔甲"])
            {
               delete this.attribute.cdData["气力盔甲"];
            }
         }
      }
   }
}

