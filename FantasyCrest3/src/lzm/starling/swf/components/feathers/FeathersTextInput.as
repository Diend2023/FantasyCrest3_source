package lzm.starling.swf.components.feathers
{
   import feathers.controls.TextInput;
   import flash.text.TextFormat;
   import lzm.starling.swf.components.ISwfComponent;
   import lzm.starling.swf.display.SwfSprite;
   import starling.display.DisplayObject;
   import starling.text.TextField;
   
   public class FeathersTextInput extends TextInput implements ISwfComponent
   {
      
      public function FeathersTextInput()
      {
         super();
      }
      
      public function initialization(componetContent:SwfSprite) : void
      {
         var textFormat:TextFormat = null;
         var _backgroundSkin:DisplayObject = componetContent.getChildByName("_backgroundSkin");
         var _backgroundDisabledSkin:DisplayObject = componetContent.getChildByName("_backgroundDisabledSkin");
         var _backgroundFocusedSkin:DisplayObject = componetContent.getChildByName("_backgroundFocusedSkin");
         var _textFormat:TextField = componetContent.getTextField("_textFormat");
         if(_backgroundSkin)
         {
            this.backgroundSkin = _backgroundSkin;
            _backgroundSkin.removeFromParent();
         }
         if(_backgroundDisabledSkin)
         {
            this.backgroundDisabledSkin = _backgroundDisabledSkin;
            _backgroundDisabledSkin.removeFromParent();
         }
         if(_backgroundFocusedSkin)
         {
            this.backgroundFocusedSkin = _backgroundFocusedSkin;
            _backgroundFocusedSkin.removeFromParent();
         }
         if(_textFormat != null)
         {
            this.textEditorProperties.fontFamily = _textFormat.format.font;
            this.textEditorProperties.fontSize = _textFormat.format.size;
            this.textEditorProperties.color = _textFormat.format.color;
            textFormat = new TextFormat();
            textFormat.font = _textFormat.format.font;
            textFormat.size = _textFormat.format.size;
            textFormat.color = _textFormat.format.color;
            this.promptProperties.textFormat = textFormat;
            this.prompt = _textFormat.text;
         }
         componetContent.removeFromParent(true);
      }
      
      public function get editableProperties() : Object
      {
         return {
            "prompt":prompt,
            "displayAsPassword":displayAsPassword,
            "maxChars":maxChars,
            "isEditable":isEditable
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

