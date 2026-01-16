package zygame.display
{
   import dragonBones.starling.StarlingArmatureDisplay;
   import zygame.core.DataCore;
   
   public class DragonActor extends Actor
   {
      
      private var _display:StarlingArmatureDisplay;
      
      public function DragonActor(target:String, fps:int = 24)
      {
         super(null,fps);
         targetName = target;
         _display = DataCore.createDragonMovcilp(target,false);
         this.addChild(_display);
         _display.animation.play("待机");
      }
      
      override public function onInit() : void
      {
      }
      
      override public function draw(bool:Boolean = false) : void
      {
         if(_display.armature)
         {
            _display.armature.advanceTime(0.016666666666666666);
         }
      }
      
      override public function stop() : void
      {
         _display.animation.stop();
      }
      
      override public function play() : void
      {
         _display.animation.play();
      }
      
      public function playAction(pname:String) : void
      {
         if(_display.animation.lastAnimationName != pname)
         {
            _display.animation.play(pname);
         }
      }
   }
}

