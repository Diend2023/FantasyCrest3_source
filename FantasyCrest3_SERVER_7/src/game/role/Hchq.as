package game.role
{
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class Hchq extends FlyRole
   {
      
      public var _flyNumber:int = 0;
      
      public function Hchq(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onDown(key:int) : void
      {
         super.onDown(key);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(_flyNumber > 0)
         {
            _flyNumber--;
            if(_flyNumber == 0)
            {
               isFly = false;
            }
         }
         if(isFly)
         {
            attribute.speed = 8;
         }
         else
         {
            attribute.speed = 4;
         }
         var _loc1_:String = actionName;
         if("水炮弹大回转" === _loc1_)
         {
            if(currentFrame == 22)
            {
               if(isKeyDown(65))
               {
                  this.scaleX = -1;
               }
               else if(isKeyDown(68))
               {
                  this.scaleX = 1;
               }
            }
         }
         trace("t=",this.isThrough,"c=",this.isCanHit);
      }
      
      override public function onShapeChange() : void
      {
         super.onShapeChange();
         var _loc1_:String = actionName;
         if("陆空切换" === _loc1_)
         {
            if(currentFrame == 3)
            {
               _flyNumber = 600;
               this.goldenTime = 3;
               this.isFly = !this.isFly;
            }
         }
      }
   }
}

