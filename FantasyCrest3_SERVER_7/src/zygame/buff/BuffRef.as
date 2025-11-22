package zygame.buff
{
   import starling.utils.rad2deg;
   import zygame.core.GameCore;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   
   public class BuffRef
   {
      
      private var _name:String;
      
      private var _role:BaseRole;
      
      private var _time:int;
      
      private var _effectName:String;
      
      public function BuffRef(buffName:String, role:BaseRole, time:int, effectName:String = null)
      {
         super();
         _name = buffName;
         _role = role;
         _time = time;
         _effectName = effectName;
      }
      
      public function action() : void
      {
         if(_effectName)
         {
            onBuffAnimation();
         }
      }
      
      public function onBuffAnimation() : void
      {
         var w:int = _role.width;
         var h:int = _role.height;
         var effect:EffectDisplay = new EffectDisplay(_effectName,{
            "x":Math.random() * 30 - 15,
            "y":Math.random() * h * -0.5,
            "isLockAction":true,
            "unhit":true
         },_role);
         effect.rotation = rad2deg(360 * Math.random());
         effect.scale = w / effect.width;
         GameCore.currentWorld.addChild(effect);
         effect.isCanHit = false;
      }
      
      public function getAttributeBonus(pname:String) : int
      {
         return 0;
      }
      
      public function get currentTime() : int
      {
         return _time;
      }
      
      public function set currentTime(i:int) : void
      {
         _time = i;
      }
      
      public function get currentRole() : BaseRole
      {
         return _role;
      }
      
      public function set currentRole(role:BaseRole) : void
      {
         _role = role;
      }
      
      public function outTime() : Boolean
      {
         if(_time == -1)
         {
            return false;
         }
         _time--;
         return _time <= 0;
      }
      
      public function set effectActionName(str:String) : void
      {
         _effectName = str;
      }
      
      public function get effectActionName() : String
      {
         return _effectName;
      }
      
      public function set targetName(str:String) : void
      {
         _name = str;
      }
      
      public function get targetName() : String
      {
         return _name;
      }
   }
}

