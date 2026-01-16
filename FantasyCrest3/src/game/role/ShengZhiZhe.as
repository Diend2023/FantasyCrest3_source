package game.role
{
   import flash.utils.Dictionary;
   import zygame.buff.AttributeChangeBuff;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class ShengZhiZhe extends GameRole
   {
      
      private var _buff:RoleAttributeData;
      
      private var _dic:Dictionary;
      
      public function ShengZhiZhe(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         _buff = new RoleAttributeData();
         var buff:AttributeChangeBuff = new AttributeChangeBuff("buff",this,-1,_buff);
         this.addBuff(buff);
         _dic = new Dictionary();
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(this.world.getEffectFormName("buff",this))
         {
            _buff.power = 100;
            _buff.armorDefense = 400;
            _buff.magicDefense = 400;
         }
         else
         {
            _buff.power = 0;
            _buff.armorDefense = 0;
            _buff.magicDefense = 0;
         }
         for(var i in _dic)
         {
            if(_dic[i] < 180)
            {
               _dic[i]++;
            }
            if(i.isJump() == false)
            {
               _dic[i] = 0;
            }
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         if(_dic[enemy] == null)
         {
            _dic[enemy] = 0;
         }
         if(beData.armorScale == 0 && beData.magicScale == 0)
         {
            beData.armorScale = 1;
         }
         if(actionName == "无双击" || actionName == "圣光洗礼")
         {
            beData.armorScale += _dic[enemy] / 180 * 0.1;
         }
         else if(actionName == "星落打")
         {
            beData.armorScale += _dic[enemy] / 180 * 1;
         }
         else
         {
            beData.armorScale += _dic[enemy] / 180 * 0.5;
         }
         super.onHitEnemy(beData,enemy);
      }
      
      override public function onBeHit(beData:BeHitData) : void
      {
         if(this.world.getEffectFormName("buff",this) && Math.random() > 0.7)
         {
            this.goldenTime = 1;
         }
         super.onBeHit(beData);
      }
   }
}

