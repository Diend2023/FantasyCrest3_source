package game.role
{
   import feathers.data.ListCollection;
   import game.server.AccessRun3Model;
   import game.server.HostRun2Model;
   import game.skill.BingDong;
   import game.skill.BingHua;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   import zygame.display.World;
   
   public class DongShiLang extends ArmorRole
   {
      
      public var cd:cint = new cint();
      
      private var _isps:Boolean = false;
      
      private var _ctime:int = 0;
      
      private var _isWJ:Boolean = false;
      
      private var _suihua:Array = [];
      
      public function DongShiLang(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"mofa.png",
            "msg":"auto"
         }]);
      }
      
      override public function onInit() : void
      {
         super.onInit();
      }
      
      public function wj() : void
      {
         var bh:int = 0;
         var bhsk:BingHua = null;
         _isWJ = true;
         armor = 3000;
         _isps = false;
         for(bh = 0; bh < 3; )
         {
            bhsk = new BingHua("binghua",{
               "x":-50 + -25 * (bh + 1),
               "y":-50 + -25 * (bh + 1)
            },this,0.5,0.5);
            bhsk.name = "bhsk";
            bhsk.continuousTime = 120 * (bh + 1);
            this.world.addChild(bhsk);
            _suihua.push(bhsk);
            bh++;
         }
         this.roleXmlData.parsingAction("DSL");
      }
      
      override public function onFrame() : void
      {
         var i:int = 0;
         super.onFrame();
         if(inFrame("卍解",21))
         {
            wj();
         }
         for(i = _suihua.length - 1; i >= 0; )
         {
            if(_suihua[i].parent)
            {
               if(i * 1000 >= armor)
               {
                  (_suihua[i] as EffectDisplay).continuousTime = 0;
                  _suihua.removeAt(i);
               }
               else
               {
                  (_suihua[i] as EffectDisplay).continuousTime = 60;
               }
            }
            else
            {
               _suihua.removeAt(i);
            }
            i--;
         }
         if(actionName == "冰花破碎")
         {
            _ctime = 600;
         }
         if(inFrame("解除卍解",7))
         {
            this.roleXmlData.parsingAction("dongshilang");
         }
         if(roleXmlData.targetName == "DSL")
         {
            this.attribute.armorDefense = 1;
            this.attribute.magicDefense = 1.4;
            if(!_isps && this.world.getEffectFormName("bhsk",this) == null)
            {
               this.clearDebuffMove();
               this.breakAction();
               this.runLockAction("冰花破碎");
               _isps = true;
               _ctime = 600;
            }
            if(_isps)
            {
               _ctime--;
               if(_ctime <= 0 && !isLock)
               {
                  this.clearDebuffMove();
                  this.breakAction();
                  this.runLockAction("解除卍解");
               }
            }
         }
         else
         {
            this.attribute.armorDefense = 0.5;
            this.attribute.magicDefense = 0.7;
         }
         if(cd.value > 0)
         {
            cd.value--;
            this.listData.getItemAt(0).msg = (cd.value / 60).toFixed(1);
         }
         else
         {
            this.listData.getItemAt(0).msg = "auto";
         }
         this.listData.updateAll();
      }
      
      override public function isGod() : Boolean
      {
         if(actionName == "解除卍解" || actionName == "冰花破碎")
         {
            return true;
         }
         return super.isGod();
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         if(_isps && hasAction("极·" + str))
         {
            str = "极·" + str;
         }
         super.runLockAction(str,canBreak);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         if(world.runModel is AccessRun3Model)
         {
            return;
         }
         if(cd.value <= 0 && Math.random() > 0.7)
         {
            cd.value = 600;
            bing(enemy.x,enemy.y);
         }
      }
      
      public function bing(xz:int, yz:int) : void
      {
         var bd:BingDong = new BingDong("Bing",null,this,1.5,1.5);
         bd.x = xz;
         bd.y = yz - 60;
         bd.continuousTime = roleXmlData.targetName == "DSL" ? 120 : 85;
         this.world.addChild(bd);
         if(world.runModel is HostRun2Model)
         {
            (world.runModel as HostRun2Model).doFunc(this.name,"bing",xz,yz);
         }
      }
      
      override public function copyData() : Object
      {
         var ob:Object = super.copyData();
         ob.wanjie = this.roleXmlData.targetName == "DSL";
         ob.wjcd = _isWJ;
         ob.a = armor;
         ob.ps = _isps;
         ob.roleTarget = roleXmlData.targetName;
         return ob;
      }
      
      override public function setData(value:Object) : void
      {
         super.setData(value);
         if(value.wjcd)
         {
            this.attribute.updateCD("卍解",999);
         }
         if(value.wanjie && value.a > 0 && value.roleTarget != roleXmlData.targetName)
         {
            _isps = value.ps;
            if(!_isps)
            {
               wj();
            }
            armor = value.a;
         }
         if(value.roleTarget)
         {
            roleXmlData.parsingAction(value.roleTarget);
         }
      }
   }
}

