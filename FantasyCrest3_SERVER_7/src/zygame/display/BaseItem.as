package zygame.display
{
   import feathers.controls.BasicButton;
   import feathers.controls.List;
   import feathers.controls.renderers.IListItemRenderer;
   import feathers.core.ToggleGroup;
   import feathers.utils.touch.TapToSelect;
   
   public class BaseItem extends BasicButton implements IListItemRenderer
   {
      
      private var _index:int;
      
      private var _owner:List;
      
      private var _data:Object;
      
      private var _factoryID:String;
      
      private var _isSelected:Boolean;
      
      private var _toggleGroup:ToggleGroup;
      
      private var _tapSelect:TapToSelect;
      
      public function BaseItem()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(!_tapSelect)
         {
            _tapSelect = new TapToSelect(this);
         }
      }
      
      public function get data() : Object
      {
         return _data;
      }
      
      public function set data(value:Object) : void
      {
         _data = value;
      }
      
      public function get isSelected() : Boolean
      {
         return _isSelected;
      }
      
      public function set isSelected(value:Boolean) : void
      {
         if(this._isSelected === value)
         {
            return;
         }
         this._isSelected = value;
         this.invalidate("selected");
         this.invalidate("state");
         this.dispatchEventWith("change");
         this.dispatchEventWith("stageChange");
      }
      
      public function get factoryID() : String
      {
         return _factoryID;
      }
      
      public function set factoryID(value:String) : void
      {
         _factoryID = value;
      }
      
      public function get index() : int
      {
         return _index;
      }
      
      public function set index(value:int) : void
      {
         _index = value;
      }
      
      public function get owner() : List
      {
         return _owner;
      }
      
      public function set owner(value:List) : void
      {
         _owner = value;
      }
   }
}

