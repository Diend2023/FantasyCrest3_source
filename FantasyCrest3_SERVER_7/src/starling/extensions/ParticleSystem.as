package starling.extensions
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.animation.IAnimatable;
   import starling.display.BlendMode;
   import starling.display.DisplayObject;
   import starling.display.Mesh;
   import starling.rendering.IndexData;
   import starling.rendering.MeshEffect;
   import starling.rendering.Painter;
   import starling.rendering.VertexData;
   import starling.styles.MeshStyle;
   import starling.textures.Texture;
   import starling.utils.MatrixUtil;
   
   [Event(name="complete",type="starling.events.Event")]
   public class ParticleSystem extends Mesh implements IAnimatable
   {
      
      public static const MAX_NUM_PARTICLES:int = 16383;
      
      private static var sHelperMatrix:Matrix = new Matrix();
      
      private static var sHelperPoint:Point = new Point();
      
      private var _effect:MeshEffect;
      
      private var _vertexData:VertexData = new VertexData();
      
      private var _indexData:IndexData = new IndexData();
      
      private var _requiresSync:Boolean;
      
      private var _batchable:Boolean;
      
      private var _particles:Vector.<Particle>;
      
      private var _frameTime:Number;
      
      private var _numParticles:int;
      
      private var _emissionRate:Number;
      
      private var _emissionTime:Number;
      
      private var _emitterX:Number;
      
      private var _emitterY:Number;
      
      private var _blendFactorSource:String;
      
      private var _blendFactorDestination:String;
      
      public function ParticleSystem(texture:Texture = null)
      {
         super(_vertexData,_indexData);
         _particles = new Vector.<Particle>(0,false);
         _frameTime = 0;
         _emitterX = _emitterY = 0;
         _emissionTime = 0;
         _emissionRate = 10;
         _blendFactorSource = "one";
         _blendFactorDestination = "oneMinusSourceAlpha";
         _batchable = false;
         this.capacity = 128;
         this.texture = texture;
         updateBlendMode();
      }
      
      override public function dispose() : void
      {
         _effect.dispose();
         super.dispose();
      }
      
      override public function hitTest(localPoint:Point) : DisplayObject
      {
         return null;
      }
      
      private function updateBlendMode() : void
      {
         var pma:Boolean = texture ? texture.premultipliedAlpha : true;
         if(_blendFactorSource == "one" && _blendFactorDestination == "oneMinusSourceAlpha")
         {
            _vertexData.premultipliedAlpha = pma;
            if(!pma)
            {
               _blendFactorSource = "sourceAlpha";
            }
         }
         else
         {
            _vertexData.premultipliedAlpha = false;
         }
         blendMode = _blendFactorSource + ", " + _blendFactorDestination;
         BlendMode.register(blendMode,_blendFactorSource,_blendFactorDestination);
      }
      
      protected function createParticle() : Particle
      {
         return new Particle();
      }
      
      protected function initParticle(particle:Particle) : void
      {
         particle.x = _emitterX;
         particle.y = _emitterY;
         particle.currentTime = 0;
         particle.totalTime = 1;
         particle.color = Math.random() * 16777215;
      }
      
      protected function advanceParticle(particle:Particle, passedTime:Number) : void
      {
         particle.y += passedTime * 250;
         particle.alpha = 1 - particle.currentTime / particle.totalTime;
         particle.currentTime += passedTime;
      }
      
      private function setRequiresSync() : void
      {
         _requiresSync = true;
      }
      
      private function syncBuffers() : void
      {
         _effect.uploadVertexData(_vertexData);
         _effect.uploadIndexData(_indexData);
         _requiresSync = false;
      }
      
      public function start(duration:Number = 1.7976931348623157e+308) : void
      {
         if(_emissionRate != 0)
         {
            _emissionTime = duration;
         }
      }
      
      public function stop(clearParticles:Boolean = false) : void
      {
         _emissionTime = 0;
         if(clearParticles)
         {
            clear();
         }
      }
      
      public function clear() : void
      {
         _numParticles = 0;
      }
      
      override public function getBounds(targetSpace:DisplayObject, resultRect:Rectangle = null) : Rectangle
      {
         if(resultRect == null)
         {
            resultRect = new Rectangle();
         }
         getTransformationMatrix(targetSpace,sHelperMatrix);
         MatrixUtil.transformCoords(sHelperMatrix,0,0,sHelperPoint);
         resultRect.x = sHelperPoint.x;
         resultRect.y = sHelperPoint.y;
         resultRect.width = resultRect.height = 0;
         return resultRect;
      }
      
      public function advanceTime(passedTime:Number) : void
      {
         var particle:Particle = null;
         var nextParticle:Particle = null;
         var timeBetweenParticles:Number = NaN;
         var rotation:Number = NaN;
         var y:Number = NaN;
         var x:Number = NaN;
         var offsetY:Number = NaN;
         var offsetX:Number = NaN;
         var i:int = 0;
         var cos:Number = NaN;
         var sin:Number = NaN;
         var cosX:Number = NaN;
         var cosY:Number = NaN;
         var sinX:Number = NaN;
         var sinY:Number = NaN;
         setRequiresRedraw();
         setRequiresSync();
         var particleIndex:int = 0;
         var maxNumParticles:int = capacity;
         while(particleIndex < _numParticles)
         {
            particle = _particles[particleIndex] as Particle;
            if(particle.currentTime < particle.totalTime)
            {
               advanceParticle(particle,passedTime);
               particleIndex++;
            }
            else
            {
               if(particleIndex != _numParticles - 1)
               {
                  nextParticle = _particles[_numParticles - 1] as Particle;
                  _particles[_numParticles - 1] = particle;
                  _particles[particleIndex] = nextParticle;
               }
               --_numParticles;
               if(_numParticles == 0 && _emissionTime == 0)
               {
                  dispatchEventWith("complete");
               }
            }
         }
         if(_emissionTime > 0)
         {
            timeBetweenParticles = 1 / _emissionRate;
            _frameTime += passedTime;
            while(_frameTime > 0)
            {
               if(_numParticles < maxNumParticles)
               {
                  particle = _particles[_numParticles] as Particle;
                  initParticle(particle);
                  if(particle.totalTime > 0)
                  {
                     advanceParticle(particle,_frameTime);
                     ++_numParticles;
                  }
               }
               _frameTime -= timeBetweenParticles;
            }
            if(_emissionTime != 1.7976931348623157e+308)
            {
               _emissionTime = _emissionTime > passedTime ? _emissionTime - passedTime : 0;
            }
            if(_numParticles == 0 && _emissionTime == 0)
            {
               dispatchEventWith("complete");
            }
         }
         var vertexID:int = 0;
         var pivotX:Number = texture ? texture.width / 2 : 5;
         var pivotY:Number = texture ? texture.height / 2 : 5;
         for(i = 0; i < _numParticles; )
         {
            vertexID = i * 4;
            particle = _particles[i] as Particle;
            rotation = particle.rotation;
            offsetX = pivotX * particle.scale;
            offsetY = pivotY * particle.scale;
            x = particle.x;
            y = particle.y;
            _vertexData.colorize("color",particle.color,particle.alpha,vertexID,4);
            if(rotation)
            {
               cos = Math.cos(rotation);
               sin = Math.sin(rotation);
               cosX = cos * offsetX;
               cosY = cos * offsetY;
               sinX = sin * offsetX;
               sinY = sin * offsetY;
               _vertexData.setPoint(vertexID,"position",x - cosX + sinY,y - sinX - cosY);
               _vertexData.setPoint(vertexID + 1,"position",x + cosX + sinY,y + sinX - cosY);
               _vertexData.setPoint(vertexID + 2,"position",x - cosX - sinY,y - sinX + cosY);
               _vertexData.setPoint(vertexID + 3,"position",x + cosX - sinY,y + sinX + cosY);
            }
            else
            {
               _vertexData.setPoint(vertexID,"position",x - offsetX,y - offsetY);
               _vertexData.setPoint(vertexID + 1,"position",x + offsetX,y - offsetY);
               _vertexData.setPoint(vertexID + 2,"position",x - offsetX,y + offsetY);
               _vertexData.setPoint(vertexID + 3,"position",x + offsetX,y + offsetY);
            }
            i++;
         }
      }
      
      override public function render(painter:Painter) : void
      {
         if(_numParticles != 0)
         {
            if(_batchable)
            {
               painter.batchMesh(this);
            }
            else
            {
               painter.finishMeshBatch();
               painter.drawCount += 1;
               painter.prepareToDraw();
               painter.excludeFromCache(this);
               if(_requiresSync)
               {
                  syncBuffers();
               }
               style.updateEffect(_effect,painter.state);
               _effect.render(0,_numParticles * 2);
            }
         }
      }
      
      public function populate(count:int) : void
      {
         var p:Particle = null;
         var i:int = 0;
         var maxNumParticles:int = capacity;
         count = Math.min(count,maxNumParticles - _numParticles);
         for(i = 0; i < count; )
         {
            p = _particles[_numParticles + i];
            initParticle(p);
            advanceParticle(p,Math.random() * p.totalTime);
            i++;
         }
         _numParticles += count;
      }
      
      public function get capacity() : int
      {
         return _vertexData.numVertices / 4;
      }
      
      public function set capacity(value:int) : void
      {
         var i:* = 0;
         var numVertices:int = 0;
         var oldCapacity:int = capacity;
         var newCapacity:* = value > 16383 ? 16383 : value;
         var baseVertexData:VertexData = new VertexData(style.vertexFormat,4);
         var texture:Texture = this.texture;
         if(texture)
         {
            texture.setupVertexPositions(baseVertexData);
            texture.setupTextureCoordinates(baseVertexData);
         }
         else
         {
            baseVertexData.setPoint(0,"position",0,0);
            baseVertexData.setPoint(1,"position",10,0);
            baseVertexData.setPoint(2,"position",0,10);
            baseVertexData.setPoint(3,"position",10,10);
         }
         for(i = oldCapacity; i < newCapacity; )
         {
            numVertices = i * 4;
            baseVertexData.copyTo(_vertexData,numVertices);
            _indexData.addQuad(numVertices,numVertices + 1,numVertices + 2,numVertices + 3);
            _particles[i] = createParticle();
            i++;
         }
         if(newCapacity < oldCapacity)
         {
            _particles.length = newCapacity;
            _indexData.numIndices = newCapacity * 6;
            _vertexData.numVertices = newCapacity * 4;
         }
         _indexData.trim();
         _vertexData.trim();
         setRequiresSync();
      }
      
      public function get isEmitting() : Boolean
      {
         return _emissionTime > 0 && _emissionRate > 0;
      }
      
      public function get numParticles() : int
      {
         return _numParticles;
      }
      
      public function get emissionRate() : Number
      {
         return _emissionRate;
      }
      
      public function set emissionRate(value:Number) : void
      {
         _emissionRate = value;
      }
      
      public function get emitterX() : Number
      {
         return _emitterX;
      }
      
      public function set emitterX(value:Number) : void
      {
         _emitterX = value;
      }
      
      public function get emitterY() : Number
      {
         return _emitterY;
      }
      
      public function set emitterY(value:Number) : void
      {
         _emitterY = value;
      }
      
      public function get blendFactorSource() : String
      {
         return _blendFactorSource;
      }
      
      public function set blendFactorSource(value:String) : void
      {
         _blendFactorSource = value;
         updateBlendMode();
      }
      
      public function get blendFactorDestination() : String
      {
         return _blendFactorDestination;
      }
      
      public function set blendFactorDestination(value:String) : void
      {
         _blendFactorDestination = value;
         updateBlendMode();
      }
      
      override public function set texture(value:Texture) : void
      {
         var i:int = 0;
         super.texture = value;
         if(value)
         {
            for(i = _vertexData.numVertices - 4; i >= 0; )
            {
               value.setupVertexPositions(_vertexData,i);
               value.setupTextureCoordinates(_vertexData,i);
               i -= 4;
            }
         }
         updateBlendMode();
      }
      
      override public function setStyle(meshStyle:MeshStyle = null, mergeWithPredecessor:Boolean = true) : void
      {
         super.setStyle(meshStyle,mergeWithPredecessor);
         if(_effect)
         {
            _effect.dispose();
         }
         _effect = style.createEffect();
         _effect.onRestore = setRequiresSync;
      }
      
      public function get batchable() : Boolean
      {
         return _batchable;
      }
      
      public function set batchable(value:Boolean) : void
      {
         _batchable = value;
         setRequiresRedraw();
      }
   }
}

