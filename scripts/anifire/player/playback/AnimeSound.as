package anifire.player.playback
{
	import anifire.constant.AnimeConstants;
	import anifire.player.managers.DownloadManager;
	import anifire.util.UtilHashArray;
	import anifire.util.UtilUnitConvert;
	import anifire.util.UtilXmlInfo;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	public class AnimeSound extends EventDispatcher
	{
		
		public static const XML_TAG:String = "sound";
		
		public static const FORMAT_MP3:String = "mp3";
		
		public static const FORMAT_SWF:String = "swf";
		
		public static const TRIM_START_XML_NODE:String = "trimStart";
		
		public static const TRIM_END_XML_NODE:String = "trimEnd";
		
		public static const START_XML_NODE:String = "start";
		
		public static const STOP_XML_NODE:String = "stop";
		
		public static const SOUND_FILE_XML_NODE:String = "sfile";
		
		public static const FADE_IN_XML_NODE:String = "fadein";
		
		public static const FADE_OUT_XML_NODE:String = "fadeout";
		
		public static const TRACK_PARAM_XML:String = "@track";
		
		public static const ID:String = "id";
		
		public static const TTS_PARAM_XML:String = "@tts";
		
		public static const VALUE_POSITIVE:String = "1";
		
		public static const VOLUME_PARAM_XML:String = "vol";
		
		public static const SUBTYPE_PARAM_XML:String = "subtype";
		
		public static const DEFAULT_FADE_DURATION:Number = 500;
		 
		
		protected var _startFrame:Number;
		
		protected var _endFrame:Number;
		
		protected var _trimStartFrame:int = 1;
		
		protected var _trimEndFrame:int = -1;
		
		protected var _actualEndFrame:Number;
		
		private var _startMilliSec:Number;
		
		private var _endMilliSec:Number;
		
		protected var _bufferProgress:Number = 0;
		
		private var _subtype:String = null;
		
		protected var _id:String;
		
		private var _file:String = "";
		
		private var _volume:Number = 1;
		
		private var _inner_volume:Number = 1;
		
		private var _fadeFactor:Number = 1;
		
		private var _duration_in_millisec:Number;
		
		private var _movieId:String;
		
		private var _myMovieSegmentEndMilliSecond:Number;
		
		private var _linkageData:Array;
		
		private var _track:Number = -1;
		
		private var _isSpeech:Boolean = false;
		
		protected var _loopSound:Boolean = true;
		
		private var _isCustomFade:Boolean;
		
		private var _customFadeInDuration:Number;
		
		private var _customFadeInVolume:Number;
		
		private var _customFadeOutDuration:Number;
		
		private var _customFadeOutVolume:Number;
		
		private var _inner_vol_bak:Number;
		
		public function AnimeSound()
		{
			super();
		}
		
		private static function getStartFrameFromSoundXML(param1:XML) : Number
		{
			return Number(param1[START_XML_NODE].toString());
		}
		
		private static function getEndFrameFromSoundXML(param1:XML) : Number
		{
			return Number(param1[STOP_XML_NODE].toString());
		}
		
		protected static function splitSoundXmlBySoundDuration(param1:XML, param2:UtilHashArray, param3:String, param4:PlayerDataStock) : Array
		{
			var _loc6_:Number = NaN;
			var _loc7_:Number = NaN;
			var _loc8_:Number = NaN;
			var _loc11_:Number = NaN;
			var _loc12_:XML = null;
			var _loc5_:Array = new Array();
			var _loc9_:AnimeSound = new AnimeSound();
			if(!_loc9_.init(param1,param2,param3,param4))
			{
				return _loc5_;
			}
			_loc6_ = _loc9_.getStartFrame();
			_loc7_ = _loc9_.getEndFrame();
			_loc8_ = UtilUnitConvert.secToFrame(_loc9_.durationInMillisec / 1000);
			if(_loc8_ <= 0)
			{
				return _loc5_;
			}
			var _loc10_:Number = _loc6_;
			do
			{
				_loc11_ = Math.min(_loc10_ + _loc8_,_loc7_);
				_loc12_ = param1.copy();
				(_loc12_.child(START_XML_NODE)[0] as XML).setChildren(_loc10_.toString());
				(_loc12_.child(STOP_XML_NODE)[0] as XML).setChildren(_loc11_.toString());
				_loc5_.push(_loc12_);
				_loc10_ = _loc11_;
			}
			while(_loc7_ - _loc11_ > 2);
			
			return _loc5_;
		}
		
		public static function createAndInitSounds(param1:XML, param2:UtilHashArray, param3:String, param4:PlayerDataStock) : Array
		{
			var isInitSuccess:Boolean = false;
			var soundXmlNode:XML = null;
			var embedSound:EmbedSound = null;
			var progressiveSound:ProgressiveSound = null;
			var splitedSoundXMLArray:Array = null;
			var curSplitedXML:XML = null;
			var streamSound:StreamSound = null;
			var length:int = 0;
			var i:int = 0;
			var soundXML:XML = param1;
			var themeXMLs:UtilHashArray = param2;
			var movieId:String = param3;
			var dataStock:PlayerDataStock = param4;
			var soundArray:Array = [];
			var downloadType:String = AnimeConstants.DOWNLOAD_TYPE_EMBED;
			var zipFileName:String = UtilXmlInfo.getZipFileNameOfSound(soundXML[SOUND_FILE_XML_NODE].toString());
			var thumbId:String = UtilXmlInfo.getThumbIdFromFileName(zipFileName);
			var themeId:String = UtilXmlInfo.getThemeIdFromFileName(zipFileName);
			var themeXml:XML = themeXMLs.getValueByKey(themeId) as XML;
			var byteArray:ByteArray = dataStock.getPlayerData(zipFileName) as ByteArray;
			if(themeXml)
			{
				soundXmlNode = XMLList(themeXml.sound.(@id == thumbId))[0];
			}
			if(soundXmlNode)
			{
				downloadType = soundXmlNode.@downloadtype;
			}
			else if(byteArray && byteArray.length > 0 && UtilXmlInfo.getFileNameExtension(zipFileName) == FORMAT_SWF)
			{
				downloadType = AnimeConstants.DOWNLOAD_TYPE_EMBED;
			}
			else
			{
				downloadType = AnimeConstants.DOWNLOAD_TYPE_PROGRESSIVE;
			}
			if(downloadType == AnimeConstants.DOWNLOAD_TYPE_EMBED)
			{
				embedSound = new EmbedSound();
				isInitSuccess = embedSound.init(soundXML,themeXMLs,movieId,dataStock);
				if(isInitSuccess)
				{
					soundArray.push(embedSound);
				}
			}
			else if(downloadType == AnimeConstants.DOWNLOAD_TYPE_PROGRESSIVE)
			{
				progressiveSound = new ProgressiveSound();
				isInitSuccess = progressiveSound.init(soundXML,themeXMLs,movieId,dataStock);
				if(isInitSuccess)
				{
					soundArray.push(progressiveSound);
				}
			}
			else if(downloadType == AnimeConstants.DOWNLOAD_TYPE_STREAM)
			{
				splitedSoundXMLArray = splitSoundXmlBySoundDuration(soundXML,themeXMLs,movieId,dataStock);
				length = splitedSoundXMLArray.length;
				i = 0;
				while(i < length)
				{
					curSplitedXML = splitedSoundXMLArray[i] as XML;
					streamSound = new StreamSound();
					isInitSuccess = streamSound.init(curSplitedXML,themeXMLs,movieId,dataStock);
					if(isInitSuccess)
					{
						soundArray.push(streamSound);
					}
					i++;
				}
			}
			return soundArray;
		}
		
		public function get isSpeech() : Boolean
		{
			return this._isSpeech;
		}
		
		public function get track() : Number
		{
			return this._track;
		}
		
		public function get myMovieSegmentEndMilliSecond() : Number
		{
			return this._myMovieSegmentEndMilliSecond;
		}
		
		public function get movieId() : String
		{
			return this._movieId;
		}
		
		public function set movieId(param1:String) : void
		{
			this._movieId = param1;
		}
		
		protected function get fadeFactor() : Number
		{
			return this._fadeFactor;
		}
		
		protected function set fadeFactor(param1:Number) : void
		{
			this._fadeFactor = param1;
		}
		
		protected function get volume() : Number
		{
			return this._volume;
		}
		
		protected function set volume(param1:Number) : void
		{
			this._volume = param1;
		}
		
		protected function get inner_volume() : Number
		{
			return this._inner_volume;
		}
		
		protected function set inner_volume(param1:Number) : void
		{
			this._inner_volume = param1;
			this._inner_vol_bak = param1;
		}
		
		public function get id() : String
		{
			return this._id;
		}
		
		public function set id(param1:String) : void
		{
			this._id = param1;
		}
		
		protected function get subtype() : String
		{
			return this._subtype;
		}
		
		protected function set subtype(param1:String) : void
		{
			this._subtype = param1;
		}
		
		protected function get file() : String
		{
			return this._file;
		}
		
		protected function set file(param1:String) : void
		{
			this._file = param1;
		}
		
		public function getStartFrame() : Number
		{
			return this._startFrame;
		}
		
		protected function setStartFrame(param1:Number) : void
		{
			this._startFrame = param1;
		}
		
		public function getEndFrame() : Number
		{
			return this._endFrame;
		}
		
		protected function setEndFrame(param1:Number) : void
		{
			this._endFrame = param1;
		}
		
		public function getActualEndFrame() : Number
		{
			return this._actualEndFrame;
		}
		
		protected function setActualEndFrame(param1:Number) : void
		{
			this._actualEndFrame = param1;
		}
		
		public function get trimStartFrame() : int
		{
			return this._trimStartFrame;
		}
		
		protected function get endMilliSec() : Number
		{
			return this._endMilliSec;
		}
		
		protected function set endMilliSec(param1:Number) : void
		{
			this._endMilliSec = param1;
		}
		
		protected function get startMilliSec() : Number
		{
			return this._startMilliSec;
		}
		
		protected function set startMilliSec(param1:Number) : void
		{
			this._startMilliSec = param1;
		}
		
		public function getBufferProgress() : Number
		{
			return this._bufferProgress;
		}
		
		protected function setBufferProgress(param1:Number) : void
		{
			this._bufferProgress = param1;
		}
		
		protected function get durationInMillisec() : Number
		{
			return this._duration_in_millisec;
		}
		
		protected function set durationInMillisec(param1:Number) : void
		{
			this._duration_in_millisec = param1;
		}
		
		public function get linkageData() : Array
		{
			return this._linkageData;
		}
		
		public function set linkageData(param1:Array) : void
		{
			this._linkageData = param1;
		}
		
		private function updateStartMilliSecFromEndFrame() : void
		{
			this.startMilliSec = UtilUnitConvert.frameToSec(this.getStartFrame()) * 1000;
		}
		
		private function updateEndMilliSecFromEndFrame() : void
		{
			this.endMilliSec = UtilUnitConvert.frameToSec(this.getEndFrame()) * 1000;
		}
		
		public function init(param1:XML, param2:UtilHashArray, param3:String, param4:PlayerDataStock) : Boolean
		{
			var buffer:int = 0;
			var themeId:String = null;
			var themeXml:XML = null;
			var thumbId:String = null;
			var soundXmlNode:XML = null;
			var soundXML:XML = param1;
			var themeXMLs:UtilHashArray = param2;
			var movieId_input:String = param3;
			var dataStock:PlayerDataStock = param4;
			var startFrame:int = getStartFrameFromSoundXML(soundXML);
			var endFrame:int = getEndFrameFromSoundXML(soundXML);
			if(soundXML.hasOwnProperty(TRIM_START_XML_NODE))
			{
				this._trimStartFrame = int(soundXML.trimStart);
				startFrame = Math.min(startFrame,startFrame + this._trimStartFrame);
			}
			if(soundXML.hasOwnProperty(TRIM_END_XML_NODE))
			{
				this._trimEndFrame = int(soundXML.trimEnd);
				endFrame = Math.min(endFrame,startFrame + this._trimEndFrame - this._trimStartFrame);
			}
			this.setStartFrame(startFrame);
			this.setEndFrame(endFrame);
			this.setActualEndFrame(endFrame);
			this.updateStartMilliSecFromEndFrame();
			this.updateEndMilliSecFromEndFrame();
			this.id = soundXML.attribute(ID).toString();
			this.movieId = movieId_input;
			if(soundXML.hasOwnProperty(TRACK_PARAM_XML))
			{
				this._track = Number(soundXML.@track);
			}
			if(soundXML.hasOwnProperty(TTS_PARAM_XML) && String(soundXML.@tts) == VALUE_POSITIVE)
			{
				this._isSpeech = true;
				this._loopSound = false;
				if(this._trimStartFrame <= 1 && this._trimEndFrame <= 1)
				{
					buffer = 48;
					this.setEndFrame(endFrame + buffer);
					this.updateEndMilliSecFromEndFrame();
				}
			}
			if(soundXML.attribute(VOLUME_PARAM_XML).length() != 0)
			{
				this.inner_volume = Number(soundXML.attribute(VOLUME_PARAM_XML));
			}
			else
			{
				this.inner_volume = 1;
			}
			this.file = UtilXmlInfo.getZipFileNameOfSound(soundXML[SOUND_FILE_XML_NODE].toString());
			try
			{
				themeId = UtilXmlInfo.getThemeIdFromFileName(this.file);
				themeXml = themeXMLs.getValueByKey(themeId) as XML;
				thumbId = UtilXmlInfo.getThumbIdFromFileName(this.file);
				soundXmlNode = XMLList(themeXml.sound.(@id == thumbId))[0];
				this.subtype = soundXmlNode.attribute(SUBTYPE_PARAM_XML).length() > 0?soundXmlNode.@subtype:AnimeConstants.ASSET_TYPE_SOUND_SUBTYPE_BG_MUSIC;
				this.durationInMillisec = parseFloat(soundXmlNode.@duration);
			}
			catch(e:Error)
			{
				this.subtype = AnimeConstants.ASSET_TYPE_SOUND_SUBTYPE_BG_MUSIC;
			}
			if(soundXML.hasOwnProperty(FADE_IN_XML_NODE))
			{
				this._customFadeInDuration = UtilUnitConvert.frameToDuration(Number(soundXML.fadein.@duration)) * 1000;
				this._customFadeInVolume = Number(soundXML.fadein.@vol);
				this._isCustomFade = true;
			}
			if(soundXML.hasOwnProperty(FADE_OUT_XML_NODE))
			{
				this._customFadeOutDuration = UtilUnitConvert.frameToDuration(Number(soundXML.fadeout.@duration)) * 1000;
				this._customFadeOutVolume = Number(soundXML.fadeout.@vol);
				this._isCustomFade = true;
			}
			var totalDuration:int = UtilUnitConvert.frameToDuration(endFrame - startFrame) * 1000;
			if(totalDuration < this._customFadeOutDuration)
			{
				this._customFadeInDuration = 0;
				this._customFadeOutDuration = 0;
			}
			else if(totalDuration < this._customFadeInDuration + this._customFadeOutDuration)
			{
				this._customFadeInDuration = 0;
			}
			return true;
		}
		
		public function initDependency(param1:Number, param2:Number, param3:DownloadManager) : void
		{
			var _loc4_:Number = this.getStartFrame() + param1;
			var _loc5_:Number = this.getEndFrame() + param1;
			this._myMovieSegmentEndMilliSecond = UtilUnitConvert.frameToSec(param1 + param2) * 1000;
			if(_loc4_ < param1 + param2)
			{
				if(_loc5_ > param1 + param2)
				{
					_loc5_ = param1 + param2;
				}
			}
			else
			{
				this.inner_volume = 0;
			}
			this.setStartFrame(_loc4_);
			this.setEndFrame(_loc5_);
			this.updateStartMilliSecFromEndFrame();
			this.updateEndMilliSecFromEndFrame();
		}
		
		public function play(param1:Number) : void
		{
		}
		
		public function goToAndPause(param1:Number) : void
		{
		}
		
		public function pause(param1:Number) : void
		{
		}
		
		public function resume() : void
		{
		}
		
		public function setVolume(param1:Number) : void
		{
		}
		
		public function fadeVolume(param1:Number) : void
		{
		}
		
		public function updateVolumeByCurrentTime(param1:Number) : void
		{
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			if(this._isCustomFade)
			{
				_loc2_ = this.customMusicFadeByCurrentTime(param1);
			}
			else
			{
				_loc2_ = this.defaultMusicFadeByCurrentTime(param1);
			}
			_loc3_ = this.defaultMusicEndFadeByCurrentTime(param1);
			var _loc4_:Number = _loc3_ * _loc2_;
			if(this.fadeFactor != _loc4_)
			{
				this.fadeVolume(_loc4_);
			}
		}
		
		private function defaultMusicEndFadeByCurrentTime(param1:Number) : Number
		{
			var _loc2_:Number = 1;
			var _loc3_:Number = this.myMovieSegmentEndMilliSecond - param1;
			if(_loc3_ <= DEFAULT_FADE_DURATION && _loc3_ >= 0)
			{
				_loc2_ = _loc3_ / DEFAULT_FADE_DURATION;
			}
			else if(param1 > this.myMovieSegmentEndMilliSecond)
			{
				_loc2_ = 0;
			}
			return _loc2_;
		}
		
		private function customMusicFadeByCurrentTime(param1:Number) : Number
		{
			var _loc2_:Number = this.inner_volume;
			var _loc3_:Number = 1;
			var _loc4_:Number = this.startMilliSec + this._customFadeInDuration;
			var _loc5_:Number = this.endMilliSec - this._customFadeOutDuration;
			if(this.endMilliSec - this.startMilliSec <= this._customFadeInDuration + this._customFadeOutDuration)
			{
				_loc3_ = _loc2_;
			}
			else if(param1 >= _loc4_ && param1 <= _loc5_)
			{
				_loc3_ = _loc2_;
			}
			else if(param1 >= this.startMilliSec && param1 <= _loc4_)
			{
				_loc3_ = (_loc2_ - this._customFadeInVolume) * ((param1 - this.startMilliSec) / this._customFadeInDuration) + this._customFadeInVolume;
			}
			else if(param1 >= _loc5_ && param1 <= this.endMilliSec)
			{
				_loc3_ = (_loc2_ - this._customFadeOutVolume) * ((this.endMilliSec - param1) / this._customFadeOutDuration) + this._customFadeOutVolume;
			}
			else
			{
				_loc3_ = 0;
			}
			_loc3_ = _loc3_ / _loc2_;
			return _loc3_;
		}
		
		private function defaultMusicFadeByCurrentTime(param1:Number) : Number
		{
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			var _loc2_:Number = 1;
			if(this.subtype == AnimeConstants.ASSET_TYPE_SOUND_SUBTYPE_BG_MUSIC)
			{
				_loc3_ = this.startMilliSec + DEFAULT_FADE_DURATION;
				_loc4_ = this.endMilliSec - DEFAULT_FADE_DURATION;
				if(this.endMilliSec - this.startMilliSec <= DEFAULT_FADE_DURATION * 2)
				{
					_loc2_ = 1;
				}
				else if(param1 >= _loc3_ && param1 <= _loc4_)
				{
					_loc2_ = 1;
				}
				else if(param1 >= this.startMilliSec && param1 <= _loc3_)
				{
					_loc2_ = (param1 - this.startMilliSec) / DEFAULT_FADE_DURATION;
				}
				else if(param1 >= _loc4_ && param1 <= this.endMilliSec)
				{
					_loc2_ = (this.endMilliSec - param1) / DEFAULT_FADE_DURATION;
				}
				else
				{
					_loc2_ = 0;
				}
			}
			return _loc2_;
		}
	}
}
