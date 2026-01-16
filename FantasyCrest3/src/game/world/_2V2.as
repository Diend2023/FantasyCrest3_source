package game.world
{
   import game.view.GameStateView;
   
   public class _2V2 extends SubstitutesWorld
   {
      
      public function _2V2(mapName:String, toName:String)
      {
         super(mapName,toName);
      }
      
      override public function initRole() : void
      {
         (state as GameStateView).create3P4PHPMP();
         this.isDoublePlayer = true;
         (state as GameStateView).bind(0,this.getRoleList()[0]);
         (state as GameStateView).bind(1,this.getRoleList()[2]);
         (state as GameStateView).bind(2,this.getRoleList()[1]);
         (state as GameStateView).bind(3,this.getRoleList()[3]);
         this.getRoleList()[0].troopid = 0;
         this.getRoleList()[1].troopid = 0;
         this.getRoleList()[2].troopid = 1;
         this.getRoleList()[3].troopid = 1;
         this.getRoleList()[1].ai = true;
         this.getRoleList()[2].ai = false;
         this.getRoleList()[3].ai = true;
         bindXY(this.getRoleList()[0],"1p");
         bindXY(this.getRoleList()[1],"1p");
         bindXY(this.getRoleList()[2],"2p");
         bindXY(this.getRoleList()[3],"2p");
         p1 = this.getRoleList()[0];
         p2 = this.getRoleList()[2];
         this.getRoleList()[0].scaleX = 1;
         this.getRoleList()[1].scaleX = 1;
         this.getRoleList()[2].scaleX = -1;
         this.getRoleList()[3].scaleX = -1;
         this.getRoleList()[1].addX(-100);
         this.getRoleList()[3].addX(100);
         mathCenterPos();
         moveMap(1);
         this.p1assist.push(this.getRoleList()[1]);
         this.p2assist.push(this.getRoleList()[3]);
         this.createChangeTipsView();
      }
   }
}

