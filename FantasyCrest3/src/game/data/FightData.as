package game.data
{
   import flash.utils.Dictionary;
   import game.role.GameRole;
   import game.world.BaseGameWorld;
   import game.world._1V1LEVEL;
   import game.world._1V3;
   import game.world._2V2LEVEL;
   import game.world._3V1;
   import zygame.display.World;
   
   public class FightData
   {
      
      private var _dict1:Dictionary;
      
      private var _dict2:Dictionary;
      
      private var _world:BaseGameWorld;
      
      public function FightData(world:BaseGameWorld)
      {
         super();
         _world = world;
         _dict1 = new Dictionary();
         _dict2 = new Dictionary();
      }
      
      public function update(role:GameRole) : void
      {
         if(role.fightid == -1)
         {
            return;
         }
         var dict:Dictionary = role.troopid == 0 ? _dict1 : _dict2;
         if(!dict[role.fightid])
         {
            dict[role.fightid] = {};
         }
         if(role.hurt < dict[role.fightid].hurt)
         {
            role.hurt = dict[role.fightid].hurt + role.hurt;
         }
         if(role.beHurt < dict[role.fightid].beHurt)
         {
            role.beHurt = dict[role.fightid].beHurt + role.beHurt;
         }
         dict[role.fightid].hurt = role.hurt;
         dict[role.fightid].beHurt = role.beHurt;
         dict[role.fightid].target = role.targetName;
         dict[role.fightid].timeHurt = int(role.hurt / (_world.frameCount / 60));
      }
      
      public function get data1() : Array
      {
         return getData(1);
      }
      
      public function get data2() : Array
      {
         return getData(2);
      }
      
      private function getData(id:int) : Array
      {
         var fen:int = 0;
         var ob:Object = null;
         var isWin:Boolean = _world.cheakGameOver() == 0;
         var arr:Array = [];
         for(var i in this["_dict" + id])
         {
            fen = 0;
            ob = this["_dict" + id][i];
            if(ob.timeHurt > 1000)
            {
               fen += 50;
            }
            else
            {
               fen += ob.timeHurt / 1000 * 50;
            }
            if(ob.hurt > ob.beHurt)
            {
               fen += 50 * (1 - ob.beHurt / ob.hurt);
            }
            else
            {
               fen -= 50 * (1 - ob.hurt / ob.beHurt);
            }
            if(fen < -100)
            {
               fen = -100;
            }
            switch(World.defalutClass)
            {
               case _1V3:
                  if(fen > 0 && isWin)
                  {
                     fen *= 3;
                  }
               case _3V1:
                  if(fen < 0)
                  {
                     fen = 0;
                  }
               case _1V1LEVEL:
               case _2V2LEVEL:
                  if(!isWin && fen > 0)
                  {
                     fen = 0;
                  }
            }
            if(id == 1)
            {
               ob.score = fen;
               Game.addForce(ob.target,fen);
            }
            ob.id = id;
            arr.push(ob);
         }
         return arr;
      }
   }
}

