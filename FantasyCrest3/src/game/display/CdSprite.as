package game.display
{
   import flash.geom.Rectangle;
   import game.role.GameRole;
   import starling.display.Image;
   import starling.textures.TextureAtlas;
   import zygame.core.DataCore;
   import zygame.data.RoleFrameGroup;
   import zygame.display.BaseRole;
   import zygame.display.BatchContainer;
   
   public class CdSprite extends BatchContainer
   {
      
      public var keyType:String;
      
      private var _wImg:Image;
      
      private var _sImg:Image;
      
      private var _Img:Image;
      
      private var _textureAtlas:TextureAtlas;
      
      private var _cdFrame:Array;
      
      private var _keyFrame:Array;
      
      public var hpmp:HPMP;
      
      private var _cdingArray:Array;
      
      public function CdSprite(key:String)
      {
         super();
         keyType = key;
         _cdingArray = [];
      }
      
      override public function onInit() : void
      {
         var textureAtlas:TextureAtlas = DataCore.getTextureAtlas("hpmp");
         var bg:Image = new Image(textureAtlas.getTexture("key_" + keyType + ".png"));
         this.addChild(bg);
         bg.alignPivot();
         _textureAtlas = textureAtlas;
         _cdFrame = [_textureAtlas.getTexture("cdframe.png"),_textureAtlas.getTexture("cdframe_mp.png")];
         _keyFrame = [textureAtlas.getTexture("cd_" + keyType + ".png"),textureAtlas.getTexture("cd_" + keyType + "_mp.png")];
         var wImg:Image = new Image(textureAtlas.getTexture("cdframe.png"));
         wImg.alignPivot("left","top");
         wImg.x -= wImg.width / 2;
         this.addChild(wImg);
         var sImg:Image = new Image(textureAtlas.getTexture("cdframe.png"));
         sImg.alignPivot("left","top");
         sImg.scaleY = -1;
         sImg.x -= sImg.width / 2;
         this.addChild(sImg);
         var kImg:Image = new Image(textureAtlas.getTexture("cd_" + keyType + ".png"));
         kImg.alignPivot("left");
         kImg.x -= kImg.width / 2;
         kImg.textureRepeat = true;
         kImg.tileGrid = new Rectangle();
         this.addChild(kImg);
         _sImg = wImg;
         _wImg = sImg;
         _Img = kImg;
         _sImg.textureRepeat = true;
         _sImg.tileGrid = new Rectangle();
         _wImg.textureRepeat = true;
         _wImg.tileGrid = new Rectangle();
      }
      
      public function update(role:BaseRole) : void
      {
         updateCD(keyType,role,_Img);
         updateCD("S" + keyType,role,_sImg);
         updateCD("W" + keyType,role,_wImg);
         this.updateDisplay();
      }
      
      private function updateCD(key:String, role:BaseRole, img:Image) : void
      {
         var index:int = 0;
         var group:RoleFrameGroup = role.roleXmlData.getFrameGroupFromKey(key);
         if(key == "L" && !group)
         {
            group = role.roleXmlData.getGroupAt("瞬步");
         }
         if(group)
         {
            img.visible = true;
            img.alpha = 1;
            if(role.attribute.getCD(group.name) == 0)
            {
               img.width = img.texture.width;
               index = int(_cdingArray.indexOf(group.name));
               if(index != -1)
               {
                  _cdingArray.splice(index,1);
               }
            }
            else
            {
               img.width = (1 - role.attribute.getCD(group.name) / role.attribute.getMaxCD(group.name)) * img.texture.width;
               if(_cdingArray.indexOf(group.name) == -1)
               {
                  _cdingArray.push(group.name);
               }
               img.alpha = 0.5;
            }
            if(key.length > 1)
            {
               img.texture = group["mp"] > 0 ? _cdFrame[1] : _cdFrame[0];
            }
            else
            {
               img.texture = group["mp"] > 0 ? _keyFrame[1] : _keyFrame[0];
            }
            if(group["mp"] > (hpmp.role as GameRole).currentMp.value)
            {
               img.alpha = 0.3;
            }
         }
         else
         {
            img.visible = false;
         }
      }
      
      override public function dispose() : void
      {
         this._cdFrame.splice(0,_cdFrame.length);
         _cdFrame = null;
         this._cdingArray.splice(0,this._cdingArray.length);
         _cdingArray = null;
         this._Img = null;
         this._keyFrame.splice(0,this._keyFrame.length);
         this._sImg = null;
         this._textureAtlas = null;
         this._wImg = null;
         this._keyFrame = null;
         super.dispose();
      }
   }
}

