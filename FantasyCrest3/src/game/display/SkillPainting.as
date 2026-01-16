package game.display
{
   import game.data.Game;
   import game.uilts.GameFont;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.text.TextField;
   import starling.text.TextFormat;
   import starling.textures.Texture;
   import zygame.core.DataCore;
   import zygame.display.DisplayObjectContainer;
   
   public class SkillPainting extends DisplayObjectContainer
   {
      
      private var _targetName:String;
      
      private var _skillName:String;
      
      private var _troopid:int;
      
      public function SkillPainting(target:String, skillName:String, troop:int)
      {
         super();
         _skillName = skillName;
         _targetName = target;
         _troopid = troop;
         this.alignPivot();
      }
      
      override public function onInit() : void
      {
         var tex:Texture;
         var img:Image;
         var maskbg:Quad;
         var tw:Tween;
         var textbg:TextField;
         var text:TextField;
         var bg:Quad = new Quad(stage.stageWidth,250,0);
         this.addChild(bg);
         bg.alpha = 0;
         bg.pivotY = bg.height / 2;
         bg.y = bg.height / 2;
         bg.scaleY = 0;
         Starling.juggler.tween(bg,0.5,{
            "alpha":0.5,
            "scaleY":1
         });
         tex = Game.assets.getTexture(_targetName);
         if(!tex)
         {
            tex = DataCore.getTexture("none");
         }
         img = new Image(tex);
         this.addChild(img);
         img.x = stage.stageWidth;
         maskbg = new Quad(stage.stageWidth,250,0);
         this.addChild(maskbg);
         img.mask = maskbg;
         maskbg.pivotY = maskbg.height / 2;
         maskbg.y = maskbg.height / 2;
         maskbg.scaleY = 0;
         Starling.juggler.tween(maskbg,0.5,{"scaleY":1});
         tw = new Tween(img,0.5,"easeOutBack");
         tw.animate("x",0);
         Starling.juggler.add(tw);
         textbg = new TextField(stage.stageWidth - 300,250,_skillName,new TextFormat(GameFont.FONT_NAME,64,0));
         this.addChild(textbg);
         textbg.alignPivot();
         textbg.x = stage.stageWidth;
         textbg.y = 128;
         textbg.alpha = 0;
         text = new TextField(stage.stageWidth - 300,250,_skillName,new TextFormat(GameFont.FONT_NAME,64,16777215));
         this.addChild(text);
         text.alignPivot();
         text.x = stage.stageWidth;
         text.y = 125;
         text.alpha = 0;
         textbg.skewX = 0.2;
         text.skewX = 0.2;
         Starling.juggler.tween(textbg,0.5,{
            "alpha":1,
            "x":428,
            "transition":"easeOutBack"
         });
         Starling.juggler.tween(text,0.5,{
            "alpha":1,
            "x":425,
            "transition":"easeOutBack"
         });
         tw.onComplete = function():void
         {
            Starling.juggler.delayCall(function():void
            {
               var tw:Tween;
               Starling.juggler.tween(bg,0.5,{
                  "alpha":0,
                  "scaleY":0
               });
               Starling.juggler.tween(maskbg,0.5,{
                  "alpha":0,
                  "scaleY":0
               });
               tw = new Tween(img,0.5,"easeInBack");
               tw.animate("x",stage.stageWidth);
               tw.onComplete = function():void
               {
                  textbg.dispose();
                  text.dispose();
                  bg.dispose();
                  img.dispose();
                  maskbg.dispose();
                  removeFromParent(true);
               };
               Starling.juggler.add(tw);
               Starling.juggler.tween(textbg,0.5,{
                  "alpha":0,
                  "x":stage.stageWidth,
                  "transition":"easeInBack"
               });
               Starling.juggler.tween(text,0.5,{
                  "alpha":0,
                  "x":stage.stageWidth,
                  "transition":"easeInBack"
               });
            },0.2);
         };
         this.y = stage.stageHeight / 2 - 150;
         if(_troopid == 1)
         {
            this.scaleX = -1;
            this.x = stage.stageWidth;
            textbg.scaleX = -1;
            text.scaleX = -1;
         }
      }
   }
}

