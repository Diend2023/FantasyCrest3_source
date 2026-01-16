package zygame.display
{
   import dragonBones.animation.AnimationState;
   import dragonBones.starling.StarlingArmatureDisplay;
   import starling.display.DisplayObject;
   import zygame.ai.AiHeart;
   import zygame.core.DataCore;
   import zygame.data.RoleAttributeData;
   import zygame.utils.RUtils;
   
   public class DragonRole extends BaseRole
   {
      
      private var _display:StarlingArmatureDisplay;
      
      private var _animate:AnimationState;
      
      public var canFadeIn:Boolean = true;
      
      public var fadeArray:Array;
      
      private var _frameCount:int;
      
      public function DragonRole(roleTarget:String, xz:int, yz:int, pworld:World, fps:int = 24, pscale:Number = 1, troop:int = -1, roleAttr:RoleAttributeData = null)
      {
         var ob:Object = null;
         fadeArray = [];
         super(roleTarget,xz,yz,pworld,fps,pscale,troop,roleAttr);
         var roleXml:XML = DataCore.assetsRole.getXmlData(roleTarget);
         if(roleXml)
         {
            if(roleXml.@initName != "" && roleXml.@initName != undefined)
            {
               roleTarget = roleXml.@initName;
            }
            ob = DataCore.getJSON(roleTarget + "_ske");
            roleTarget = ob.armature[0].name;
         }
         createRole(roleTarget);
         if(roleXml.@ai == undefined)
         {
            setAi(new AiHeart(this,DataCore.assetsSwf.otherAssets.getXml("ordinary")));
         }
         else
         {
            setAi(new AiHeart(this,DataCore.getXml(RUtils.getPathName(roleXml.@ai))));
         }
         this.createBody(null);
      }
      
      public function createRole(target:String, skin:String = null) : void
      {
         roleXmlData.parsingAction(target);
         if(_display)
         {
            _display.removeFromParent();
         }
         _display = DataCore.createDragonMovcilp(skin ? skin : target);
         this.addChild(_display);
         _display.animation.play("待机");
         _display.scale = this.contentScale;
      }
      
      override public function onShapeChange() : void
      {
         if(!isPlay || !_display)
         {
            return;
         }
         if(!roleXmlData.currentRoleFrame || roleXmlData.currentRoleFrame.group.name != actionName || roleXmlData.currentRoleFrame.at != currentFrame)
         {
            roleXmlData.updateActionTexture(actionName,currentFrame);
         }
         this.onDraw();
         if(this.attribute.hp == 0 && actionName == "起身")
         {
            currentFrame = 0;
         }
         else if(currentFrame >= _frameCount)
         {
            if(!isInjured())
            {
               currentFrame = 0;
               breakAction();
            }
            else
            {
               currentFrame = _frameCount;
            }
         }
         else
         {
            currentFrame++;
         }
         if(currentFrame == _frameCount && this.isAllowUnJumpAction)
         {
            this.isAllowUnJumpAction = "";
         }
         super.onShapeChange();
      }
      
      override public function onDraw() : void
      {
         super.onDraw();
         if(_display.animation.animationNames.indexOf(actionName) != -1)
         {
            if(actionName != _display.animation.lastAnimationName)
            {
               if(canFadeIn && currentActionLegnth > 1 || fadeArray.indexOf(actionName) != -1 && fadeArray.indexOf(_display.animation.lastAnimationName) != -1)
               {
                  _display.animation.fadeIn(actionName,0.1);
               }
               else
               {
                  _display.animation.play(actionName);
               }
            }
         }
         _animate = _display.animation.lastAnimationState;
         if(!_animate)
         {
            return;
         }
         _frameCount = currentActionLegnth;
         var frameDeyle:Number = (_animate.totalTime - 0.05) / _frameCount;
         _display.armature.advanceTime(frameDeyle);
      }
      
      override public function get currentActionLegnth() : int
      {
         if(!_animate)
         {
            return 0;
         }
         return int(_animate.totalTime / (1 / fps));
      }
      
      override public function go(i:int) : void
      {
         super.go(i);
         this.roleXmlData.updateActionTexture(actionName,currentFrame);
      }
      
      override public function hasAction(str:String) : Boolean
      {
         if(!_display)
         {
            return false;
         }
         return _display.animation.animationNames.indexOf(str) != -1;
      }
      
      override public function onFrame() : void
      {
         super.onFrame();
      }
      
      override public function discarded() : void
      {
         super.discarded();
      }
      
      override public function get display() : DisplayObject
      {
         return _display;
      }
      
      public function get dragonDisplay() : StarlingArmatureDisplay
      {
         return _display as StarlingArmatureDisplay;
      }
      
      override public function dispose() : void
      {
         _display = null;
         super.dispose();
      }
   }
}

