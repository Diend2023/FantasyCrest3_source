package game.data
{
   import flash.display.Stage;
   import flash.events.DataEvent;
   import flash.events.Event;
   import game.view.GameTipsView;
   import unit4399.events.RankListEvent;
   import unit4399.events.SaveEvent;
   import zygame.core.SceneCore;
   
   public class Game4399Tools
   {
      
      public var serviceHold:Object;
      
      public var data:Object;
      
      public var onLogined:Function;
      
      public var onSaveed:Function;
      
      public var onRankList:Function;
      
      public var onLoginOut:Function;
      
      public var onRankSelf:Function;
      
      public function Game4399Tools()
      {
         super();
      }
      
      public function set main(pmain:Stage) : void
      {
         pmain.addEventListener("saveBackIndex",saveProcess);
         pmain.addEventListener("netSaveError",netSaveErrorHandler,false,0,true);
         pmain.addEventListener("netGetError",netGetErrorHandler,false,0,true);
         pmain.addEventListener("multipleError",multipleErrorHandler,false,0,true);
         pmain.addEventListener("getuserdata",saveProcess);
         pmain.addEventListener("saveuserdata",saveProcess);
         pmain.addEventListener("getuserdatalist",saveProcess);
         pmain.addEventListener("logreturn",saveProcess);
         pmain.addEventListener("rankListSuccess",onRankListSuccessHandler);
         pmain.addEventListener("rankListError",onRankListErrorHandler);
         pmain.addEventListener("userLoginOut",onUserLogOutHandler,false,0,true);
      }
      
      public function onUserLogOutHandler(e:Event) : void
      {
         SceneCore.pushView(new GameTipsView("用户已退出"));
         if(Boolean(onLoginOut))
         {
            onLoginOut();
         }
      }
      
      public function getData(index:int) : void
      {
         if(serviceHold)
         {
            serviceHold.getData(false,index);
         }
      }
      
      public function saveData(data:Object, index:int) : void
      {
         if(serviceHold)
         {
            serviceHold.saveData("幻想纹章存档",data,false,index);
         }
      }
      
      public function submitScore(score:int, index:int, rankid:int, data:Object) : void
      {
         if(score > 0)
         {
            if(serviceHold)
            {
               serviceHold.submitScoreToRankLists(index,[{
                  "rId":rankid,
                  "score":score,
                  "extra":data
               }]);
            }
         }
      }
      
      public function getRankList(rankid:int, pageSize:int, page:int) : void
      {
         if(serviceHold)
         {
            serviceHold.getRankListsData(rankid,pageSize,page);
         }
      }
      
      public function getRankSelfData(rankid:int) : void
      {
         if(serviceHold)
         {
            serviceHold.getOneRankInfo(rankid,userName);
         }
      }
      
      public function get logInfo() : Object
      {
         if(!serviceHold)
         {
            return null;
         }
         return serviceHold.isLog;
      }
      
      public function get nickName() : String
      {
         var data:Object = logInfo;
         if(!data)
         {
            return null;
         }
         return data.nickName;
      }
      
      public function get userName() : String
      {
         var data:Object = logInfo;
         if(!data)
         {
            return null;
         }
         return data.name;
      }
      
      public function get uid() : String
      {
         var data:Object = logInfo;
         if(!data)
         {
            return null;
         }
         return data.uid;
      }
      
      private function saveProcess(e:SaveEvent) : void
      {
         var tmpObj:Object = null;
         switch(e.type)
         {
            case "logreturn":
               getData(0);
               break;
            case "getuserdata":
               try
               {
                  data = e.data.data;
               }
               catch(e:Error)
               {
                  data = null;
               }
               if(Boolean(onLogined))
               {
                  onLogined();
               }
               break;
            case "saveuserdata":
               if(e.ret as Boolean == true)
               {
                  SceneCore.pushView(new GameTipsView("已储存"));
                  if(Boolean(onSaveed))
                  {
                     onSaveed();
                  }
                  break;
               }
               SceneCore.pushView(new GameTipsView("储存失败"));
               break;
            case "saveBackIndex":
               tmpObj = e.ret as Object;
               if(tmpObj == null || int(tmpObj.idx) == -1)
               {
                  trace("返回的存档索引值出错了");
                  break;
               }
               trace("返回的存档索引值(从0开始算)：" + tmpObj.idx);
               break;
            case "getuserdatalist":
         }
      }
      
      public function onRankListErrorHandler(evt:RankListEvent) : void
      {
         SceneCore.pushView(new GameTipsView("读取排行榜异常"));
      }
      
      public function onRankListSuccessHandler(evt:RankListEvent) : void
      {
         var obj:Object = evt.data;
         var data:* = obj.data;
         switch(obj.apiName)
         {
            case "1":
               if(Boolean(onRankSelf))
               {
                  onRankSelf(data);
               }
               break;
            case "2":
            case "4":
               decodeRankListInfo(data);
               break;
            case "3":
               decodeSumitScoreInfo(data);
               break;
            case "5":
         }
      }
      
      public function decodeRankListInfo(dataAry:Array) : void
      {
         if(dataAry == null || dataAry.length == 0)
         {
            SceneCore.pushView(new GameTipsView("无战力数据"));
            return;
         }
         if(Boolean(onRankList))
         {
            onRankList(dataAry);
         }
      }
      
      public function decodeSumitScoreInfo(dataAry:Array) : void
      {
         var tmpObj:Object = null;
         var str:String = "";
         if(dataAry == null || dataAry.length == 0)
         {
            SceneCore.pushView(new GameTipsView("提交战力失败-无数据"));
            return;
         }
         for(var i in dataAry)
         {
            tmpObj = dataAry[i];
            str = "第" + (Number(i) + 1) + "条数据。排行榜ID：" + tmpObj.rId + "信息码值：" + tmpObj.code + "\n";
            if(tmpObj.code == "10000")
            {
               if(tmpObj.lastRank > tmpObj.curRank)
               {
                  SceneCore.pushView(new GameTipsView("进阶至" + tmpObj.curRank + "名次"));
               }
               str += "当前排名:" + tmpObj.curRank + ",当前分数：" + tmpObj.curScore + ",上一局排名：" + tmpObj.lastRank + ",上一局分数：" + tmpObj.lastScore + "\n";
            }
            else
            {
               str += "该排行榜提交的分数出问题了。信息：" + tmpObj.message + "\n";
               SceneCore.pushView(new GameTipsView("提交战力失败:" + tmpObj.message));
            }
         }
      }
      
      private function netSaveErrorHandler(evt:Event) : void
      {
         trace("网络存档失败了！");
      }
      
      private function netGetErrorHandler(evt:DataEvent) : void
      {
         var tmpStr:String = "网络取" + evt.data + "档失败了！";
         trace(tmpStr);
      }
      
      private function multipleErrorHandler(evt:Event) : void
      {
         trace("游戏多开了！");
      }
   }
}

