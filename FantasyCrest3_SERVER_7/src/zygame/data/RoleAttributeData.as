package zygame.data
{
   import zygame.buff.BuffRef;
   import zygame.core.DataCore;
   import zygame.display.BaseRole;
   import zygame.utils.MemoryUtils;
   
   public class RoleAttributeData
   {
      
      public var name:String;
      
      private var _ceData:EncryptCEData;
      
      private var _buff:Vector.<BuffRef>;
      
      private var _cdData:Object;
      
      private var _cdMaxData:Object;
      
      public const jumpPuase:int = 6;
      
      public var target:String;
      
      public var onUpdateLevel:Function;
      
      public var roleName:String;
      
      public function RoleAttributeData(pTarget:String = null)
      {
         super();
         _ceData = new EncryptCEData();
         target = pTarget;
         _buff = new Vector.<BuffRef>();
         _cdData = {};
         _cdMaxData = {};
         if(pTarget)
         {
            DataCore.fightData.initAttribute(this);
         }
      }
      
      public function onBuffFrame() : void
      {
         var i:int = 0;
         var len:int = int(_buff.length);
         for(i = len - 1; i >= 0; )
         {
            _buff[i].action();
            if(_buff[i].outTime())
            {
               _buff.removeAt(i);
            }
            i--;
         }
      }
      
      public function set onChange(func:Function) : void
      {
         _ceData.setCall = func;
      }
      
      public function get hp() : int
      {
         return getValue("hp");
      }
      
      public function set hp(i:int) : void
      {
         if(i < 0)
         {
            i = 0;
         }
         return _ceData.setValue("hp",i);
      }
      
      public function get exp() : int
      {
         return getValue("exp");
      }
      
      public function set exp(i:int) : void
      {
         var oldhp:int = 0;
         if(i < 0)
         {
            i = 0;
         }
         var maxexp:int = GameEXPData.getMaxExp(growth);
         if(i > maxexp)
         {
            i = maxexp;
         }
         var currentLv:int = this.lv;
         _ceData.setValue("exp",i);
         if(currentLv != this.lv)
         {
            oldhp = this.hp;
            DataCore.fightData.initAttribute(this);
            this.hp = oldhp;
            if(onUpdateLevel != null)
            {
               onUpdateLevel();
            }
         }
      }
      
      public function get lv() : int
      {
         return GameEXPData.lv(this.exp,this.growth);
      }
      
      public function get nextexp() : int
      {
         var qlv:int = lv;
         return GameEXPData.exp(qlv,growth);
      }
      
      public function get growth() : int
      {
         return getValue("growth");
      }
      
      public function set growth(i:int) : void
      {
         if(i < 0)
         {
            i = 0;
         }
         _ceData.setValue("growth",i);
      }
      
      public function get hpmax() : int
      {
         return getValue("hpmax");
      }
      
      public function set hpmax(i:int) : void
      {
         if(i < 0)
         {
            i = 0;
         }
         _ceData.setValue("hpmax",i);
      }
      
      public function get gold() : int
      {
         return getValue("gold") * this.lv * (0.8 + Math.random() * 0.2);
      }
      
      public function set gold(i:int) : void
      {
         _ceData.setValue("gold",i);
      }
      
      public function get lucky() : int
      {
         return getValue("lucky");
      }
      
      public function set lucky(i:int) : void
      {
         _ceData.setValue("lucky",i);
      }
      
      public function get resurrectionTime() : int
      {
         return getValue("resurrectionTime");
      }
      
      public function set resurrectionTime(i:int) : void
      {
         return _ceData.setValue("resurrectionTime",i);
      }
      
      public function get power() : int
      {
         return getValue("power");
      }
      
      public function set power(i:int) : void
      {
         _ceData.setValue("power",i);
      }
      
      public function get expRewards() : int
      {
         return getValue("expRewards");
      }
      
      public function set expRewards(i:int) : void
      {
         _ceData.setValue("expRewards",i);
      }
      
      public function get desire() : int
      {
         return getValue("desire");
      }
      
      public function set desire(i:int) : void
      {
         return _ceData.setValue("desire",i);
      }
      
      public function set beatBack(i:int) : void
      {
         _ceData.setValue("maxBeatBack",i);
         _ceData.setValue("beatBack",i);
      }
      
      public function get beatBack() : int
      {
         return getValue("beatBack");
      }
      
      public function weakenBeatBack(i:int = 1) : void
      {
         var value:int = beatBack - i;
         _ceData.setValue("beatBack",value);
      }
      
      public function replyBeatBack(i:int = 0) : void
      {
         var value:int = getValue("maxBeatBack") + i;
         _ceData.setValue("beatBack",value);
      }
      
      public function get gravity() : int
      {
         return getValue("gravity");
      }
      
      public function set gravity(i:int) : void
      {
         return _ceData.setValue("gravity",i);
      }
      
      public function get shooting() : int
      {
         return getValue("shooting");
      }
      
      public function set shooting(i:int) : void
      {
         return _ceData.setValue("shooting",i);
      }
      
      public function get crit() : int
      {
         return getValue("crit");
      }
      
      public function set crit(i:int) : void
      {
         return _ceData.setValue("crit",i);
      }
      
      public function get critHurt() : int
      {
         return getValue("critHurt");
      }
      
      public function set critHurt(i:int) : void
      {
         return _ceData.setValue("critHurt",i);
      }
      
      public function get dodgeRate() : int
      {
         return getValue("dodgeRate");
      }
      
      public function set dodgeRate(i:int) : void
      {
         return _ceData.setValue("dodgeRate",i);
      }
      
      public function get magic() : int
      {
         return getValue("magic");
      }
      
      public function set magic(i:int) : void
      {
         return _ceData.setValue("magic",i);
      }
      
      public function get armorDefense() : int
      {
         return getValue("armorDefense");
      }
      
      public function set armorDefense(i:int) : void
      {
         return _ceData.setValue("armorDefense",i);
      }
      
      public function get magicDefense() : int
      {
         return getValue("magicDefense");
      }
      
      public function set magicDefense(i:int) : void
      {
         return _ceData.setValue("magicDefense",i);
      }
      
      public function get speed() : int
      {
         return getValue("speed");
      }
      
      public function set speed(i:int) : void
      {
         return _ceData.setValue("speed",i);
      }
      
      public function get jump() : int
      {
         var pjump:int = getValue("jump");
         return pjump * this.gravity / 100;
      }
      
      public function set jump(i:int) : void
      {
         return _ceData.setValue("jump",i);
      }
      
      public function get fight() : int
      {
         var i:int = 0;
         i += this.power * this.shooting / 100;
         i += this.magic * this.shooting / 100;
         i += this.armorDefense;
         i += this.magicDefense;
         i += (this.hpmax + this.hpmax * this.dodgeRate / 100) / 50;
         return int(i + this.power * this.crit / 100 * this.critHurt / 100);
      }
      
      public function setValue(key:String, value:int) : void
      {
         _ceData.setValue(key,value);
      }
      
      public function getValue(key:String) : int
      {
         var i:int = 0;
         var value:int = _ceData.getValue(key);
         var len:int = int(_buff.length);
         for(i = len - 1; i >= 0; )
         {
            value += _buff[i].getAttributeBonus(key);
            i--;
         }
         return value;
      }
      
      public function pushBuff(buff:BuffRef, maxCount:int, clear:Boolean = false) : void
      {
         var l:int = 0;
         var i:int = 0;
         for(l = _buff.length - 1; l >= 0; )
         {
            if(_buff[l].targetName == buff.targetName)
            {
               if(clear)
               {
                  _buff.removeAt(l);
               }
               else
               {
                  i++;
               }
            }
            l--;
         }
         if(i >= maxCount)
         {
            return;
         }
         _buff.push(buff);
      }
      
      public function hasBuff(pClass:Class, target:String = null) : BuffRef
      {
         var l:int = 0;
         for(l = 0; l < _buff.length; )
         {
            if(_buff[l] is pClass && (target == null || target == _buff[l].targetName))
            {
               return _buff[l];
            }
            l++;
         }
         return null;
      }
      
      public function updateCD(skillName:String, cd:Number) : void
      {
         _cdData[skillName] = cd * 60;
         if(int(_cdMaxData[skillName]) < _cdData[skillName])
         {
            _cdMaxData[skillName] = _cdData[skillName];
         }
      }
      
      public function getCD(skillName:String) : int
      {
         return _cdData[skillName];
      }
      
      public function getMaxCD(skillName:String) : int
      {
         return _cdMaxData[skillName];
      }
      
      public function updateAllCD() : void
      {
         for(var i in _cdData)
         {
            if(_cdData[i] < 50000)
            {
               _cdData[i]--;
               if(_cdData[i] <= 0)
               {
                  delete _cdData[i];
               }
            }
         }
      }
      
      public function get cdData() : Object
      {
         return _cdData;
      }
      
      public function clearCD() : void
      {
         for(var i in _cdData)
         {
            delete _cdData[i];
         }
      }
      
      public function toObject() : Object
      {
         return _ceData.toObject();
      }
      
      public function get ceData() : EncryptCEData
      {
         return _ceData;
      }
      
      public function get buffs() : Vector.<BuffRef>
      {
         return _buff;
      }
      
      public function clear() : void
      {
         var i:int = 0;
         this._ceData.gc();
         MemoryUtils.clearObject(_cdMaxData);
         MemoryUtils.clearObject(_cdData);
         _cdData = null;
         _cdMaxData = null;
         for(i = this._buff.length - 1; i >= 0; )
         {
            this._buff.removeAt(i);
            i--;
         }
      }
      
      public function getBuffCount(targetName:String) : int
      {
         var ret:int = 0;
         for(var i in buffs)
         {
            if(buffs[i].targetName == targetName)
            {
               ret++;
            }
         }
         return ret;
      }
      
      public function updateRole(baseRole:BaseRole) : void
      {
         for(var i in buffs)
         {
            buffs[i].currentRole = baseRole;
         }
      }
   }
}

