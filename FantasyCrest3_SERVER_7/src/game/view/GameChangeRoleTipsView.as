package game.view
{
   import game.data.Game;
   import starling.display.Image;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.display.DisplayObjectContainer;
   
   public class GameChangeRoleTipsView extends DisplayObjectContainer
   {
      
      private var _leftImage:Image;
      
      private var _rightImage:Image;
      
      public var p1head:Image;
      
      public var p2head:Image;
      
      public var p1array:Array;
      
      public var p2array:Array;
      
      public function GameChangeRoleTipsView(array1:Array, array2:Array)
      {
         super();
         p1array = array1;
         p2array = array2;
      }
      
      override public function onInit() : void
      {
         var leftImage:Image = null;
         var rightImage:Image = null;
         super.onInit();
         var textures:TextureAtlas = DataCore.getTextureAtlas("hpmp");
         if(p1array.length > 0)
         {
            leftImage = new Image(textures.getTexture("change_role1.png"));
            this.addChild(leftImage);
            leftImage.scale = 0.8;
            p1head = new Image(Game.getHeadImage(p1array[0].targetName));
            this.addChild(p1head);
            p1head.width = 28;
            p1head.height = 28;
            p1head.y = 2;
            p1head.x = leftImage.width - 36;
            _leftImage = leftImage;
         }
         if(p2array.length > 0)
         {
            rightImage = new Image(textures.getTexture("change_role2.png"));
            this.addChild(rightImage);
            rightImage.scale = 0.8;
            rightImage.x = stage.stageWidth - rightImage.width;
            p2head = new Image(Game.getHeadImage(p2array[0].targetName));
            this.addChild(p2head);
            p2head.width = 28;
            p2head.height = 28;
            p2head.y = 2;
            p2head.x = rightImage.x + 4;
            _rightImage = rightImage;
         }
      }
      
      public function update() : void
      {
         if(_leftImage)
         {
            _leftImage.visible = p1array.length > 0;
            p1head.visible = _leftImage.visible;
            if(p1head.visible)
            {
               p1head.texture = Game.getHeadImage(p1array[0].targetName);
            }
         }
         if(_rightImage)
         {
            _rightImage.visible = p2array.length > 0;
            p2head.visible = _rightImage.visible;
            if(p2head.visible)
            {
               p2head.texture = Game.getHeadImage(p2array[0].targetName);
            }
         }
      }
   }
}

