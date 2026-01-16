package game.skill
{
   import zygame.display.BaseRole;
   
   public class HuZhuQiu extends UDPSkill
   {
      
      public var tox:int = 0;
      
      public var toy:int = 0;
      
      public function HuZhuQiu(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
      }
      
      override public function onInit() : void
      {
         super.onInit();
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         this.x += (tox - this.x) * 0.1;
         this.y += (toy - this.y) * 0.1;
      }
   }
}

