package game.role
{
   import zygame.buff.AttributeChangeBuff;
   import zygame.core.GameCore;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class HuangFeiHong extends GameRole
   {
      
      private var _isBJ:RoleAttributeData = new RoleAttributeData();
      
      private var _backHit:Vector.<BaseRole> = new Vector.<BaseRole>();
      
      public function HuangFeiHong(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onFrame() : void
      {
         var i:int = 0;
         super.onFrame();
         for(i = _backHit.length - 1; i >= 0; )
         {
            if(_backHit[i].actionName == "起身")
            {
               trace("弹飞！");
               _backHit[i].breakAction();
               _backHit[i].blow = true;
               _backHit[i].straight = 60;
               _backHit[i].beHitY = 20;
               _backHit[i].goldenTime = 0;
               _backHit[i].onFallGroundEffect();
               _backHit.removeAt(i);
            }
            i--;
         }
         if(inFrame("狮王争霸",19))
         {
            _isBJ.crit = 25;
            this.addBuff(new AttributeChangeBuff("hfhbj",this,-1,_isBJ,"heian"));
            GameCore.soundCore.playBGSound("hfh_bgm");
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         if(beData.moveY <= -25)
         {
            if(_backHit.indexOf(enemy) == -1)
            {
               _backHit.push(enemy);
            }
         }
      }
      
      override public function copyData() : Object
      {
         var ob:Object = super.copyData();
         ob.isBJ = _isBJ.crit == 25;
         return ob;
      }
      
      override public function setData(value:Object) : void
      {
         super.setData(value);
         if(value.isBJ)
         {
            this.attribute.updateCD("狮王争霸",9999);
            _isBJ.crit = 25;
            this.addBuff(new AttributeChangeBuff("hfhbj",this,-1,_isBJ,"heian"));
            GameCore.soundCore.playBGSound("hfh_bgm");
         }
      }
   }
}

