package game.role
{
   import feathers.data.ListCollection;
   import fight.effect.ColorQuad;
   import starling.core.Starling;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   import zygame.display.World;
   
   public class Axiuluo extends GameRole
   {
      
      private var _cd:cint = new cint();
      
      private var _bodong:cint = new cint();
      
      private var _bdskill:Array = ["裂波斩","邪光斩","冰刃·波动剑","爆炎·波动剑"];
      
      public function Axiuluo(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"mofa.png",
            "msg":0
         }]);
      }
      
      override public function onFrame() : void
      {
         var qu:ColorQuad = null;
         var qu2:ColorQuad = null;
         super.onFrame();
         if(actionName == "不动明王阵" || actionName == "邪光·波动阵")
         {
            this.golden = 3;
         }
         if(inFrame("波动刻印",10))
         {
            this.attribute.updateCD("鬼印珠",0);
         }
         if(inFrame("暗天波动眼",8))
         {
            qu = new ColorQuad(0,1,1,10);
            qu.alpha = 0;
            Starling.juggler.tween(qu,1,{"alpha":0.65});
            qu.blendMode = "normal";
            qu.touchable = false;
            world.parent.addChildAt(qu,1);
            qu2 = new ColorQuad(0,1,1,10);
            qu2.alpha = 0;
            Starling.juggler.tween(qu2,1,{"alpha":0.3});
            qu2.blendMode = "normal";
            qu2.create();
            qu2.touchable = false;
            _cd.value = 600;
         }
         if(_cd.value > 0)
         {
            this.attribute.dodgeRate = 70;
            _cd.value--;
         }
         else
         {
            this.attribute.dodgeRate = 1;
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         if(beData.armorScale == 0 && beData.magicScale == 0)
         {
            beData.armorScale = 1;
         }
         if(this.world.getEffectFormName("ky1",this))
         {
            beData.magicScale += 0.25;
         }
         if(this.world.getEffectFormName("ky2",this))
         {
            beData.magicScale += 0.25;
         }
         super.onHitEnemy(beData,enemy);
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         var effect:EffectDisplay = null;
         if(str == "普通攻击" && _cd.value > 0)
         {
            str = "新·普通攻击";
         }
         if(_bdskill.indexOf(str) != -1)
         {
            _bodong.value++;
            if(_bodong.value >= 5)
            {
               _bodong.value = 0;
               effect = new EffectDisplay("axl14",{
                  "x":-60,
                  "y":-202
               },this,1,1);
               effect.isLockAction = true;
               effect.name = "ky2";
               world.addChild(effect);
               this.attribute.updateCD("鬼印珠",0);
            }
            this.listData.getItemAt(0).msg = _bodong.value;
            this.listData.updateAll();
         }
         super.runLockAction(str,canBreak);
      }
   }
}

