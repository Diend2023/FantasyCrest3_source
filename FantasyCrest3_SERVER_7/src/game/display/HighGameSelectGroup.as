package game.display
{
   import game.data.SelectGroupConfig;
   import game.item.RoleSelectItem;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   
   public class HighGameSelectGroup extends SelectGroup
   {
      
      public var eCount:int = 2;
      
      private var bans:Array;
      
      private var banData:Array = [];
      
      public function HighGameSelectGroup(p:int, config:SelectGroupConfig)
      {
         eCount = config.banCount;
         super(p,config);
      }
      
      override public function onInit() : void
      {
         var i:int = 0;
         var img:Image = null;
         var i2:int = 0;
         var img2:Image = null;
         bans = [];
         var id:int = playerid == 0 ? 1 : 2;
         var textures:TextureAtlas = DataCore.getTextureAtlas("select_role");
         var select:Image = new Image(textures.getTexture(id + "phigh"));
         select.scale = 0.5;
         select.x = -5;
         select.scaleX = id == 1 ? 1 : -1;
         select.scaleX *= 0.5;
         if(id == 2)
         {
            select.alignPivot("right","top");
         }
         this.addChild(select);
         for(i = 0; i < this.groupConfig.banCount; )
         {
            img = new Image(textures.getTexture(id + "pframe"));
            this.addChild(img);
            img.scale = 0.5;
            img.x = 43 + i * (img.width + 5);
            img.y = 3;
            bans.push(img);
            i++;
         }
         for(i2 = 0; i2 < maxSelectNum; )
         {
            img2 = new Image(textures.getTexture(id + "pframe"));
            this.addChild(img2);
            img2.scale = 0.5;
            img2.x = 43 + i2 * (img2.width + 5);
            img2.y = 45;
            i2++;
         }
      }
      
      override public function hasObject(data:Object) : Boolean
      {
         for(var i in banData)
         {
            if(banData[i].target == data.target)
            {
               return true;
            }
         }
         return super.hasObject(data);
      }
      
      override public function pushSelect(ob:Object) : Boolean
      {
         if(_selectIndex == maxSelectNum || hasObject(ob) || ob.selected || eCount <= 0 && ob.lock)
         {
            return false;
         }
         var head:RoleSelectItem = new RoleSelectItem();
         head.data = ob;
         this.addChild(head);
         head.scale = 0.45;
         head.x = 43 + head.width * _selectIndex;
         head.y = 3;
         head.alpha = 0;
         Starling.juggler.tween(head,0.25,{"alpha":1});
         if(eCount > 0)
         {
            eCount--;
            head.x = bans[0].x;
            head.y = bans[0].y;
            bans.shift();
            banData.push(ob);
         }
         else
         {
            _selectIndex++;
            _array.push(head);
            head.y += 42;
         }
         return true;
      }
      
      public function get isBaned() : Boolean
      {
         return eCount == 0;
      }
   }
}

