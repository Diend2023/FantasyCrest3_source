package game.role
{
   import feathers.data.ListCollection;
   import flash.geom.Point;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.World;
   
   public class Twelve extends GameRole
   {
      
      public function Twelve(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         this.listData = new ListCollection([{
            "icon":"fangyu.png",
            "msg":"0"
         }]);
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
         this.listData.getItemAt(0).msg = int(getMS() * 100) + "%";
         this.listData.updateAll();
      }
      
      private function getMS() : Number
      {
         var ms:Number = 0;
         if(this.beHitCount > 30)
         {
            ms = 0.8;
         }
         else
         {
            ms = this.beHitCount / 30 * 0.8;
         }
         return ms;
      }
      
      override public function hurtNumber(beHurt:int, beData:BeHitData, pos:Point) : void
      {
         super.hurtNumber(beHurt * (1 - getMS()),beData,pos);
      }
   }
}

