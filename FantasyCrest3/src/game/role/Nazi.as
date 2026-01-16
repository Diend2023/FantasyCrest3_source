package game.role
{
   import feathers.data.ListCollection;
   import starling.display.Image;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class Nazi extends GameRole
   {
      
      private var _image2:Image;
      
      private var _longcd:cint = new cint();
      
      public function Nazi(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"liliang.png",
            "msg":"125%"
         }]);
      }
      
      override public function onInit() : void
      {
         super.onInit();
         _image2 = new Image(this.display["texture"]);
         this.addChild(_image2);
         _image2.blendMode = "add";
         _image2.visible = false;
         _image2.color = 16776960;
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(inFrame("雷龙的魔力",2))
         {
            _longcd.value = 600;
         }
         if(_longcd.value > 0)
         {
            _longcd.value--;
         }
         if(_longcd.value > 0)
         {
            this.attribute.crit = 50;
         }
         else
         {
            this.attribute.crit = 25;
         }
         this.attribute.critHurt = 125 + 75 * (1 - this.attribute.hp / this.attribute.hpmax);
         this.listData.getItemAt(0).msg = this.attribute.critHurt + "%";
         this.listData.updateAll();
      }
      
      override public function playSkill(target:String) : void
      {
         if(_longcd.value > 0)
         {
            switch(target)
            {
               case "普通攻击":
                  super.playSkill("雷炎攻击");
                  return;
               case "火龙的煌炎":
                  super.playSkill("雷炎龙的煌炎");
                  if(actionName == "雷炎龙的煌炎")
                  {
                     this.attribute.updateCD(target,7);
                     this.attribute.updateCD("雷炎龙的煌炎",7);
                  }
                  return;
               case "火龙的咆哮":
                  super.playSkill("雷炎龙的咆哮");
                  if(actionName == "雷炎龙的咆哮")
                  {
                     this.attribute.updateCD(target,7);
                     this.attribute.updateCD("雷炎龙的咆哮",7);
                  }
                  return;
               case "火龙的铁拳":
                  super.playSkill("雷炎龙的铁拳");
                  if(actionName == "雷炎龙的铁拳")
                  {
                     this.attribute.updateCD(target,7);
                     this.attribute.updateCD("雷炎龙的铁拳",7);
                  }
                  return;
               case "灭龙奥义·红莲爆炎剑":
                  super.playSkill("灭龙奥义·红莲爆雷剑");
                  if(actionName == "灭龙奥义·红莲爆雷剑")
                  {
                     this.attribute.updateCD(target,30);
                     this.attribute.updateCD("灭龙奥义·红莲爆雷剑",30);
                  }
                  return;
            }
         }
         super.playSkill(target);
      }
      
      override public function onShapeChange() : void
      {
         super.onShapeChange();
         if(_image2)
         {
            _image2.visible = _longcd.value > 0;
            _image2.texture = this.display["texture"];
            _image2.x = this.display.x;
            _image2.y = this.display.y;
            _image2.width = this.display.width;
            _image2.height = this.display.height;
         }
      }
   }
}

