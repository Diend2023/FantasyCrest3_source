package lzm.starling.swf.components.feathers
{
   import feathers.controls.Check;
   import flash.text.TextFormat;
   import lzm.starling.swf.components.ISwfComponent;
   import lzm.starling.swf.display.SwfScale9Image;
   import lzm.starling.swf.display.SwfSprite;
   import starling.display.Image;
   import starling.text.TextField;
   
   public class FeathersCheck extends Check implements ISwfComponent
   {
      
      public function FeathersCheck()
      {
         super();
      }
      
      public function initialization(componetContent:SwfSprite) : void
      {
         var textFormat:TextFormat = null;
         var _defaultSkin:SwfScale9Image = componetContent.getScale9Image("_defaultSkin");
         var _defaultSelectedSkin:Image = componetContent.getImage("_defaultSelectedSkin");
         var _downSkin:SwfScale9Image = componetContent.getScale9Image("_downSkin");
         var _downSelectedSkin:Image = componetContent.getImage("_downSelectedSkin");
         var _disabledSkin:SwfScale9Image = componetContent.getScale9Image("_disabledSkin");
         var _disabledSelectedSkin:Image = componetContent.getImage("_disabledSelectedSkin");
         var _labelTextField:TextField = componetContent.getTextField("_labelTextField");
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
            "isSelected":isSelected
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

