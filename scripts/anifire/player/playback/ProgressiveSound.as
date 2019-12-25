package anifire.player.playback
{
	import anifire.constant.AnimeConstants;
	import anifire.constant.ThemeConstants;
	import anifire.core.AssetLinkage;
	import anifire.event.AVM2SoundEvent;
	import anifire.event.SpeechPitchEvent;
	import anifire.interfaces.ISoundAsset;
	import anifire.managers.CCThemeManager;
	import anifire.models.AssetModel;
	import anifire.player.events.PlayerEvent;
	import anifire.player.managers.DownloadManager;
	import anifire.sound.SoundHelper;
	import anifire.util.UtilErrorLogger;
	import anifire.util.UtilHashArray;
	import anifire.util.UtilNetwork;
	import anifire.util.UtilUnitConvert;
	import anifire.util.UtilXmlInfo;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	public class ProgressiveSound extends AnimeSound implements ISoundAsset
	{
		
		private static const SAMPLE_RATE:Number = 44100;
		
		private static const BYTES_PER_SAMPLE:uint = 8;
		
		private static const STATE_NULL:int = 0;
		
		private static const STATE_PLAYING:int = 1;
		
		private static const STATE_PAUSED:int = 2;
		 
		
		private var _state:int;
		
		private var _sound:Sound;
		
		private var _soundChannel:SoundChannel;
		
		private var _currentPlayingMilliSecond:Number;
		
		private var _soundTransform:SoundTransform;
		
		private var _isSoundCompletelyDownload:Boolean;
		
		private var _numTry:Number = 0;
		
		private var _urlRequest:URLRequest;
		
		private var _soundCompletedOnce:Boolean = false;
		
		private var _lastPitchValue:Number = 0;
		
		private var _speechPitchCounter:int = 0;
		
		private var _linkedCharacterIdArray:Array;
		
		public function ProgressiveSound()
		{
			super();
		}
		
		private function get state() : Number
		{
			return this._state;
		}
		
		private function set state(param1:Number) : void
		{
			this._state = param1;
		}
		
		public function get sound() : Sound
		{
			return this._sound;
		}
		
		public function set sound(param1:Sound) : void
		{
			if(param1 && param1 != this._sound)
			{
				if(this._sound)
				{
					this._sound.removeEventListener(Event.COMPLETE,this.onSoundCompletelyDownloaded);
					this._sound.removeEventListener(ProgressEvent.PROGRESS,this.onSoundDownloading);
					this._sound.removeEventListener(IOErrorEvent.IO_ERROR,this.onSoundLoadFailed);
				}
				this._sound = param1;
				if(this._sound)
				{
					this._sound.addEventListener(Event.COMPLETE,this.onSoundCompletelyDownloaded);
					this._sound.addEventListener(ProgressEvent.PROGRESS,this.onSoundDownloading);
					this._sound.addEventListener(IOErrorEvent.IO_ERROR,this.onSoundLoadFailed);
				}
				this._isSoundCompletelyDownload = false;
			}
		}
		
		public function load() : void
		{
			var _loc1_:SoundLoaderContext = null;
			if(this._sound && this._urlRequest)
			{
				_loc1_ = new SoundLoaderContext(0);
				this._sound.load(this._urlRequest,_loc1_);
			}
		}
		
		public function close() : void
		{
		}
		
		private function onSoundLoadFailed(param1:IOErrorEvent) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onSoundLoadFailed);
			dispatchEvent(param1);
		}
		
		private function onSoundDownloading(param1:ProgressEvent) : void
		{
			this.dispatchEvent(param1);
		}
		
		private function get soundChannel() : SoundChannel
		{
			return this._soundChannel;
		}
		
		private function set soundChannel(param1:SoundChannel) : void
		{
			this._soundChannel = param1;
		}
		
		private function get soundTransform() : SoundTransform
		{
			return this._soundTransform;
		}
		
		private function set soundTransform(param1:SoundTransform) : void
		{
			this._soundTransform = param1;
		}
		
		override public function init(param1:XML, param2:UtilHashArray, param3:String, param4:PlayerDataStock) : Boolean
		{
			if(!super.init(param1,param2,param3,param4))
			{
				return false;
			}
			this.state = STATE_NULL;
			return true;
		}
		
		override public function initDependency(param1:Number, param2:Number, param3:DownloadManager) : void
		{
			var _loc6_:AssetModel = null;
			var _loc7_:String = null;
			var _loc8_:String = null;
			super.initDependency(param1,param2,param3);
			var _loc4_:String = UtilXmlInfo.getThemeIdFromFileName(this.file);
			var _loc5_:String = UtilXmlInfo.getThumbIdFromFileName(this.file);
			if(_loc4_ == ThemeConstants.UGC_THEME_ID)
			{
				_loc6_ = CCThemeManager.instance.getThemeModel(_loc4_).getSoundModel(_loc5_);
				_loc7_ = _loc6_.encAssetId;
				_loc8_ = _loc6_.signature;
				this._urlRequest = UtilNetwork.getGetSoundAssetRequest(_loc4_,_loc7_,AnimeConstants.DOWNLOAD_TYPE_PROGRESSIVE,_loc8_);
			}
			else
			{
				this._urlRequest = UtilNetwork.getGetSoundAssetRequest(_loc4_,_loc5_,AnimeConstants.DOWNLOAD_TYPE_PROGRESSIVE);
			}
			this.sound = new Sound();
			param3.registerSoundChannel(this._urlRequest,this.startMilliSec,this.endMilliSec,this,UtilUnitConvert.frameToTime(_trimStartFrame) * 1000);
			this.soundTransform = new SoundTransform(this.volume * this.fadeFactor * this.inner_volume);
			this.updateVolumeByCurrentTime(this.startMilliSec);
		}
		
		private function onSoundCompletelyDownloaded(param1:Event) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onSoundCompletelyDownloaded);
			this._isSoundCompletelyDownload = true;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,1,1));
			dispatchEvent(param1);
		}
		
		private function onBufferExhaust(param1:Event) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onBufferExhaust);
			this.dispatchBufferExhaustEvent(this.soundChannel.position);
		}
		
		private function dispatchBufferExhaustEvent(param1:Number) : void
		{
			this._currentPlayingMilliSecond = param1;
			this.dispatchEvent(new AVM2SoundEvent(PlayerEvent.BUFFER_EXHAUST,this));
		}
		
		override public function getBufferProgress() : Number
		{
			return 100;
		}
		
		override public function setVolume(param1:Number) : void
		{
			this.volume = param1;
			this.soundTransform.volume = this.fadeFactor * this.volume * this.inner_volume;
			if(this.soundChannel)
			{
				this.soundChannel.soundTransform = this.soundTransform;
			}
		}
		
		override public function fadeVolume(param1:Number) : void
		{
			this.fadeFactor = param1;
			this.soundTransform.volume = this.fadeFactor * this.volume * this.inner_volume;
			if(this.soundChannel)
			{
				this.soundChannel.soundTransform = this.soundTransform;
			}
		}
		
		private function doSoundComplete(param1:Event) : void
		{
			this._soundCompletedOnce = true;
		}
		
		override public function play(param1:Number) : void
		{
			var startTime:Number = NaN;
			var loop:int = 0;
			var startPosition:Number = NaN;
			var curMilliSec:Number = param1;
			try
			{
				if(this._state != STATE_PLAYING)
				{
					startTime = curMilliSec - this.startMilliSec;
					if(_trimStartFrame > 1)
					{
						startTime = startTime + UtilUnitConvert.frameToTime(_trimStartFrame) * 1000;
					}
					if(SoundHelper.isSoundBufferReadyAtTime(this.sound,startTime,this._isSoundCompletelyDownload))
					{
						this._soundCompletedOnce = false;
						loop = !!_loopSound?int(int.MAX_VALUE):0;
						if(loop)
						{
							startTime = startTime % this.sound.length;
						}
						this.soundChannel = this.sound.play(startTime,loop,this.soundTransform);
						this.soundChannel.addEventListener(Event.SOUND_COMPLETE,this.doSoundComplete);
						if(!this._isSoundCompletelyDownload)
						{
							SoundHelper.addBufferExhaustEventListenerToSoundChannel(this.soundChannel,this.sound,this.startMilliSec,this.endMilliSec,this.onBufferExhaust);
						}
						this.state = STATE_PLAYING;
						startPosition = Math.floor(startTime * SAMPLE_RATE / 1000);
						this.sound.extract(new ByteArray(),1,startPosition);
					}
					else
					{
						this._currentPlayingMilliSecond = curMilliSec;
						this.dispatchBufferExhaustEvent(curMilliSec);
					}
				}
				else
				{
					this.updateVolumeByCurrentTime(curMilliSec);
				}
				if(linkageData)
				{
					this.dispatchPitchEvent(curMilliSec);
				}
				return;
			}
			catch(e:Error)
			{
				UtilErrorLogger.getInstance().appendCustomError("ProgressiveSound:play",e);
				return;
			}
		}
		
		override public function set linkageData(param1:Array) : void
		{
			super.linkageData = param1;
			this._linkedCharacterIdArray = [];
			var _loc2_:uint = linkageData.length;
			var _loc3_:int = 0;
			while(_loc3_ < _loc2_)
			{
				this._linkedCharacterIdArray.push(AssetLinkage.getCharIdFromLinkage(linkageData[_loc3_] as String));
				_loc3_++;
			}
		}
		
		private function dispatchPitchEvent(param1:Number) : void
		{
			var samples:ByteArray = null;
			var length:Number = NaN;
			var STEP:int = 0;
			var MULTIPLIER:int = 0;
			var c:int = 0;
			var event:SpeechPitchEvent = null;
			var curMilliSec:Number = param1;
			if(!linkageData || !this.soundChannel)
			{
				return;
			}
			var total:Number = 0;
			if(!this._soundCompletedOnce)
			{
				samples = new ByteArray();
				length = Math.floor(SAMPLE_RATE / AnimeConstants.FRAME_PER_SEC);
				length = this.sound.extract(samples,length);
				samples.position = 0;
				STEP = 64;
				MULTIPLIER = 128;
				c = 0;
				while(c < 56)
				{
					try
					{
						if(c * STEP < samples.length)
						{
							samples.position = c * STEP;
							if(samples.bytesAvailable >= BYTES_PER_SAMPLE)
							{
								total = total + (Math.abs(samples.readFloat()) + Math.abs(samples.readFloat()));
							}
						}
					}
					catch(e:Error)
					{
						UtilErrorLogger.getInstance().appendCustomError("ProgressiveSound:dispatchPitchEvent",e);
					}
					c++;
				}
				total = Math.round(total * MULTIPLIER);
			}
			if(total != this._lastPitchValue && this._speechPitchCounter % 2 == 0)
			{
				this._lastPitchValue = total;
				event = new SpeechPitchEvent(SpeechPitchEvent.PITCH);
				event.charIdArray = this._linkedCharacterIdArray;
				event.soundId = this.id;
				event.value = total;
				this.dispatchEvent(event);
			}
			this._speechPitchCounter++;
			if(this._speechPitchCounter > 1000)
			{
				this._speechPitchCounter = 0;
			}
		}
		
		override public function goToAndPause(param1:Number) : void
		{
			var targetMilliSec:Number = param1;
			try
			{
				this._currentPlayingMilliSecond = targetMilliSec;
				if(this.soundChannel)
				{
					this.soundChannel.removeEventListener(AVM2SoundEvent.BUFFER_EXHAUST,this.onBufferExhaust);
					this.soundChannel.stop();
					this.soundChannel = null;
				}
				this.state = STATE_PAUSED;
				return;
			}
			catch(e:Error)
			{
				UtilErrorLogger.getInstance().appendCustomError("ProgressiveSound:goToAndPause",e);
				return;
			}
		}
		
		override public function resume() : void
		{
			this.play(this._currentPlayingMilliSecond);
		}
		
		override public function pause(param1:Number) : void
		{
			var currentTimeInMilliSecond:Number = param1;
			try
			{
				if(this.soundChannel)
				{
					this._currentPlayingMilliSecond = this.soundChannel.position + this.startMilliSec;
					this.soundChannel.removeEventListener(AVM2SoundEvent.BUFFER_EXHAUST,this.onBufferExhaust);
					this.soundChannel.stop();
					this.soundChannel = null;
				}
				this.state = STATE_PAUSED;
				return;
			}
			catch(e:Error)
			{
				UtilErrorLogger.getInstance().appendCustomError("ProgressiveSound:pause",e);
				return;
			}
		}
	}
}
