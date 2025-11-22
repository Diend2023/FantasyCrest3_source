package lzm.starling.swf.again
{
   import starling.display.Sprite;
   
   public class ASprite extends Sprite
   {
      
      public function ASprite()
      {
         super();
      }
      
      public function clearChild() : void
      {
         this.removeChildren();
      }
   }
}

