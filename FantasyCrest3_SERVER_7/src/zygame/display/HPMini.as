package zygame.display
{
   import starling.display.Quad;
   import starling.text.TextField;
   import starling.text.TextFormat;
   
   public class HPMini extends DisplayObjectContainer
   {
      
      private var _hpLine:Quad;
      
      private var _hpLineBg:Quad;
      
      private var _role:BaseRole;
      
      private var _lvLabel:TextField;
      
      public function HPMini(role:BaseRole)
      {
         super();
         _hpLineBg = new Quad(35,6,3355443);
         this.addChild(_hpLineBg);
         _hpLine = new Quad(35,4,role.troopid == 1 ? 65535 : 16711680);
         this.addChild(_hpLine);
         _hpLine.x = 1;
         _hpLine.y = 1;
         _role = role;
         this.alignPivot();
         var q:Quad = new Quad(16,12,0);
         q.alpha = 0.6;
         this.addChild(q);
         q.x = -16;
         q.y = -6;
         _lvLabel = new TextField(16,16,"40",new TextFormat("white_num_font",10,16777215));
         _lvLabel.x = -16;
         _lvLabel.y = -9;
         this.addChild(_lvLabel);
      }
      
      override public function onFrame() : void
      {
         this.visible = _role.isInjured();
         if(!this.visible)
         {
            return;
         }
         this.scaleX = _role.scaleX < 0 ? -1 : 1;
         _lvLabel.text = _role.attribute.lv.toString();
         _hpLine.scaleX = _role.attribute.hp / _role.attribute.hpmax;
      }
   }
}

