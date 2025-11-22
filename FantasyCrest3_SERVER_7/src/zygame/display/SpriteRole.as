package zygame.display
{
   import nape.geom.Vec2;
   import nape.phys.BodyType;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.textures.Texture;
   import zygame.ai.AiHeart;
   import zygame.core.DataCore;
   import zygame.data.RoleAttributeData;
   import zygame.data.RoleFrame;
   
   public class SpriteRole extends BaseRole
   {
      
      private var _texture:Texture;
      
      private var _image:Image;
      
      public function SpriteRole(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         var aiTag:String = null;
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         _texture = DataCore.getTexture(roleTarget);
         if(!_texture)
         {
            throw new Error("精灵表角色" + roleTarget + "不存在有效的纹理数据");
         }
         var roleXml:XML = DataCore.assetsRole.getXmlData(roleTarget);
         _image = new Image(_texture);
         this.addChild(_image);
         draw(true);
         try
         {
            aiTag = String(this.roleXmlData.xml.@ai);
            aiTag = aiTag.substr(0,aiTag.indexOf("."));
            if(DataCore.getXml(aiTag))
            {
               this.setAi(new AiHeart(this,DataCore.getXml(aiTag)));
            }
            else
            {
               this.setAi(new AiHeart(this,DataCore.getXml("ordinary")));
            }
         }
         catch(e:Error)
         {
            this.setAi(new AiHeart(this,DataCore.getXml("ordinary")));
            trace("无AI索引");
         }
         this.createBody(null);
      }
      
      override public function go(i:int) : void
      {
         this.roleXmlData.updateActionTexture(actionName,currentFrame,_image,_texture);
         super.go(i);
      }
      
      override public function createBody(vertice:Vector.<Vec2>, type:BodyType = null) : void
      {
         super.createBody(vertice,type);
         if(roleXmlData.bodyVec.length > 3)
         {
            createBodyVec(roleXmlData.bodyVec);
            this.body.userData.noFight = true;
         }
      }
      
      override public function onShapeChange() : void
      {
         var pFrame:RoleFrame = null;
         if(!isPlay)
         {
            return;
         }
         if(actionName == "普通攻击")
         {
         }
         if(!roleXmlData.currentRoleFrame || roleXmlData.currentRoleFrame.group.name != actionName || roleXmlData.currentRoleFrame.at != currentFrame)
         {
            roleXmlData.updateActionTexture(actionName,currentFrame,_image,_texture);
         }
         if(this.attribute.hp == 0 && actionName == "起身")
         {
            currentFrame = 0;
         }
         else
         {
            pFrame = roleXmlData.getFrameAt(actionName,currentFrame);
            if(pFrame && pFrame.isHitMapGoOn)
            {
               if(jumpMath > 0)
               {
                  jumpMath = 0;
               }
            }
            if(!pFrame || (!pFrame.isHitMapGoOn || isHitMap()))
            {
               if(currentFrame >= roleXmlData.getActionLength(actionName) - 1)
               {
                  if(!isInjured())
                  {
                     if(actionName == "普通攻击")
                     {
                        trace("中断！");
                     }
                     currentFrame = 0;
                     if(isLock)
                     {
                        this.breakAction();
                     }
                  }
                  else
                  {
                     currentFrame = roleXmlData.getActionLength(actionName) - 1;
                  }
               }
               else
               {
                  currentFrame++;
               }
            }
         }
         if(currentFrame == roleXmlData.getActionLength(actionName) - 1 && this.isAllowUnJumpAction)
         {
            this.isAllowUnJumpAction = "";
         }
         super.onShapeChange();
      }
      
      override public function get display() : DisplayObject
      {
         return this._image;
      }
   }
}

