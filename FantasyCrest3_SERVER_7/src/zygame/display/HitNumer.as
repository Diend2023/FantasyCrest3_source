package zygame.display
{
   import starling.text.TextField;
   import starling.text.TextFormat;
   
   public class HitNumer extends DisplayObjectContainer
   {
      
      public var role:BaseRole;
      
      private var _text:TextField;
      
      private var _hit:int = 0;
      
      private var _hitUpdate:int = 0;
      
      public function HitNumer()
      {
         super();
      }
      
      override public function onInit() : void
      {
         _text = new TextField(300,640,"9999",new TextFormat("hitfont_font",40,16777215));
         _text.alignPivot();
         _text.y = 200;
         _text.x = stage.stageWidth - 150;
         _text.alpha = 0;
         _text.touchable = false;
         _text.skewX = 0.25;
         this.addChild(_text);
      }
      
      override public function onFrame() : void
      {
         var targetAlpha:Number = NaN;
         if(role)
         {
            if(_hit != role.hit && role.hit != 0)
            {
               _hit = role.hit;
               _text.scale = 1.3;
               _hitUpdate = 60;
            }
            if(_hitUpdate > 0)
            {
               _text.text = role.hit.toString() + "h";
               targetAlpha = role.hit == 0 ? 0 : 1;
               _text.alpha += (targetAlpha - _text.alpha) * 0.2;
               _text.scale += (1 - _text.scale) * 0.35;
            }
            _hitUpdate--;
            if(_hitUpdate < 0)
            {
               if(_text.alpha > 0)
               {
                  _text.alpha -= 0.1;
               }
               else
               {
                  role.hit = 0;
                  _hit = 0;
                  _text.alpha = 0;
               }
            }
         }
      }
   }
}

