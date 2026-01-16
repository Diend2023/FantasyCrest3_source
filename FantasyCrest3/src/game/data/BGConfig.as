package game.data
{
   public class BGConfig
   {
      
      public static const shenlin:Object = [{
         "name":"1_0",
         "align":"bottom",
         "move":150,
         "moveY":150
      }];
      
      public static const none:Object = [{
         "name":"0_0",
         "align":"bottom",
         "move":150,
         "moveY":150
      }];
      
      public static const senlin:Object = [{
         "name":"3_0",
         "align":"bottom",
         "move":150,
         "moveY":150,
         "scale":2
      }];
      
      public static const test:Object = [{
         "name":"2_0",
         "align":"bottom",
         "move":50,
         "moveY":50
      },{
         "name":"2_1",
         "align":"bottom",
         "move":100,
         "moveY":100,
         "scale":1.5
      },{
         "name":"2_2",
         "align":"bottom",
         "move":150,
         "moveY":150,
         "scale":1.5
      },{
         "name":"map",
         "type":"sound"
      }];
      
      public function BGConfig()
      {
         super();
      }
   }
}

