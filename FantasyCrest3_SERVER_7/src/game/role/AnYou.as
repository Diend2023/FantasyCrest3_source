package game.role
{
   import feathers.data.ListCollection;
   import flash.geom.Point;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.World;
   
   public class AnYou extends GameRole
   {
      
      private var _mshang:cint = new cint();
      
      private var _hit:cint = new cint();
      
      public function AnYou(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         listData = new ListCollection([{
            "icon":"liliang.png",
            "msg":"0"
         },{
            "icon":"fangyu.png",
            "msg":"0"
         }]);
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         if(_mshang.value <= 0)
         {
            _hit.value = hit;
            if(this.hit == 12)
            {
               _hit.value = 0;
               _mshang.value = 1500;
               listData.getItemAt(1).msg = _mshang.value;
            }
            listData.getItemAt(0).msg = _hit.value;
            listData.updateAll();
         }
      }
      
      override public function hurtNumber(beHurt:int, beData:BeHitData, pos:Point) : void
      {
         if(_mshang.value > 0)
         {
            if(_mshang.value > beHurt)
            {
               _mshang.value -= beHurt;
               this.listData.getItemAt(1).msg = _mshang.value;
               this.listData.updateItemAt(1);
               super.hurtNumber(1,beData,pos);
            }
            else
            {
               beHurt -= _mshang.value;
               _mshang.value = 0;
               this.listData.getItemAt(1).msg = _mshang.value;
               this.listData.updateItemAt(1);
               super.hurtNumber(beHurt,beData,pos);
            }
         }
         else
         {
            super.hurtNumber(beHurt,beData,pos);
         }
      }
   }
}

