package zygame.data
{
   import flash.geom.Rectangle;
   import zygame.display.BaseRole;
   import zygame.display.DisplayObjectContainer;
   import zygame.display.EffectDisplay;
   
   public class BeHitData
   {
      
      public var lastIsHit:Boolean = true;
      
      public var straight:int;
      
      public var moveX:int;
      
      public var moveY:int;
      
      public var armorScale:Number = 1;
      
      public var magicScale:Number = 0;
      
      public var lockHurt:int = 0;
      
      public var isBreakDam:Boolean;
      
      public var bodyParent:DisplayObjectContainer;
      
      public var blow:Boolean;
      
      public var hitRect:Rectangle;
      
      public var isCrit:Boolean = false;
      
      public var hitEffect:String = null;
      
      public var hitVibrationSize:int = 0;
      
      private var _cardFrame:int = 0;
      
      public function BeHitData(pParent:DisplayObjectContainer, mx:int = 0, my:int = 0, s:int = 60)
      {
         super();
         bodyParent = pParent;
         moveX = mx;
         moveY = my;
         straight = s;
      }
      
      public function getHurt(attribute:RoleAttributeData) : int
      {
         var wvalue:int = 0;
         var mvalue:int = 0;
         if(lockHurt != 0)
         {
            return lockHurt;
         }
         var hurt:int = 1;
         var hurtScale:Number = 0.8 + Math.random() * 0.2;
         if(armorScale == 0 && magicScale == 0)
         {
            armorScale = 1;
         }
         if(armorScale > 0)
         {
            wvalue = role.attribute.power * hurtScale * armorScale;
            if(attribute.armorDefense != 0)
            {
               wvalue *= 1 - attribute.armorDefense / 500 * 0.5;
            }
            hurt += wvalue;
         }
         if(magicScale > 0)
         {
            mvalue = role.attribute.magic * hurtScale * magicScale;
            if(attribute.magicDefense != 0)
            {
               mvalue *= 1 - attribute.magicDefense / 500 * 0.5;
            }
            hurt += mvalue;
         }
         if(hurt <= 0)
         {
            hurt = 1;
         }
         var num:Number = 1 - role.attribute.crit / 100;
         isCrit = Math.random() > num;
         if(isCrit)
         {
            hurt *= role.attribute.critHurt / 100;
         }
         return hurt;
      }
      
      public function isHit(attribute:RoleAttributeData) : Boolean
      {
         var selfHit:int = role.attribute.shooting - attribute.dodgeRate;
         if(selfHit < 3)
         {
            selfHit = 3;
         }
         lastIsHit = Math.random() * 100 < selfHit;
         return lastIsHit;
      }
      
      public function get hitEffectName() : String
      {
         if(hitEffect)
         {
            return hitEffect;
         }
         return role.hitEffectName;
      }
      
      public function get isNoRole() : Boolean
      {
         return !(bodyParent is BaseRole || bodyParent is EffectDisplay);
      }
      
      public function get role() : BaseRole
      {
         if(bodyParent is BaseRole)
         {
            return bodyParent as BaseRole;
         }
         if(bodyParent is EffectDisplay)
         {
            return (bodyParent as EffectDisplay).role;
         }
         return null;
      }
      
      public function set cardFrame(i:int) : void
      {
         _cardFrame = i;
      }
      
      public function get cardFrame() : int
      {
         return _cardFrame;
      }
      
      public function discarded() : void
      {
         bodyParent = null;
      }
   }
}

