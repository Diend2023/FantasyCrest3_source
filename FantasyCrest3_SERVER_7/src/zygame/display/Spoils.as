package zygame.display
{
   import nape.phys.Body;
   import nape.phys.BodyType;
   import nape.phys.Material;
   import nape.shape.Polygon;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.textures.Texture;
   import starling.utils.deg2rad;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   import zygame.data.ItemPropsData;
   import zygame.data.RoleAttributeData;
   import zygame.data.SpoilsRefresh;
   
   public class Spoils extends BodyDisplayObject
   {
      
      public static var defaultTextureAtlasName:String = "props";
      
      public static var addPropFunc:Function;
      
      public static var defaultClass:Class = Spoils;
      
      private var _world:World;
      
      public var isPickUp:Boolean = false;
      
      public var isHitMap:Boolean = false;
      
      private var _moveY:int = 0;
      
      private var _propsData:ItemPropsData;
      
      private var _attridute:RoleAttributeData;
      
      public var display:Image;
      
      public function Spoils(world:World, attridute:RoleAttributeData, xz:int, yz:int, target:String, isNew:Boolean = false, count:int = 1, extendData:Object = null)
      {
         super();
         targetName = target;
         _attridute = attridute;
         _propsData = new ItemPropsData(DataCore.props.queryAll(targetName),count,extendData);
         _world = world;
         this.x = xz;
         this.y = yz;
         if(this.x < 50)
         {
            this.x = 50;
         }
         if(this.x > GameCore.currentWorld.map.getWidth() - 50)
         {
            this.x = GameCore.currentWorld.map.getWidth() - 50;
         }
         this.createSpoilsBody();
         if(isNew)
         {
            this.body.velocity.y = -150 + Math.random() * -150;
         }
      }
      
      override public function onInit() : void
      {
         create(DataCore.assetsSwf.otherAssets.getTextureAtlas(defaultTextureAtlasName).getTextures(targetName)[0]);
      }
      
      public function create(texture:Texture) : void
      {
         var image:Image = new Image(texture);
         this.addChild(image);
         image.alignPivot();
         image.width = 20;
         image.height = 20;
         display = image;
         var tw:Tween = new Tween(image,1);
         tw.animate("rotation",deg2rad(15));
         tw.reverse = true;
         tw.repeatCount = 9999;
         Starling.juggler.add(tw);
      }
      
      private function createSpoilsBody() : void
      {
         var box:Body = new Body(BodyType.DYNAMIC);
         var mate:Material = Material.sand();
         mate.density = 1;
         var p:Polygon = new Polygon(Polygon.rect(-5,-5,10,10));
         p.material = mate;
         box.shapes.add(p);
         box.space = _world.nape;
         box.allowRotation = false;
         box.rotation = 0;
         box.position.x = this.x;
         box.position.y = this.y;
         this.body = box;
         this.body.gravMass = 0;
         this.body.userData.ref = this;
      }
      
      override public function onFrame() : void
      {
         this.body.velocity.x += -this.body.velocity.x;
         this.body.velocity.x = int(this.body.velocity.x);
         _moveY = this.body.velocity.y;
         this.body.velocity.y += 18;
         this.x = this.body.position.x;
         this.y = this.body.position.y;
         if(isPickUp)
         {
            this.body.velocity.x = 0;
            this.alpha -= 0.05;
            if(this.alpha <= 0)
            {
               this.discarded();
            }
         }
         else if(!isHitMap && this.hitTestAtMap(body) || this.body.velocity.y > 0)
         {
            hitend();
         }
      }
      
      public function pickUp(role:BaseRole) : void
      {
         if(!isPickUp)
         {
            if(isHitMap)
            {
               if(addPropFunc != null)
               {
                  if(addPropFunc(_propsData))
                  {
                     isPickUp = true;
                     this.body.velocity.y = -50;
                     SpoilsRefresh.singleton.remove(this.name);
                     return;
                  }
               }
               else
               {
                  if(_propsData.name == "金币")
                  {
                     isPickUp = true;
                     this.body.velocity.y = -50;
                     SpoilsRefresh.singleton.remove(this.name);
                     GameCore.scriptCore.addGold(this._attridute.gold);
                     return;
                  }
                  if(DataCore.props.add(_propsData))
                  {
                     isPickUp = true;
                     this.body.velocity.y = -50;
                     SpoilsRefresh.singleton.remove(this.name);
                     return;
                  }
               }
            }
            this.body.velocity.x = this.x > role.x ? 150 : -150;
            this.body.velocity.y = -50;
         }
      }
      
      override public function discarded() : void
      {
         this.body.space.bodies.remove(body);
         this.parent.removeChild(this);
         GameCore.currentWorld.remove(this);
      }
      
      public function get data() : Object
      {
         return {
            "x":this.x,
            "y":this.y,
            "name":this.name,
            "targetName":targetName,
            "roleTarget":this._attridute.target
         };
      }
      
      public function hitend() : void
      {
         isHitMap = true;
      }
   }
}

