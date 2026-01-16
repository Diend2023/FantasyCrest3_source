package zygame.display
{
   import flash.utils.Dictionary;
   import nape.dynamics.Arbiter;
   import nape.dynamics.InteractionFilter;
   import nape.geom.Geom;
   import nape.geom.GeomPoly;
   import nape.geom.GeomPolyList;
   import nape.geom.Ray;
   import nape.geom.RayResult;
   import nape.geom.Vec2;
   import nape.phys.Body;
   import nape.phys.BodyList;
   import nape.phys.BodyType;
   import nape.phys.Material;
   import nape.shape.Polygon;
   import starling.utils.rad2deg;
   import zygame.core.GameCore;
   import zygame.tmx.Map;
   
   public class BodyDisplayObject extends KeyDisplayObject
   {
      
      public var bodyCache:Dictionary;
      
      public var speedScale:Number = 1;
      
      private var _body:Body;
      
      private var _isHit:Boolean = false;
      
      private var _isAcceptOne:Boolean = false;
      
      private var _grav:Boolean = false;
      
      public function BodyDisplayObject()
      {
         super();
         bodyCache = new Dictionary();
      }
      
      public function hitTestAtMap(body:Body) : Vector.<Body>
      {
         var bodyPresseds:Vector.<Body> = new Vector.<Body>();
         var bodiesUnderMouse:BodyList = new BodyList();
         bodiesUnderMouse = GameCore.currentWorld.nape.bodiesInBody(body);
         bodiesUnderMouse.foreach(function(body2:Body):void
         {
            if(body2 != body && (body2.userData.ref is Map || body2.userData.ref is Actor))
            {
               if((body2.userData.ref as BodyDisplayObject).isCanHit)
               {
                  bodyPresseds.push(body2);
               }
            }
         });
         if(bodyPresseds.length == 0)
         {
            return null;
         }
         return bodyPresseds;
      }
      
      public function isHitGround(body2:Body) : Boolean
      {
         var testBody:Body = null;
         var d:int = 0;
         var yd:* = 0;
         var c:int = 0;
         var d2:int = 0;
         var a:int = 0;
         var arbiter:Arbiter = null;
         var cheakVec2:Vec2 = null;
         var r:int = 0;
         var v:Vector.<Body> = this.hitTestAtMap(body2);
         if(v)
         {
            testBody = null;
            d = 99;
            yd = 99;
            for(c = 0; c < v.length; )
            {
               d2 = Geom.distanceBody(v[c],body,new Vec2(),new Vec2());
               if(d >= Math.abs(d2) || !testBody)
               {
                  testBody = v[c];
                  d = Math.abs(d2);
                  yd = d2;
               }
               c++;
            }
            if(testBody.userData.isThrough && yd < -1)
            {
               return false;
            }
            a = 0;
            while(a < testBody.arbiters.length)
            {
               arbiter = testBody.arbiters.at(a);
               if(body == arbiter.body1 || body == arbiter.body2)
               {
                  cheakVec2 = arbiter.collisionArbiter.normal.copy();
                  if(arbiter.body2.userData.isThrough)
                  {
                     cheakVec2.x *= -1;
                     cheakVec2.y *= -1;
                  }
                  r = rad2deg(arbiter.collisionArbiter.normal.angle);
                  arbiter.collisionArbiter;
                  if(arbiter.body1 != this.body || r < -20 && r > -130)
                  {
                     return false;
                  }
               }
               a++;
            }
            return true;
         }
         return false;
      }
      
      public function hitTestPosAtMap(posX:Number, posY:Number, andActor:Boolean = true) : Body
      {
         var bodyPressed:Body;
         var point:Vec2 = new Vec2(posX,posY);
         var bodiesUnderMouse:BodyList = GameCore.currentWorld.nape.bodiesUnderPoint(point);
         bodiesUnderMouse.foreach(function(body2:Body):void
         {
            var mode:String = null;
            if(body2.userData.ref is Map || body2.userData.ref is Actor && andActor)
            {
               mode = body2.userData.texture.mode;
               if((body2.userData.ref as BodyDisplayObject).isCanHit && mode == "not_penetrate")
               {
                  bodyPressed = body2;
               }
            }
         });
         return bodyPressed;
      }
      
      override public function setX(i:int) : void
      {
         if(body && body.type != BodyType.STATIC)
         {
            body.position.x = i;
         }
         super.setX(i);
      }
      
      override public function setY(i:int) : void
      {
         if(body && body.type != BodyType.STATIC)
         {
            body.position.y = i;
         }
         super.setY(i);
      }
      
      public function addX(i:int) : void
      {
         setX(body.position.x + i);
      }
      
      public function addY(i:int) : void
      {
         setY(body.position.y + i);
      }
      
      public function set posx(i:int) : void
      {
         setX(i);
      }
      
      public function get posx() : int
      {
         return this.x;
      }
      
      public function set posy(i:int) : void
      {
         setY(i);
      }
      
      public function get posy() : int
      {
         return this.y;
      }
      
      public function ray(putPoint:Vec2) : int
      {
         if(!body.space)
         {
            return 8096;
         }
         body.position.x = 0;
         body.position.y = 0;
         var r:Ray = new Ray(new Vec2(this.x,this.y),putPoint);
         var rRst:RayResult = body.space.rayCast(r,false,new InteractionFilter(8,2));
         body.position.x = this.x;
         body.position.y = this.y;
         if(!rRst)
         {
            return 8096;
         }
         var i:int = rRst.distance;
         rRst.dispose();
         return i;
      }
      
      public function rayResult(putPoint:Vec2) : RayResult
      {
         body.position.x = 0;
         body.position.y = 0;
         body.shapes.at(0).filter.collisionGroup = 0;
         var r:Ray = new Ray(new Vec2(this.x,this.y),putPoint);
         var rRst:RayResult = body.space.rayCast(r,true,new InteractionFilter());
         body.position.x = this.x;
         body.position.y = this.y;
         return rRst;
      }
      
      public function removeBody(pbody:Body = null) : void
      {
         if(!pbody)
         {
            pbody = this.body;
         }
         if(pbody)
         {
            clearBodyAttr(pbody);
            if(pbody.space)
            {
               pbody.space.bodies.remove(pbody);
            }
            if(pbody == this._body)
            {
               this._body = null;
            }
         }
      }
      
      public function onBodyFilter(filter:InteractionFilter) : void
      {
      }
      
      public function findBodyCache(key:String) : Body
      {
         return bodyCache[key];
      }
      
      public function pushBodyCache(key:String, body:Body) : void
      {
         bodyCache[key] = body;
      }
      
      public function getBodyKey(vertice:Vector.<Vec2>) : String
      {
         var i:int = 0;
         var key:String = "";
         for(i = vertice.length - 1; i >= 0; )
         {
            key += vertice[i].x + "_" + vertice[i].y + "_";
            i--;
         }
         return key;
      }
      
      public function createBody(vertice:Vector.<Vec2>, type:BodyType = null) : void
      {
         var key:String;
         var pbody:Body;
         var polygon:GeomPoly;
         var polyShapeList:GeomPolyList;
         if(this.scaleX == 0 || this.scaleY == 0)
         {
            return;
         }
         if(vertice && vertice.length < 3)
         {
            return;
         }
         key = this.getBodyKey(vertice);
         this.removeBody();
         pbody = findBodyCache(key);
         if(!pbody)
         {
            if(!type)
            {
               type = BodyType.DYNAMIC;
            }
            polygon = new GeomPoly(vertice);
            pbody = new Body(type);
            polyShapeList = polygon.convexDecomposition();
            polyShapeList.foreach(function(shape:*):void
            {
               var polygon:Polygon = new Polygon(shape);
               polygon.material = createMaterial();
               onBodyFilter(polygon.filter);
               pbody.shapes.push(polygon);
            });
            if(!isNaN(this.x) && !isNaN(this.y))
            {
               pbody.position.x = this.posx;
               pbody.position.y = this.posy;
            }
            pbody.gravMass = _grav ? 1 : 0;
            pbody.allowRotation = false;
            pbody.isBullet = true;
            pbody.scaleShapes(this.scaleX,this.scaleY);
            this.pushBodyCache(key,pbody);
         }
         else if(!isNaN(this.x) && !isNaN(this.y))
         {
            pbody.position.x = this.posx;
            pbody.position.y = this.posy;
         }
         this._body = pbody;
         this.body.userData.ref = this;
         this.body.userData.noHit = true;
         this.body.rotation = this.rotation;
         pbody.space = world.nape;
         isCanHit = _isHit;
      }
      
      public function set isGravMode(b:Boolean) : void
      {
         if(body)
         {
            body.gravMass = b ? 1 : 0;
         }
         _grav = true;
      }
      
      public function get isGravMode() : Boolean
      {
         return _grav;
      }
      
      public function createMaterial() : Material
      {
         return new Material(0,1,2);
      }
      
      public function set isCanMove(b:Boolean) : void
      {
         if(this.body)
         {
            this.body.allowMovement = b;
         }
      }
      
      public function set isCanHit(b:Boolean) : void
      {
         this._isHit = b;
         if(this.body)
         {
            this.body.userData.noHit = !b;
         }
      }
      
      public function set isThrough(b:Boolean) : void
      {
         if(this.body)
         {
            this.body.userData.isThrough = b;
         }
      }
      
      public function get isThrough() : Boolean
      {
         if(this.body)
         {
            return this.body.userData.isThrough;
         }
         return false;
      }
      
      public function get isCanHit() : Boolean
      {
         if(!this.body)
         {
            return _isHit;
         }
         return this.body.userData.noHit != true;
      }
      
      public function set acceptOne(bool:Boolean) : void
      {
         _isAcceptOne = bool;
      }
      
      public function get acceptOne() : Boolean
      {
         return _isAcceptOne;
      }
      
      public function get body() : Body
      {
         return _body;
      }
      
      public function set body(pBody:Body) : void
      {
         _body = pBody;
      }
      
      public function xMove(xz:Number) : void
      {
         if(isNaN(xz))
         {
            return;
         }
         if(this.body)
         {
            this.body.velocity.x = xz * 60 * speedScale;
         }
         else
         {
            this.x += xz * speedScale;
         }
      }
      
      public function yMove(yz:Number) : void
      {
         if(isNaN(yz))
         {
            return;
         }
         if(this.body)
         {
            this.body.velocity.y = yz * 60 * speedScale;
         }
         else
         {
            this.y += yz * speedScale;
         }
      }
      
      public function clearBodyAttr(body2:Body) : void
      {
         if(body2)
         {
            for(var i in body2.userData)
            {
               body2.userData[i] = null;
               delete body2.userData[i];
            }
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(bodyCache)
         {
            for(var i in bodyCache)
            {
               clearBodyAttr(bodyCache[i]);
               delete bodyCache[i];
            }
         }
         if(_body)
         {
            clearBodyAttr(_body);
            _body.space = null;
         }
         this._body = null;
      }
   }
}

