package anifire.player.playback
{
	import anifire.constant.AnimeConstants;
	import anifire.event.AVM1SoundEvent;
	import anifire.player.events.PlayerEvent;
	import anifire.sound.AVM1Sound;
	import anifire.util.UtilHashArray;
	import anifire.util.UtilUnitConvert;
	import anifire.util.UtilXmlInfo;
	import flash.display.AVM1Movie;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	
	public class EmbedSound extends AnimeSound
	{
		
		private static const STATE_NULL:int = 0;
		
		private static const STATE_BUFFER_INITIALIZING:int = 1;
		
		private static const STATE_PAUSED:int = 2;
		
		private static const STATE_PLAYING:int = 3;
		 
		
		private var _state:int = 0;
		
		private var _soundChannel:SoundChannel = null;
		
		private var _loader:Loader;
		
		private var _sound:AVM1Sound;
		
		private var _loopCounter:int = 0;
		
		private var bytes:ByteArray;
		
		public function EmbedSound()
		{
			this.bytes = new ByteArray();
			super();
		}
		
		private function get state() : int
		{
			return this._state;
		}
		
		private function set state(param1:int) : void
		{
			this._state = param1;
		}
		
		private function get sound() : AVM1Sound
		{
			return this._sound;
		}
		
		private function set sound(param1:AVM1Sound) : void
		{
			this._sound = param1;
		}
		
		private function get loader() : Loader
		{
			return this._loader;
		}
		
		private function set loader(param1:Loader) : void
		{
			this._loader = param1;
		}
		
		protected function getVolume() : Number
		{
			return this.volume;
		}
		
		override public function setVolume(param1:Number) : void
		{
			this.volume = param1;
			if(this.sound != null)
			{
				this.sound.setVolume(param1 * this.fadeFactor * this.inner_volume);
			}
		}
		
		private function get loopCounter() : int
		{
			return this._loopCounter;
		}
		
		private function set loopCounter(param1:int) : void
		{
			this._loopCounter = param1;
		}
		
		override public function fadeVolume(param1:Number) : void
		{
			param1 = int(param1 * 10) / 10;
			this.fadeFactor = param1;
			this.setVolume(this.getVolume());
		}
		
		override public function init(param1:XML, param2:UtilHashArray, param3:String, param4:PlayerDataStock) : Boolean
		{
			if(!super.init(param1,param2,param3,param4))
			{
				return false;
			}
			this.state = STATE_NULL;
			if(param4.getPlayerData(this.file) == null)
			{
				return false;
			}
			var _loc5_:String = UtilXmlInfo.getThemeIdFromFileName(this.file);
			if(_loc5_ != "ugc")
			{
				param4.decryptPlayerData(this.file);
			}
			return true;
		}
		
		public function initRemoteData(param1:PlayerDataStock) : void
		{
			if(this.getBufferProgress() >= 100)
			{
				this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
				return;
			}
			if(this.state != STATE_BUFFER_INITIALIZING)
			{
				this.loader = new Loader();
				this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onInitRemoteDataCompleted);
				try
				{
					this.loader.loadBytes(param1.getPlayerData(this.file) as ByteArray);
				}
				catch(e:Error)
				{
				}
				this.state = STATE_BUFFER_INITIALIZING;
			}
		}
		
		private function onInitRemoteDataCompleted(param1:Event) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onInitRemoteDataCompleted);
			this.sound = new AVM1Sound();
			this.sound.addEventListener(AVM1SoundEvent.SOUND_INIT_COMPLETE,this.onInitAVMsoundComplete);
			this.sound.init(LoaderInfo(param1.target).content as AVM1Movie);
		}
		
		private function onInitAVMsoundComplete(param1:AVM1SoundEvent) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onInitAVMsoundComplete);
			this.setBufferProgress(100);
			this.state = STATE_PAUSED;
			if(this.subtype == AnimeConstants.ASSET_TYPE_SOUND_SUBTYPE_BG_MUSIC)
			{
				this.fadeVolume(0);
			}
			else
			{
				this.fadeVolume(1);
			}
			this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
		}
		
		override public function play(param1:Number) : void
		{
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			if(this.state == STATE_PAUSED)
			{
				_loc2_ = this.sound.getDuration() * this.loopCounter + 1000 / AnimeConstants.FRAME_PER_SEC;
				if(param1 >= _loc2_)
				{
					_loc3_ = (param1 - this.startMilliSec) % this.sound.getDuration();
					if(_loopSound)
					{
						this.sound.addEventListener(AVM1SoundEvent.SOUND_COMPLETE,this.onPlayComplete);
					}
					if(_trimStartFrame > 1)
					{
						_loc3_ = _loc3_ + UtilUnitConvert.frameToTime(_trimStartFrame) * 1000;
					}
					this.setVolume(this.getVolume());
					this.sound.gotoAndPlay(_loc3_);
					this.state = STATE_PLAYING;
				}
			}
			else if(this.state == STATE_PLAYING)
			{
				this.updateVolumeByCurrentTime(param1);
			}
		}
		
		private function onPlayComplete(param1:Event) : void
		{
			this.sound.removeEventListener(AVM1SoundEvent.SOUND_COMPLETE,this.onPlayComplete);
			this.state = STATE_PAUSED;
			this.loopCounter++;
			this.play(0);
		}
		
		override public function goToAndPause(param1:Number) : void
		{
			var _loc2_:Number = (param1 - this.startMilliSec) % this.sound.getDuration();
			this.loopCounter = Math.floor((param1 - this.startMilliSec) / this.sound.getDuration());
			this.sound.gotoAndPause(_loc2_);
			this.state = STATE_PAUSED;
		}
		
		override public function pause(param1:Number) : void
		{
			if(this.sound != null)
			{
				this.sound.pause();
			}
			this.state = STATE_PAUSED;
		}
		
		override public function resume() : void
		{
			if(this.state == STATE_PAUSED)
			{
				this.sound.resume();
				this.state = STATE_PLAYING;
			}
		}
	}
}
