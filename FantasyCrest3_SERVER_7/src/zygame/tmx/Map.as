package zygame.tmx
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import io.arkeus.tiled.TiledLayer;
   import io.arkeus.tiled.TiledMap;
   import io.arkeus.tiled.TiledObject;
   import io.arkeus.tiled.TiledObjectLayer;
   import nape.geom.GeomPoly;
   import nape.geom.GeomPolyList;
   import nape.geom.Vec2;
   import nape.phys.Body;
   import nape.phys.BodyType;
   import nape.phys.Material;
   import nape.shape.Polygon;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.rendering.Painter;
   import starling.textures.Texture;
   import starling.utils.deg2rad;
   import starling.utils.rad2deg;
   import zygame.core.DataCore;
   import zygame.core.GameCore;
   import zygame.core.MonsterRefresh;
   import zygame.data.GameEXPData;
   import zygame.debug.Debug;
   import zygame.display.Actor;
   import zygame.display.BaseRole;
   import zygame.display.BodyDisplayObject;
   import zygame.display.DisplayObjectContainer;
   import zygame.display.DragonActor;
   import zygame.display.EffectDisplay;
   import zygame.display.EventDisplay;
   import zygame.display.World;
   import zygame.utils.PointUtils;
   import zygame.utils.VertexUtils;
   
   public class Map extends BodyDisplayObject
   {
      
      public static const JOIN_DRAW:String = "jojn_draw";
      
      public static const A_DRAW:String = "a_draw";
      
      public static var drawType:String = "a_draw";
      
      private var _height:int = 0;
      
      private var _width:int = 0;
      
      private var _tmxData:TiledMap;
      
      private var _effectPid:int = 0;
      
      private var _mapSprite:Dictionary;
      
      private var _index:int = 0;
      
      private var _extendData:Object;
      
      private var _npc:Vector.<Actor>;
      
      private var _events:Vector.<EventDisplay>;
      
      private var _topLayer:Sprite;
      
      private var _bottomLayer:Sprite;
      
      private var _interactive:ActorLayer;
      
      private var _npcSprite:ActorLayer;
      
      private var _roleSprite:ActorLayer;
      
      private var _mapLayer:Vector.<MapLayer>;
      
      private var _eventLayer:Sprite;
      
      private var _lv:int = 1;
      
      private var _mapCanvesVector:Vector.<MapCanvas>;
      
      public var actorLayers:Vector.<ActorLayer>;
      
      private var _style:MapStyle;
      
      public function Map(xml:XML, world:World)
      {
         super();
         if(xml == null)
         {
            trace("XML资源无法读取");
            return;
         }
         this.world = world;
         _lv = int(xml.@lv) - 1;
         if(_lv < 0)
         {
            _lv = 0;
         }
         actorLayers = new Vector.<ActorLayer>();
         _events = new Vector.<EventDisplay>();
         _tmxData = new TiledMap(xml);
         _height = _tmxData.height * _tmxData.tileHeight;
         _width = _tmxData.width * _tmxData.tileWidth;
         if(_tmxData.properties.properties.extend)
         {
            _extendData = JSON.parse(_tmxData.properties.properties.extend);
         }
         _mapSprite = new Dictionary();
         _mapCanvesVector = new Vector.<MapCanvas>();
         _topLayer = new Sprite();
         _topLayer.name = "_topLayer";
         _interactive = new ActorLayer();
         _interactive.name = "_npcLayer";
         _eventLayer = new Sprite();
         _eventLayer.name = "_eventLayer";
         _bottomLayer = new Sprite();
         this.addChildAt(_bottomLayer,0);
         this.addChild(_interactive);
         _mapLayer = new Vector.<MapLayer>();
         drawMap();
         _npcSprite = new ActorLayer();
         _interactive.addChild(_npcSprite);
         _roleSprite = new ActorLayer();
         _interactive.addChild(_roleSprite);
         actorLayers.push(_npcSprite);
         this.addChild(_eventLayer);
         this.addChild(_topLayer);
         if(xml.@texture != undefined && String(xml.@texture) != "<null>")
         {
            this.setMapStyle(MapStyle.formTextureAtlas(xml.@texture,xml.@textureOffsetX,xml.@textureOffsetY));
         }
      }
      
      override public function onInit() : void
      {
         var mw:int = stage.stageWidth;
         var mh:int = stage.stageHeight;
         parsingExtend();
      }
      
      public function setMapStyle(pstyle:MapStyle) : void
      {
         var layer:TiledObjectLayer = null;
         var wenliTag:String = null;
         _style = pstyle;
         if(!_style || !_style.landTexture)
         {
            trace("Map Style 样式缺失纹理");
            return;
         }
         trace("设置样式");
         var obLayer:Vector.<TiledLayer> = _tmxData.layers.getObjectLayers();
         for(var i in obLayer)
         {
            layer = obLayer[i] as TiledObjectLayer;
            for(var o in layer.objects)
            {
               drawDipiObject(layer.name,layer.objects[o]);
            }
            wenliTag = obLayer[i].properties.get("wenli");
            if(wenliTag != null && wenliTag != "")
            {
               setTopTexture(layer.name,_style.textureAtlas.getTextures(wenliTag)[0]);
            }
            else
            {
               setTopTexture(layer.name,_style.surfaceTexture);
            }
         }
      }
      
      private function drawMap() : void
      {
         var layer:TiledObjectLayer = null;
         for(var d in _mapLayer)
         {
            _mapLayer[d].removeSylte();
         }
         var obLayer:Vector.<TiledLayer> = _tmxData.layers.getObjectLayers();
         for(var i in obLayer)
         {
            layer = obLayer[i] as TiledObjectLayer;
            for(var o in layer.objects)
            {
               parsing(layer.name,layer.objects[o]);
            }
         }
         this.createBorder(0,-this.getHeight() / 2,5,this.getHeight() * 4);
         this.createBorder(this.getWidth(),-this.getHeight() / 2,5,this.getHeight() * 4);
      }
      
      public function get eventDisplays() : Vector.<EventDisplay>
      {
         return _events;
      }
      
      private function parsingExtend() : void
      {
         var data2:Object = null;
         var eventSprite:EventDisplay = null;
         var layers:Array = null;
         var layerOb:Object = null;
         var addto:Sprite = null;
         var mapaddto:MapLayer = null;
         if(!_extendData)
         {
            return;
         }
         var events:Object = _extendData.version ? _extendData._eventSprite : _extendData.events;
         for(var ei in events)
         {
            data2 = events[ei];
            eventSprite = new EventDisplay(data2);
            eventSprite.world = world;
            _events.push(eventSprite);
            _eventLayer.addChild(eventSprite);
            world.addUpdateList(eventSprite);
         }
         _npc = new Vector.<Actor>();
         if(_extendData.version)
         {
            layers = _extendData.layers;
            for(var layeri in layers)
            {
               layerOb = layers[layeri];
               if(layerOb.type == "scenery")
               {
                  addto = this.getChildByName(layerOb.id) as Sprite;
                  if(!addto)
                  {
                     addto = new Sprite();
                     addto.name = layerOb.id;
                  }
                  parsingScenery(_extendData[layerOb.id],addto);
                  this.addChildAt(addto,0);
               }
               else if(layerOb.type == "npc")
               {
                  parsingNpc(layerOb.id,_extendData[layerOb.id],true);
               }
               else if(layerOb.type == "map")
               {
                  mapaddto = this.getMapLayerFormName(layerOb.id == "_mapLayer" ? "hit_layer" : layerOb.id);
                  this.addChildAt(mapaddto,0);
               }
            }
         }
         else
         {
            parsingNpc(null,_extendData.npc);
            parsingScenery(_extendData.scenerySprites,_topLayer);
            parsingScenery(_extendData.scenerySpritesBottom,_bottomLayer);
         }
      }
      
      public function get eventLayer() : Sprite
      {
         return _eventLayer;
      }
      
      private function parsingScenery(scenerys:Object, addto:starling.display.DisplayObjectContainer) : void
      {
         var ob2:Object = null;
         var pXml:XML = null;
         var xmlList:XMLList = null;
         var pClass:Class = null;
         var pname:String = null;
         var actorFrame:int = 0;
         var actor:Actor = null;
         var curXml:XML = null;
         var texture:Texture = null;
         var frame:Rectangle = null;
         var image2:Image = null;
         for(var scenery2 in scenerys)
         {
            ob2 = scenerys[scenery2];
            pXml = DataCore.getXml(ob2.target);
            xmlList = pXml.children();
            pClass = null;
            pname = ob2.name;
            if(pname.indexOf(".") != -1)
            {
               pname = pname.substr(0,pname.lastIndexOf("."));
            }
            if(pXml["class"] != undefined)
            {
               pClass = GameCore.currentCore.getClass(pXml["class"]);
            }
            if(pClass && pClass[pname])
            {
               actorFrame = int(DataCore.getTextureAtlas(ob2.target).getNames("").indexOf(ob2.name));
               if(actorFrame != -1)
               {
                  actor = new pClass[pname](ob2.target);
                  actor.world = this.world;
                  applyDisplay(actor,ob2);
                  actor.rootData = ob2;
                  actor.gotoAndStop(actorFrame);
                  addto.addChild(actor);
                  _npc.push(actor);
               }
            }
            else
            {
               curXml = getXmlFindName(xmlList,ob2.name);
               texture = DataCore.getTextureAtlas(ob2.target).getTexture(ob2.name);
               frame = DataCore.getTextureAtlas(ob2.target).getFrame(ob2.name);
               if(texture)
               {
                  image2 = new Image(texture);
                  addto.addChild(image2);
                  applyDisplay(image2,ob2);
               }
            }
         }
      }
      
      private function getXmlFindName(xml:XMLList, findName:String) : XML
      {
         for(var i in xml)
         {
            if(String(xml[i].@name) == findName)
            {
               return xml[i];
            }
         }
         return null;
      }
      
      private function parsingNpc(id:String, npcData:Object, resetPoint:Boolean = false) : void
      {
         var data:Object = null;
         var identification:String = null;
         var pclass:Class = null;
         var prole:BaseRole = null;
         var xml:XML = null;
         var addto:Sprite = world.map.roleLayer;
         if(id)
         {
            if(id == "_npcLayer")
            {
               addto = _npcSprite;
               if(resetPoint)
               {
                  this.addChildAt(addto.parent,0);
               }
            }
            else
            {
               addto = this.getChildByName(id) as Sprite;
            }
            if(!addto)
            {
               addto = new ActorLayer();
               addto.name = id;
               actorLayers.push(addto);
               if(resetPoint)
               {
                  this.addChildAt(addto,0);
               }
            }
         }
         for(var npc in npcData)
         {
            data = npcData[npc];
            if(!data.noChange && DataCore.fightData.hasData(data.name) && world.worldType == "adventure")
            {
               identification = data.name + "_" + world.targetName + "_" + npc;
               if(MonsterRefresh.singleton.resurrection(identification))
               {
                  pclass = DataCore.assetsRole.getClass(data.name);
                  prole = new pclass(data.name,data.x,data.y,world,24,data.scaleX);
                  prole.scaleX = data.scaleX > 0 ? 1 : -1;
                  prole.ai = !Debug.UNAI;
                  prole.rootData = data;
                  world.addRole(prole);
                  prole.id = int(npc);
                  prole.attribute.exp = GameEXPData.exp(_lv,50);
                  prole.restoreHP(1);
                  prole.name = data.instanceName;
               }
            }
            else
            {
               xml = DataCore.getXml(data.name);
               if(xml)
               {
                  addXMLNpc(xml,data,addto);
               }
               else
               {
                  addDargonNpc(data,addto);
               }
            }
         }
      }
      
      public function addDargonNpc(data:Object, addto:Sprite = null) : void
      {
         var dragon:DragonActor = null;
         var a:Object = DataCore.getJSON(data.name + "_ske");
         if(a == null)
         {
            throw new Error("错误：不存在" + data.name + "的龙骨资源，请检查npc目录下的索引命名是否正确。");
         }
         var pClass:Class = Actor.defaultDragonClass ? Actor.defaultDragonClass : DragonActor;
         var classStr:String = a["class"];
         if(classStr)
         {
            pClass = GameCore.currentCore.getClass(classStr);
         }
         try
         {
            dragon = new pClass(data.name);
            pushActor(dragon,data,addto);
         }
         catch(e:Error)
         {
            trace("NPC类没有定义：",data.name,":",classStr);
         }
      }
      
      public function addXMLNpc(xml:XML, data:Object, addto:Sprite = null) : void
      {
         var pnpcClass:Class = null;
         if(xml["class"] != undefined)
         {
            pnpcClass = GameCore.currentCore.getClass(xml["class"]);
         }
         if(!pnpcClass)
         {
            pnpcClass = Actor.defaultSpriteClass ? Actor.defaultSpriteClass : Actor;
         }
         pushActor(new pnpcClass(data.name),data,addto);
      }
      
      public function pushActor(npcActor:Actor, data:Object, addto:Sprite = null) : void
      {
         npcActor.x = data.x;
         npcActor.y = data.y;
         npcActor.scaleX = data.scaleX;
         npcActor.scaleY = data.scaleY;
         if(data.blendMode)
         {
            npcActor.blendMode = data.blendMode;
         }
         npcActor.rootData = data;
         npcActor.setPolt(data.poltData);
         _npc.push(npcActor);
         npcActor.world = this.world;
         (addto ? addto : _npcSprite).addChild(npcActor);
      }
      
      public function get npcSprite() : ActorLayer
      {
         return _npcSprite;
      }
      
      public function removeActor(actor:Actor) : void
      {
         _npc.removeAt(_npc.indexOf(actor));
         if(actor.parent)
         {
            actor.discarded();
            actor.onFrameAfter();
         }
      }
      
      public function addRole(role:BaseRole) : void
      {
         _roleSprite.addChild(role);
      }
      
      private function applyDisplay(display:DisplayObject, ob:Object) : void
      {
         var img:Image = null;
         display.x = ob.x;
         display.y = ob.y;
         display.scaleX = ob.scaleX;
         display.scaleY = ob.scaleY;
         if(ob.pingpu && display is Image)
         {
            img = display as Image;
            img.textureRepeat = true;
            img.tileGrid = new Rectangle();
         }
         display.rotation = deg2rad(ob.rotation);
      }
      
      private function parsing(id:String, tiledObject:TiledObject) : void
      {
         if(tiledObject.points)
         {
            this.drawPointObject(id,tiledObject);
         }
      }
      
      private function createBorder(xz:int, yz:int, wz:int, hz:int) : void
      {
         var pbody:Body = new Body(BodyType.STATIC,new Vec2(xz,yz));
         var po:Polygon = new Polygon(Polygon.box(wz,hz));
         po.material = new Material(0,0,2,1);
         pbody.userData.ref = this;
         pbody.shapes.push(po);
         pbody.space = world.nape;
      }
      
      private function drawPointObject(id:String, tiledObject:TiledObject) : void
      {
         createMapBody(id,tiledObject);
      }
      
      public function createMapBody(id:String, tiledObject:TiledObject) : void
      {
         var i:int;
         var polygon:GeomPoly;
         var pbody:Body;
         var polyShapeList:GeomPolyList;
         var mapCanvas:MapCanvas;
         var xz:int = tiledObject.x;
         var yz:int = tiledObject.y;
         var points:Vector.<Point> = tiledObject.points;
         var vertice:Vector.<Vec2> = new Vector.<Vec2>();
         for(i = 0; i < points.length; )
         {
            vertice.push(new Vec2(points[i].x,points[i].y));
            i = i + 1;
         }
         polygon = new GeomPoly(vertice);
         pbody = new Body(BodyType.STATIC);
         polyShapeList = polygon.convexDecomposition();
         pbody.position.x = xz;
         pbody.position.y = yz;
         mapCanvas = new MapCanvas(tiledObject.properties.get("mode"));
         polyShapeList.foreach(function(shape:*):void
         {
            var m:int = 0;
            var v:Vec2 = null;
            var polygon:Polygon = new Polygon(shape);
            polygon.material = new Material(0,0.8,1,1);
            polygon.filter.collisionGroup = 2;
            pbody.shapes.push(polygon);
            var len:int = polygon.localVerts.length;
            var arr:Array = [];
            for(m = 0; m < len; )
            {
               v = polygon.localVerts.at(m);
               arr.push(new Point(v.x,v.y));
               m++;
            }
            mapCanvas.beginFill(0);
            mapCanvas.drawPolygon(new MapPolygon(arr));
         });
         mapCanvas.x = xz;
         mapCanvas.y = yz;
         mapCanvas.world = world;
         if(mapCanvas.parent == null)
         {
            this.getMapLayerFormName(id).addCanvas(mapCanvas);
         }
         pbody.space = world.nape;
         this.body = pbody;
         this.body.userData.ref = this;
         this.body.userData.texture = mapCanvas;
         this.body.userData.isThrough = false;
         mapCanvas.body = this.body;
         switch(tiledObject.properties.get("mode"))
         {
            case "not_visible_not_penetrate":
               mapCanvas.visible = false;
               break;
            case "not_visible_stes":
               mapCanvas.visible = false;
               this.body.userData.isThrough = true;
               break;
            case "visible_stes":
               this.body.userData.isThrough = true;
               break;
            case "dynamic_visible":
               this.body.userData.isThrough = true;
               _mapCanvesVector.push(mapCanvas);
               break;
            case "not_hit":
               this.body.space = null;
         }
      }
      
      private function drawDipiObject(id:String, ob:TiledObject) : void
      {
         var str:String = null;
         var line:Array = null;
         var allLine:* = undefined;
         var mode:String = ob.properties.get("draw_mode");
         if(!mode || mode == "auto")
         {
            str = ob.properties.get("lines");
            line = str ? JSON.parse(str) as Array : null;
            trace("lines data:",str,line);
            if(line && line.length > 0)
            {
               allLine = getLines(line);
               for(var i in allLine)
               {
                  drawPoint(id,allLine[i],ob.x,ob.y,false,false);
               }
            }
            else
            {
               drawPoint(id,ob.points,ob.x,ob.y);
            }
         }
      }
      
      public function getLines(_lines:Array) : Vector.<Vector.<Point>>
      {
         var i:int = 0;
         var isNew:Boolean = false;
         var isAdd:Boolean = false;
         var addIndex:int = 0;
         var pointOb:Object = null;
         var newv:* = undefined;
         var plist:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
         for(i = 0; i < _lines.length; )
         {
            isNew = true;
            isAdd = false;
            addIndex = -1;
            pointOb = _lines[i];
            for(var i2 in plist)
            {
               if(plist[i2][0].x == pointOb[1].x && plist[i2][0].y == pointOb[1].y)
               {
                  if(isAdd)
                  {
                     plist[addIndex].pop();
                     plist[i2] = plist[addIndex].concat(plist[i2]);
                     plist.removeAt(addIndex);
                  }
                  else
                  {
                     plist[i2].insertAt(0,new Point(pointOb[0].x,pointOb[0].y));
                     isAdd = true;
                     isNew = false;
                     addIndex = int(i2);
                  }
               }
               else if(plist[i2][plist[i2].length - 1].x == pointOb[0].x && plist[i2][plist[i2].length - 1].y == pointOb[0].y)
               {
                  if(isAdd)
                  {
                     plist[i2].pop();
                     plist[addIndex] = plist[i2].concat(plist[addIndex]);
                     plist.removeAt(int(i2));
                  }
                  else
                  {
                     plist[i2].push(new Point(pointOb[1].x,pointOb[1].y));
                     isAdd = true;
                     isNew = false;
                     addIndex = int(i2);
                  }
               }
            }
            if(isNew)
            {
               newv = new Vector.<Point>();
               for(var i3 in pointOb)
               {
                  newv.push(new Point(pointOb[i3].x,pointOb[i3].y));
               }
               plist.push(newv);
            }
            i++;
         }
         return plist;
      }
      
      private function drawPoint(id:String, points:Vector.<Point>, xz:Number, yz:Number, isClock:Boolean = true, isTopRound:Boolean = true) : void
      {
         var i:int = 0;
         var arr:Vector.<Point> = PointUtils.getMinXPoints(isClock ? PointUtils.getClockwisePoints(points) : points);
         var maxIndex:* = 0;
         for(i = 0; i < arr.length; )
         {
            if(arr[i].y < arr[maxIndex].y)
            {
               maxIndex = i;
            }
            i++;
         }
         var toparr:* = isTopRound ? getTopRoundPoints(arr,maxIndex) : arr;
         if(drawType == "a_draw")
         {
            drawDipi2(id,toparr,xz,yz);
         }
         else
         {
            drawDipi(id,toparr,xz,yz);
         }
      }
      
      private function getTopRoundPoints(arr:Vector.<Point>, index:int) : Vector.<Point>
      {
         var v:Vector.<Point> = new Vector.<Point>();
         v.push(arr[index]);
         v = v.concat(getRoundPoint(arr,index,1));
         return getRoundPoint(arr,index,-1).concat(v);
      }
      
      private function getRoundPoint(arr:Vector.<Point>, index:int, add:int) : Vector.<Point>
      {
         var v:Vector.<Point> = new Vector.<Point>();
         var ifv:Point = arr[index];
         index += add;
         while(!(index < 0 || index >= arr.length))
         {
            if(add == 1)
            {
               if(ifv.x >= arr[index].x)
               {
                  break;
               }
               v.push(arr[index]);
               ifv = arr[index];
            }
            else
            {
               if(ifv.x <= arr[index].x)
               {
                  break;
               }
               v.splice(0,0,arr[index]);
               ifv = arr[index];
            }
            index += add;
         }
         return v;
      }
      
      private function drawDipi2(id:String, arr:Vector.<Point>, xz:int, yz:int) : void
      {
         var pointStart:* = null;
         var pointEnd:Point = null;
         var i:int = 0;
         var angle:Number = NaN;
         var image:Image = null;
         var bian:Image = null;
         var oldAngle:* = -1;
         var oneadd:Boolean = true;
         for(i = 0; i < arr.length; )
         {
            if(i == 0)
            {
               pointStart = arr[i];
            }
            else
            {
               pointEnd = arr[i];
               angle = Math.atan2(pointEnd.y - pointStart.y,pointEnd.x - pointStart.x);
               if(Math.abs(rad2deg(angle)) < 80)
               {
                  image = new Image(_style.landTexture);
                  image.textureRepeat = true;
                  image.textureSmoothing = "none";
                  image.alignPivot("left");
                  image.tileGrid = new Rectangle(0,0,image.width,image.height);
                  image.x = xz + pointStart.x + _style.offsetX;
                  image.y = yz + pointStart.y + _style.offsetY;
                  image.width = Point.distance(pointStart,pointEnd);
                  image.rotation = angle;
                  this.getMapLayerFormName(id).addSkin(image);
                  if(_style.roundedLandTexture)
                  {
                     if(i != arr.length - 1)
                     {
                        bian = new Image(_style.roundedLandTexture);
                        bian.textureSmoothing = "none";
                        bian.x = xz + arr[i].x + _style.offsetX;
                        bian.y = yz + arr[i].y + _style.offsetY;
                        bian.alignPivot();
                        bian.rotation = angle;
                        this.getMapLayerFormName(id).addSkin(bian);
                     }
                     if(oneadd)
                     {
                     }
                  }
                  oldAngle = angle;
               }
               pointStart = pointEnd;
            }
            i++;
         }
      }
      
      private function drawDipi(id:String, arr:Vector.<Point>, xz:Number, yz:Number) : void
      {
         var pointStart:* = null;
         var pointEnd:Point = null;
         var lastImage:* = null;
         var i:int = 0;
         var angle:Number = NaN;
         var wz:Number = NaN;
         var imgNum:int = 0;
         var imgi:int = 0;
         var moveLen:Number = NaN;
         var image:Image = null;
         var newwz:Number = NaN;
         trace("绘制点：",arr);
         var oldAngle:* = NaN;
         var oneadd:Boolean = true;
         var lastA:Number = NaN;
         var images:Vector.<Image> = new Vector.<Image>();
         for(i = 0; i < arr.length; )
         {
            if(i == 0)
            {
               pointStart = arr[i];
            }
            else
            {
               pointEnd = arr[i];
               angle = Math.atan2(pointEnd.y - pointStart.y,pointEnd.x - pointStart.x);
               if(Math.abs(rad2deg(angle)) < 80)
               {
                  wz = Point.distance(pointStart,pointEnd);
                  imgNum = wz / _style.landTexture.width;
                  if(wz / _style.landTexture.width > imgNum)
                  {
                     imgNum++;
                  }
                  trace("格子数：",imgNum);
                  for(imgi = 0; imgi < imgNum; )
                  {
                     moveLen = _style.landTexture.width;
                     trace("宽度：",moveLen);
                     image = new Image(_style.landTexture);
                     image.textureSmoothing = "bilinear";
                     if(imgi == imgNum - 1)
                     {
                        newwz = wz - _style.landTexture.width * imgi;
                        VertexUtils.setWidth(image,newwz,0);
                     }
                     image.alignPivot("left");
                     image.x = xz + pointStart.x + _style.offsetX + moveLen * Math.cos(angle) * imgi;
                     image.y = yz + pointStart.y + _style.offsetY + moveLen * Math.sin(angle) * imgi;
                     VertexUtils.rotation(image,angle);
                     if(lastImage != null && lastImage != image)
                     {
                        VertexUtils.join(lastImage,image);
                     }
                     lastImage = image;
                     images.push(image);
                     imgi++;
                  }
                  if(!lastImage)
                  {
                  }
                  oldAngle = angle;
               }
               pointStart = pointEnd;
            }
            i++;
         }
         for(var addi in images)
         {
            this.getMapLayerFormName(id).addSkin(images[addi]);
         }
      }
      
      public function getWidth() : int
      {
         return _width;
      }
      
      public function setWidth(i:int) : void
      {
         _width = i;
      }
      
      public function getHeight() : int
      {
         return _height;
      }
      
      public function setHeight(i:int) : void
      {
         _height = i;
      }
      
      override public function onFrame() : void
      {
         var i2:int = 0;
         var brole:zygame.display.DisplayObjectContainer = null;
         var i3:int = 0;
         for(var i in _npc)
         {
            _npc[i].onFrame();
         }
         for(var i4 in _npc)
         {
            _npc[i4].onFrameAfter();
         }
         var count:int = _roleSprite.numChildren;
         for(i2 = count - 1; i2 >= 0; )
         {
            brole = _roleSprite.getChildAt(i2) as zygame.display.DisplayObjectContainer;
            if(brole && brole.parent)
            {
               brole.onFrame();
               brole.onFrameAfter();
            }
            i2--;
         }
         for(i3 = _mapCanvesVector.length - 1; i3 >= 0; )
         {
            _mapCanvesVector[i3].onFrame();
            i3--;
         }
         this.setRequiresRedraw();
      }
      
      public function getNpcs() : Vector.<Actor>
      {
         return _npc;
      }
      
      override public function discarded() : void
      {
         var i2:int = 0;
         var i:int = 0;
         var i3:int = 0;
         var i4:int = 0;
         trace("Map discarded");
         if(_mapCanvesVector)
         {
            for(i2 = _mapCanvesVector.length - 1; i2 >= 0; )
            {
               _mapCanvesVector[i2].removeFromParent(true);
               i2--;
            }
         }
         if(_mapLayer)
         {
            for(i = _mapLayer.length - 1; i >= 0; )
            {
               _mapLayer[i].removeFromParent(true);
               i--;
            }
         }
         if(_npc)
         {
            for(i3 = _npc.length - 1; i3 >= 0; )
            {
               _npc[i3].discarded();
               i3--;
            }
         }
         if(actorLayers)
         {
            for(i4 = actorLayers.length - 1; i4 >= 0; )
            {
               actorLayers[i4].removeFromParent(true);
               i4--;
            }
         }
         _npc = null;
         _mapLayer = null;
         this._bottomLayer = null;
         this._eventLayer = null;
         this._events = null;
         this._extendData = null;
         this._interactive = null;
         this._mapCanvesVector = null;
         this._mapSprite = null;
         this._tmxData = null;
         this._style = null;
         this._roleSprite = null;
         this._topLayer = null;
         this.actorLayers = null;
         this.world = null;
         this._npcSprite = null;
         super.discarded();
      }
      
      public function addActor(actor:Actor) : void
      {
         _npc.push(actor);
         _npcSprite.addChild(actor);
      }
      
      public function addEffect(skill:EffectDisplay) : void
      {
         _effectPid++;
         skill.pid = _effectPid;
         _roleSprite.addChild(skill);
      }
      
      public function get roleLayer() : ActorLayer
      {
         return _roleSprite;
      }
      
      override public function render(painter:Painter) : void
      {
         try
         {
            super.render(painter);
         }
         catch(e:Error)
         {
            trace("渲染存在问题",e.errorID,e.message);
         }
      }
      
      public function get extendData() : Object
      {
         return _extendData;
      }
      
      public function getMapLayerFormName(id:String) : MapLayer
      {
         var layer:MapLayer = null;
         for(var i in _mapLayer)
         {
            if(_mapLayer[i].name == id)
            {
               layer = _mapLayer[i];
               break;
            }
         }
         if(!layer)
         {
            layer = new MapLayer();
            layer.name = id;
            this.addChildAt(layer,0);
            _mapLayer.push(layer);
         }
         return layer;
      }
      
      protected function setLayerTeuxtre(id:String, texture:Texture) : void
      {
         getMapLayerFormName(id).addBGTexture(texture,this.getWidth(),this.getHeight());
      }
      
      public function setTopTexture(id:String, texture:Texture) : void
      {
         setLayerTeuxtre(id,texture);
      }
   }
}

