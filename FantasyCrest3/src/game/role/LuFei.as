package game.role
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class LuFei extends GameRole
   {
      
      public var attr:RoleAttributeData;
      
      private var _cd:int = 0;
      
      public function LuFei(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onInit() : void
      {
         super.onInit();
      }
      
      override public function onBeHit(beData:BeHitData) : void
      {
         _cd = 600;
         super.onBeHit(beData);
      }
      
      override public function hurtNumber(beHurt:int, beData:BeHitData, pos:Point) : void
      {
         var backHurt:int = 0;
         if(isDefense())
         {
            backHurt = beHurt * ((beData.role as GameRole).isOSkill() ? 0.5 : 0.3);
            if(backHurt > 10000)
            {
               backHurt = 10000;
            }
            beData.role.hurtNumber(backHurt,null,new Point(beData.role.x,beData.role.y));
         }
         super.hurtNumber(beHurt,beData,pos);
      }
      
      override public function onFrame() : void
      {
         var diren:BaseRole = null;
         super.onFrame();
         if(frameAt(2,4) && this.currentGroup.key == "WJ")
         {
            go(5);
         }
         else if(inFrame("大猿王枪",11))
         {
            diren = this.findRole(new Rectangle(this.x - 500,this.y - 300,1000,600));
            if(diren)
            {
               this.posx = diren.posx;
               this.posy = diren.posy - 300;
            }
            else
            {
               this.posy -= 300;
            }
         }
      }
   }
}

