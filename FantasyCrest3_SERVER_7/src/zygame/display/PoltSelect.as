package zygame.display
{
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   
   public class PoltSelect extends KeyDisplayObject
   {
      
      private var _back:Function;
      
      private var _xml:XML;
      
      private var _select:Image;
      
      private var _selectID:int = 0;
      
      public function PoltSelect(xml:XML, back:Function)
      {
         super();
         _xml = xml;
         _back = back;
      }
      
      override public function onInit() : void
      {
         var select:TextureUIText = null;
         var problem:TextureUIText = new TextureUIText(GameCore.currentWorld.poltSystem.as3Message(_xml.@message));
         this.addChild(problem);
         problem.width = stage.stageWidth - 100;
         problem.x = stage.stageWidth / 2;
         problem.y = 100;
         problem.scale = 1;
         problem.touchable = false;
         var list:XMLList = _xml.children();
         for(var i in list)
         {
            select = new TextureUIText(GameCore.currentWorld.poltSystem.as3Message(list[i].@message));
            this.addChild(select);
            select.x = stage.stageWidth / 2;
            select.y = 180 + 60 * int(i);
            select.width = stage.stageWidth - 200;
            select.scale = 0.9;
            select.bg.alpha = 0.5;
            this.pushItem(select,int(i));
            if(int(i) == 0)
            {
               _select = new Image(DataCore.assetsSwf.otherAssets.getTexture("biao"));
               this.addChild(_select);
               _select.x = select.x - select.width / 2 + 16;
               _select.y = select.y;
               select.bg.alpha = 1;
               _selectID = 0;
               _select.visible = false;
            }
         }
         this.addEventListener("touch",onTouch);
         world.addKeyDisplay(this);
      }
      
      public function pushItem(item:DisplayObject, id:int) : void
      {
         item.name = "id_" + id;
      }
      
      override public function onDown(key:int) : void
      {
         if(74 == key)
         {
            this.eventBack(_xml.children()[_selectID]);
            return;
         }
         var child:DisplayObject = this.getChildByName("id_" + _selectID);
         child["bg"].alpha = 0.5;
         switch(key - 83)
         {
            case 0:
               _selectID++;
               if(!this.getChildByName("id_" + _selectID))
               {
                  _selectID--;
               }
               break;
            case 4:
               _selectID--;
               if(!this.getChildByName("id_" + _selectID))
               {
                  _selectID++;
               }
         }
         child = this.getChildByName("id_" + _selectID);
         _select.y = child.y;
         child["bg"].alpha = 1;
      }
      
      override public function onTouch(e:TouchEvent) : void
      {
         var i2:int = 0;
         var child:DisplayObject = null;
         var touch:Touch = e.getTouch(this,"ended");
         if(touch && touch.target && touch.target.name)
         {
            this.eventBack(_xml.children()[int(touch.target.name.charAt(3))]);
         }
         var h:Touch = e.getTouch(this,"hover");
         if(h && h.target)
         {
            _select.y = h.target.y;
         }
         i2 = 0;
         while(i2 < 4)
         {
            child = this.getChildByName("id_" + i2);
            if(child)
            {
               if(child.y == _select.y)
               {
                  child["bg"].alpha = 1;
                  _selectID = i2;
               }
               else
               {
                  child["bg"].alpha = 0.5;
               }
            }
            i2++;
         }
      }
      
      public function get xml() : XML
      {
         return _xml;
      }
      
      public function eventBack(xml:XML) : void
      {
         this.clearKey();
         this.discarded();
         _back(xml);
      }
      
      override public function discarded() : void
      {
         if(world)
         {
            world.removeKeyDisplay(this);
         }
         super.discarded();
      }
   }
}

