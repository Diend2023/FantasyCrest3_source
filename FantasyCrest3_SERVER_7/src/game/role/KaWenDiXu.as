package game.role
{
   import zygame.buff.AttributeChangeBuff;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class KaWenDiXu extends GameRole
   {
      
      private var _time:int = 0;
      
      private var buff:RoleAttributeData = new RoleAttributeData();
      
      public function KaWenDiXu(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.addBuff(new AttributeChangeBuff("kwdx",this,-1,buff));
      }
      
      public function getUpBuff(quick:Boolean = false) : void
      {
         _time = 180;
         if(!quick)
         {
            buff.speed = 4;
            buff.power = 125;
         }
      }
      
      override public function quickGetUp() : void
      {
         super.quickGetUp();
         getUpBuff(true);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(actionName == "起身")
         {
            getUpBuff();
         }
         if(_time > 0)
         {
            _time--;
            if(_time == 0)
            {
               buff.speed = 0;
               buff.power = 0;
            }
         }
      }
   }
}

