package game.display
{
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import game.item.AttributeItem;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.data.RoleAttributeData;
   import zygame.display.DisplayObjectContainer;
   
   public class AttributeView extends DisplayObjectContainer
   {
      
      private var _attr:RoleAttributeData;
      
      private var _list:List;
      
      public function AttributeView()
      {
         super();
         this.touchable = false;
      }
      
      override public function onInit() : void
      {
         var textures:TextureAtlas = DataCore.getTextureAtlas("select_role");
         var arr:Array = [{"name":"liliang"},{"name":"mofa"},{"name":"shengcun"},{"name":"sudu"},{"name":"shuijing"}];
         _list = new List();
         _list.dataProvider = new ListCollection(arr);
         _list.x = 10;
         _list.itemRendererType = AttributeItem;
         this.addChild(_list);
      }
      
      public function set data(role:RoleAttributeData) : void
      {
         _attr = role;
         _list.dataProvider.getItemAt(0).pro = liliang;
         _list.dataProvider.getItemAt(1).pro = moli;
         _list.dataProvider.getItemAt(2).pro = shengcun;
         _list.dataProvider.getItemAt(3).pro = speed;
         _list.dataProvider.getItemAt(4).pro = shuijing;
         _list.dataProvider.updateAll();
      }
      
      private function get liliang() : Number
      {
         var value:int = _attr.power;
         return (value - 50) / 450;
      }
      
      private function get shengcun() : Number
      {
         var value:Number = _attr.hpmax / 30000;
         value += _attr.armorDefense / 500;
         value += _attr.magicDefense / 500;
         return value / 3;
      }
      
      private function get speed() : Number
      {
         var value:Number = _attr.jump / 20 * 0.5;
         if(_attr.speed - 3 > 0)
         {
            value += (_attr.speed - 3) / 3 * 1.5;
         }
         return value / 2;
      }
      
      private function get shuijing() : Number
      {
         return _attr.getValue("crystal") / 10;
      }
      
      private function get moli() : Number
      {
         return (_attr.magic - 50) / 450;
      }
   }
}

