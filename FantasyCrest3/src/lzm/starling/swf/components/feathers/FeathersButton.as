package lzm.starling.swf.components.feathers
{
   import feathers.controls.Button;
   import flash.text.TextFormat;
   import lzm.starling.swf.components.ISwfComponent;
   import lzm.starling.swf.display.SwfSprite;
   import starling.display.DisplayObject;
   import starling.text.TextField;
   
   public class FeathersButton extends Button implements ISwfComponent
   {
      
      public function FeathersButton()
      {
         super();
      }
      
      public function initialization(componetContent:SwfSprite) : void
      {
         var textFormat:TextFormat = null;
         var _upSkin:DisplayObject = componetContent.getChildByName("_upSkin");
         var _downSkin:DisplayObject = componetContent.getChildByName("_downSkin");
         var _disabledSkin:DisplayObject = componetContent.getChildByName("_disabledSkin");
         var _labelTextField:TextField = componetContent.getTextField("_labelTextField");
         if(_upSkin)
         {
            this.defaultSkin = _upSkin;
            _upSkin.removeFromParent();
         }
         if(_downSkin)
         {
            this.downSkin = _downSkin;
            _downSkin.removeFromParent();
         }
         if(_disabledSkin)
         {
            this.disabledSkin = _disabledSkin;
            _disabledSkin.removeFromParent();
         }
         if(_labelTextField)
         {
            textFormat = new TextFormat();
            textFormat.font = _labelTextField.format.font;
            textFormat.size = _labelTextField.format.size;
            textFormat.color = _labelTextField.format.color;
            textFormat.bold = _labelTextField.format.bold;
            textFormat.italic = _labelTextField.format.italic;
            this.defaultLabelProperties.textFormat = textFormat;
            this.label = _labelTextField.text;
         }
         componetContent.removeFromParent(true);
      }
      
      public function get editableProperties() : Object
      {
         return {
            "label":label,
            "isEnabled":isEnabled
         };
      }
      
      public function set editableProperties(properties:Object) : void
      {
         for(var key in properties)
         {
            this[key] = properties[key];
         }
      }
   }
}

