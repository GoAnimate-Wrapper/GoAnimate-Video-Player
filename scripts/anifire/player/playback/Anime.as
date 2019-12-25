package anifire.player.playback
{
	import anifire.component.ProgressMonitor;
	import anifire.constant.AnimeConstants;
	import anifire.constant.ServerConstants;
	import anifire.constant.ThemeConstants;
	import anifire.core.AssetLinkage;
	import anifire.core.CCLipSyncController;
	import anifire.event.AVM2SoundEvent;
	import anifire.event.LoadMgrEvent;
	import anifire.interfaces.IIterator;
	import anifire.iterators.ArrayIterator;
	import anifire.managers.AppConfigManager;
	import anifire.managers.CCThemeManager;
	import anifire.player.assetTransitions.sound.TransitionSound;
	import anifire.player.assetTransitions.views.WhiteboardHand;
	import anifire.player.events.PlayerEvent;
	import anifire.player.events.SceneBufferEvent;
	import anifire.player.managers.DownloadManager;
	import anifire.player.managers.PlayerApiManager;
	import anifire.player.managers.PlayerFontManager;
	import anifire.player.managers.RemoteDataManager;
	import anifire.player.managers.SceneBufferManager;
	import anifire.player.sceneEffects.EffectAsset;
	import anifire.util.FontManager;
	import anifire.util.GoExtInterface;
	import anifire.util.Util;
	import anifire.util.UtilErrorLogger;
	import anifire.util.UtilEventDispatcher;
	import anifire.util.UtilHashArray;
	import anifire.util.UtilLoadMgr;
	import anifire.util.UtilPlain;
	import anifire.util.UtilUnitConvert;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import mx.graphics.codec.PNGEncoder;
	import mx.utils.Base64Encoder;
	
	public class Anime
	{
		
		private static const STATE_NULL:int = 0;
		
		private static const STATE_PLAYING:int = 1;
		
		private static const STATE_PAUSING:int = 2;
		
		protected static const COMMAND_NULL:int = 0;
		
		protected static const COMMAND_PLAY:int = 1;
		
		protected static const COMMAND_PAUSE:int = 2;
		
		protected static const COMMAND_GOTO_AND_PAUSE:int = 3;
		
		protected static const COMMAND_SET_VOLUME:int = 4;
		
		protected static const COMMAND_REMOVE_ENTER_FRAME:int = 5;
		
		protected static const COMMAND_ADD_ENTER_FRAME:int = 6;
		
		protected static const COMMAND_END:int = 7;
		
		protected static const COMMAND_GOTO_AND_PAUSE_RESET:int = 8;
		 
		
		private var _animeScenes:Vector.<AnimeScene>;
		
		private var _animeSceneIndice:Object;
		
		private var _sounds:Array;
		
		private var _embedSounds:Array;
		
		private var _soundsIndexByFrame:UtilHashArray;
		
		private var _soundsIndexByStartFrame:UtilHashArray;
		
		private var _soundsIndexByEndFrame:UtilHashArray;
		
		private var _currentSceneIndex:int = -1;
		
		private var _currentFrame:int = 0;
		
		private var _dataStock:PlayerDataStock = null;
		
		private var _animeStage:MovieClip = null;
		
		private var _state:int = 0;
		
		private var _eventDispatcher:UtilEventDispatcher;
		
		private var _currentCommand:int = 0;
		
		private var _currentCommandArg:Array;
		
		private var _duration:Number = -1;
		
		private var _movieDurationPerMovie:UtilHashArray;
		
		private var _prevSystemTime:Number = -1;
		
		private var _prevFrame:Number = -1;
		
		private var _downloadManager:DownloadManager;
		
		private var _isInitialized:Boolean = false;
		
		private var _startFrameOffsetForEachMovie:UtilHashArray;
		
		private var _movieInfo:Object;
		
		private var pauseAtFirstFrame:Boolean = false;
		
		private var _licensedSoundInfo:String = "";
		
		private var _isSceneCharacterChecked:Boolean = false;
		
		private var _hiddenMovieTag:String = "";
		
		private var _previewStartFrame:int = 1;
		
		private var _playerFontManager:PlayerFontManager;
		
		private var _lastShownScene:AnimeScene;
		
		private var _handDrawnEffect:WhiteboardHand;
		
		private var _linkages:Vector.<AssetLinkage>;
		
		private var _assetSound:AssetSound;
		
		private var _initRemoteData:Boolean = false;
		
		private var firstLoad:Boolean = true;
		
		private var setVolumeAtFirstLoad:Boolean = false;
		
		private var lastNum:Number = 0;
		
		private var photoTaken:Boolean = false;
		
		private var en:PNGEncoder;
		
		private var encoder:Base64Encoder;
		
		private var _allSceneBufferReady:Boolean = false;
		
		private var _isReset:Boolean = false;
		
		private var _isResetCompleted:Boolean = false;
		
		private var photoArray:Array;
		
		private var photoExistArray:Array;
		
		private var is_golite_preview:String;
		
		private var _volume:Number = 1;
		
		public function Anime()
		{
			this._animeScenes = new Vector.<AnimeScene>();
			this._animeSceneIndice = {};
			this._sounds = new Array();
			this._embedSounds = new Array();
			this._soundsIndexByFrame = new UtilHashArray();
			this._soundsIndexByStartFrame = new UtilHashArray();
			this._soundsIndexByEndFrame = new UtilHashArray();
			this._eventDispatcher = new UtilEventDispatcher();
			this._downloadManager = DownloadManager.getInstance();
			this._startFrameOffsetForEachMovie = new UtilHashArray();
			this._movieInfo = {};
			this._linkages = new Vector.<AssetLinkage>();
			this.en = new PNGEncoder();
			this.encoder = new Base64Encoder();
			this.photoArray = new Array();
			this.photoExistArray = new Array();
			this.is_golite_preview = AppConfigManager.instance.getValue(ServerConstants.FLASHVAR_IS_GOLITE_PREVIEW);
			super();
			this._dataStock = new PlayerDataStock();
			this.setMovieContainer(new MovieClip());
		}
		
		public function get licensedSoundInfo() : String
		{
			return this._licensedSoundInfo;
		}
		
		public function set movieInfo(param1:Object) : void
		{
			this._movieInfo = param1;
		}
		
		public function get movieInfo() : Object
		{
			return this._movieInfo;
		}
		
		public function get hiddenMovieTag() : String
		{
			return this._hiddenMovieTag;
		}
		
		private function get movieDurationPerMovie() : UtilHashArray
		{
			return this._movieDurationPerMovie;
		}
		
		private function set movieDurationPerMovie(param1:UtilHashArray) : void
		{
			this._movieDurationPerMovie = param1;
		}
		
		public function get eventDispatcher() : EventDispatcher
		{
			return this._eventDispatcher;
		}
		
		public function get duration#1() : Number
		{
			return this._duration;
		}
		
		private function set duration#156(param1:Number) : void
		{
			this._duration = param1;
		}
		
		public function get totalDurationInSecond() : Number
		{
			return UtilUnitConvert.frameToSec(this._duration);
		}
		
		private function get startFrameOffsetForEachMovie() : UtilHashArray
		{
			return this._startFrameOffsetForEachMovie;
		}
		
		private function updateStartFrameOffsetForEachMovie() : void
		{
			var _loc1_:int = 0;
			var _loc2_:int = 0;
			var _loc3_:Number = NaN;
			var _loc4_:String = null;
			var _loc5_:int = 0;
			var _loc6_:Number = NaN;
			var _loc7_:AnimeScene = null;
			var _loc8_:Number = NaN;
			this._movieDurationPerMovie = this._startFrameOffsetForEachMovie.clone();
			_loc2_ = this._startFrameOffsetForEachMovie.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._movieDurationPerMovie.push(this._movieDurationPerMovie.getKey(_loc1_),0);
				this._startFrameOffsetForEachMovie.push(this._startFrameOffsetForEachMovie.getKey(_loc1_),0);
				_loc1_++;
			}
			_loc2_ = this._animeScenes.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				_loc7_ = this._animeScenes[_loc1_];
				_loc4_ = _loc7_.movieId;
				_loc5_ = this.movieDurationPerMovie.getIndex(_loc4_);
				_loc6_ = _loc7_.duration#1;
				_loc3_ = this.movieDurationPerMovie.getValueByIndex(_loc5_) as Number;
				this.movieDurationPerMovie.push(_loc4_,_loc3_ + _loc6_);
				_loc1_++;
			}
			if(this._startFrameOffsetForEachMovie.length > 0)
			{
				this._startFrameOffsetForEachMovie.push(this._startFrameOffsetForEachMovie.getKey(0),0);
			}
			_loc2_ = this._startFrameOffsetForEachMovie.length;
			_loc1_ = 1;
			while(_loc1_ < _loc2_)
			{
				_loc4_ = this._startFrameOffsetForEachMovie.getKey(_loc1_);
				_loc5_ = _loc1_;
				_loc8_ = this._startFrameOffsetForEachMovie.getValueByIndex(_loc5_ - 1) as Number;
				_loc6_ = this._movieDurationPerMovie.getValueByIndex(_loc1_ - 1) as Number;
				this._startFrameOffsetForEachMovie.push(_loc4_,_loc8_ + _loc6_);
				_loc1_++;
			}
		}
		
		public function get currentFrame() : Number
		{
			return this._currentFrame;
		}
		
		private function getCurCommand() : int
		{
			return this._currentCommand;
		}
		
		private function getCurCommandArg() : Array
		{
			return this._currentCommandArg;
		}
		
		private function setCurCommand(param1:int, param2:Array = null) : void
		{
			this._currentCommand = param1;
			this._currentCommandArg = param2;
		}
		
		private function removeCurCommand() : void
		{
			this._currentCommand = COMMAND_NULL;
			this._currentCommandArg = null;
		}
		
		public function getCurrentScene() : AnimeScene
		{
			if(this._currentSceneIndex >= 0 && this._currentSceneIndex < this._animeScenes.length)
			{
				return this._animeScenes[this._currentSceneIndex];
			}
			return null;
		}
		
		private function setCurrentScene(param1:int, param2:Boolean = true, param3:Boolean = false) : void
		{
			var _loc4_:AnimeScene = null;
			var _loc5_:Sprite = null;
			var _loc6_:AnimeScene = null;
			var _loc7_:Sprite = null;
			UtilErrorLogger.getInstance().info("Anime::setCurrentScene: " + param1);
			if(param1 != this._currentSceneIndex && param1 >= 0 && param1 < this._animeScenes.length)
			{
				_loc4_ = this._animeScenes[param1];
				if(this._currentSceneIndex >= 0 && this._currentSceneIndex < this._animeScenes.length)
				{
					_loc6_ = this._animeScenes[this._currentSceneIndex];
					if(_loc6_)
					{
						if(param2)
						{
							_loc7_ = _loc6_.getSceneMasterContainer() as Sprite;
							if(_loc7_)
							{
								_loc7_.soundTransform = new SoundTransform(0);
							}
						}
					}
				}
				if(_loc4_.hasTransition())
				{
					this.prepareSceneTransitionImage(_loc6_,_loc4_.isTransitionBleed());
				}
				this._currentSceneIndex = param1;
				if(_loc4_.readyToPlay || this._currentSceneIndex == 0)
				{
					this.putSceneToStage(this._currentSceneIndex);
				}
				_loc5_ = _loc4_.getSceneMasterContainer() as Sprite;
				if(_loc5_)
				{
					_loc5_.soundTransform = new SoundTransform(1);
				}
				if(!param3 && _loc4_ == this._animeScenes[this.searchSceneIndexByFrame(this._currentFrame)])
				{
					this.setCurrentSceneSound(_loc4_);
				}
				this.notifySceneEvent();
			}
		}
		
		public function notifySceneEvent() : void
		{
			var _loc1_:AnimeScene = this._animeScenes[this._currentSceneIndex];
			var _loc2_:Object = {};
			_loc2_["guid"] = _loc1_.guid;
			PlayerApiManager.instance.notifyEvent("scene",_loc2_);
		}
		
		public function getSceneInfoArray() : Array
		{
			var _loc5_:AnimeScene = null;
			var _loc1_:Array = [];
			var _loc2_:int = this._animeScenes.length;
			var _loc3_:Number = 0;
			var _loc4_:int = 0;
			while(_loc4_ < _loc2_)
			{
				_loc5_ = this._animeScenes[_loc4_];
				_loc1_.push({
					"guid":_loc5_.guid,
					"duration":_loc5_.durationInSecond,
					"startFrom":_loc3_
				});
				_loc3_ = _loc3_ + _loc5_.durationInSecond;
				_loc4_++;
			}
			return _loc1_;
		}
		
		public function getFrameByGuid(param1:String) : int
		{
			var _loc4_:AnimeScene = null;
			var _loc2_:int = this._animeScenes.length;
			var _loc3_:int = 0;
			while(_loc3_ < _loc2_)
			{
				_loc4_ = this._animeScenes[_loc3_];
				if(_loc4_.guid == param1)
				{
					return _loc4_.startFrame + 1;
				}
				_loc3_++;
			}
			return -1;
		}
		
		private function prepareSceneTransitionImage(param1:AnimeScene, param2:Boolean = false) : void
		{
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			var _loc6_:DisplayObjectContainer = null;
			var _loc7_:Number = NaN;
			var _loc8_:Matrix = null;
			var _loc9_:BitmapData = null;
			var _loc10_:Array = null;
			var _loc11_:BitmapData = null;
			var _loc5_:Number = !!param2?Number(PlayerConstant.BLEED_MARGIN):Number(0);
			if(param1)
			{
				_loc6_ = this.getMovieContainer().parent.parent.parent.parent;
				if(_loc6_)
				{
					_loc7_ = _loc6_.scaleX;
					_loc3_ = (AnimeConstants.SCREEN_WIDTH + _loc5_ * 2) * _loc7_;
					_loc4_ = (AnimeConstants.screenHeight + _loc5_ * 2) * _loc7_;
					_loc8_ = new Matrix();
					_loc9_ = new BitmapData(_loc3_,_loc4_);
					_loc8_.translate(-(AnimeConstants.SCREEN_X - _loc5_),-(AnimeConstants.screenY - _loc5_));
					_loc8_.scale(_loc7_,_loc7_);
					_loc10_ = param1.advanceCharacterActionsToNextFrame();
					_loc9_.draw(param1.getSceneMasterContainer(),_loc8_);
					param1.resumeCharacterActions(_loc10_);
					param1.endSceneCapture = _loc9_;
				}
			}
			else
			{
				_loc3_ = AnimeConstants.SCREEN_WIDTH + _loc5_ * 2;
				_loc4_ = AnimeConstants.screenHeight + _loc5_ * 2;
				_loc11_ = new BitmapData(_loc3_,_loc4_,false,0);
			}
		}
		
		public function destroyAllScene() : void
		{
			SceneBufferManager.instance.reset();
			var _loc1_:int = this._animeScenes.length;
			var _loc2_:int = 0;
			while(_loc2_ < _loc1_)
			{
				this._animeScenes[_loc2_].destroy(true);
				_loc2_++;
			}
			this._animeScenes.splice(0,this._animeScenes.length);
		}
		
		private function stopAssetMusicInFirstAppearScene(param1:Asset, param2:Asset = null, param3:String = "") : void
		{
			var _loc4_:String = null;
			var _loc5_:String = null;
			var _loc6_:String = null;
			var _loc7_:String = null;
			var _loc8_:AnimeScene = null;
			var _loc9_:AnimeScene = null;
			var _loc10_:Boolean = false;
			if(param1 is Background)
			{
				_loc6_ = param1.id;
				_loc8_ = this._animeScenes[this._currentSceneIndex];
				_loc9_ = _loc8_.prevScene;
				while(_loc9_ != null)
				{
					if(_loc9_.getBgByID(_loc6_) != null)
					{
						param1 = _loc9_.getBgByID(_loc6_);
						_loc9_ = _loc9_.prevScene;
						continue;
					}
					break;
				}
				param1.stopMusic();
			}
			else if(param1 is Character && param3 != "")
			{
				_loc7_ = param1.id;
				_loc8_ = this._animeScenes[this._currentSceneIndex];
				_loc9_ = _loc8_.prevScene;
				_loc10_ = false;
				while(_loc9_ != null)
				{
					if(param3 == "prop")
					{
						if(_loc9_.getCharByID(_loc7_) != null && _loc9_.getCharByID(_loc7_).prop != null && _loc9_.getCharByID(_loc7_).prop.file == (param2 as Prop).file)
						{
							param2 = _loc9_.getCharByID(_loc7_).prop;
						}
						else
						{
							_loc10_ = true;
						}
					}
					else if(param3 == "head")
					{
						if(_loc9_.getCharByID(_loc7_) != null && _loc9_.getCharByID(_loc7_).head != null && _loc9_.getCharByID(_loc7_).head.file == (param2 as Prop).file)
						{
							param2 = _loc9_.getCharByID(_loc7_).head;
						}
						else
						{
							_loc10_ = true;
						}
					}
					else if(param3 == "wear")
					{
						if(_loc9_.getCharByID(_loc7_) != null && _loc9_.getCharByID(_loc7_).wear != null && _loc9_.getCharByID(_loc7_).wear.file == (param2 as Prop).file)
						{
							param2 = _loc9_.getCharByID(_loc7_).wear;
						}
						else
						{
							_loc10_ = true;
						}
					}
					if(_loc10_ == true)
					{
						break;
					}
					_loc9_ = _loc9_.prevScene;
				}
				param2.stopMusic();
			}
			else if(param1 is Prop)
			{
				_loc5_ = param1.id;
				_loc8_ = this._animeScenes[this._currentSceneIndex];
				_loc9_ = _loc8_.prevScene;
				while(_loc9_ != null)
				{
					if(_loc9_.getPropById(_loc5_) != null)
					{
						param1 = _loc9_.getPropById(_loc5_);
						_loc9_ = _loc9_.prevScene;
						continue;
					}
					break;
				}
				param1.stopMusic();
			}
			else if(param1 is EffectAsset)
			{
				_loc4_ = param1.id;
				_loc8_ = this._animeScenes[this._currentSceneIndex];
				_loc9_ = _loc8_.prevScene;
				while(_loc9_ != null)
				{
					if(_loc9_.getEffectById(_loc4_) != null)
					{
						param1 = _loc9_.getEffectById(_loc4_);
						_loc9_ = _loc9_.prevScene;
						continue;
					}
					break;
				}
				param1.stopMusic();
			}
		}
		
		private function setCurrentSceneSound(param1:AnimeScene) : void
		{
			var _loc2_:AnimeScene = null;
			var _loc3_:Boolean = false;
			var _loc4_:int = 0;
			var _loc5_:int = 0;
			var _loc6_:Array = null;
			var _loc7_:String = null;
			var _loc8_:String = null;
			var _loc9_:Character = null;
			var _loc10_:Character = null;
			var _loc11_:String = null;
			var _loc12_:String = null;
			var _loc13_:Behaviour = null;
			var _loc14_:Behaviour = null;
			if(param1 != null)
			{
				_loc2_ = param1.prevScene;
				if(_loc2_ != null)
				{
					if(_loc2_.getNumBg() == 0)
					{
						if(param1.getNumBg() != 0)
						{
							param1.getBgByIndex(0).playMusic(0,0,new SoundTransform(this.volume));
						}
					}
					else if(param1.getNumBg() != 0)
					{
						if(_loc2_.getBgByIndex(0).id != param1.getBgByIndex(0).id)
						{
							this.stopAssetMusicInFirstAppearScene(_loc2_.getBgByIndex(0));
							param1.getBgByIndex(0).playMusic(0,0,new SoundTransform(this.volume));
						}
					}
					else
					{
						this.stopAssetMusicInFirstAppearScene(_loc2_.getBgByIndex(0));
					}
					_loc3_ = false;
					_loc4_ = 0;
					_loc5_ = 0;
					_loc6_ = new Array();
					_loc4_ = 0;
					while(_loc4_ < param1.getNumProp())
					{
						_loc11_ = param1.getPropByIndex(_loc4_).id;
						if(_loc2_.getPropById(_loc11_) == null)
						{
							param1.getPropByIndex(_loc4_).playMusic(0,0,new SoundTransform(this.volume));
						}
						else
						{
							_loc6_.push(param1.getPropByIndex(_loc4_).id);
						}
						_loc4_++;
					}
					_loc4_ = 0;
					while(_loc4_ < _loc2_.getNumProp())
					{
						_loc3_ = false;
						_loc5_ = 0;
						while(_loc5_ < _loc6_.length)
						{
							if(_loc2_.getPropByIndex(_loc4_).id == _loc6_[_loc5_])
							{
								_loc3_ = true;
								break;
							}
							_loc5_++;
						}
						if(!_loc3_)
						{
							this.stopAssetMusicInFirstAppearScene(_loc2_.getPropByIndex(_loc4_));
						}
						_loc4_++;
					}
					_loc4_ = 0;
					while(_loc4_ < param1.getNumChar())
					{
						_loc7_ = param1.getCharByIndex(_loc4_).id;
						_loc9_ = _loc2_.getCharByID(_loc7_);
						if(param1.getCharByIndex(_loc4_).prop != null && param1.getCharByIndex(_loc4_).prop.sound != null)
						{
							_loc8_ = param1.getCharByIndex(_loc4_).prop.file;
							if(_loc9_ == null || _loc9_ != null && _loc9_.prop == null || _loc9_ != null && _loc9_.prop.file != _loc8_)
							{
								param1.getCharByIndex(_loc4_).prop.playMusic(0,0,new SoundTransform(this.volume));
							}
						}
						if(param1.getCharByIndex(_loc4_).head != null && param1.getCharByIndex(_loc4_).head.sound != null)
						{
							_loc8_ = param1.getCharByIndex(_loc4_).head.file;
							if(_loc9_ == null || _loc9_ != null && _loc9_.head == null || _loc9_ != null && _loc9_.head.file != _loc8_)
							{
								param1.getCharByIndex(_loc4_).head.playMusic(0,0,new SoundTransform(this.volume));
							}
						}
						if(param1.getCharByIndex(_loc4_).wear != null && param1.getCharByIndex(_loc4_).wear.sound != null)
						{
							_loc8_ = param1.getCharByIndex(_loc4_).wear.file;
							if(_loc9_ == null || _loc9_ != null && _loc9_.wear == null || _loc9_ != null && _loc9_.wear.file != _loc8_)
							{
								param1.getCharByIndex(_loc4_).wear.playMusic(0,0,new SoundTransform(this.volume));
							}
						}
						_loc4_++;
					}
					_loc4_ = 0;
					while(_loc4_ < _loc2_.getNumChar())
					{
						_loc7_ = _loc2_.getCharByIndex(_loc4_).id;
						_loc10_ = param1.getCharByID(_loc7_);
						if(_loc2_.getCharByIndex(_loc4_).prop != null && _loc2_.getCharByIndex(_loc4_).prop.sound != null)
						{
							_loc8_ = _loc2_.getCharByIndex(_loc4_).prop.file;
							if(_loc10_ == null || _loc10_ != null && _loc10_.prop == null || _loc10_ != null && _loc10_.prop.file != _loc8_)
							{
								this.stopAssetMusicInFirstAppearScene(_loc2_.getCharByIndex(_loc4_),_loc2_.getCharByIndex(_loc4_).prop,"prop");
							}
						}
						if(_loc2_.getCharByIndex(_loc4_).head != null && _loc2_.getCharByIndex(_loc4_).head.sound != null)
						{
							_loc8_ = _loc2_.getCharByIndex(_loc4_).head.file;
							if(_loc10_ == null || _loc10_ != null && _loc10_.head == null || _loc10_ != null && _loc10_.head.file != _loc8_)
							{
								this.stopAssetMusicInFirstAppearScene(_loc2_.getCharByIndex(_loc4_),_loc2_.getCharByIndex(_loc4_).head,"head");
							}
						}
						if(_loc2_.getCharByIndex(_loc4_).wear != null && _loc2_.getCharByIndex(_loc4_).wear.sound != null)
						{
							_loc8_ = _loc2_.getCharByIndex(_loc4_).wear.file;
							if(_loc10_ == null || _loc10_ != null && _loc10_.wear == null || _loc10_ != null && _loc10_.wear.file != _loc8_)
							{
								this.stopAssetMusicInFirstAppearScene(_loc2_.getCharByIndex(_loc4_),_loc2_.getCharByIndex(_loc4_).wear,"wear");
							}
						}
						_loc4_++;
					}
					_loc6_ = new Array();
					_loc4_ = 0;
					while(_loc4_ < param1.getNumEffect())
					{
						_loc12_ = param1.getEffectByIndex(_loc4_).id;
						if(_loc2_.getEffectById(_loc12_) == null)
						{
							param1.getEffectByIndex(_loc4_).playMusic(0,0,new SoundTransform(this.volume));
						}
						else
						{
							_loc6_.push(param1.getEffectByIndex(_loc4_).id);
						}
						_loc4_++;
					}
					_loc4_ = 0;
					while(_loc4_ < _loc2_.getNumEffect())
					{
						_loc3_ = false;
						_loc5_ = 0;
						while(_loc5_ < _loc6_.length)
						{
							if(_loc2_.getEffectByIndex(_loc4_).id == _loc6_[_loc5_])
							{
								_loc3_ = true;
								break;
							}
							_loc5_++;
						}
						if(!_loc3_)
						{
							this.stopAssetMusicInFirstAppearScene(_loc2_.getEffectByIndex(_loc4_));
						}
						_loc4_++;
					}
					_loc6_ = new Array();
					_loc4_ = 0;
					while(_loc4_ < param1.getNumChar())
					{
						if(param1.getCharByIndex(_loc4_).action.isFirstBehavior)
						{
							param1.getCharByIndex(_loc4_).playMusic(0,0,new SoundTransform(this.volume));
						}
						else
						{
							_loc13_ = param1.getCharByIndex(_loc4_).action;
							while(!_loc13_.isFirstBehavior)
							{
								_loc13_ = _loc13_.prevBehavior;
							}
							_loc6_.push(param1.getCharByIndex(_loc4_));
						}
						_loc4_++;
					}
					_loc4_ = 0;
					while(_loc4_ < _loc2_.getNumChar())
					{
						_loc3_ = false;
						_loc5_ = 0;
						while(_loc5_ < _loc6_.length)
						{
							if(_loc2_.getCharByIndex(_loc4_).motion != null)
							{
								if(_loc2_.getCharByIndex(_loc4_).motion == (_loc6_[_loc5_] as Character).action.prevBehavior)
								{
									_loc3_ = true;
								}
							}
							else if(_loc2_.getCharByIndex(_loc4_).action == (_loc6_[_loc5_] as Character).action.prevBehavior)
							{
								_loc3_ = true;
							}
							if(_loc3_)
							{
								break;
							}
							_loc5_++;
						}
						if(!_loc3_)
						{
							if(_loc2_.getCharByIndex(_loc4_).motion != null)
							{
								_loc14_ = _loc2_.getCharByIndex(_loc4_).motion;
							}
							else
							{
								_loc14_ = _loc2_.getCharByIndex(_loc4_).action;
							}
							while(_loc14_.isFirstBehavior != true)
							{
								if(_loc14_.prevBehavior == null)
								{
									break;
								}
								_loc14_ = _loc14_.prevBehavior;
							}
							_loc14_.myChar.stopMusic();
						}
						_loc4_++;
					}
				}
			}
		}
		
		private function addSound(param1:AnimeSound) : void
		{
			this._sounds.push(param1);
			if(param1 is EmbedSound)
			{
				this._embedSounds.push(param1);
			}
		}
		
		private function getSoundByIndex(param1:int) : AnimeSound
		{
			return this._sounds[param1];
		}
		
		private function getSoundById(param1:String) : AnimeSound
		{
			var _loc2_:int = 0;
			while(_loc2_ < this._sounds.length)
			{
				if(AnimeSound(this._sounds[_loc2_]).id == param1)
				{
					return AnimeSound(this._sounds[_loc2_]);
				}
				_loc2_++;
			}
			return null;
		}
		
		private function getEmbedSoundByIndex(param1:int) : EmbedSound
		{
			return this._embedSounds[param1] as EmbedSound;
		}
		
		private function getSoundsByFrame(param1:Number) : Array
		{
			var _loc2_:Array = this._soundsIndexByFrame.getValueByKey(param1.toString());
			return _loc2_ == null?new Array():_loc2_;
		}
		
		private function getSoundsByStartFrame(param1:Number) : Array
		{
			var _loc2_:Array = this._soundsIndexByStartFrame.getValueByKey(param1.toString());
			return _loc2_ == null?new Array():_loc2_;
		}
		
		private function getSoundsByEndFrame(param1:Number) : Array
		{
			var _loc2_:Array = this._soundsIndexByEndFrame.getValueByKey(param1.toString());
			return _loc2_ == null?new Array():_loc2_;
		}
		
		private function getNumSounds() : int
		{
			return this._sounds.length;
		}
		
		private function getNumEmbedSounds() : int
		{
			return this._embedSounds.length;
		}
		
		public function getDataStock() : PlayerDataStock
		{
			return this._dataStock;
		}
		
		public function setDataStock(param1:PlayerDataStock) : void
		{
			this._dataStock = param1;
		}
		
		public function getMovieContainer() : MovieClip
		{
			return this._animeStage;
		}
		
		private function setMovieContainer(param1:MovieClip) : void
		{
			this._animeStage = param1;
		}
		
		private function showMovieContainer() : void
		{
			this.getMovieContainer().visible = true;
		}
		
		private function hideMovieContainer() : void
		{
			this.getMovieContainer().visible = false;
		}
		
		private function addScene(param1:AnimeScene) : void
		{
			var _loc2_:int = this._animeScenes.push(param1) - 1;
			if(this._animeSceneIndice[param1.id] == null)
			{
				this._animeSceneIndice[param1.id] = _loc2_;
			}
		}
		
		public function getSceneByIndex(param1:int) : AnimeScene
		{
			return this._animeScenes[param1];
		}
		
		private function getSceneById(param1:String) : AnimeScene
		{
			if(this._animeSceneIndice[param1] != null)
			{
				return this._animeScenes[this._animeSceneIndice[param1]];
			}
			return null;
		}
		
		private function searchSceneIndexByFrame(param1:Number) : int
		{
			var _loc5_:AnimeScene = null;
			var _loc2_:int = 0;
			var _loc3_:int = this._animeScenes.length - 1;
			var _loc4_:int = 0;
			while(_loc2_ <= _loc3_)
			{
				_loc4_ = Math.floor((_loc2_ + _loc3_) / 2);
				_loc5_ = this._animeScenes[_loc4_];
				if(_loc5_.startFrame > param1)
				{
					_loc3_ = _loc4_ - 1;
				}
				else if(_loc5_.endFrame < param1)
				{
					_loc2_ = _loc4_ + 1;
				}
				else
				{
					_loc2_ = _loc3_ + 1;
				}
			}
			return _loc4_;
		}
		
		public function getNumScene() : Number
		{
			return this._animeScenes.length;
		}
		
		public function getAnimeScenes() : Vector.<AnimeScene>
		{
			return this._animeScenes;
		}
		
		private function sortSceneXmlByZorder(param1:XMLList) : Array
		{
			var _loc3_:XML = null;
			var _loc2_:Array = new Array();
			var _loc4_:int = 0;
			while(_loc4_ < param1.length())
			{
				_loc3_ = param1[_loc4_];
				_loc2_.push(_loc3_);
				_loc4_++;
			}
			_loc2_.sort(AnimeScene.compareSceneXmlZorder);
			return _loc2_;
		}
		
		private function doShowMovieContainer(param1:Event) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.doShowMovieContainer);
			this.showMovieContainer();
		}
		
		private function isSkipScene(param1:XML) : Boolean
		{
			var _loc2_:Boolean = false;
			if(param1.toXMLString().toLowerCase().indexOf(AnimeConstants.MAGIC_KEY) > -1)
			{
				_loc2_ = true;
			}
			if(Number(param1.@adelay) < 4.8)
			{
				_loc2_ = true;
			}
			return _loc2_;
		}
		
		protected function init(param1:PlayerDataStock, param2:Boolean = false) : void
		{
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			var _loc5_:Boolean = false;
			var _loc8_:XML = null;
			var _loc9_:Number = NaN;
			var _loc10_:Array = null;
			var _loc11_:AnimeScene = null;
			var _loc12_:XML = null;
			var _loc13_:Array = null;
			var _loc14_:AnimeSound = null;
			var _loc15_:ProgressiveSound = null;
			var _loc16_:StreamSound = null;
			var _loc17_:XML = null;
			var _loc18_:XML = null;
			var _loc19_:XMLList = null;
			var _loc20_:XML = null;
			var _loc21_:XML = null;
			var _loc22_:XMLList = null;
			var _loc23_:XML = null;
			var _loc24_:AssetLinkage = null;
			var _loc25_:String = null;
			var _loc26_:AnimeSound = null;
			var _loc27_:Array = null;
			var _loc28_:AnimeScene = null;
			UtilErrorLogger.getInstance().info("Anime:init");
			this._assetSound = new AssetSound(this);
			this._dataStock = param1;
			this._downloadManager = DownloadManager.getInstance();
			this._downloadManager.init();
			this._playerFontManager = PlayerFontManager.instance;
			this._playerFontManager.dataStock = this._dataStock;
			var _loc6_:int = 0;
			while(_loc6_ < param1.getFilmXmlArray().length)
			{
				_loc8_ = param1.getFilmXmlArray()[_loc6_] as XML;
				_loc9_ = XML(_loc8_.child("meta")[0]).child("mver")[0] != null?Number(Number(XML(_loc8_.child("meta")[0]).child("mver")[0])):Number(0);
				this._startFrameOffsetForEachMovie.push(_loc6_.toString(),0);
				this._hiddenMovieTag = this._hiddenMovieTag + _loc8_.meta.hiddenTag;
				_loc10_ = this.sortSceneXmlByZorder(_loc8_.child(AnimeScene.XML_TAG));
				_loc3_ = 0;
				while(_loc3_ < _loc10_.length)
				{
					_loc12_ = _loc10_[_loc3_] as XML;
					if(!this.isSkipScene(_loc12_))
					{
						_loc11_ = new AnimeScene();
						_loc11_.init(_loc12_,this,this.getDataStock().getThemeXMLs(),this.getDataStock(),_loc9_,_loc6_.toString(),param2);
						this.addScene(_loc11_);
					}
					_loc3_++;
				}
				this._licensedSoundInfo = "";
				_loc3_ = 0;
				while(_loc3_ < _loc8_.child(AnimeSound.XML_TAG).length())
				{
					_loc17_ = _loc8_.child(AnimeSound.XML_TAG)[_loc3_];
					if(int(_loc17_.stop) > int(_loc17_.start))
					{
						_loc13_ = AnimeSound.createAndInitSounds(_loc17_,this.getDataStock().getThemeXMLs(),_loc6_.toString(),this.getDataStock());
						_loc4_ = 0;
						while(_loc4_ < _loc13_.length)
						{
							_loc14_ = _loc13_[_loc4_] as AnimeSound;
							this.addSound(_loc14_);
							if(_loc14_ is ProgressiveSound)
							{
								_loc15_ = _loc14_ as ProgressiveSound;
								_loc15_.addEventListener(PlayerEvent.BUFFER_EXHAUST,this.onBufferExhaust,false,0,true);
							}
							else if(_loc14_ is StreamSound)
							{
								_loc16_ = _loc14_ as StreamSound;
								_loc16_.addEventListener(AVM2SoundEvent.BUFFER_EXHAUST,this.onBufferExhaust,false,0,true);
							}
							_loc4_++;
						}
						if(_loc17_.hasOwnProperty("info"))
						{
							this._licensedSoundInfo = this._licensedSoundInfo + (_loc17_.info.title + " - Author: " + _loc17_.info.author + "\n");
						}
					}
					_loc3_++;
				}
				_loc19_ = _loc8_..text;
				for each(_loc18_ in _loc19_)
				{
					if(_loc18_.@embed != "false" && _loc18_.hasOwnProperty("@font"))
					{
						this._playerFontManager.addFont(_loc18_.@font);
					}
				}
				_loc22_ = _loc8_..chart;
				for each(_loc20_ in _loc22_)
				{
					_loc21_ = _loc20_.style[0];
					if(_loc21_.hasOwnProperty("@font"))
					{
						this._playerFontManager.addCffFont(_loc21_.@font);
					}
				}
				_loc3_ = 0;
				while(_loc3_ < _loc8_.child(AssetLinkage.XML_TAG).length())
				{
					_loc23_ = _loc8_.child(AssetLinkage.XML_TAG)[_loc3_];
					_loc24_ = new AssetLinkage();
					_loc24_.deserialize(_loc23_);
					this._linkages.push(_loc24_);
					_loc25_ = _loc24_.getSoundId();
					_loc26_ = this.getSoundById(_loc25_);
					if(_loc26_)
					{
						_loc26_.linkageData = _loc24_.getSceneAndCharId();
						_loc27_ = _loc24_.getSceneId();
						_loc4_ = 0;
						while(_loc4_ < _loc27_.length)
						{
							_loc28_ = this.getSceneById(_loc27_[_loc4_]);
							if(_loc28_)
							{
								_loc28_.narration = _loc26_;
							}
							_loc4_++;
						}
					}
					_loc3_++;
				}
				_loc6_++;
			}
			var _loc7_:XML = param1.getThemeXMLs().getValueByKey(ThemeConstants.UGC_THEME_ID);
			if(_loc7_)
			{
				CCThemeManager.instance.getThemeModel(ThemeConstants.UGC_THEME_ID).parseThemeXML(_loc7_);
			}
			if(param1.playerCustomFontList)
			{
				FontManager.instance.addCustomFontList(param1.playerCustomFontList as Array);
			}
			this.hideMovieContainer();
			this.addEventListener(PlayerEvent.PLAYHEAD_TIME_CHANGE,this.doShowMovieContainer,false,0,true);
			this._playerFontManager.addEventListener(Event.COMPLETE,this.onAllFontsLoaded);
			this._playerFontManager.loadAllFonts();
			this._isInitialized = true;
		}
		
		private function checkSoundOverlapWithScene(param1:AnimeSound, param2:AnimeScene) : Boolean
		{
			if(param1.getActualEndFrame() < param2.startFrame || param1.getStartFrame() > param2.endFrame)
			{
				return false;
			}
			return true;
		}
		
		private function onAllFontsLoaded(param1:Event) : void
		{
			this._playerFontManager.removeEventListener(param1.type,this.onAllFontsLoaded);
			this.initDependency();
		}
		
		private function onBufferExhaust(param1:Event) : void
		{
			this.removeEnterFrame();
			this.dispatchEvent(new PlayerEvent(PlayerEvent.BUFFER_EXHAUST));
			this._downloadManager.addEventListener(PlayerEvent.BUFFER_READY,this.onBufferReady,false,0,true);
			this._downloadManager.reorganizeCustomerQueue(UtilUnitConvert.frameToSec(this._currentFrame) * 1000);
		}
		
		private function onBufferReady(param1:Event) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onBufferReady);
			this.addEnterFrame();
			this.dispatchEvent(new PlayerEvent(PlayerEvent.BUFFER_READY));
		}
		
		private function initDependency() : void
		{
			var _loc7_:int = 0;
			var _loc8_:AnimeScene = null;
			var _loc9_:AnimeScene = null;
			var _loc10_:AnimeScene = null;
			var _loc11_:Array = null;
			var _loc12_:AnimeSound = null;
			var _loc13_:Number = NaN;
			var _loc14_:Number = NaN;
			UtilErrorLogger.getInstance().info("Anime:initDependency");
			var _loc1_:Number = 0;
			var _loc2_:Number = this._animeScenes.length;
			var _loc3_:UtilHashArray = this._dataStock.getThemeXMLs();
			var _loc4_:UtilLoadMgr = new UtilLoadMgr();
			if(_loc2_ > 0)
			{
				_loc7_ = 0;
				while(_loc7_ < _loc2_)
				{
					_loc8_ = _loc7_ < _loc2_ - 1?this._animeScenes[_loc7_ + 1]:null;
					_loc9_ = _loc7_ > 0?this._animeScenes[_loc7_ - 1]:null;
					_loc10_ = this._animeScenes[_loc7_];
					_loc10_.initDependency(_loc8_,_loc9_,_loc1_ + 1,this._downloadManager,_loc3_);
					_loc1_ = _loc1_ + _loc10_.duration#1;
					TransitionSound.soundIndex++;
					_loc7_++;
				}
				this._duration = _loc1_;
				this.setCurrentScene(0,false);
			}
			this.updateStartFrameOffsetForEachMovie();
			var _loc5_:int = 0;
			while(_loc5_ < this.getNumSounds())
			{
				_loc12_ = this.getSoundByIndex(_loc5_);
				_loc12_.initDependency(this._startFrameOffsetForEachMovie.getValueByKey(_loc12_.movieId) as Number,this._movieDurationPerMovie.getValueByKey(_loc12_.movieId) as Number,this._downloadManager);
				if(!this._soundsIndexByStartFrame.containsKey(_loc12_.getStartFrame().toString()))
				{
					this._soundsIndexByStartFrame.push(_loc12_.getStartFrame().toString(),new Array());
				}
				_loc11_ = this._soundsIndexByStartFrame.getValueByKey(_loc12_.getStartFrame().toString()) as Array;
				_loc11_.push(_loc12_);
				if(!this._soundsIndexByEndFrame.containsKey(_loc12_.getEndFrame().toString()))
				{
					this._soundsIndexByEndFrame.push(_loc12_.getEndFrame().toString(),new Array());
				}
				_loc11_ = this._soundsIndexByEndFrame.getValueByKey(_loc12_.getEndFrame().toString()) as Array;
				_loc11_.push(_loc12_);
				_loc13_ = _loc12_.getEndFrame();
				_loc14_ = _loc12_.getStartFrame();
				while(_loc14_ <= _loc13_)
				{
					if(!this._soundsIndexByFrame.containsKey(_loc14_.toString()))
					{
						this._soundsIndexByFrame.push(_loc14_.toString(),new Array());
					}
					_loc11_ = this._soundsIndexByFrame.getValueByKey(_loc14_.toString()) as Array;
					_loc11_.push(this.getSoundByIndex(_loc5_));
					_loc14_++;
				}
				_loc5_++;
			}
			this.initLipSync();
			this._downloadManager.initDependency(UtilUnitConvert.frameToSec(this._duration) * 1000,this.getMovieContainer().stage,UtilUnitConvert.frameToTime(this._previewStartFrame) * 1000);
			var _loc6_:PlayerEvent = new PlayerEvent(PlayerEvent.MOVIE_STRUCTURE_READY);
			this.dispatchEvent(_loc6_);
			this.initRemoteData(0);
			PlayerApiManager.instance.notifyEvent("ready");
		}
		
		private function initLipSync() : void
		{
			var _loc2_:AssetLinkage = null;
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			var _loc5_:int = 0;
			var _loc6_:AnimeScene = null;
			var _loc7_:Character = null;
			var _loc8_:Array = null;
			var _loc10_:int = 0;
			var _loc11_:String = null;
			var _loc12_:AnimeSound = null;
			var _loc1_:int = this._linkages.length;
			var _loc9_:int = this._animeScenes.length;
			_loc3_ = 0;
			while(_loc3_ < _loc1_)
			{
				_loc2_ = this._linkages[_loc3_];
				_loc11_ = _loc2_.getSoundId();
				_loc12_ = this.getSoundById(_loc11_);
				if(_loc12_)
				{
					_loc8_ = _loc2_.getCharId();
					if(_loc8_ && _loc8_.length > 0)
					{
						_loc10_ = _loc8_.length;
						_loc4_ = 0;
						while(_loc4_ < _loc9_)
						{
							_loc6_ = this._animeScenes[_loc4_];
							if(_loc6_ && this.checkSoundOverlapWithScene(_loc12_,_loc6_))
							{
								_loc5_ = 0;
								while(_loc5_ < _loc10_)
								{
									_loc7_ = _loc6_.getCharByID(_loc8_[_loc5_]);
									if(_loc7_)
									{
										_loc7_.addSpeechPitchSource(_loc12_);
									}
									_loc5_++;
								}
							}
							_loc4_++;
						}
					}
				}
				_loc3_++;
			}
		}
		
		private function doDispatchMovieStartBufferReady(param1:Event) : void
		{
			if(param1 != null)
			{
				(param1.target as IEventDispatcher).removeEventListener(param1.type,this.doDispatchMovieStartBufferReady);
			}
			var _loc2_:PlayerEvent = new PlayerEvent(PlayerEvent.BUFFER_READY_WHEN_MOVIE_START);
			this.dispatchEvent(_loc2_);
			if(this._previewStartFrame > 1)
			{
				this.goToAndPause(this._previewStartFrame);
			}
			this.addEnterFrame();
		}
		
		protected function startPlay() : void
		{
			UtilErrorLogger.getInstance().info("Anime:startPlay");
			this.setState(Anime.STATE_PLAYING);
			if(this.getNumScene() > 0)
			{
				this.setCurrentScene(0,false);
			}
			this.addEnterFrame();
		}
		
		private function putSceneToStage(param1:int) : void
		{
			var currentScene:AnimeScene = null;
			var movieContainer:MovieClip = null;
			var sceneContainer:DisplayObjectContainer = null;
			var sceneIndex:int = param1;
			try
			{
				if(this._animeScenes && sceneIndex >= 0 && sceneIndex < this._animeScenes.length)
				{
					currentScene = this._animeScenes[sceneIndex];
					if(currentScene)
					{
						if(this._lastShownScene)
						{
							this._lastShownScene.destroy();
						}
						this._lastShownScene = currentScene;
						currentScene.prepareImage();
						movieContainer = this.getMovieContainer();
						sceneContainer = currentScene.getSceneMasterContainer();
						if(movieContainer && sceneContainer)
						{
							UtilPlain.removeAllSon(movieContainer);
							movieContainer.addChild(sceneContainer);
						}
						currentScene.reloadWhiteboardMask();
					}
				}
				return;
			}
			catch(e:Error)
			{
				UtilErrorLogger.getInstance().error("Anime::putSceneToStage: " + e);
				return;
			}
		}
		
		public function initRemoteDataByScene(param1:AnimeScene) : void
		{
			this.initRemoteData(param1.startFrame);
		}
		
		private function initRemoteData(param1:Number) : void
		{
			var _loc5_:EmbedSound = null;
			var _loc7_:AnimeScene = null;
			if(this._initRemoteData)
			{
				return;
			}
			this._initRemoteData = true;
			UtilErrorLogger.getInstance().info("Anime:initRemoteData");
			this.removeEnterFrame();
			var _loc2_:int = this.searchSceneIndexByFrame(param1);
			var _loc3_:int = this.getNumScene();
			var _loc4_:RemoteDataManager = RemoteDataManager.getInstance();
			_loc4_.addEventListener(LoadMgrEvent.ALL_COMPLETE,this.onInitAllRemoteDataCompleted,false,0,true);
			ProgressMonitor.getInstance().addProgressEventDispatcher(_loc4_);
			_loc4_.init(this.getDataStock());
			var _loc6_:int = 0;
			while(_loc6_ < this.getNumEmbedSounds())
			{
				_loc5_ = this.getEmbedSoundByIndex(_loc6_);
				_loc4_.addTask(_loc5_);
				_loc6_++;
			}
			var _loc8_:int = _loc2_;
			while(_loc8_ < _loc2_ + _loc3_ && _loc8_ < this.getNumScene())
			{
				_loc7_ = this.getSceneByIndex(_loc8_);
				_loc4_.addTask(_loc7_);
				_loc8_++;
			}
			_loc4_.commit();
		}
		
		private function onInitEachRemoteDataCompleted(... rest) : void
		{
			this.dispatchEvent(new PlayerEvent(PlayerEvent.LOADING_BYTES));
		}
		
		private function onInitAllRemoteDataCompleted(param1:Event) : void
		{
			UtilErrorLogger.getInstance().info("initRemoteData complete!");
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onInitAllRemoteDataCompleted);
			this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
			this._allSceneBufferReady = true;
			this._downloadManager.addEventListener(PlayerEvent.BUFFER_READY,this.doDispatchMovieStartBufferReady,false,0,true);
			this._downloadManager.startDownload();
		}
		
		private function addEnterFrame() : void
		{
			if(this._animeScenes.length == 0 || this._duration == -1)
			{
				return;
			}
			if(!this.getMovieContainer().hasEventListener(Event.ENTER_FRAME))
			{
				UtilErrorLogger.getInstance().info("addEnterFrame");
				this.getMovieContainer().addEventListener(Event.ENTER_FRAME,this.onEnterFrame,false,0,true);
			}
			SceneBufferManager.highSpeedMode = false;
		}
		
		private function removeEnterFrame() : void
		{
			if(this.getMovieContainer().hasEventListener(Event.ENTER_FRAME))
			{
				UtilErrorLogger.getInstance().info("removeEnterFrame");
				this.getMovieContainer().removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
			}
			SceneBufferManager.highSpeedMode = true;
		}
		
		private function traceMemory(param1:Number, param2:String) : void
		{
			if(this.lastNum != param1)
			{
			}
			this.lastNum = param1;
		}
		
		private function onSceneBufferReady(param1:SceneBufferEvent) : void
		{
			this.putSceneToStage(this._currentSceneIndex);
			this.addEnterFrame();
			this.dispatchEvent(new PlayerEvent(PlayerEvent.BUFFER_READY));
		}
		
		private function onEnterFrame(... rest) : void
		{
			var _loc5_:Array = null;
			var _loc6_:int = 0;
			var _loc8_:AnimeSound = null;
			var _loc9_:Number = NaN;
			var _loc10_:Boolean = false;
			var _loc11_:Number = NaN;
			var _loc12_:AnimeSound = null;
			var _loc13_:Number = NaN;
			var _loc14_:Number = NaN;
			var _loc15_:AnimeScene = null;
			var _loc16_:BitmapData = null;
			var _loc17_:ByteArray = null;
			var _loc18_:String = null;
			var _loc19_:Number = NaN;
			if(!this._allSceneBufferReady)
			{
				this.removeEnterFrame();
				return;
			}
			this._currentFrame++;
			var _loc2_:AnimeScene = this._animeScenes[this._currentSceneIndex];
			if(this._currentFrame > this._duration)
			{
				this._currentFrame--;
				this.pause();
				if(this._assetSound.hasEventListener("AssetSoundRdy"))
				{
					this._assetSound.removeEventListener("AssetSoundRdy",this.AssetSoundRdyHandeler);
				}
				this._assetSound.getSceneToStop(_loc2_,this._currentFrame);
				this.dispatchEvent(new PlayerEvent(PlayerEvent.PLAYHEAD_MOVIE_END));
				return;
			}
			var _loc3_:Boolean = false;
			if(this._currentFrame >= _loc2_.endFrame && this._currentSceneIndex < this._animeScenes.length - 1)
			{
				CCLipSyncController.getInstance().speakingCharacter = null;
				_loc3_ = true;
				this.setCurrentScene(this._currentSceneIndex + 1);
				_loc2_ = this._animeScenes[this._currentSceneIndex];
			}
			var _loc4_:Boolean = true;
			if(!_loc2_.readyToPlay)
			{
				_loc4_ = false;
			}
			if(SceneBufferManager.instance.isBufferReady == false)
			{
				_loc4_ = false;
			}
			var _loc7_:Boolean = true;
			_loc5_ = this.getSoundsByStartFrame(this._currentFrame);
			if(_loc5_ != null)
			{
				_loc6_ = 0;
				while(_loc6_ < _loc5_.length)
				{
					_loc8_ = _loc5_[_loc6_] as AnimeSound;
					if(_loc8_.getBufferProgress() < 100)
					{
						_loc7_ = false;
						break;
					}
					_loc6_++;
				}
			}
			if(!_loc7_)
			{
				_loc4_ = false;
				this.removeEnterFrame();
			}
			if(_loc4_ == false)
			{
				this._currentFrame--;
				SceneBufferManager.highSpeedMode = true;
				this.removeEnterFrame();
				this.dispatchEvent(new PlayerEvent(PlayerEvent.BUFFER_EXHAUST));
				if(!_loc2_.readyToPlay)
				{
					SceneBufferManager.highSpeedMode = true;
					SceneBufferManager.instance.addEventListener(SceneBufferEvent.BUFFER_READY,this.onSceneBufferReady);
					SceneBufferManager.instance.startBuffering(this._currentSceneIndex,this);
				}
			}
			else
			{
				SceneBufferManager.highSpeedMode = false;
				if(this.firstLoad)
				{
					this.firstLoad = false;
					_loc15_ = this._animeScenes[this._currentSceneIndex];
					if(GoExtInterface.available)
					{
						GoExtInterface.addCallback("getPhotoArray",this.sendPhotoArray);
					}
					this._assetSound.getSceneToPlay(this.currentFrame,_loc15_);
				}
				if(this.is_golite_preview == "1")
				{
					if(!this.photoTaken && this._currentSceneIndex > Math.floor(this.getNumScene() / 2) - 2 && this._animeScenes[this._currentSceneIndex].endFrame - 1 == this._currentFrame && this.photoExistArray.indexOf(this._currentFrame) == -1)
					{
						_loc16_ = Util.capturePicture(this.getMovieContainer(),new Rectangle(AnimeConstants.SCREEN_X,AnimeConstants.SCREEN_Y,AnimeConstants.SCREEN_WIDTH,AnimeConstants.SCREEN_HEIGHT),AnimeConstants.SCREEN_WIDTH + AnimeConstants.SCREEN_X,AnimeConstants.SCREEN_HEIGHT + AnimeConstants.SCREEN_Y);
						if(this.photoExistArray.length == 4)
						{
							this.photoTaken = true;
						}
						_loc17_ = this.en.encode(_loc16_);
						this.encoder.encodeBytes(_loc17_,0,_loc17_.length);
						_loc18_ = this.encoder.flush();
						this.photoArray.push(_loc18_);
						this.photoExistArray.push(this.currentFrame);
					}
				}
				_loc9_ = new Date().time;
				_loc10_ = true;
				_loc11_ = 1;
				if(this._prevSystemTime < 0 || this._prevFrame < 0)
				{
					_loc10_ = false;
				}
				else if(_loc3_)
				{
					_loc10_ = false;
				}
				else
				{
					_loc11_ = (_loc9_ - this._prevSystemTime) / 1000 / (this._currentFrame - this._prevFrame) * AnimeConstants.FRAME_PER_SEC;
					if(_loc11_ < 2)
					{
						_loc10_ = false;
					}
					else if(this._currentFrame % 2 == 0)
					{
						_loc10_ = false;
					}
				}
				if(!_loc10_)
				{
					_loc2_.play(this._currentFrame);
				}
				_loc5_ = this.getSoundsByFrame(this._currentFrame);
				if(_loc5_ != null)
				{
					_loc19_ = UtilUnitConvert.frameToSec(this._currentFrame) * 1000;
					_loc6_ = 0;
					while(_loc6_ < _loc5_.length)
					{
						_loc12_ = _loc5_[_loc6_] as AnimeSound;
						_loc12_.play(_loc19_);
						_loc6_++;
					}
				}
				_loc5_ = this.getSoundsByEndFrame(this._currentFrame);
				_loc13_ = UtilUnitConvert.frameToSec(this.currentFrame,true) * 1000;
				if(_loc5_ != null)
				{
					_loc6_ = 0;
					while(_loc6_ < _loc5_.length)
					{
						_loc12_ = _loc5_[_loc6_] as AnimeSound;
						_loc12_.pause(_loc13_);
						_loc6_++;
					}
				}
				if(this.pauseAtFirstFrame)
				{
					this.pauseAtFirstFrame = false;
					this.execute(Anime.COMMAND_PAUSE);
				}
				if(this._state == Anime.STATE_PAUSING)
				{
					this.pauseAtFirstFrame = false;
					this.execute(Anime.COMMAND_PAUSE);
					this.pause();
				}
				if(this.setVolumeAtFirstLoad)
				{
					this.setVolumeAtFirstLoad = false;
					this.setVolume(this.volume);
				}
				this._prevFrame = this._currentFrame;
				this._prevSystemTime = _loc9_;
				this.dispatchEvent(new PlayerEvent(PlayerEvent.PLAYHEAD_TIME_CHANGE));
				_loc14_ = _loc2_.getLastActionFrame();
				if(_loc14_ - this._currentFrame <= 1 && _loc14_ > this._currentFrame)
				{
					this.dispatchEvent(new PlayerEvent(PlayerEvent.PLAYHEAD_SCENE_LAST_ACTION_FRAME_REACHED));
				}
			}
			this.dispatchEvent(new PlayerEvent(Event.ENTER_FRAME,_loc11_));
		}
		
		private function sendPhotoArray() : Array
		{
			return this.photoArray;
		}
		
		private function pause(param1:Boolean = true) : void
		{
			var i:int = 0;
			var currentTimeInMilliSecond:Number = NaN;
			var curSound:AnimeSound = null;
			var needPauseMC:Boolean = param1;
			try
			{
				this.setState(Anime.STATE_PAUSING);
				if(this._assetSound.hasEventListener("AssetSoundRdy"))
				{
					this._assetSound.removeEventListener("AssetSoundRdy",this.AssetSoundRdyHandeler);
				}
				this.removeEnterFrame();
				if(needPauseMC)
				{
					this._animeScenes[this._currentSceneIndex].pause();
					this._assetSound.getSceneToStop(this._animeScenes[this.searchSceneIndexByFrame(this._currentFrame)],this._currentFrame);
				}
				currentTimeInMilliSecond = UtilUnitConvert.frameToSec(this.currentFrame,true) * 1000;
				i = 0;
				while(i < this.getSoundsByFrame(this._currentFrame).length)
				{
					curSound = this.getSoundsByFrame(this._currentFrame)[i] as AnimeSound;
					curSound.pause(currentTimeInMilliSecond);
					i++;
				}
				this.dispatchEvent(new PlayerEvent(PlayerEvent.PAUSE));
				return;
			}
			catch(e:Error)
			{
				UtilErrorLogger.getInstance().appendCustomError("Anime:pause",e);
				return;
			}
		}
		
		private function resume() : void
		{
			var _loc1_:int = 0;
			this.setState(Anime.STATE_PLAYING);
			this._assetSound.addEventListener("AssetSoundRdy",this.AssetSoundRdyHandeler,false,0,true);
			this._assetSound.getSceneToPlay(this.currentFrame,this._animeScenes[this.searchSceneIndexByFrame(this.currentFrame)]);
			this.dispatchEvent(new PlayerEvent(PlayerEvent.RESUME));
		}
		
		private function AssetSoundRdyHandeler(param1:Event) : void
		{
			var _loc3_:AnimeSound = null;
			if(this._assetSound.hasEventListener("AssetSoundRdy"))
			{
				this._assetSound.removeEventListener("AssetSoundRdy",this.AssetSoundRdyHandeler);
			}
			this.addEnterFrame();
			this._animeScenes[this._currentSceneIndex].resume();
			var _loc2_:int = 0;
			while(_loc2_ < this.getSoundsByFrame(this._currentFrame).length)
			{
				_loc3_ = this.getSoundsByFrame(this._currentFrame)[_loc2_] as AnimeSound;
				_loc3_.resume();
				_loc2_++;
			}
		}
		
		private function goToAndPause(param1:int, param2:Boolean = false) : void
		{
			var _loc3_:int = 0;
			var _loc5_:int = 0;
			var _loc6_:AnimeScene = null;
			var _loc7_:AnimeScene = null;
			var _loc8_:AnimeSound = null;
			this.setState(Anime.STATE_PAUSING);
			this._currentFrame = param1;
			if(this.getNumScene() > 0)
			{
				_loc5_ = this.searchSceneIndexByFrame(param1);
				_loc6_ = this.getSceneByIndex(_loc5_);
				if(_loc6_.hasTransition() && !_loc6_.doTransitionSupportSeeking)
				{
					if(_loc6_.getTransitionFrameNum() > _loc6_.movieToSceneFrame(param1))
					{
						_loc5_--;
						if(_loc5_ >= 0)
						{
							param1 = this.getSceneByIndex(_loc5_).endFrame;
						}
						else
						{
							_loc5_ = 0;
							param1 = this.getSceneByIndex(0).startFrame;
						}
						this._currentFrame = param1;
					}
				}
				if(_loc5_ != this._currentSceneIndex)
				{
					this.setCurrentScene(_loc5_,true,param2);
				}
				_loc7_ = this._animeScenes[this._currentSceneIndex];
				_loc7_.goToAndPause(param1);
			}
			var _loc4_:Number = UtilUnitConvert.frameToSec(param1) * 1000;
			_loc3_ = 0;
			while(_loc3_ < this.getSoundsByFrame(this._currentFrame).length)
			{
				_loc8_ = this.getSoundsByFrame(this._currentFrame)[_loc3_] as AnimeSound;
				_loc8_.goToAndPause(_loc4_);
				_loc3_++;
			}
			this._downloadManager.reorganizeCustomerQueue(UtilUnitConvert.frameToSec(param1) * 1000);
			this.fadeVolume(1);
		}
		
		private function goToAndPauseReset() : void
		{
			var _loc1_:AnimeScene = null;
			var _loc2_:int = 0;
			while(_loc2_ < this.getNumScene())
			{
				this.getSceneByIndex(_loc2_).goToAndPauseReset();
				_loc2_++;
			}
		}
		
		public function get volume() : Number
		{
			return this._volume;
		}
		
		private function setVolume(param1:Number) : void
		{
			var _loc2_:int = 0;
			this._volume = param1;
			if(this.firstLoad)
			{
				this.setVolumeAtFirstLoad = true;
				return;
			}
			_loc2_ = 0;
			while(_loc2_ < this.getNumSounds())
			{
				this.getSoundByIndex(_loc2_).setVolume(param1);
				_loc2_++;
			}
			_loc2_ = 0;
			while(_loc2_ < this.getNumScene())
			{
				this.getSceneByIndex(_loc2_).setVolume(param1);
				_loc2_++;
			}
			if(this._assetSound != null)
			{
				this._assetSound.setSceneVolume(this._currentFrame,this._animeScenes[this.searchSceneIndexByFrame(this.currentFrame)],param1);
			}
		}
		
		private function fadeVolume(param1:Number) : void
		{
			var _loc2_:int = 0;
			while(_loc2_ < this.getNumSounds())
			{
				this.getSoundByIndex(_loc2_).fadeVolume(param1);
				_loc2_++;
			}
		}
		
		private function isBufferReadyAtFrame(param1:Number) : Boolean
		{
			var _loc2_:int = this.searchSceneIndexByFrame(param1);
			if(this.getSceneByIndex(_loc2_).getBufferProgress() >= 100)
			{
				return true;
			}
			return false;
		}
		
		public function get previewStartFrame() : int
		{
			return this._previewStartFrame;
		}
		
		public function set previewStartFrame(param1:int) : void
		{
			if(param1 > 0)
			{
				this._previewStartFrame = param1;
			}
		}
		
		protected function execute(param1:int, ... rest) : void
		{
			var _loc3_:Number = NaN;
			var _loc4_:Boolean = false;
			var _loc5_:Boolean = false;
			var _loc6_:Array = null;
			switch(param1)
			{
				case Anime.COMMAND_PLAY:
					if(!(this.firstLoad && this._state == Anime.STATE_NULL))
					{
						if(this._currentFrame < this._duration)
						{
							this.resume();
						}
						else
						{
							this.dispatchEvent(new PlayerEvent(PlayerEvent.PLAYHEAD_MOVIE_END));
						}
					}
					this.pauseAtFirstFrame = false;
					break;
				case Anime.COMMAND_PAUSE:
					if(this.firstLoad && (this._state == Anime.STATE_NULL || this._state == Anime.STATE_PAUSING))
					{
						this.pauseAtFirstFrame = true;
					}
					else if(this._state == Anime.STATE_PLAYING)
					{
						_loc5_ = true;
						if(rest.length > 0)
						{
							_loc5_ = rest[0];
						}
						this.pause(_loc5_);
					}
					else if(this._assetSound != null)
					{
						if(this._assetSound.hasEventListener("AssetSoundRdy"))
						{
							this._assetSound.removeEventListener("AssetSoundRdy",this.AssetSoundRdyHandeler);
						}
						this._assetSound.getSceneToStop(this.getSceneByIndex(this.searchSceneIndexByFrame(this.currentFrame)),this.currentFrame);
					}
					break;
				case Anime.COMMAND_GOTO_AND_PAUSE:
					_loc3_ = Number(rest[0]);
					_loc4_ = Boolean(rest[1]);
					if(this.isBufferReadyAtFrame(_loc3_))
					{
						this.goToAndPause(_loc3_,_loc4_);
					}
					else
					{
						_loc6_ = new Array();
						_loc6_.push(_loc3_,_loc4_);
						this.setCurCommand(param1,_loc6_);
						this.addEventListener(PlayerEvent.INIT_REMOTE_DATA_COMPLETE,this.re_Execute,false,0,true);
						this._currentFrame = _loc3_;
						this.initRemoteData(_loc3_);
					}
					break;
				case Anime.COMMAND_SET_VOLUME:
					this.setVolume(rest[0] as Number);
					break;
				case Anime.COMMAND_REMOVE_ENTER_FRAME:
					this.removeEnterFrame();
					break;
				case Anime.COMMAND_ADD_ENTER_FRAME:
					this.addEnterFrame();
					break;
				case Anime.COMMAND_END:
					this.dispatchEvent(new PlayerEvent(PlayerEvent.PLAYHEAD_MOVIE_END));
					break;
				case COMMAND_GOTO_AND_PAUSE_RESET:
					this.goToAndPauseReset();
			}
		}
		
		private function re_Execute(... rest) : void
		{
			this.removeAllListener(PlayerEvent.INIT_REMOTE_DATA_COMPLETE);
			var _loc2_:int = this.getCurCommand();
			var _loc3_:Array = this.getCurCommandArg();
			this.removeCurCommand();
			this.execute(_loc2_,_loc3_[0],_loc3_[1]);
		}
		
		private function getState() : int
		{
			return this._state;
		}
		
		private function setState(param1:int) : void
		{
			switch(param1)
			{
				case Anime.STATE_NULL:
				case Anime.STATE_PAUSING:
				case Anime.STATE_PAUSING:
				case Anime.STATE_PLAYING:
					this._state = param1;
			}
		}
		
		public function destroy() : void
		{
			this._downloadManager.destroy();
			this._dataStock.destroy();
			if(this._isInitialized)
			{
				this.pause();
			}
		}
		
		public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
		{
			this._eventDispatcher.addEventListener(param1,param2,param3,param4,param5);
		}
		
		protected function dispatchEvent(param1:PlayerEvent) : Boolean
		{
			return this._eventDispatcher.dispatchEvent(param1);
		}
		
		public function hasEventListener(param1:String) : Boolean
		{
			return this._eventDispatcher.hasEventListener(param1);
		}
		
		public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
		{
			return this._eventDispatcher.removeEventListener(param1,param2,param3);
		}
		
		protected function willTrigger(param1:String) : Boolean
		{
			return this._eventDispatcher.willTrigger(param1);
		}
		
		protected function removeAllListener(param1:String, param2:Boolean = false) : void
		{
			return this._eventDispatcher.removeAllListener(param1,param2);
		}
		
		public function getSoundIterator() : IIterator
		{
			return new ArrayIterator(this._sounds);
		}
		
		public function initHandDrawnEffect() : void
		{
			if(!this._handDrawnEffect)
			{
				this._handDrawnEffect = new WhiteboardHand();
				this._handDrawnEffect.visible = false;
			}
		}
		
		public function get handDrawnEffect() : WhiteboardHand
		{
			return this._handDrawnEffect;
		}
	}
}
