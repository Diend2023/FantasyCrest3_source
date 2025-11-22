package zygame.data
{
   public dynamic class RoleFrameGroup
   {
      
      public var data:XML;
      
      public var fps:int = 24;
      
      public var name:String;
      
      public var frames:Vector.<RoleFrame>;
      
      public var cd:Number = 0;
      
      public var key:String = null;
      
      public var type:String = "land";
      
      public function RoleFrameGroup(xml:XML, pfps:int = -1)
      {
         var currentFrame:* = null;
         var frame:RoleFrame = null;
         var arr:Array = null;
         super();
         data = xml;
         name = xml.@name;
         cd = Number(xml.@cd);
         if(xml.@fps != undefined)
         {
            fps = int(xml.@fps);
         }
         else if(pfps > 0)
         {
            fps = pfps;
         }
         if(xml.@key != undefined)
         {
            key = xml.@key;
         }
         if(xml.@type != undefined)
         {
            type = xml.@type;
         }
         frames = new Vector.<RoleFrame>();
         var list:XMLList = xml.children();
         for(var i in list)
         {
            frame = new RoleFrame(list[i]);
            frame.group = this;
            frames.push(frame);
            frame.at = int(i);
            if(currentFrame)
            {
               currentFrame.nextGox = frame.gox - currentFrame.gox;
               currentFrame.nextGoy = frame.goy - currentFrame.goy;
            }
            currentFrame = frame;
         }
         if(xml.@other != undefined)
         {
            arr = JSON.parse(xml.@other) as Array;
            for(var a in arr)
            {
               this[arr[a].id] = arr[a].value;
            }
         }
      }
      
      public function clear() : void
      {
         var i:int = 0;
         data = null;
         name = null;
         for(i = frames.length - 1; i >= 0; )
         {
            frames[i].clear();
            frames.removeAt(i);
            i--;
         }
         frames = null;
      }
   }
}

