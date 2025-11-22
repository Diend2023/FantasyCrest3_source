package zygame.core
{
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import lzm.starling.swf.FPSUtil;
   
   public class SoundCore
   {
      
      public var fps:FPSUtil;
      
      private var _bgChannel:SoundChannel;
      
      private var _soundCount:int = 0;
      
      public var soundOld:Array;
      
      private var _currentBGSoundName:String;
      
      public var soundDic:Dictionary;
      
      public function SoundCore()
      {
         super();
         soundOld = [];
         soundDic = new Dictionary();
         fps = new FPSUtil(6);
      }
      
      public function playBGSound(target:String) : void
      {
         if(_bgChannel)
         {
            if(target == _currentBGSoundName)
            {
               return;
            }
            _bgChannel.stop();
         }
         _currentBGSoundName = target;
         var sound:Sound = DataCore.getSound(target);
         if(sound)
         {
            _bgChannel = sound.play(0,99999,new SoundTransform(0.6));
         }
         bgvolume = bgvolume;
         volume = volume;
      }
      
      public function playEffect(target:String, balance:Number = 0, ifFunc:Function = null) : SoundChannel
      {
         var v:Number;
         var sound:Sound;
         var channel:SoundChannel;
         if(volume == 0)
         {
            return null;
         }
         v = balance;
         if(v > 0)
         {
            v *= -1;
         }
         v = 1 + v;
         if(v < 0)
         {
            return null;
         }
         if(soundOld.indexOf(target) == -1)
         {
            soundOld.push(target);
            sound = DataCore.getSound(target);
            if(sound && sound.length > 0)
            {
               channel = sound.play();
               channel.soundTransform = new SoundTransform(v,balance);
               _soundCount++;
               channel.addEventListener("soundComplete",function(e:Event):void
               {
                  if(ifFunc != null)
                  {
                     delete soundDic[ifFunc];
                  }
                  _soundCount--;
               });
               if(ifFunc != null)
               {
                  soundDic[ifFunc] = channel;
               }
               return channel;
            }
            return null;
         }
         return null;
      }
      
      public function updateSound() : void
      {
         if(fps.update())
         {
            soundOld = [];
         }
         for(var i in soundDic)
         {
            if(i())
            {
               if((soundDic[i] as SoundChannel).soundTransform.volume > 0)
               {
                  (soundDic[i] as SoundChannel).soundTransform = new SoundTransform((soundDic[i] as SoundChannel).soundTransform.volume - 0.05,(soundDic[i] as SoundChannel).soundTransform.pan);
               }
            }
         }
      }
      
      public function get playSoundCount() : int
      {
         return _soundCount;
      }
      
      public function set pan(p:Number) : void
      {
         var v:* = p;
         if(v > 0)
         {
            v *= -1;
         }
         v = 1 + v;
         if(v < 0)
         {
            v = 0;
         }
         if(_bgChannel)
         {
            _bgChannel.soundTransform = new SoundTransform(v,p);
         }
      }
      
      public function set bgvolume(i:Number) : void
      {
         DataCore.updateValue("bg_sound_volume",i);
         DataCore.save();
         if(_bgChannel)
         {
            _bgChannel.soundTransform = new SoundTransform(i);
         }
      }
      
      public function get bgvolume() : Number
      {
         return DataCore.getNumber("bg_sound_volume",1);
      }
      
      public function set volume(i:Number) : void
      {
         DataCore.updateValue("sound_volume",i);
         DataCore.save();
         SoundMixer.soundTransform = new SoundTransform(volume);
      }
      
      public function get volume() : Number
      {
         return DataCore.getNumber("sound_volume",1);
      }
   }
}

