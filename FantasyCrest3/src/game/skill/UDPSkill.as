package game.skill
{
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   
   public class UDPSkill extends EffectDisplay
   {
      
      public function UDPSkill(target:String, data:Object, pRole:BaseRole, pScaleX:Number = 1, pScaleY:Number = 1)
      {
         super(target,data,pRole,pScaleX,pScaleY);
      }
      
      public function copyData() : Object
      {
         return {
            "gox":this.gox,
            "goy":this.goy,
            "x":this.posx,
            "y":this.posy,
            "roleid":this.role.pid,
            "name":this.name
         };
      }
      
      public function setData(data:Object) : void
      {
         gox2 = data.gox;
         goy2 = data.goy;
         posx = data.x;
         posy = data.y;
      }
   }
}

