package game.display
{
   import game.data.Game;
   import game.data.SelectGroupConfig;
   import game.item.RoleSelectItem;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.display.DisplayObjectContainer;
   
   public class SelectGroup extends DisplayObjectContainer
   {
      
      public var maxSelectNum:int = 0;
      
      public var playerid:int = 0;
      
      protected var _selectIndex:int = 0;
      
      protected var _array:Array = [];
      
      public var groupConfig:SelectGroupConfig;
      
      public function SelectGroup(p:int, config:SelectGroupConfig)
      {
         super();
         playerid = p;
         groupConfig = config;
         maxSelectNum = config.selectCount;
      }
      
      override public function onInit() : void
      {
         var i:int = 0;
         var img:Image = null;
         var textures:TextureAtlas = DataCore.getTextureAtlas("select_role");
         for(i = 0; i < maxSelectNum; )
         {
            img = new Image(textures.getTexture((playerid == 0 ? 1 : 2) + "pframe"));
            this.addChild(img);
            img.x = i * (img.width + 5);
            img.y = 7;
            i++;
         }
      }
      
      public function get array() : Array
      {
         if(_array.length == 0)
         {
            if(Game.levelData)
            {
               return Game.levelData.currentFightArray;
            }
            return [];
         }
         var arr:Array = [];
         for(var i in _array)
         {
            arr.push(_array[i].data.target);
         }
         return arr;
      }
      
      public function pushSelect(ob:Object) : Boolean
      {
         if(_selectIndex == maxSelectNum || hasObject(ob) || ob.selected || ob.lock)
         {
            return false;
         }
         var head:RoleSelectItem = new RoleSelectItem();
         head.data = ob;
         this.addChild(head);
         head.scale = 0.9;
         head.x = head.width * _selectIndex;
         head.y = 5;
         _selectIndex++;
         _array.push(head);
         head.alpha = 0;
         Starling.juggler.tween(head,0.25,{"alpha":1});
         return true;
      }
      
      public function hasObject(data:Object) : Boolean
      {
         var head:RoleSelectItem = null;
         for(var i in _array)
         {
            head = _array[i] as RoleSelectItem;
            if(head.data.target == data.target)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get isSelected() : Boolean
      {
         return _selectIndex == maxSelectNum;
      }
      
      override public function dispose() : void
      {
         groupConfig = null;
         this._array = null;
         super.dispose();
      }
   }
}

