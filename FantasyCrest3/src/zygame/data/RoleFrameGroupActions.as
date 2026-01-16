package zygame.data
{
   import flash.utils.Dictionary;
   import zygame.utils.MemoryUtils;
   
   public class RoleFrameGroupActions
   {
      
      public var landActions:Dictionary;
      
      public var airActions:Dictionary;
      
      public var actions:Dictionary;
      
      public var actionXMLList:XMLList;
      
      public var targetName:String;
      
      public function RoleFrameGroupActions(targetName:String, xml:XMLList)
      {
         super();
         landActions = new Dictionary();
         airActions = new Dictionary();
         actions = new Dictionary();
         actionXMLList = xml;
         this.targetName = targetName;
      }
      
      public function parsingAction(fps:int) : void
      {
         var roleFrameGroup:RoleFrameGroup = null;
         var child:XMLList = actionXMLList;
         for(var i in child)
         {
            roleFrameGroup = new RoleFrameGroup(child[i],fps);
            actions[String(child[i].@name)] = roleFrameGroup;
            if(roleFrameGroup.key != null)
            {
               if(roleFrameGroup.type == "all" || roleFrameGroup.type == "injured")
               {
                  airActions[roleFrameGroup.key] = roleFrameGroup;
                  landActions[roleFrameGroup.key] = roleFrameGroup;
               }
               else if(roleFrameGroup.type == "air")
               {
                  airActions[roleFrameGroup.key] = roleFrameGroup;
               }
               else
               {
                  landActions[roleFrameGroup.key] = roleFrameGroup;
               }
            }
         }
      }
      
      public function clear() : void
      {
         MemoryUtils.clearObject(landActions);
         MemoryUtils.clearObject(airActions);
         landActions = null;
         airActions = null;
         for(var i in actions)
         {
            (actions[i] as RoleFrameGroup).clear();
            delete actions[i];
         }
         actions = null;
      }
   }
}

