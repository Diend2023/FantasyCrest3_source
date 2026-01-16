package starling.extensions
{
   import starling.textures.Texture;
   import starling.utils.deg2rad;
   
   public class PDParticleSystem extends ParticleSystem
   {
      
      public static const EMITTER_TYPE_GRAVITY:int = 0;
      
      public static const EMITTER_TYPE_RADIAL:int = 1;
      
      private var _emitterType:int;
      
      private var _emitterXVariance:Number;
      
      private var _emitterYVariance:Number;
      
      private var _defaultDuration:Number;
      
      private var _lifespan:Number;
      
      private var _lifespanVariance:Number;
      
      private var _startSize:Number;
      
      private var _startSizeVariance:Number;
      
      private var _endSize:Number;
      
      private var _endSizeVariance:Number;
      
      private var _emitAngle:Number;
      
      private var _emitAngleVariance:Number;
      
      private var _startRotation:Number;
      
      private var _startRotationVariance:Number;
      
      private var _endRotation:Number;
      
      private var _endRotationVariance:Number;
      
      private var _speed:Number;
      
      private var _speedVariance:Number;
      
      private var _gravityX:Number;
      
      private var _gravityY:Number;
      
      private var _radialAcceleration:Number;
      
      private var _radialAccelerationVariance:Number;
      
      private var _tangentialAcceleration:Number;
      
      private var _tangentialAccelerationVariance:Number;
      
      private var _maxRadius:Number;
      
      private var _maxRadiusVariance:Number;
      
      private var _minRadius:Number;
      
      private var _minRadiusVariance:Number;
      
      private var _rotatePerSecond:Number;
      
      private var _rotatePerSecondVariance:Number;
      
      private var _startColor:ColorArgb;
      
      private var _startColorVariance:ColorArgb;
      
      private var _endColor:ColorArgb;
      
      private var _endColorVariance:ColorArgb;
      
      public function PDParticleSystem(config:XML, texture:Texture)
      {
         super(texture);
         parseConfig(config);
      }
      
      override protected function createParticle() : Particle
      {
         return new PDParticle();
      }
      
      override protected function initParticle(aParticle:Particle) : void
      {
         var particle:PDParticle = aParticle as PDParticle;
         var lifespan:Number = _lifespan + _lifespanVariance * (Math.random() * 2 - 1);
         var textureWidth:Number = texture ? texture.width : 16;
         particle.currentTime = 0;
         particle.totalTime = lifespan > 0 ? lifespan : 0;
         if(lifespan <= 0)
         {
            return;
         }
         var emitterX:Number = this.emitterX;
         var emitterY:Number = this.emitterY;
         particle.x = emitterX + _emitterXVariance * (Math.random() * 2 - 1);
         particle.y = emitterY + _emitterYVariance * (Math.random() * 2 - 1);
         particle.startX = emitterX;
         particle.startY = emitterY;
         var angle:Number = _emitAngle + _emitAngleVariance * (Math.random() * 2 - 1);
         var speed:Number = _speed + _speedVariance * (Math.random() * 2 - 1);
         particle.velocityX = speed * Math.cos(angle);
         particle.velocityY = speed * Math.sin(angle);
         var startRadius:Number = _maxRadius + _maxRadiusVariance * (Math.random() * 2 - 1);
         var endRadius:Number = _minRadius + _minRadiusVariance * (Math.random() * 2 - 1);
         particle.emitRadius = startRadius;
         particle.emitRadiusDelta = (endRadius - startRadius) / lifespan;
         particle.emitRotation = _emitAngle + _emitAngleVariance * (Math.random() * 2 - 1);
         particle.emitRotationDelta = _rotatePerSecond + _rotatePerSecondVariance * (Math.random() * 2 - 1);
         particle.radialAcceleration = _radialAcceleration + _radialAccelerationVariance * (Math.random() * 2 - 1);
         particle.tangentialAcceleration = _tangentialAcceleration + _tangentialAccelerationVariance * (Math.random() * 2 - 1);
         var startSize:Number = _startSize + _startSizeVariance * (Math.random() * 2 - 1);
         var endSize:Number = _endSize + _endSizeVariance * (Math.random() * 2 - 1);
         if(startSize < 0.1)
         {
            startSize = 0.1;
         }
         if(endSize < 0.1)
         {
            endSize = 0.1;
         }
         particle.scale = startSize / textureWidth;
         particle.scaleDelta = (endSize - startSize) / lifespan / textureWidth;
         var startColor:ColorArgb = particle.colorArgb;
         var colorDelta:ColorArgb = particle.colorArgbDelta;
         startColor.red = _startColor.red;
         startColor.green = _startColor.green;
         startColor.blue = _startColor.blue;
         startColor.alpha = _startColor.alpha;
         if(_startColorVariance.red != 0)
         {
            startColor.red += _startColorVariance.red * (Math.random() * 2 - 1);
         }
         if(_startColorVariance.green != 0)
         {
            startColor.green += _startColorVariance.green * (Math.random() * 2 - 1);
         }
         if(_startColorVariance.blue != 0)
         {
            startColor.blue += _startColorVariance.blue * (Math.random() * 2 - 1);
         }
         if(_startColorVariance.alpha != 0)
         {
            startColor.alpha += _startColorVariance.alpha * (Math.random() * 2 - 1);
         }
         var endColorRed:Number = _endColor.red;
         var endColorGreen:Number = _endColor.green;
         var endColorBlue:Number = _endColor.blue;
         var endColorAlpha:Number = _endColor.alpha;
         if(_endColorVariance.red != 0)
         {
            endColorRed += _endColorVariance.red * (Math.random() * 2 - 1);
         }
         if(_endColorVariance.green != 0)
         {
            endColorGreen += _endColorVariance.green * (Math.random() * 2 - 1);
         }
         if(_endColorVariance.blue != 0)
         {
            endColorBlue += _endColorVariance.blue * (Math.random() * 2 - 1);
         }
         if(_endColorVariance.alpha != 0)
         {
            endColorAlpha += _endColorVariance.alpha * (Math.random() * 2 - 1);
         }
         colorDelta.red = (endColorRed - startColor.red) / lifespan;
         colorDelta.green = (endColorGreen - startColor.green) / lifespan;
         colorDelta.blue = (endColorBlue - startColor.blue) / lifespan;
         colorDelta.alpha = (endColorAlpha - startColor.alpha) / lifespan;
         var startRotation:Number = _startRotation + _startRotationVariance * (Math.random() * 2 - 1);
         var endRotation:Number = _endRotation + _endRotationVariance * (Math.random() * 2 - 1);
         particle.rotation = startRotation;
         particle.rotationDelta = (endRotation - startRotation) / lifespan;
      }
      
      override protected function advanceParticle(aParticle:Particle, passedTime:Number) : void
      {
         var distanceX:Number = NaN;
         var distanceY:Number = NaN;
         var distanceScalar:Number = NaN;
         var radialX:Number = NaN;
         var radialY:Number = NaN;
         var tangentialX:* = NaN;
         var tangentialY:* = NaN;
         var newY:* = NaN;
         var particle:PDParticle = aParticle as PDParticle;
         var restTime:Number = particle.totalTime - particle.currentTime;
         passedTime = restTime > passedTime ? passedTime : restTime;
         particle.currentTime += passedTime;
         if(_emitterType == 1)
         {
            particle.emitRotation += particle.emitRotationDelta * passedTime;
            particle.emitRadius += particle.emitRadiusDelta * passedTime;
            particle.x = emitterX - Math.cos(particle.emitRotation) * particle.emitRadius;
            particle.y = emitterY - Math.sin(particle.emitRotation) * particle.emitRadius;
         }
         else
         {
            distanceX = particle.x - particle.startX;
            distanceY = particle.y - particle.startY;
            distanceScalar = Math.sqrt(distanceX * distanceX + distanceY * distanceY);
            if(distanceScalar < 0.01)
            {
               distanceScalar = 0.01;
            }
            radialX = distanceX / distanceScalar;
            radialY = distanceY / distanceScalar;
            tangentialX = radialX;
            tangentialY = radialY;
            radialX *= particle.radialAcceleration;
            radialY *= particle.radialAcceleration;
            newY = tangentialX;
            tangentialX = -tangentialY * particle.tangentialAcceleration;
            tangentialY = newY * particle.tangentialAcceleration;
            particle.velocityX += passedTime * (_gravityX + radialX + tangentialX);
            particle.velocityY += passedTime * (_gravityY + radialY + tangentialY);
            particle.x += particle.velocityX * passedTime;
            particle.y += particle.velocityY * passedTime;
         }
         particle.scale += particle.scaleDelta * passedTime;
         particle.rotation += particle.rotationDelta * passedTime;
         particle.colorArgb.red += particle.colorArgbDelta.red * passedTime;
         particle.colorArgb.green += particle.colorArgbDelta.green * passedTime;
         particle.colorArgb.blue += particle.colorArgbDelta.blue * passedTime;
         particle.colorArgb.alpha += particle.colorArgbDelta.alpha * passedTime;
         particle.color = particle.colorArgb.toRgb();
         particle.alpha = particle.colorArgb.alpha;
      }
      
      private function updateEmissionRate() : void
      {
         emissionRate = capacity / _lifespan;
      }
      
      private function parseConfig(config:XML) : void
      {
         var getIntValue:* = function(element:XMLList):int
         {
            return parseInt(element.attribute("value"));
         };
         var getFloatValue:* = function(element:XMLList):Number
         {
            return parseFloat(element.attribute("value"));
         };
         var getColor:* = function(element:XMLList):ColorArgb
         {
            var color:ColorArgb = new ColorArgb();
            color.red = parseFloat(element.attribute("red"));
            color.green = parseFloat(element.attribute("green"));
            color.blue = parseFloat(element.attribute("blue"));
            color.alpha = parseFloat(element.attribute("alpha"));
            return color;
         };
         var getBlendFunc:* = function(element:XMLList):String
         {
            var value:int = getIntValue(element);
            switch(value)
            {
               case 0:
                  return "zero";
               case 1:
                  return "one";
               case 768:
                  return "sourceColor";
               case 769:
                  return "oneMinusSourceColor";
               case 770:
                  return "sourceAlpha";
               case 771:
                  return "oneMinusSourceAlpha";
               case 772:
                  return "destinationAlpha";
               case 773:
                  return "oneMinusDestinationAlpha";
               case 774:
                  return "destinationColor";
               case 775:
                  return "oneMinusDestinationColor";
               default:
                  throw new ArgumentError("unsupported blending function: " + value);
            }
         };
         _emitterXVariance = parseFloat(config.sourcePositionVariance.attribute("x"));
         _emitterYVariance = parseFloat(config.sourcePositionVariance.attribute("y"));
         _gravityX = parseFloat(config.gravity.attribute("x"));
         _gravityY = parseFloat(config.gravity.attribute("y"));
         _emitterType = getIntValue(config.emitterType);
         _lifespan = Math.max(0.01,getFloatValue(config.particleLifeSpan));
         _lifespanVariance = getFloatValue(config.particleLifespanVariance);
         _startSize = getFloatValue(config.startParticleSize);
         _startSizeVariance = getFloatValue(config.startParticleSizeVariance);
         _endSize = getFloatValue(config.finishParticleSize);
         _endSizeVariance = getFloatValue(config.FinishParticleSizeVariance);
         _emitAngle = deg2rad(getFloatValue(config.angle));
         _emitAngleVariance = deg2rad(getFloatValue(config.angleVariance));
         _startRotation = deg2rad(getFloatValue(config.rotationStart));
         _startRotationVariance = deg2rad(getFloatValue(config.rotationStartVariance));
         _endRotation = deg2rad(getFloatValue(config.rotationEnd));
         _endRotationVariance = deg2rad(getFloatValue(config.rotationEndVariance));
         _speed = getFloatValue(config.speed);
         _speedVariance = getFloatValue(config.speedVariance);
         _radialAcceleration = getFloatValue(config.radialAcceleration);
         _radialAccelerationVariance = getFloatValue(config.radialAccelVariance);
         _tangentialAcceleration = getFloatValue(config.tangentialAcceleration);
         _tangentialAccelerationVariance = getFloatValue(config.tangentialAccelVariance);
         _maxRadius = getFloatValue(config.maxRadius);
         _maxRadiusVariance = getFloatValue(config.maxRadiusVariance);
         _minRadius = getFloatValue(config.minRadius);
         _minRadiusVariance = getFloatValue(config.minRadiusVariance);
         _rotatePerSecond = deg2rad(getFloatValue(config.rotatePerSecond));
         _rotatePerSecondVariance = deg2rad(getFloatValue(config.rotatePerSecondVariance));
         _startColor = getColor(config.startColor);
         _startColorVariance = getColor(config.startColorVariance);
         _endColor = getColor(config.finishColor);
         _endColorVariance = getColor(config.finishColorVariance);
         blendFactorSource = getBlendFunc(config.blendFuncSource);
         blendFactorDestination = getBlendFunc(config.blendFuncDestination);
         defaultDuration = getFloatValue(config.duration);
         capacity = getIntValue(config.maxParticles);
         if(isNaN(_endSizeVariance))
         {
            _endSizeVariance = getFloatValue(config.finishParticleSizeVariance);
         }
         if(isNaN(_lifespan))
         {
            _lifespan = Math.max(0.01,getFloatValue(config.particleLifespan));
         }
         if(isNaN(_lifespanVariance))
         {
            _lifespanVariance = getFloatValue(config.particleLifeSpanVariance);
         }
         if(isNaN(_minRadiusVariance))
         {
            _minRadiusVariance = 0;
         }
         updateEmissionRate();
      }
      
      public function get emitterType() : int
      {
         return _emitterType;
      }
      
      public function set emitterType(value:int) : void
      {
         _emitterType = value;
      }
      
      public function get emitterXVariance() : Number
      {
         return _emitterXVariance;
      }
      
      public function set emitterXVariance(value:Number) : void
      {
         _emitterXVariance = value;
      }
      
      public function get emitterYVariance() : Number
      {
         return _emitterYVariance;
      }
      
      public function set emitterYVariance(value:Number) : void
      {
         _emitterYVariance = value;
      }
      
      public function get defaultDuration() : Number
      {
         return _defaultDuration;
      }
      
      public function set defaultDuration(value:Number) : void
      {
         _defaultDuration = value < 0 ? 1.7976931348623157e+308 : value;
      }
      
      override public function set capacity(value:int) : void
      {
         super.capacity = value;
         updateEmissionRate();
      }
      
      public function get lifespan() : Number
      {
         return _lifespan;
      }
      
      public function set lifespan(value:Number) : void
      {
         _lifespan = Math.max(0.01,value);
         updateEmissionRate();
      }
      
      public function get lifespanVariance() : Number
      {
         return _lifespanVariance;
      }
      
      public function set lifespanVariance(value:Number) : void
      {
         _lifespanVariance = value;
      }
      
      public function get startSize() : Number
      {
         return _startSize;
      }
      
      public function set startSize(value:Number) : void
      {
         _startSize = value;
      }
      
      public function get startSizeVariance() : Number
      {
         return _startSizeVariance;
      }
      
      public function set startSizeVariance(value:Number) : void
      {
         _startSizeVariance = value;
      }
      
      public function get endSize() : Number
      {
         return _endSize;
      }
      
      public function set endSize(value:Number) : void
      {
         _endSize = value;
      }
      
      public function get endSizeVariance() : Number
      {
         return _endSizeVariance;
      }
      
      public function set endSizeVariance(value:Number) : void
      {
         _endSizeVariance = value;
      }
      
      public function get emitAngle() : Number
      {
         return _emitAngle;
      }
      
      public function set emitAngle(value:Number) : void
      {
         _emitAngle = value;
      }
      
      public function get emitAngleVariance() : Number
      {
         return _emitAngleVariance;
      }
      
      public function set emitAngleVariance(value:Number) : void
      {
         _emitAngleVariance = value;
      }
      
      public function get startRotation() : Number
      {
         return _startRotation;
      }
      
      public function set startRotation(value:Number) : void
      {
         _startRotation = value;
      }
      
      public function get startRotationVariance() : Number
      {
         return _startRotationVariance;
      }
      
      public function set startRotationVariance(value:Number) : void
      {
         _startRotationVariance = value;
      }
      
      public function get endRotation() : Number
      {
         return _endRotation;
      }
      
      public function set endRotation(value:Number) : void
      {
         _endRotation = value;
      }
      
      public function get endRotationVariance() : Number
      {
         return _endRotationVariance;
      }
      
      public function set endRotationVariance(value:Number) : void
      {
         _endRotationVariance = value;
      }
      
      public function get speed() : Number
      {
         return _speed;
      }
      
      public function set speed(value:Number) : void
      {
         _speed = value;
      }
      
      public function get speedVariance() : Number
      {
         return _speedVariance;
      }
      
      public function set speedVariance(value:Number) : void
      {
         _speedVariance = value;
      }
      
      public function get gravityX() : Number
      {
         return _gravityX;
      }
      
      public function set gravityX(value:Number) : void
      {
         _gravityX = value;
      }
      
      public function get gravityY() : Number
      {
         return _gravityY;
      }
      
      public function set gravityY(value:Number) : void
      {
         _gravityY = value;
      }
      
      public function get radialAcceleration() : Number
      {
         return _radialAcceleration;
      }
      
      public function set radialAcceleration(value:Number) : void
      {
         _radialAcceleration = value;
      }
      
      public function get radialAccelerationVariance() : Number
      {
         return _radialAccelerationVariance;
      }
      
      public function set radialAccelerationVariance(value:Number) : void
      {
         _radialAccelerationVariance = value;
      }
      
      public function get tangentialAcceleration() : Number
      {
         return _tangentialAcceleration;
      }
      
      public function set tangentialAcceleration(value:Number) : void
      {
         _tangentialAcceleration = value;
      }
      
      public function get tangentialAccelerationVariance() : Number
      {
         return _tangentialAccelerationVariance;
      }
      
      public function set tangentialAccelerationVariance(value:Number) : void
      {
         _tangentialAccelerationVariance = value;
      }
      
      public function get maxRadius() : Number
      {
         return _maxRadius;
      }
      
      public function set maxRadius(value:Number) : void
      {
         _maxRadius = value;
      }
      
      public function get maxRadiusVariance() : Number
      {
         return _maxRadiusVariance;
      }
      
      public function set maxRadiusVariance(value:Number) : void
      {
         _maxRadiusVariance = value;
      }
      
      public function get minRadius() : Number
      {
         return _minRadius;
      }
      
      public function set minRadius(value:Number) : void
      {
         _minRadius = value;
      }
      
      public function get minRadiusVariance() : Number
      {
         return _minRadiusVariance;
      }
      
      public function set minRadiusVariance(value:Number) : void
      {
         _minRadiusVariance = value;
      }
      
      public function get rotatePerSecond() : Number
      {
         return _rotatePerSecond;
      }
      
      public function set rotatePerSecond(value:Number) : void
      {
         _rotatePerSecond = value;
      }
      
      public function get rotatePerSecondVariance() : Number
      {
         return _rotatePerSecondVariance;
      }
      
      public function set rotatePerSecondVariance(value:Number) : void
      {
         _rotatePerSecondVariance = value;
      }
      
      public function get startColor() : ColorArgb
      {
         return _startColor;
      }
      
      public function set startColor(value:ColorArgb) : void
      {
         _startColor = value;
      }
      
      public function get startColorVariance() : ColorArgb
      {
         return _startColorVariance;
      }
      
      public function set startColorVariance(value:ColorArgb) : void
      {
         _startColorVariance = value;
      }
      
      public function get endColor() : ColorArgb
      {
         return _endColor;
      }
      
      public function set endColor(value:ColorArgb) : void
      {
         _endColor = value;
      }
      
      public function get endColorVariance() : ColorArgb
      {
         return _endColorVariance;
      }
      
      public function set endColorVariance(value:ColorArgb) : void
      {
         _endColorVariance = value;
      }
   }
}

