package zygame.data
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   import zygame.display.EffectDisplay;
   import zygame.utils.SoundUtils;
   
   public class SkillXMLData
   {
      
      private var _skill:EffectDisplay;
      
      private var _pointXY:Point;
      
      private var _xml:XMLList;
      
      public var length:int = 0;
      
      public var currentXml:XML;
      
      private var _textures:TextureAtlas;
      
      public var hitEffect:String = null;
      
      public var rootXML:XML;
      
      public function SkillXMLData(target:String, skill:EffectDisplay)
      {
         var pan:Number;
         super();
         _skill = skill;
         rootXML = DataCore.getXml(target);
         if(rootXML == null)
         {
            throw new Error("特效资源目标：" + target + "不存在，请检查是否有进行载入资源。");
         }
         _xml = rootXML.children();
         if(rootXML.@hitEffect != undefined)
         {
            hitEffect = rootXML.@hitEffect;
         }
         _textures = DataCore.getTextureAtlas(target);
         length = _xml.length();
         if(rootXML.@sound != undefined)
         {
            pan = SoundUtils.mathPan(skill.x,skill.y,GameCore.currentWorld.centerX,GameCore.currentWorld.centerY,skill.stage.stageWidth);
            GameCore.soundCore.playEffect(rootXML.@sound,pan,function():Boolean
            {
               if(_skill == null)
               {
                  return true;
               }
               return _skill.parent == null;
            });
         }
         _pointXY = new Point(int(rootXML.@px),int(rootXML.@py));
      }
      
      public function updateActionTexture(frame:int, image:Image) : void
      {
         var pname:String = null;
         var frameRect:Rectangle = null;
         if(length > frame && _xml)
         {
            currentXml = _xml[frame];
            pname = String(_xml[frame].@name);
            frameRect = _textures.getFrame(pname);
            if(!frameRect)
            {
               frameRect = _textures.getRegion(pname);
            }
            image.width = frameRect.width;
            image.height = frameRect.height;
            image.x = _pointXY.x;
            image.y = _pointXY.y;
            image.texture = _textures.getTexture(pname);
         }
      }
      
      public function discarded() : void
      {
         this._skill = null;
         this._textures = null;
         this._xml = null;
         this.currentXml = null;
         this.rootXML = null;
         this._pointXY = null;
      }
   }
}

