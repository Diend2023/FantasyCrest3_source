package zygame.utils
{
   import lzm.starling.swf.SwfAssetManager;
   import zygame.core.DataCore;
   
   public class WDAssetsManager extends SwfAssetManager
   {
      
      public var isWeb:Boolean = false;
      
      private var _dragonNames:Array;
      
      public var arr:Array = [];
      
      public function WDAssetsManager(web:Boolean)
      {
         super();
         _dragonNames = [];
         isWeb = web;
      }
      
      override public function enqueue(name:String, resource:Array, fps:int = 24) : void
      {
         var i2:int = 0;
         var cutName:String = null;
         arr = arr.concat(resource);
         if(isWeb)
         {
            for(var i in resource)
            {
               resource[i] = String(resource[i]).replace(".bytes",".data");
            }
         }
         for(i2 = resource.length - 1; i2 >= 0; )
         {
            resource[i2] = DataCore.webAssetsPath + String(resource[i2]);
            cutName = resource[i2];
            cutName = cutName.substr(0,cutName.lastIndexOf("."));
            cutName = cutName.substr(cutName.lastIndexOf("/") + 1);
            if(String(resource[i2]).indexOf("<null>") != -1 || otherAssets.getTexture(cutName))
            {
               resource.splice(i2,1);
            }
            i2--;
         }
         super.enqueue(name,resource,fps);
      }
      
      override public function loadQueue(onProgress:Function) : void
      {
         var i:Object;
         for(i in arr)
         {
            trace("<file path=\"" + arr[i] + "\"/>");
         }
         this._isLoading = false;
         super.loadQueue(function(num:Number):void
         {
            if(!DataCore.onProgress(num))
            {
               onProgress(num);
            }
            if(num == 1)
            {
               otherAssets.cheak();
            }
         });
      }
   }
}

