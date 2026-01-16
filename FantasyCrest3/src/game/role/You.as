package game.role
{
   import fight.effect.ColorQuad;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.Image;
   import zygame.core.DataCore;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   import zygame.display.World;
   import zygame.style.ColorStyle;
   
   public class You extends GameRole
   {
      
      private var isYD:Boolean = false;
      
      private var cd:cint = new cint();
      
      private var hpLock:cint = new cint();
      
      private var padic:Dictionary;
      
      public function You(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onBeHit(beData:BeHitData) : void
      {
         super.onBeHit(beData);
         if(cd.value > 0)
         {
            if(Math.random() > 0.7 && attribute.getCD("影乌鸦·脱离") <= 0)
            {
               clearDebuffMove();
               breakAction();
               playSkill("影乌鸦·脱离");
            }
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         if(beData.bodyParent is EffectDisplay && ((beData.bodyParent as EffectDisplay).display as Image).style is ColorStyle)
         {
            trace("天照伤害");
            enemy.hurtNumber(enemy.attribute.hp * 0.02,null,new Point(enemy.x,enemy.y - 50));
         }
         if(cd.value > 0)
         {
            padic[enemy] = int(padic[enemy]) + 1;
         }
      }
      
      override public function onFrame() : void
      {
         var img:Image;
         var qu2:ColorQuad;
         var effect:EffectDisplay;
         var effect2:EffectDisplay;
         var boom:EffectDisplay;
         super.onFrame();
         if(inFrame("月读",4))
         {
            isYD = true;
            hpLock.value = this.attribute.hp;
            padic = new Dictionary();
            img = new Image(DataCore.getTexture("you_yuedu"));
            img.alpha = 0;
            world.parent.addChildAt(img,1);
            Starling.juggler.tween(img,1,{"alpha":0.9});
            img.touchable = false;
            img.alignPivot();
            img.x = stage.stageWidth / 2;
            img.y = stage.stageHeight / 2;
            Starling.juggler.delayCall(function():void
            {
               img.removeFromParent(true);
               var c:ColorQuad = new ColorQuad(16711680);
               c.blendMode = "normal";
               c.create();
               attribute.hp = hpLock.value;
               for(var i in padic)
               {
                  i.hurtNumber(padic[i] * 500 * (0.8 + Math.random() * 0.2),null,new Point(i.x,i.y - 50));
               }
            },10);
            qu2 = new ColorQuad(16711680,1,1,10);
            qu2.alpha = 0;
            Starling.juggler.tween(qu2,1,{"alpha":0.1});
            qu2.blendMode = "normal";
            qu2.create();
            qu2.touchable = false;
            cd.value = 600;
         }
         if(cd.value > 0)
         {
            cd.value--;
            this.attribute.power = 0;
         }
         else
         {
            this.attribute.power = 300;
         }
         if(inFrame("幻术·转移",1))
         {
            effect = this.world.getEffectFormName("wuya",this);
            if(effect)
            {
               this.posx = effect.bounds.width / 2 + effect.bounds.x;
               this.posy = 0;
               if(this.posx > world.map.getWidth() - 80)
               {
                  this.posx = world.map.getWidth() - 80;
               }
               else if(this.posx < 80)
               {
                  this.posx = 80;
               }
               this.posy += this.getRoundPx();
               effect.continuousTime = 3;
            }
         }
         if(inFrame("幻术·爆炸",4))
         {
            effect2 = this.world.getEffectFormName("wuya",this);
            if(effect2)
            {
               boom = new EffectDisplay("baozha",{
                  "hitY":24,
                  "hitX":1 * (effect2.scaleX > 0 ? 1 : -1),
                  "cardFrame":12,
                  "blendMode":"changeColor",
                  "color":0,
                  "wFight":600
               },this,2,2);
               effect2.continuousTime = 3;
               world.addChild(boom);
               boom.posx = effect2.bounds.width / 2 + effect2.bounds.x - 400 + (effect2.scaleX < 0 ? -50 : 0);
               boom.posy = effect2.bounds.height / 2 + effect2.bounds.y - 350;
            }
         }
      }
      
      override public function playSkill(target:String) : void
      {
         var effect2:EffectDisplay = null;
         if(target == "幻术·转移" || target == "幻术·爆炸")
         {
            effect2 = this.world.getEffectFormName("wuya",this);
            if(!effect2)
            {
               return;
            }
         }
         super.playSkill(target);
      }
      
      override public function copyData() : Object
      {
         var ob:Object = super.copyData();
         ob.isYD = isYD;
         return ob;
      }
      
      override public function setData(value:Object) : void
      {
         super.setData(value);
         if(value.isYD)
         {
            this.attribute.updateCD("月读",999);
         }
      }
   }
}

