package game.role
{
   import feathers.data.ListCollection;
   import fight.effect.ColorQuad;
   import flash.geom.Point;
   import zygame.buff.Treatment;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class Mixieer extends GameRole
   {
      
      private var _cd:cint = new cint();
      
      private var _hp:cint = new cint();
      
      private var _fuhuo:Boolean = false;
      
      public function Mixieer(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"fangyu.png",
            "msg":0
         }]);
      }
      
      override public function onFrame() : void
      {
         var prole:BaseRole = null;
         super.onFrame();
         if(actionName == "极速飓风拳" && frameAt(5,55))
         {
            this.golden = 3;
            for(var i in this.world.roles)
            {
               prole = this.world.roles[i];
               if(prole.troopid != this.troopid)
               {
                  if(prole.posx > this.posx)
                  {
                     prole.posx -= 3;
                  }
                  else
                  {
                     prole.posx += 3;
                  }
               }
            }
         }
         if(inFrame("快速愈合",3))
         {
            this.addBuff(new Treatment(this,5,0.02 * ((this.attribute.hpmax - this.attribute.hp) / this.attribute.hpmax)));
         }
         if(inFrame("大天使·复活",5) || inFrame("大天使·复活",25))
         {
            if(currentFrame == 25)
            {
               if(!_fuhuo)
               {
                  _fuhuo = true;
                  this.restoreHP(0.15);
               }
            }
            new ColorQuad(16777215,1,1).create();
         }
         if(_fuhuo)
         {
            this.attribute.updateCD("大天使·复活",999);
         }
         if(inFrame("大天使·复活",25))
         {
            trace(_fuhuo,inFrame("大天使·复活",25));
         }
         if(this.actionName == "大天使·复活")
         {
            this.golden = 5;
         }
         if(_cd.value > 0)
         {
            _cd.value--;
            this.listData.getItemAt(0).msg = _hp.value;
         }
         else
         {
            this.listData.getItemAt(0).msg = 0;
         }
         this.listData.updateAll();
      }
      
      override public function isGod() : Boolean
      {
         if(this._fuhuo && this.actionName == "大天使·复活")
         {
            return true;
         }
         return super.isGod();
      }
      
      override public function dieEffect() : void
      {
         if(this.actionName == "大天使·复活")
         {
            _fuhuo = true;
            this.restoreHP(0.3);
            this.goldenTime = 10;
         }
         else
         {
            super.dieEffect();
         }
      }
      
      override public function onBeHit(beData:BeHitData) : void
      {
         if(this.world.getEffectFormName("hudun",this) != null)
         {
            if(beData.armorScale == 0 && beData.magicScale == 0)
            {
               beData.armorScale = 0.1;
            }
            else
            {
               beData.armorScale = 0;
            }
         }
         if(this.beHitCount > 0 && this.beHitCount % 5 == 0)
         {
            this._cd.value = 240;
            this._hp.value = 200;
         }
         super.onBeHit(beData);
      }
      
      override public function hurtNumber(beHurt:int, beData:BeHitData, pos:Point) : void
      {
         if(_cd.value > 0 && _hp.value > 0)
         {
            if(_hp.value > beHurt)
            {
               _hp.value -= beHurt;
               beHurt = 1;
            }
            else
            {
               beHurt -= _hp.value;
               _hp.value = 0;
            }
         }
         super.hurtNumber(beHurt,beData,pos);
      }
      
      override public function copyData() : Object
      {
         var ob:Object = super.copyData();
         ob.fuhuo = _fuhuo;
         return ob;
      }
      
      override public function setData(value:Object) : void
      {
         _fuhuo = value.fuhuo;
         super.setData(value);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         if(this.actionName == "恶魔之手")
         {
            (enemy as GameRole).jumpTime = 0;
         }
      }
   }
}

