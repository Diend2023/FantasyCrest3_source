package game.item
{
   import game.data.Game;
   import game.world._1VSB;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Quad;
   import zygame.core.DataCore;
   import zygame.display.BaseItem;
   import zygame.display.World;
   import zygame.server.Service;
   import zygame.style.GreyStyle;
   
   public class RoleSelectItem extends BaseItem
   {
      
      private var _head:Image;
      
      private var _frame:Image;
      
      private var _select:Quad;
      
      private var _lock:Image;
      
      private var _new:Image;
      
      public function RoleSelectItem()
      {
         super();
         var frame:Image = new Image(DataCore.getTextureAtlas("role_head").getTexture("frame"));
         this.addChild(frame);
         _frame = frame;
         this.width = frame.width;
         this.height = frame.height;
         _select = new Quad(this.width,this.height,16776960);
         _select.blendMode = "add";
         _select.alpha = 0;
         this.addChild(_select);
         _lock = new Image(DataCore.getTextureAtlas("select_role").getTexture("lock_state"));
         this.addChild(_lock);
         _lock.alignPivot();
         _lock.x = frame.width / 2;
         _lock.y = frame.height / 2;
         _new = new Image(DataCore.getTextureAtlas("start_main").getTexture("new"));
         this.addChild(_new);
         _new.alignPivot("center","bottom");
         _new.x = this.width / 2;
         _new.y = this.height;
      }
      
      override public function set data(value:Object) : void
      {
         var data:Object = null;
         if(value)
         {
            _new.visible = value.isNew;
            if(!_head)
            {
               _head = new Image(DataCore.getTextureAtlas("role_head").getTextures(value.head)[0]);
               this.addChildAt(_head,0);
               _head.x = 4;
               _head.y = 4;
               _head.width = 65;
               _head.height = 65;
            }
            else
            {
               _head.texture = DataCore.getTextureAtlas("role_head").getTextures(value.head)[0];
            }
            if(value.selected)
            {
               _head.style = new GreyStyle();
               _select.alpha = 1;
               Starling.juggler.tween(_select,0.25,{"alpha":(value ? 0.35 : 0)});
            }
            else
            {
               _head.style = null;
            }
            data = null;
            data = Service.userData;
            if(isLock(value,data))
            {
               _lock.visible = true;
            }
            else
            {
               _lock.visible = false;
            }
            trace(value.target);
            value.lock = _lock.visible;
         }
         super.data = value;
      }
      
      public function isLock(value:Object, data2:Object) : Boolean
      {
         if(true)
         {
            if(value.xml.@bind != undefined && Game.fbData.getWinTimes(value.xml.@bind) >= int(value.xml.@bindFight))
            {
               return false;
            }
            if(World.defalutClass != _1VSB && ((value.coin > 0 || value.crystal > 0) && (!data2 || !data2.userData || !data2.userData.buys || data2.userData.buys.indexOf(value.target) == -1)))
            {
               return true;
            }
            return false;
         }
         if(World.defalutClass == _1VSB)
         {
            return false;
         }
         if(value.xml.@bind != undefined)
         {
            return Game.fbData.getWinTimes(value.xml.@bind) < int(value.xml.@bindFight);
         }
         return false;
      }
      
      override public function set isSelected(value:Boolean) : void
      {
         super.isSelected = value;
         Starling.juggler.tween(_select,0.25,{"alpha":(value ? 0.35 : 0)});
      }
      
      override public function dispose() : void
      {
         this._head = null;
         this._frame = null;
         if(this._select)
         {
            this._select.removeFromParent(true);
         }
         this._select = null;
         this._lock = null;
         this._new = null;
         super.dispose();
      }
   }
}

