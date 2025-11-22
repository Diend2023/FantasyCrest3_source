package game.display
{
   import starling.display.Image;
   import starling.display.Quad;
   import starling.textures.Texture;
   import zygame.core.DataCore;
   import zygame.display.BaseRole;
   import zygame.display.DisplayObjectContainer;
   
   public class FBHpState extends DisplayObjectContainer
   {
      
      private var _img:Image;
      
      private var _hpscale:Quad = new Quad(200,16,16711680);
      
      private var _role:BaseRole;
      
      private var _showtime:int = 0;
      
      public function FBHpState()
      {
         super();
      }
      
      override public function onInit() : void
      {
         _img = new Image(null);
         this.addChild(_img);
         _img.width = 32;
         _img.height = 32;
         var hpbg2:Quad = new Quad(202,18,16777215);
         this.addChild(hpbg2);
         hpbg2.x = 31;
         hpbg2.y = -1;
         var hpbg:Quad = new Quad(200,16,0);
         this.addChild(hpbg);
         hpbg.x = 32;
         this.addChild(_hpscale);
         _hpscale.x = 32;
      }
      
      public function set role(r:BaseRole) : void
      {
         _role = r;
         var v:Vector.<Texture> = DataCore.getTextureAtlas("role_head").getTextures(r.targetName);
         var t:Texture = v.length == 0 ? DataCore.getTextureAtlas("role_head").getTexture("none") : v[0];
         _img.texture = t;
         _showtime = 180;
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         if(_role && _role.parent && _showtime > 0)
         {
            this.visible = true;
            _showtime--;
            _hpscale.scaleX = _role.attribute.hp / _role.attribute.hpmax;
         }
         else
         {
            this.visible = false;
         }
      }
   }
}

