package game.role
{
   import starling.display.Image;
   import zygame.data.RoleAttributeData;
   import zygame.display.SpriteRole;
   import zygame.display.World;
   import zygame.filters.GoldenBodyFilter;
   
   public class BullyRole extends SpriteRole
   {
      
      public var img:Image;
      
      public function BullyRole(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      override public function onInit() : void
      {
         super.onInit();
         img = new Image((this.display as Image).texture);
         this.addChildAt(img,0);
         img.x = display.x;
         img.y = display.y;
      }
      
      override public function onShapeChange() : void
      {
         super.onShapeChange();
         if(img)
         {
            img.visible = golden > 0;
            if(img.visible)
            {
               img.texture = (this.display as Image).texture;
               img.x = display.x;
               img.y = display.y;
               img.width = (this.display as Image).texture.width;
               img.height = (this.display as Image).texture.height;
               img.scaleX = contentScale;
               img.scaleY = contentScale;
               if(golden <= 0)
               {
                  img.visible = false;
               }
            }
         }
      }
      
      override public function set golden(i:int) : void
      {
         super.golden = i;
         if(!img)
         {
            return;
         }
         if(i > 0)
         {
            if(img.filter == null)
            {
               img.filter = new GoldenBodyFilter();
            }
         }
         else if(img.filter)
         {
            img.filter.dispose();
            img.filter = null;
         }
      }
      
      override public function dispose() : void
      {
         if(img)
         {
            if(img.filter)
            {
               img.filter.dispose();
            }
            img.removeFromParent(true);
            img = null;
         }
         super.dispose();
      }
   }
}

