package game.role
{
   import feathers.data.ListCollection;
   import flash.geom.Rectangle;
   import game.buff.AttributeChangeBuff;
   import game.world._1VStory;
   import game.world._FBBaseWorld;
   import starling.display.Image;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   import zygame.style.ColorStyle;
   
   public class GuiJianShi extends GameRole
   {
      
      private var _arr:Array = ["暴走","血气分流","龙挑","嗜魂血气爆","血之狂暴","嗜魂封魔斩","血龙卷","怒气爆发","崩山击","嗜魂之手","狂·罗刹"];
      
      private var _open:Boolean = false;
      
      private var _math:int = 0;
      
      private var _image2:Image;
      
      private var _buff:AttributeChangeBuff;
      
      private var _recd:int = 0;
      
      public function GuiJianShi(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         listData = new ListCollection([{
            "icon":"liliang.png",
            "msg":0
         }]);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(_recd > 0)
         {
            _recd--;
         }
         else if(!(world is _1VStory || world is _FBBaseWorld))
         {
            for(var i in this.world.getRoleList())
            {
               if(this.world.getRoleList()[i].troopid != this.troopid && this.world.getRoleList()[i].actionName == "起身")
               {
                  this.attribute.hp += this.attribute.hpmax * 0.05;
                  if(this.attribute.hp > this.attribute.hpmax)
                  {
                     this.attribute.hp = this.attribute.hpmax;
                  }
                  _recd = 300;
                  break;
               }
            }
         }
         switch(this.actionName)
         {
            case "嗜魂之手":
               hand();
               break;
            case "嗜魂封魔斩":
               hand_o();
               break;
            case "暴走":
               open();
               break;
            case "血气分流":
               gethp();
         }
      }
      
      override public function onInit() : void
      {
         super.onInit();
         _image2 = new Image(this.display["texture"]);
         this.addChild(_image2);
         _image2.blendMode = "add";
         _image2.visible = false;
         _buff = new AttributeChangeBuff("KuangZhanShiZhiHun",this,-1,new RoleAttributeData());
         this.addBuff(_buff);
      }
      
      override public function onShapeChange() : void
      {
         super.onShapeChange();
         if(_image2)
         {
            _image2.texture = this.display["texture"];
            _image2.x = this.display.x;
            _image2.y = this.display.y;
            _image2.width = this.display.width;
            _image2.height = this.display.height;
         }
      }
      
      override public function get hitEffectName() : String
      {
         return "chop";
      }
      
      public function gethp() : void
      {
         if(inFrame(actionName,29))
         {
            this.attribute.hp += this.attribute.hpmax * (_math / 100);
            if(this.attribute.hp > this.attribute.hpmax)
            {
               this.attribute.hp = this.attribute.hpmax;
            }
            _math = 0;
         }
      }
      
      override public function onSUpdate() : void
      {
         super.onSUpdate();
         _buff.changeData.power = (1 - this.attribute.hp / this.attribute.hpmax) * 200;
         listData.getItemAt(0).msg = _buff.changeData.power;
         listData.updateItemAt(0);
         if(!_open || this.attribute.hp / this.attribute.hpmax < 0.1)
         {
            return;
         }
         _math--;
         if(_math <= 0)
         {
            _math = 1;
            this.attribute.hp -= this.attribute.hpmax * 0.01;
         }
      }
      
      public function open() : void
      {
         if(inFrame(actionName,6))
         {
            openapi();
         }
      }
      
      private function openapi() : void
      {
         _open = !_open;
         if(_open)
         {
            (this._image2 as Image).style = new ColorStyle(16711680,0.8);
         }
         else
         {
            (this._image2 as Image).style = null;
         }
         _image2.visible = _open;
      }
      
      public function hand() : void
      {
         var rect:Rectangle = null;
         var role:BaseRole = null;
         if(frameAt(3,5))
         {
            rect = this.body.bounds.toRect();
            if(this.scaleX > 0)
            {
               rect.width += 250;
            }
            else
            {
               rect.x -= 250;
               rect.width += 250;
            }
            if(rect.x + rect.width < world.map.getWidth() && rect.x > 0)
            {
               role = findRole(rect);
               if(role)
               {
                  role.clearDebuffMove();
                  role.straight = 30;
                  role.setX(this.x + 32 * this.scaleX);
                  role.setY(this.y - 32);
               }
            }
         }
      }
      
      public function hand_o() : void
      {
         var rect:Rectangle = null;
         var role:BaseRole = null;
         if(frameAt(7,18))
         {
            rect = this.body.bounds.toRect();
            if(this.scaleX > 0)
            {
               rect.width += 350;
            }
            else
            {
               rect.x -= 350;
               rect.width += 350;
            }
            if(rect.x + rect.width < world.map.getWidth() && rect.x > 0)
            {
               role = findRole(rect);
               if(role)
               {
                  role.clearDebuffMove();
                  role.straight = 30;
                  if(Math.abs(role.x - this.x) < 64)
                  {
                     role.beHitX = 0;
                  }
                  else
                  {
                     role.beHitX = -3 * this.scaleX;
                  }
                  role.scaleX = this.scaleX * -1;
               }
            }
         }
      }
      
      override public function runLockAction(str:String, canBreak:Boolean = false) : void
      {
         if(str == "普通攻击" && _open)
         {
            str = "血·普通攻击";
         }
         if(!this.isLock && _arr.indexOf(str) != -1 && this.attribute.hp / this.attribute.hpmax > 0.1)
         {
            this.attribute.hp -= this.attribute.hp * 0.02;
         }
         super.runLockAction(str,canBreak);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         if(actionName == "血气分流")
         {
            _math++;
            if(_math > 5)
            {
               _math = 5;
            }
         }
      }
      
      override public function copyData() : Object
      {
         var data:Object = super.copyData();
         data.open = this._open;
         return data;
      }
      
      override public function setData(value:Object) : void
      {
         super.setData(value);
         if(value.open && !this._open)
         {
            openapi();
         }
      }
   }
}

