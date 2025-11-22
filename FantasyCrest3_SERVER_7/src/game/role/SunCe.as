package game.role
{
   import flash.geom.Rectangle;
   import game.server.AccessRun3Model;
   import game.server.HostRun2Model;
   import game.skill.HuZhuQiu;
   import zygame.data.BeHitData;
   import zygame.data.RoleAttributeData;
   import zygame.display.BaseRole;
   import zygame.display.EffectDisplay;
   import zygame.display.World;
   
   public class SunCe extends GameRole
   {
      
      public var sprites:Vector.<HuZhuQiu> = new Vector.<HuZhuQiu>();
      
      public var isGo:Boolean = false;
      
      public var isBeHit:Boolean = false;
      
      public var boomTime:int = 0;
      
      public function SunCe(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
      }
      
      public function createQiuQiu(isBeHit2:Boolean = false) : void
      {
         var G:HuZhuQiu = null;
         if(sprites.length < 6)
         {
            this.isBeHit = isBeHit2;
            G = new HuZhuQiu("G",null,this,0.25,0.25);
            G.x = this.posx;
            G.y = this.posy;
            G.tox = G.x;
            G.toy = G.y;
            G.continuousTime = 600;
            world.addChild(G);
            sprites.push(G);
            if(world.runModel is HostRun2Model)
            {
               (world.runModel as HostRun2Model).doFunc(this.name,"createQiuQiu",isBeHit);
            }
         }
      }
      
      override public function onHitEnemy(beData:BeHitData, enemy:BaseRole) : void
      {
         super.onHitEnemy(beData,enemy);
         if(world.runModel is AccessRun3Model)
         {
            return;
         }
         if(Math.random() > 0.8 && !isGo)
         {
            createQiuQiu();
         }
      }
      
      override public function onBeHit(beData:BeHitData) : void
      {
         super.onBeHit(beData);
         if(world.runModel is AccessRun3Model)
         {
            return;
         }
         if(Math.random() > 0.8 && !isGo)
         {
            createQiuQiu(true);
         }
      }
      
      override public function onFrame() : void
      {
         var i:int = 0;
         var role2:BaseRole = null;
         var boom:EffectDisplay = null;
         super.onFrame();
         if(boomTime > 0)
         {
            boomTime--;
         }
         for(i = sprites.length - 1; i >= 0; )
         {
            if(sprites[i].parent)
            {
               if(isGo)
               {
                  role2 = null;
                  if(!isBeHit)
                  {
                     role2 = this.findRole(new Rectangle(0,0,world.map.width,world.map.height));
                     if(role2)
                     {
                        sprites[i].tox = role2.posx + Math.random() * 200 - 100;
                        sprites[i].toy = role2.posy - 50 + Math.random() * 200 - 100;
                     }
                  }
                  if(boomTime == 0)
                  {
                     boom = new EffectDisplay("baozha",{
                        "hitY":24,
                        "hitX":1 * (sprites[i].scaleX > 0 ? 1 : -1),
                        "cardFrame":12,
                        "wFight":300
                     },this,0.5,0.5);
                     world.addChild(boom);
                     boom.posx = sprites[i].bounds.width / 2 + sprites[i].bounds.x - 130;
                     boom.posy = sprites[i].bounds.height / 2 + sprites[i].bounds.y - 100;
                     sprites[i].discarded();
                     sprites[i].continuousTime = 3;
                     sprites.splice(i,1);
                  }
               }
               else if(Math.random() > 0.8)
               {
                  sprites[i].continuousTime = 600;
                  sprites[i].tox = this.posx + Math.random() * 200 - 100;
                  sprites[i].toy = this.posy - 50 + Math.random() * 200 - 100;
               }
            }
            i--;
         }
         if(sprites.length >= 5 && boomTime == 0)
         {
            isGo = true;
            boomTime = 32;
         }
         if(sprites.length == 0)
         {
            isGo = false;
            boomTime = 0;
         }
      }
   }
}

