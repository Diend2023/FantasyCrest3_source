package game.display
{
   import starling.display.Image;
   import starling.textures.Texture;
   
   public class MessageImage extends Image
   {
      
      public function MessageImage(texture:Texture)
      {
         super(texture);
      }
      
      override public function set width(value:Number) : void
      {
         super.width = value * (scaleX < 0 ? -1 : 1);
      }
      
      override public function set scaleX(value:Number) : void
      {
         super.scaleX = value;
      }
   }
}

