package zygame.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.net.FileReference;
   import flash.system.MessageChannel;
   import flash.system.Worker;
   import flash.system.WorkerDomain;
   import flash.utils.ByteArray;
   import lzm.starling.swf.FPSUtil;
   import starling.core.Starling;
   import starling.display.Quad;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import zygame.display.DisplayObjectContainer;
   
   public class GIFUtils extends DisplayObjectContainer
   {
      
      public static var mainToWorker:MessageChannel;
      
      public static var workerToMain:MessageChannel;
      
      [Embed(source="GIFWorker.swf",mimeType="application/octet-stream")] //在同目录下添加了原本不存在的GIFWorker.swf文件
      // private static var GIFWorker:Class = §GIFWorker_swf$15fb488c19bf95edf1249f0e9adaa817-438212441§;
      private static var GIFWorker:Class // 修复错误的类名
      
      private var _fps:FPSUtil;
      
      private var _scale:Number;
      
      private var _bitmaps:Array;
      
      private var _bitmap:Bitmap;
      
      private var _loadText:TextField;
      
      private var _gifWorker:Worker;
      
      private var _isEncodeing:Boolean = false;
      
      public var isDiscarded:Boolean = false;
      
      private var _maxFrameCount:int = 60;
      
      public function GIFUtils(fps:int, scale:Number = 0.3)
      {
         super();
         _scale = scale;
         _fps = new FPSUtil(fps);
         _bitmaps = [];
         _bitmap = new Bitmap();
         Starling.current.nativeStage.addChild(_bitmap);
      }
      
      public function start() : void
      {
         Starling.current.stage.addEventListener("enterFrame",onFrameEvent);
      }
      
      public function onFrameEvent(e:starling.events.Event) : void
      {
         var bitmapData:BitmapData = null;
         var newbitmapData:BitmapData = null;
         var mr:Matrix = null;
         var scale:Number = NaN;
         var byte:ByteArray = null;
         if(_fps.update())
         {
            bitmapData = Starling.current.stage.drawToBitmapData();
            newbitmapData = new BitmapData(bitmapData.width * _scale,bitmapData.height * _scale,true,16777215);
            mr = new Matrix();
            scale = 0.5;
            mr.scale(scale,scale);
            mr.tx = -(bitmapData.width * scale - newbitmapData.width) / 2;
            mr.ty = -(bitmapData.height * scale - newbitmapData.height) / 2;
            newbitmapData.draw(bitmapData,mr);
            bitmapData.dispose();
            byte = new ByteArray();
            byte.shareable = true;
            newbitmapData.copyPixelsToByteArray(newbitmapData.rect,byte);
            _bitmaps.push(byte);
            if(_bitmap.bitmapData)
            {
               _bitmap.bitmapData.dispose();
            }
            _bitmap.bitmapData = newbitmapData;
            if(this._bitmaps.length >= _maxFrameCount)
            {
               close();
               this.save();
            }
         }
      }
      
      public function close() : void
      {
         Starling.current.stage.removeEventListeners("enterFrame");
      }
      
      public function save() : void
      {
         if(_isEncodeing)
         {
            return;
         }
         _isEncodeing = true;
         _gifWorker = WorkerDomain.current.createWorker(new GIFWorker(),true);
         mainToWorker = Worker.current.createMessageChannel(_gifWorker);
         workerToMain = _gifWorker.createMessageChannel(Worker.current);
         _gifWorker.setSharedProperty("mainToWorker",mainToWorker);
         _gifWorker.setSharedProperty("workerToMain",workerToMain);
         workerToMain.addEventListener("channelMessage",onWorkerToMain);
         _gifWorker.start();
         mainToWorker.send({
            "type":"encode",
            "bmds":_bitmaps,
            "width":_bitmap.width,
            "height":_bitmap.height
         });
         if(_bitmap)
         {
            _bitmap.bitmapData.dispose();
            _bitmap.parent.removeChild(_bitmap);
            _bitmap = null;
         }
         var loading:Quad = new Quad(200,32,0);
         this.addChild(loading);
         loading.alpha = 0.7;
         _loadText = new TextField(200,32,"正在转码 0%",new TextFormat("Verdana",12,16777215));
         this.addChild(_loadText);
      }
      
      public function onWorkerToMain(e:flash.events.Event) : void
      {
         var file:FileReference = null;
         var receive:Object = workerToMain.receive();
         trace("[Worker Back] " + JSON.stringify(receive));
         if(receive.type == "encoded")
         {
            file = new FileReference();
            file.save(receive.bytes,"export.gif");
            _gifWorker.terminate();
            _gifWorker = null;
            _isEncodeing = false;
            this.removeFromParent(true);
            isDiscarded = true;
         }
         else
         {
            _loadText.text = "正在转码 " + int(receive.num * 100) + "%";
         }
      }
   }
}

