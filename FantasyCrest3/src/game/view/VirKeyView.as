package game.view
{
   import flash.geom.Point;
   import game.display.CommonButton;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.events.Touch;
   import starling.textures.TextureAtlas;
   import starling.utils.rad2deg;
   import zygame.core.DataCore;
   import zygame.display.TouchDisplayObject;
   
   public class VirKeyView extends TouchDisplayObject
   {
      
      private var _moveKey:Image;
      
      private var _moveBottom:Image;
      
      private var _touchTime:int = 0;
      
      public function VirKeyView()
      {
         super();
      }
      
      override public function onInit() : void
      {
         super.onInit();
         var textures:TextureAtlas = DataCore.getTextureAtlas("hpmp");
         var moveKey:Image = new Image(textures.getTexture("key_bottom.png"));
         this.addChild(moveKey);
         moveKey.alignPivot();
         moveKey.x = 150;
         moveKey.y = stage.stageHeight - 100;
         _moveBottom = moveKey;
         _moveKey = new Image(textures.getTexture("key_move.png"));
         this.addChild(_moveKey);
         _moveKey.pivotX = 16;
         _moveKey.pivotY = 16;
         _moveKey.x = 150;
         _moveKey.y = moveKey.y;
         _moveKey.visible = false;
         var q:Quad = new Quad(300,200,16711680);
         q.alpha = 0;
         this.addChild(q);
         q.name = "move";
         q.x = 0;
         q.y = stage.stageHeight - q.height;
         var J:CommonButton = new CommonButton("j_key.png","hpmp");
         this.addChild(J);
         J.x = stage.stageWidth - 150;
         J.y = stage.stageHeight - 75;
         J.name = "j";
         J.callBack = onTag;
         var K:CommonButton = new CommonButton("k_key.png","hpmp");
         this.addChild(K);
         K.x = stage.stageWidth - 80;
         K.y = stage.stageHeight - 165;
         K.callBack = onTag;
         K.name = "k";
         var U:CommonButton = new CommonButton("u_key.png","hpmp");
         this.addChild(U);
         U.x = stage.stageWidth - 255;
         U.y = stage.stageHeight - 75;
         U.callBack = onTag;
         U.name = "u";
         var I:CommonButton = new CommonButton("i_key.png","hpmp");
         this.addChild(I);
         I.x = stage.stageWidth - 220;
         I.y = stage.stageHeight - 155;
         I.callBack = onTag;
         I.name = "i";
         var O:CommonButton = new CommonButton("o_key.png","hpmp");
         this.addChild(O);
         O.x = stage.stageWidth - 160;
         O.y = stage.stageHeight - 230;
         O.callBack = onTag;
         O.name = "o";
         var P:CommonButton = new CommonButton("p_key.png","hpmp");
         this.addChild(P);
         P.x = stage.stageWidth - 70;
         P.y = stage.stageHeight - 270;
         P.callBack = onTag;
         P.name = "p";
         world.addUpdateList(this);
         isTouch = true;
      }
      
      override public function onFrame() : void
      {
         if(_touchTime > 0)
         {
            _touchTime--;
         }
      }
      
      public function onTag(target:String) : void
      {
         switch(target)
         {
            case "j_key.png":
               world.onDown(74);
               break;
            case "k_key.png":
               world.onDown(75);
               break;
            case "u_key.png":
               world.onDown(85);
               break;
            case "i_key.png":
               world.onDown(73);
               break;
            case "o_key.png":
               world.onDown(79);
               break;
            case "p_key.png":
               world.onDown(80);
         }
      }
      
      override public function onTouchBegin(touch:Touch) : void
      {
         if(!touch.target)
         {
            return;
         }
         var touchName:String = touch.target.name;
         var _loc3_:* = touchName;
         if("move" === _loc3_)
         {
            _moveKey.x = touch.globalX;
            _moveKey.y = touch.globalY;
            moveKey();
            _moveKey.visible = true;
            if(_touchTime > 1)
            {
               world.onDown(76);
            }
            _touchTime = 12;
         }
      }
      
      override public function onTouchMove(touch:Touch) : void
      {
         if(!touch.target)
         {
            return;
         }
         var touchName:String = touch.target.name;
         var _loc3_:* = touchName;
         if("move" === _loc3_)
         {
            _moveKey.x = touch.globalX;
            _moveKey.y = touch.globalY;
            moveKey();
            _moveKey.visible = true;
         }
      }
      
      override public function onTouchEnd(touch:Touch) : void
      {
         if(!touch.target)
         {
            return;
         }
         var touchName:String = touch.target.name;
         switch(touchName)
         {
            case "move":
               _moveKey.visible = false;
               world.onUp(68);
               world.onUp(87);
               world.onUp(83);
               world.onUp(65);
               world.onUp(76);
               break;
            case "j":
               world.onUp(74);
               break;
            case "k":
               world.onUp(75);
               break;
            case "u":
               world.onUp(85);
               break;
            case "i":
               world.onUp(73);
               break;
            case "o":
               world.onUp(79);
               break;
            case "p":
               world.onUp(80);
         }
      }
      
      public function moveKey() : void
      {
         var c:Number = NaN;
         var s:Number = NaN;
         var r:Number = Math.atan2(_moveKey.y - _moveBottom.y,_moveKey.x - _moveBottom.x);
         _moveKey.rotation = r;
         var point1:Point = new Point(_moveKey.x,_moveKey.y);
         var point2:Point = new Point(_moveBottom.x,_moveBottom.y);
         var len:Number = Point.distance(point1,point2);
         if(len > _moveBottom.width * 0.3)
         {
            c = Math.cos(r);
            s = Math.sin(r);
            _moveKey.x = _moveBottom.x + _moveBottom.width * 0.3 * c;
            _moveKey.y = _moveBottom.y + _moveBottom.width * 0.3 * s;
         }
         r = rad2deg(r);
         if(Math.abs(Math.abs(r) - 90) < 30)
         {
            if(r < 0)
            {
               world.onUp(83);
               world.onDown(87);
            }
            else
            {
               world.onUp(87);
               world.onDown(83);
            }
         }
         else if(_moveKey.x > 150)
         {
            world.onUp(83);
            world.onUp(87);
            world.onUp(65);
            world.onDown(68);
         }
         else
         {
            world.onUp(83);
            world.onUp(87);
            world.onUp(68);
            world.onDown(65);
         }
      }
   }
}

