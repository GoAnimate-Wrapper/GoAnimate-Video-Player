package anifire.player.components
{
	import anifire.component.ProgressMonitor;
	import anifire.component.timeFrameSynchronizer;
	import anifire.constant.AnimeConstants;
	import anifire.constant.ServerConstants;
	import anifire.event.LoadMgrEvent;
	import anifire.managers.AmplitudeAnalyticsManager;
	import anifire.managers.AppConfigManager;
	import anifire.player.events.PlayerEndScreenEvent;
	import anifire.player.events.PlayerEvent;
	import anifire.player.managers.PlayerApiManager;
	import anifire.player.managers.SceneBufferManager;
	import anifire.player.playback.AnimeScene;
	import anifire.player.playback.PlainPlayer;
	import anifire.util.GoExtInterface;
	import anifire.util.Util;
	import anifire.util.UtilDict;
	import anifire.util.UtilErrorLogger;
	import anifire.util.UtilHashArray;
	import anifire.util.UtilLoadMgr;
	import anifire.util.UtilMath;
	import anifire.util.UtilMovieInfoXMLLoader;
	import anifire.util.UtilUnitConvert;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	import mx.binding.Binding;
	import mx.binding.BindingManager;
	import mx.binding.IBindingClient;
	import mx.binding.IWatcherSetupUtil2;
	import mx.core.FlexGlobals;
	import mx.core.IFlexModuleFactory;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.events.ResizeEvent;
	import mx.graphics.SolidColor;
	import spark.components.Group;
	import spark.components.Label;
	import spark.effects.Fade;
	import spark.primitives.Rect;
	
	use namespace mx_internal;
	
	public class PreviewPlayer extends Group implements IBindingClient
	{
		
		private static const LOADING_ICON_NAME:String = "loading_icon";
		
		private static var PLAYHEAD_STATE_PLAY:int = 1;
		
		private static var PLAYHEAD_STATE_PAUSE:int = 2;
		
		private static var PLAYHEAD_STATE_NULL:int = 0;
		
		private static var PLAYHEAD_STATE_MOVIE_END:int = 3;
		
		public static const NORMAL_SCREEN_MODE:uint = 0;
		
		public static const FULL_SCREEN_MODE:uint = 1;
		
		public static const RECORDING_SCREEN_MODE:uint = 2;
		
		private static var _watcherSetupUtil:IWatcherSetupUtil2;
		 
		
		private var _460696194_stageAd:PlayerStageAd;
		
		private var _1462422359alertText:Label;
		
		private var _61512610buffering:BufferingScreen;
		
		private var _1707945992contentContainer:Group;
		
		private var _1593500967endScreen:PlayerEndScreen;
		
		private var _1282133823fadeIn:Fade;
		
		private var _1091436750fadeOut:Fade;
		
		private var _459583688loadingScreen:LoadingScreen;
		
		private var _1840541266movieStage:Group;
		
		private var _690449604playerControl:PlayerControl;
		
		private var _772093527scaleContainer:Group;
		
		private var _176252277screenContainer:Group;
		
		private var _1523976162timeFrameSynchronizer:timeFrameSynchronizer;
		
		private var _213424028watermark:PlayerWatermark;
		
		private var __moduleFactoryInitialized:Boolean = false;
		
		private var _apiManager:PlayerApiManager;
		
		private var _filmXML:XML;
		
		private var _themeXMLs:UtilHashArray;
		
		private var _imageData:UtilHashArray;
		
		private var _urlRequest:URLRequest;
		
		private var _urlRequestArray:Array;
		
		private var previewMode:Boolean = false;
		
		private var firstStart:Boolean = true;
		
		protected var plainPlayer:PlainPlayer;
		
		private var _expectedPlayHeadState:int;
		
		private var _subComponents:Array;
		
		private var _isInited:Boolean = false;
		
		private var movieInfoLoader:UtilMovieInfoXMLLoader;
		
		private var _shouldPauseWhenLoadingMovie:Boolean = false;
		
		private var showingAdsVideo:Boolean = false;
		
		private var params:Object;
		
		private var _1155998129createYourOwnWidth:Number;
		
		private var _1909198402createYourOwnHeight:Number;
		
		private var _420974171_screen_height:Number = 354;
		
		private var _screenMode:int = -1;
		
		protected var _isPlaying:Boolean;
		
		private var _hideControlBarTimeoutId:uint = 0;
		
		mx_internal var _bindings:Array;
		
		mx_internal var _watchers:Array;
		
		mx_internal var _bindingsByDestination:Object;
		
		mx_internal var _bindingsBeginWithWord:Object;
		
		public function PreviewPlayer()
		{
			var target:Object = null;
			var watcherSetupUtilClass:Object = null;
			this._apiManager = PlayerApiManager.instance;
			this._expectedPlayHeadState = PreviewPlayer.PLAYHEAD_STATE_NULL;
			this._subComponents = new Array();
			this._1155998129createYourOwnWidth = FlexGlobals.topLevelApplication.width;
			this._1909198402createYourOwnHeight = FlexGlobals.topLevelApplication.height;
			this._bindings = [];
			this._watchers = [];
			this._bindingsByDestination = {};
			this._bindingsBeginWithWord = {};
			super();
			mx_internal::_document = this;
			var bindings:Array = this._PreviewPlayer_bindingsSetup();
			var watchers:Array = [];
			target = this;
			if(_watcherSetupUtil == null)
			{
				watcherSetupUtilClass = getDefinitionByName("_anifire_player_components_PreviewPlayerWatcherSetupUtil");
				watcherSetupUtilClass["init"](null);
			}
			_watcherSetupUtil.setup(this,function(param1:String):*
			{
				return target[param1];
			},function(param1:String):*
			{
				return PreviewPlayer[param1];
			},bindings,watchers);
			mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
			mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
			this.percentWidth = 100;
			this.percentHeight = 100;
			this.mxmlContent = [this._PreviewPlayer_Rect1_c(),this._PreviewPlayer_Group2_i(),this._PreviewPlayer_LoadingScreen1_i(),this._PreviewPlayer_PlayerControl1_i()];
			this._PreviewPlayer_Fade1_i();
			this._PreviewPlayer_Fade2_i();
			this.addEventListener("creationComplete",this.___PreviewPlayer_Group1_creationComplete);
			this.addEventListener("mouseMove",this.___PreviewPlayer_Group1_mouseMove);
			this.addEventListener("rollOver",this.___PreviewPlayer_Group1_rollOver);
			this.addEventListener("rollOut",this.___PreviewPlayer_Group1_rollOut);
			this.addEventListener("resize",this.___PreviewPlayer_Group1_resize);
			var i:uint = 0;
			while(i < bindings.length)
			{
				Binding(bindings[i]).execute();
				i++;
			}
		}
		
		public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
		{
			PreviewPlayer._watcherSetupUtil = param1;
		}
		
		override public function set moduleFactory(param1:IFlexModuleFactory) : void
		{
			super.moduleFactory = param1;
			if(this.__moduleFactoryInitialized)
			{
				return;
			}
			this.__moduleFactoryInitialized = true;
		}
		
		override public function initialize() : void
		{
			super.initialize();
		}
		
		public function get screen_height() : Number
		{
			return this._screen_height;
		}
		
		public function getParams() : Object
		{
			var _loc1_:String = null;
			var _loc2_:Array = null;
			var _loc3_:uint = 0;
			var _loc4_:int = 0;
			var _loc5_:String = null;
			var _loc6_:String = null;
			this.params = {};
			if(GoExtInterface.available)
			{
				_loc1_ = GoExtInterface.call("window.location.search.substring",1);
			}
			if(_loc1_)
			{
				_loc2_ = _loc1_.split("&");
				_loc3_ = 0;
				while(_loc3_ < _loc2_.length)
				{
					_loc4_ = _loc2_[_loc3_].indexOf("=");
					if(_loc4_ != -1)
					{
						_loc5_ = _loc2_[_loc3_].substring(0,_loc4_);
						_loc6_ = _loc2_[_loc3_].substring(_loc4_ + 1);
						this.params[_loc5_] = _loc6_;
					}
					_loc3_++;
				}
			}
			return this.params;
		}
		
		public function getMovieDuration() : Number
		{
			return this.plainPlayer.duration#1;
		}
		
		public function loadScenePreview(param1:int) : void
		{
			if(param1 > 1)
			{
				this.plainPlayer.previewStartFrame = param1;
				SceneBufferManager.instance.defaultMinBufferTime = SceneBufferManager.PREVIEW_MIN_BUFFER_TIME_IN_SEC;
			}
		}
		
		private function loadMovieInfoXML() : void
		{
			try
			{
				if(this.plainPlayer)
				{
					this.movieInfoLoader = new UtilMovieInfoXMLLoader();
					this.movieInfoLoader.addEventListener(UtilMovieInfoXMLLoader.LOAD_COMPLETE,this.movieInfoLoader_loadCompleteHandler);
					this.movieInfoLoader.loadMovieInfo(AppConfigManager.instance.getValue(ServerConstants.PARAM_MOVIE_ID));
				}
				return;
			}
			catch(ex:Error)
			{
				return;
			}
		}
		
		private function movieInfoLoader_loadCompleteHandler(param1:Event) : void
		{
			var _loc2_:XML = this.movieInfoLoader.xml;
			this.plainPlayer.movieInfo = _loc2_;
			if(_loc2_)
			{
				if(ServerConstants.IS_WIX)
				{
					if(!ServerConstants.IS_WIX_PAID)
					{
						this.watermark.showWatermark(PlayerWatermark.WATERMARK_ID_FULL_SCREEN);
					}
				}
				else if(_loc2_.hasOwnProperty("watermark"))
				{
					if(String(_loc2_.watermark) != "")
					{
						this.watermark.loadCustomWatermarkByUrl(_loc2_.watermark);
					}
					else if(_loc2_.watermark[0].hasOwnProperty("@style"))
					{
						switch(String(_loc2_.watermark[0].@style))
						{
							case "twoLines":
								this.watermark.showWatermark(PlayerWatermark.WATERMARK_ID_TWO_LINES);
								break;
							case "g4s":
								this.watermark.showWatermark(PlayerWatermark.WATERMARK_ID_G4S);
								break;
							case "freeTrial":
								this.watermark.showWatermark(PlayerWatermark.WATERMARK_ID_FREE_TRIAL);
						}
					}
				}
				else
				{
					this.watermark.showWatermark(PlayerWatermark.WATERMARK_ID_DEFAULT);
				}
				if(_loc2_.hasOwnProperty("access_privilege"))
				{
					if(_loc2_.access_privilege.hasOwnProperty("@require_biz") && _loc2_.access_privilege.@require_biz == "1")
					{
						this._stageAd.turnOn();
					}
				}
			}
		}
		
		private function onCreationCompleted(... rest) : void
		{
			var _loc5_:UtilLoadMgr = null;
			Util.initLog();
			this._expectedPlayHeadState = PreviewPlayer.PLAYHEAD_STATE_NULL;
			this.addComponents();
			this.plainPlayer = new PlainPlayer();
			this.playerControl.plainPlayer = this.plainPlayer;
			this.plainPlayer.addEventListener(PlayerEvent.PLAYHEAD_TIME_CHANGE,this.doRemoveLoadingScreen);
			this.plainPlayer.addEventListener(PlayerEvent.MOVIE_STRUCTURE_READY,this.onMovieStructureReady,false,0,true);
			this.plainPlayer.addEventListener(PlayerEvent.BUFFER_EXHAUST,this.onBufferExhaust,false,0,true);
			this.plainPlayer.addEventListener(PlayerEvent.BUFFER_READY,this.onBufferReady,false,0,true);
			this.plainPlayer.addEventListener(PlayerEvent.PLAYHEAD_TIME_CHANGE,this.onMovieTimeChange,false,0,true);
			this.plainPlayer.addEventListener(PlayerEvent.PLAYHEAD_MOVIE_END,this.onMovieEnd,false,0,true);
			if(Util.isVideoRecording())
			{
				_loc5_ = new UtilLoadMgr();
				_loc5_.addEventListener(LoadMgrEvent.ALL_COMPLETE,this.doTellVideoRecordingSoftwareMovieStart);
				_loc5_.addEventDispatcher(this.plainPlayer.eventDispatcher,PlayerEvent.BUFFER_READY_WHEN_MOVIE_START);
				_loc5_.addEventDispatcher(this.plainPlayer.eventDispatcher,PlayerEvent.PLAYHEAD_TIME_CHANGE);
				_loc5_.commit();
			}
			this.loadMovieInfoXML();
			var _loc2_:DisplayObjectContainer = this.plainPlayer.getMovieContainer();
			var _loc3_:UIComponent = new UIComponent();
			_loc3_.addChild(_loc2_);
			this.movieStage.addElement(_loc3_);
			var _loc4_:URLVariables = AppConfigManager.instance.createURLVariables();
			if(_loc4_["movieOwner"] != "")
			{
				this.loadingScreen.init(_loc4_["movieOwner"]);
			}
			if(this.previewMode)
			{
				this.startPreview();
			}
			this.endScreen.addEventListener("btn_nextmovie_click",this.onNextMovieClick);
			this._isInited = true;
			FlexGlobals.topLevelApplication.addEventListener(FullScreenEvent.FULL_SCREEN,this.fullScreenHandler);
			this.screenMode = NORMAL_SCREEN_MODE;
			ProgressMonitor.getInstance().addEventListener(ProgressEvent.PROGRESS,this.onProgress);
			this.initAPI();
		}
		
		private function initAPI() : void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.addCallback("getSceneGuid",this.getCurrentSceneGuid);
				ExternalInterface.addCallback("isPlaying",this.isPlaying);
				ExternalInterface.addCallback("getSceneInfoArray",this.getSceneInfoArray);
				ExternalInterface.addCallback("seekScene",this.seekScene);
				ExternalInterface.addCallback("seek",this.seek);
			}
		}
		
		public function getCurrentScene() : AnimeScene
		{
			return this.plainPlayer.getCurrentScene();
		}
		
		public function getCurrentSceneGuid() : String
		{
			var _loc1_:AnimeScene = this.getCurrentScene();
			return !!_loc1_?_loc1_.guid:null;
		}
		
		public function getSceneInfoArray() : Array
		{
			return this.plainPlayer.getSceneInfoArray();
		}
		
		public function seek(param1:Number) : void
		{
			var _loc2_:int = UtilUnitConvert.secToFrame(param1,true,true);
			this.seekFrame(_loc2_);
		}
		
		public function seekScene(param1:String) : void
		{
			var _loc2_:int = this.plainPlayer.getFrameByGuid(param1);
			if(_loc2_ != -1)
			{
				this.seekFrame(_loc2_);
			}
		}
		
		public function seekFrame(param1:int) : void
		{
			this.timeFrameSynchronizer.stopSyn();
			this.pausePlainPlayer(false,true,true);
			this.goToAndPausePlainPlayer(false,true,true,param1,true);
			this.playerControl.curFrame = param1;
			this.timeFrameSynchronizer.startSyn();
			if(this._expectedPlayHeadState == PreviewPlayer.PLAYHEAD_STATE_PLAY)
			{
				this.resumePlainPlayer(false,true,true);
			}
			else if(this._expectedPlayHeadState == PLAYHEAD_STATE_MOVIE_END)
			{
				this._expectedPlayHeadState = PLAYHEAD_STATE_PAUSE;
			}
			this.playerControl.timeChangeListener(param1);
		}
		
		public function isPlaying() : Boolean
		{
			return this._isPlaying;
		}
		
		private function initWatermarkByImageData() : void
		{
			var _loc1_:Object = null;
			if(this._imageData)
			{
				_loc1_ = this._imageData.getValueByKey("watermarkUrl");
				if(_loc1_ is String)
				{
					switch(_loc1_)
					{
						case "default":
							this.watermark.showWatermark(PlayerWatermark.WATERMARK_ID_DEFAULT);
							break;
						case "twoLines":
							this.watermark.showWatermark(PlayerWatermark.WATERMARK_ID_TWO_LINES);
							break;
						case "g4s":
							this.watermark.showWatermark(PlayerWatermark.WATERMARK_ID_G4S);
							break;
						case "fullScreen":
							this.watermark.showWatermark(PlayerWatermark.WATERMARK_ID_FULL_SCREEN);
							break;
						case "freeTrial":
							this.watermark.showWatermark(PlayerWatermark.WATERMARK_ID_FREE_TRIAL);
							break;
						default:
							this.watermark.loadCustomWatermarkByUrl(_loc1_ as String);
					}
				}
			}
		}
		
		private function onSceneBuffering(param1:ProgressEvent) : void
		{
			if(param1.bytesTotal && param1.bytesTotal != 0)
			{
				this.playerControl.timerDisplay.text = UtilDict.toDisplay("player","buffering") + " " + String(Math.floor(100 * param1.bytesLoaded / param1.bytesTotal)) + "%";
			}
		}
		
		private function fullScreenHandler(param1:FullScreenEvent) : void
		{
			var isEmbed:Boolean = false;
			var e:FullScreenEvent = param1;
			try
			{
				if(e.fullScreen)
				{
					this.screenMode = FULL_SCREEN_MODE;
				}
				else
				{
					isEmbed = AppConfigManager.instance.getValue(ServerConstants.PARAM_ISEMBED_ID) == "1";
					this.screenMode = !!isEmbed?int(FULL_SCREEN_MODE):int(NORMAL_SCREEN_MODE);
				}
				return;
			}
			catch(e:Error)
			{
				UtilErrorLogger.getInstance().appendCustomError("PreviewPlayer:fullScreenHandler",e);
				return;
			}
		}
		
		private function onMovieStructureReady(param1:PlayerEvent) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onMovieStructureReady);
			this.playerControl.init(this.plainPlayer.duration#1);
			this.playerControl.timerDisplay.text = UtilDict.toDisplay("player","player_initializing");
			this.addEventListener(PlayerEvent.PLAYHEAD_USER_RESUME,this.doEnableTimelineRelatedStuff);
			if(this._shouldPauseWhenLoadingMovie)
			{
				this.doRemoveLoadingScreen();
			}
			this.initUI();
		}
		
		private function initUI() : void
		{
		}
		
		private function doEnableTimelineRelatedStuff(param1:Event) : void
		{
			this.plainPlayer.removeEventListener(PlayerEvent.REAL_START_PLAY,this.doEnableTimelineRelatedStuff);
			this.removeEventListener(PlayerEvent.PLAYHEAD_USER_RESUME,this.doEnableTimelineRelatedStuff);
			this.playerControl.enableTimeLine();
			var _loc2_:URLVariables = AppConfigManager.instance.createURLVariables();
			if(_loc2_[ServerConstants.PARAM_ISSLIDE] == "1")
			{
				this.playerControl.enableTimeLine(false);
			}
			this.dispatchEvent(new PlayerEvent(PlayerEvent.BUFFER_READY_WHEN_MOVIE_START));
		}
		
		private function doRemoveLoadingScreen(param1:Event = null) : void
		{
			if(param1)
			{
				IEventDispatcher(param1.target).removeEventListener(param1.type,this.doRemoveLoadingScreen);
			}
			this.plainPlayer.removeEventListener(PlayerEvent.PLAYHEAD_TIME_CHANGE,this.doRemoveLoadingScreen);
			this.removeEventListener(PlayerEvent.PLAYHEAD_USER_RESUME,this.doRemoveLoadingScreen);
			this.removeEventListener(PlayerEvent.PLAYHEAD_USER_PAUSE,this.doTriggerPauseWhenMovieLoad);
			this.removeEventListener(PlayerEvent.PLAYHEAD_USER_RESUME,this.doNotTriggerPauseWhenMovieLoad);
			this.loadingScreen.visible = false;
			if(this.contentContainer.contains(this.loadingScreen))
			{
				this.contentContainer.removeElement(this.loadingScreen);
			}
			this.playerControl.timerDisplay.text = "";
			this.dispatchEvent(new Event("info_load_complete"));
		}
		
		private function onMovieTimeChange(param1:PlayerEvent) : void
		{
			this.playerControl.timeChangeListener(this.plainPlayer.currentFrame);
			this.dispatchEvent(new PlayerEvent(PlayerEvent.PLAYHEAD_TIME_CHANGE));
		}
		
		private function doTriggerPauseWhenMovieLoad(param1:Event) : void
		{
			if(this.plainPlayer.loadingState == PlainPlayer.MOVIE_ZIP_LOADED)
			{
				this.doRemoveLoadingScreen();
			}
			this._shouldPauseWhenLoadingMovie = true;
		}
		
		private function doNotTriggerPauseWhenMovieLoad(param1:Event) : void
		{
			this._shouldPauseWhenLoadingMovie = false;
		}
		
		public function initAndPreview(param1:XML, param2:UtilHashArray, param3:UtilHashArray) : void
		{
			this._filmXML = param1;
			this._imageData = param2;
			this._themeXMLs = param3;
			this.previewMode = true;
			if(this._filmXML.@isWide.length() > 0 && this._filmXML.@isWide == "1")
			{
				this.switchToWideScreen();
			}
			else
			{
				this.switchToNormalScreen();
			}
			this.initWatermarkByImageData();
		}
		
		public function init(param1:URLRequest, param2:Array) : void
		{
			this._urlRequest = param1;
			this._urlRequestArray = param2;
			this.loadMovieInfoXML();
		}
		
		private function onTimeLineDrag(... rest) : void
		{
			UtilErrorLogger.getInstance().info("PreviewPlayer::onTimeLineDrag");
			this.pausePlainPlayer(false,true,true);
			this.timeFrameSynchronizer.stopSyn();
			this.goToAndPausePlainPlayer(false,true,true,this.playerControl.curFrame,true);
		}
		
		private function onTimeLinePress(... rest) : void
		{
			UtilErrorLogger.getInstance().info("PreviewPlayer::onTimeLinePress");
			this.timeFrameSynchronizer.stopSyn();
			this.pausePlainPlayer(false,true,true);
		}
		
		private function onTimeLineRelease(... rest) : void
		{
			UtilErrorLogger.getInstance().info("PreviewPlayer::onTimeLineRelease");
			this.timeFrameSynchronizer.startSyn();
			if(this._expectedPlayHeadState == PreviewPlayer.PLAYHEAD_STATE_PLAY)
			{
				this.resumePlainPlayer(false,true,true);
			}
			else if(this._expectedPlayHeadState == PLAYHEAD_STATE_MOVIE_END)
			{
				this._expectedPlayHeadState = PLAYHEAD_STATE_PAUSE;
			}
		}
		
		private function onPauseButClick() : void
		{
			UtilErrorLogger.getInstance().info("PreviewPlayer::onPauseButClick");
			this.pausePlainPlayer(false,true,true);
			this._expectedPlayHeadState = PreviewPlayer.PLAYHEAD_STATE_PAUSE;
			this._apiManager.notifyEvent("pause");
		}
		
		private function startPreview() : void
		{
			this.plainPlayer.addEventListener(PlayerEvent.PLAYHEAD_TIME_CHANGE,this.doStartTimeFrameSynchronized);
			this.plainPlayer.initAndPreview(this._filmXML,this._themeXMLs,this._imageData);
			this.playerControl.playListener();
			this._expectedPlayHeadState = PreviewPlayer.PLAYHEAD_STATE_PLAY;
			this.firstStart = false;
		}
		
		private function doStartTimeFrameSynchronized(param1:Event) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.doStartTimeFrameSynchronized);
			this.timeFrameSynchronizer.startSyn();
		}
		
		private function doTellVideoRecordingSoftwareMovieStart(param1:Event) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.doTellVideoRecordingSoftwareMovieStart);
			navigateToURL(new URLRequest("FSCommand:start"));
		}
		
		public function destroy() : void
		{
			if(!this._isInited)
			{
				return;
			}
			try
			{
				if(this.plainPlayer != null)
				{
					this.plainPlayer.destroy();
				}
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		public function destroyMC() : void
		{
			if(!this._isInited)
			{
				return;
			}
			try
			{
				if(this.plainPlayer != null)
				{
					this.plainPlayer.destroyAllScene();
				}
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		private function startPlay() : void
		{
			var playFunc:Function = null;
			var showBranding:Boolean = true;
			if(AppConfigManager.instance.getValue("pwm") == "0")
			{
				showBranding = false;
			}
			if(showBranding)
			{
				this.loadingScreen.showBranding();
			}
			this.timeFrameSynchronizer.stopSyn();
			if(this.plainPlayer)
			{
				if(AppConfigManager.instance.getValue(ServerConstants.FLASHVAR_IS_GOLITE_PREVIEW) != "1")
				{
					this.plainPlayer.addEventListener(PlayerEvent.PLAYHEAD_TIME_CHANGE,this.doStartTimeFrameSynchronized);
				}
				this.plainPlayer.addEventListener(PlayerEvent.ERROR_LOADING_MOVIE,this.onErrorLoadingMovie,false,0,true);
				this.plainPlayer.addEventListener(PlayerEvent.LOAD_MOVIE_PROGRESS,this.onMovieProgress,false,0,true);
			}
			var initFunc:Function = function():void
			{
				if(plainPlayer)
				{
					plainPlayer.initMovie(_urlRequest,_urlRequestArray);
					playerControl.playListener();
				}
			};
			if(this.movieInfoLoader && this.movieInfoLoader.loading)
			{
				playFunc = function(param1:Event):void
				{
					movieInfoLoader.removeEventListener(UtilMovieInfoXMLLoader.LOAD_COMPLETE,playFunc);
					initFunc();
				};
				this.movieInfoLoader.addEventListener(UtilMovieInfoXMLLoader.LOAD_COMPLETE,playFunc);
			}
			else
			{
				initFunc();
			}
		}
		
		private function onErrorLoadingMovie(param1:PlayerEvent) : void
		{
			var _loc2_:String = param1.getData() as String;
			var _loc3_:String = UtilDict.toDisplay("player","We cannot play this video at the moment. This might be due to an unstable Internet connection, a Flash player issue or can also happen when accessing the Internet through a firewall. Sorry about the inconvenience.");
			switch(_loc2_)
			{
				case ServerConstants.ERROR_CODE_MOVIE_NOT_FOUND:
					_loc3_ = UtilDict.toDisplay("player","player_errnotfound");
					break;
				case ServerConstants.ERROR_CODE_MOVIE_DELETED:
					_loc3_ = UtilDict.toDisplay("player","player_errdeleted");
					break;
				case ServerConstants.ERROR_CODE_MOVIE_NOT_SHARE:
					_loc3_ = UtilDict.toDisplay("player","player_errprivated");
					break;
				case ServerConstants.ERROR_CODE_MOVIE_MODERATING:
					_loc3_ = UtilDict.toDisplay("player","player_errprocess");
					break;
				case ServerConstants.ERROR_CODE_NO_ACCESS:
					_loc3_ = UtilDict.toDisplay("player","player_err_noaccess");
			}
			this.alertText.text = _loc3_;
			this.alertText.visible = true;
			this.loadingScreen.visible = false;
			currentState = "";
		}
		
		private function onMovieProgress(param1:PlayerEvent) : void
		{
			var _loc2_:ProgressEvent = ProgressEvent(param1.getData());
			var _loc3_:Number = Math.round(_loc2_.bytesLoaded / _loc2_.bytesTotal * 100);
			var _loc4_:PlayerEvent = new PlayerEvent(PlayerEvent.LOAD_MOVIE_PROGRESS);
			this.dispatchEvent(_loc4_);
		}
		
		private function onProgress(param1:ProgressEvent) : void
		{
			this.loadingScreen.setProgress(UtilMath.boundaryCheck(param1.bytesLoaded / param1.bytesTotal,0,1));
		}
		
		private function onPlayButClick() : void
		{
			UtilErrorLogger.getInstance().info("PreviewPlayer::onPlayButClick");
			if(this._expectedPlayHeadState == PLAYHEAD_STATE_MOVIE_END)
			{
				this.replay();
			}
			else
			{
				this.play();
			}
			var _loc1_:Object = {};
			_loc1_[AmplitudeAnalyticsManager.EVENT_PROPERTIES_MOVIE_ID] = AppConfigManager.instance.getValue(ServerConstants.PARAM_MOVIE_ID);
			var _loc2_:String = !!this.previewMode?AmplitudeAnalyticsManager.EVENT_NAME_PREVIEW_VIDEO:AmplitudeAnalyticsManager.EVENT_NAME_PLAY_VIDEO;
			AmplitudeAnalyticsManager.instance.log(_loc2_,_loc1_);
		}
		
		private function startPlainPlayer() : void
		{
			if(this.previewMode)
			{
				this.startPreview();
			}
			else
			{
				this.startPlay();
			}
			this.dispatchEvent(new PlayerEvent(PlayerEvent.PLAYHEAD_USER_START_PLAY));
		}
		
		private function pausePlainPlayer(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean = true) : void
		{
			if(param3)
			{
				this.dispatchEvent(new PlayerEvent(PlayerEvent.PLAYHEAD_USER_PAUSE));
			}
			if(param2)
			{
				this.plainPlayer.pauseMovie(param4);
			}
			if(param1)
			{
				this.playerControl.pauseListener();
			}
		}
		
		private function resumePlainPlayer(param1:Boolean, param2:Boolean, param3:Boolean) : void
		{
			if(param3)
			{
				this.dispatchEvent(new PlayerEvent(PlayerEvent.PLAYHEAD_USER_RESUME));
			}
			if(param2)
			{
				this.plainPlayer.playMovie();
			}
			if(param1)
			{
				this.playerControl.playListener();
			}
			this._apiManager.notifyEvent("play");
		}
		
		private function goToAndPausePlainPlayer(param1:Boolean, param2:Boolean, param3:Boolean, param4:Number, param5:Boolean = false) : void
		{
			if(param3)
			{
				this.dispatchEvent(new PlayerEvent(PlayerEvent.PLAYHEAD_USER_GOTOANDPAUSE));
			}
			if(param2)
			{
				this.plainPlayer.goToAndPauseMovie(param4,param5);
			}
			if(param1)
			{
				this.playerControl.timeChangeListener(param4);
			}
		}
		
		private function setVolumeInPlainPlayer(param1:Number) : void
		{
			this.plainPlayer.setVolume(param1);
		}
		
		public function resume() : void
		{
			this.resumePlainPlayer(true,true,true);
			this._expectedPlayHeadState = PreviewPlayer.PLAYHEAD_STATE_PLAY;
		}
		
		public function pause(param1:Boolean = true, param2:Boolean = false) : void
		{
			if(param2)
			{
				this.plainPlayer.onRemoveEnterFrame();
			}
			this._expectedPlayHeadState = PreviewPlayer.PLAYHEAD_STATE_PAUSE;
			this.pausePlainPlayer(true,true,true,param1);
			this._isPlaying = false;
		}
		
		public function play(param1:Boolean = false) : void
		{
			var _loc3_:Object = null;
			var _loc4_:String = null;
			this.timeFrameSynchronizer.startSyn();
			if(param1)
			{
				this.plainPlayer.onAddEnterFrame();
			}
			if(this.firstStart)
			{
				this.hideEndScreen();
				this.startPlainPlayer();
			}
			else
			{
				this.resumePlainPlayer(true,true,true);
			}
			var _loc2_:* = AppConfigManager.instance.getValue(ServerConstants.PARAM_ISEMBED_ID) == "1";
			if(_loc2_ && this.firstStart)
			{
				_loc3_ = {};
				_loc3_[AmplitudeAnalyticsManager.EVENT_PROPERTIES_EMBED_VIDEO_ID] = AppConfigManager.instance.getValue(ServerConstants.PARAM_MOVIE_ID);
				_loc3_[AmplitudeAnalyticsManager.EVENT_PROPERTIES_OWNER_ID] = AppConfigManager.instance.getValue(ServerConstants.PARAM_MOVIE_OWNER_ID);
				_loc4_ = AmplitudeAnalyticsManager.EVENT_NAME_WATCH_EMBED_VIDEO;
				AmplitudeAnalyticsManager.instance.log(_loc4_,_loc3_);
			}
			this.firstStart = false;
			this._expectedPlayHeadState = PreviewPlayer.PLAYHEAD_STATE_PLAY;
			this._isPlaying = true;
			this._apiManager.notifyEvent("play");
		}
		
		public function replay() : void
		{
			this.timeFrameSynchronizer.startSyn();
			this._expectedPlayHeadState = PreviewPlayer.PLAYHEAD_STATE_PLAY;
			this.pausePlainPlayer(true,true,true);
			this.plainPlayer.goToAndPauseResetMovie();
			this.goToAndPausePlainPlayer(true,true,true,this.plainPlayer.previewStartFrame);
			this.resumePlainPlayer(true,true,true);
			this._isPlaying = true;
			this._apiManager.notifyEvent("play");
			if(this.plainPlayer.getNumScene() == 1)
			{
				this.plainPlayer.notifySceneEvent();
			}
		}
		
		private function showEndScreen(param1:Object = null, param2:Boolean = true) : void
		{
			var _loc4_:Fade = null;
			var _loc3_:* = AppConfigManager.instance.getValue(ServerConstants.PARAM_ISEMBED_ID) == "1";
			if(!_loc3_ && !this.previewMode)
			{
				return;
			}
			this.endScreen.visible = true;
			if(param2)
			{
				_loc4_ = new Fade();
				_loc4_.target = this.endScreen;
				_loc4_.alphaFrom = 0;
				_loc4_.alphaTo = 1;
				_loc4_.duration#1 = 1000;
				_loc4_.play();
			}
		}
		
		private function hideEndScreen(... rest) : void
		{
			this.endScreen.visible = false;
		}
		
		public function set subComponents(param1:Array) : void
		{
			this._subComponents = param1;
		}
		
		public function get subComponents() : Array
		{
			return this._subComponents;
		}
		
		private function addComponents() : void
		{
			var _loc1_:int = 0;
			while(_loc1_ < this._subComponents.length)
			{
				this.addChild(this._subComponents[_loc1_]);
				_loc1_++;
			}
		}
		
		private function onBufferExhaust(param1:PlayerEvent) : void
		{
			this.playerControl.timerDisplay.text = UtilDict.toDisplay("player","buffering") + "...";
			SceneBufferManager.instance.addEventListener(ProgressEvent.PROGRESS,this.onSceneBuffering);
			if(!this.loadingScreen.visible)
			{
				this.buffering.visible = this.buffering.includeInLayout = true;
			}
			this.pausePlainPlayer(false,true,false);
		}
		
		private function onBufferReady(param1:PlayerEvent) : void
		{
			this.playerControl.timerDisplay.text = "";
			SceneBufferManager.instance.removeEventListener(ProgressEvent.PROGRESS,this.onSceneBuffering);
			this.buffering.visible = this.buffering.includeInLayout = false;
			if(this._expectedPlayHeadState == PLAYHEAD_STATE_PLAY)
			{
				this.resumePlainPlayer(false,true,true);
			}
		}
		
		private function onMovieEnd(param1:PlayerEvent) : void
		{
			this.pause();
			this._expectedPlayHeadState = PLAYHEAD_STATE_MOVIE_END;
			if(this.plainPlayer.licensedSoundInfo != "")
			{
				this.endScreen.showCreditScreen(this.plainPlayer.licensedSoundInfo);
			}
			else if(Util.isVideoRecording())
			{
				navigateToURL(new URLRequest("FSCommand:stop"));
			}
			this.addEventListener(PlayerEvent.PLAYHEAD_USER_GOTOANDPAUSE,this.hideEndScreen,false,0,true);
			this.addEventListener(PlayerEvent.PLAYHEAD_USER_PAUSE,this.hideEndScreen,false,0,true);
			this.addEventListener(PlayerEvent.PLAYHEAD_USER_RESUME,this.hideEndScreen,false,0,true);
			this.timeFrameSynchronizer.stopSyn();
			if(!Util.isVideoRecording())
			{
				this.showEndScreen();
			}
			this.dispatchEvent(new PlayerEvent(PlayerEvent.PLAYHEAD_MOVIE_END));
			this._isPlaying = false;
			this._apiManager.notifyEvent("end");
		}
		
		private function onCreditScreenTimesUp(param1:Event) : void
		{
			if(Util.isVideoRecording())
			{
				navigateToURL(new URLRequest("FSCommand:stop"));
			}
		}
		
		private function onReplayButtonClick(param1:Event) : void
		{
			if(this.firstStart)
			{
				this.play();
			}
			else
			{
				this.replay();
			}
		}
		
		private function onNextMovieClick(param1:Event) : void
		{
			var _loc2_:PlayerEvent = new PlayerEvent(PlayerEvent.NEXTMOVIE);
			this.dispatchEvent(_loc2_);
		}
		
		public function setDisclaimer(param1:String) : void
		{
		}
		
		private function onMouseMove() : void
		{
			if(this._screenMode == FULL_SCREEN_MODE)
			{
				clearTimeout(this._hideControlBarTimeoutId);
				this.playerControl.visible = true;
				this._hideControlBarTimeoutId = setTimeout(this.hideControlBar,2000);
			}
			else if(this._screenMode == NORMAL_SCREEN_MODE)
			{
				this.playerControl.visible = true;
			}
		}
		
		private function hideControlBar() : void
		{
			this.playerControl.visible = false;
		}
		
		public function switchToWideScreen() : void
		{
			this._screen_height = AnimeConstants.WIDE_SCREEN_HEIGHT;
			this.contentContainer.height = AnimeConstants.WIDE_SCREEN_HEIGHT;
			var _loc1_:Number = AnimeConstants.SCREEN_Y + (AnimeConstants.SCREEN_HEIGHT - this._screen_height) / 2;
			this.movieStage.horizontalScrollPosition = AnimeConstants.SCREEN_X;
			this.movieStage.verticalScrollPosition = _loc1_;
			this.movieStage.width = AnimeConstants.SCREEN_WIDTH;
			this.movieStage.height = this._screen_height;
			this.resizeScaleContainer();
		}
		
		public function switchToNormalScreen() : void
		{
			this._screen_height = AnimeConstants.SCREEN_HEIGHT;
			this.contentContainer.height = AnimeConstants.SCREEN_HEIGHT;
			this.movieStage.horizontalScrollPosition = AnimeConstants.SCREEN_X;
			this.movieStage.verticalScrollPosition = AnimeConstants.SCREEN_Y;
			this.movieStage.width = AnimeConstants.SCREEN_WIDTH;
			this.movieStage.height = AnimeConstants.SCREEN_HEIGHT;
			this.resizeScaleContainer();
		}
		
		protected function onResize(param1:ResizeEvent) : void
		{
			var _loc4_:Number = NaN;
			var _loc2_:Number = this.height;
			var _loc3_:Number = this.width;
			if(_loc3_ < 400)
			{
				_loc4_ = Math.min(_loc3_ / this.contentContainer.width,_loc2_ / this.contentContainer.height);
				this.playerControl.scaleX = this.playerControl.scaleY = _loc4_;
			}
			else
			{
				this.playerControl.scaleX = this.playerControl.scaleY = 1;
			}
			this.resizeScaleContainer();
		}
		
		private function resizeScaleContainer() : void
		{
			var _loc1_:Number = this.width + 1;
			var _loc2_:Number = this.height + 1;
			var _loc3_:Number = Math.min(_loc1_ / this.contentContainer.width,_loc2_ / this.contentContainer.height);
			this.scaleContainer.scaleX = this.scaleContainer.scaleY = _loc3_;
			if(this._screenMode == RECORDING_SCREEN_MODE && this._screen_height == AnimeConstants.WIDE_SCREEN_HEIGHT)
			{
				this.scaleContainer.scaleX = _loc1_ / this.contentContainer.width;
				this.scaleContainer.scaleY = _loc2_ / this.contentContainer.height;
			}
		}
		
		public function set screenMode(param1:int) : void
		{
			if(param1 != this._screenMode)
			{
				this._screenMode = param1;
				switch(param1)
				{
					case NORMAL_SCREEN_MODE:
						this.screenContainer.percentHeight = 100;
						this.resizeScaleContainer();
						break;
					case FULL_SCREEN_MODE:
						this.screenContainer.percentHeight = 100;
						this.resizeScaleContainer();
						break;
					case RECORDING_SCREEN_MODE:
						this.screenContainer.percentHeight = 100;
						this.resizeScaleContainer();
						this.playerControl.visible = false;
				}
			}
		}
		
		protected function onRollOver(param1:MouseEvent) : void
		{
			if(this._screenMode == NORMAL_SCREEN_MODE)
			{
				clearTimeout(this._hideControlBarTimeoutId);
				this.playerControl.visible = true;
			}
		}
		
		protected function onRollOut(param1:MouseEvent) : void
		{
			if(this._screenMode == NORMAL_SCREEN_MODE)
			{
				clearTimeout(this._hideControlBarTimeoutId);
				this._hideControlBarTimeoutId = setTimeout(this.hideControlBar,2000);
			}
		}
		
		private function _PreviewPlayer_Fade1_i() : Fade
		{
			var _loc1_:Fade = new Fade();
			_loc1_.duration#1 = 500;
			_loc1_.alphaFrom = 0;
			_loc1_.alphaTo = 1;
			this.fadeIn = _loc1_;
			BindingManager.executeBindings(this,"fadeIn",this.fadeIn);
			return _loc1_;
		}
		
		private function _PreviewPlayer_Fade2_i() : Fade
		{
			var _loc1_:Fade = new Fade();
			_loc1_.duration#1 = 500;
			_loc1_.alphaFrom = 1;
			_loc1_.alphaTo = 0;
			this.fadeOut = _loc1_;
			BindingManager.executeBindings(this,"fadeOut",this.fadeOut);
			return _loc1_;
		}
		
		private function _PreviewPlayer_Rect1_c() : Rect
		{
			var _loc1_:Rect = new Rect();
			_loc1_.left = 0;
			_loc1_.right = 0;
			_loc1_.top = 0;
			_loc1_.bottom = 0;
			_loc1_.fill = this._PreviewPlayer_SolidColor1_c();
			_loc1_.initialized(this,null);
			return _loc1_;
		}
		
		private function _PreviewPlayer_SolidColor1_c() : SolidColor
		{
			var _loc1_:SolidColor = new SolidColor();
			_loc1_.color = 0;
			return _loc1_;
		}
		
		private function _PreviewPlayer_Group2_i() : Group
		{
			var _loc1_:Group = new Group();
			_loc1_.left = 0;
			_loc1_.right = 0;
			_loc1_.top = 0;
			_loc1_.bottom = 0;
			_loc1_.clipAndEnableScrolling = true;
			_loc1_.mxmlContent = [this._PreviewPlayer_Group3_i()];
			_loc1_.id = "screenContainer";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.screenContainer = _loc1_;
			BindingManager.executeBindings(this,"screenContainer",this.screenContainer);
			return _loc1_;
		}
		
		private function _PreviewPlayer_Group3_i() : Group
		{
			var _loc1_:Group = new Group();
			_loc1_.verticalCenter = 0;
			_loc1_.horizontalCenter = 0;
			_loc1_.mxmlContent = [this._PreviewPlayer_Group4_i()];
			_loc1_.id = "scaleContainer";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.scaleContainer = _loc1_;
			BindingManager.executeBindings(this,"scaleContainer",this.scaleContainer);
			return _loc1_;
		}
		
		private function _PreviewPlayer_Group4_i() : Group
		{
			var _loc1_:Group = new Group();
			_loc1_.width = 550;
			_loc1_.height = 354;
			_loc1_.clipAndEnableScrolling = true;
			_loc1_.mxmlContent = [this._PreviewPlayer_Rect2_c(),this._PreviewPlayer_Group5_i(),this._PreviewPlayer_PlayerWatermark1_i(),this._PreviewPlayer_PlayerStageAd1_i(),this._PreviewPlayer_BufferingScreen1_i(),this._PreviewPlayer_PlayerEndScreen1_i(),this._PreviewPlayer_Label1_i(),this._PreviewPlayer_timeFrameSynchronizer1_i()];
			_loc1_.id = "contentContainer";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.contentContainer = _loc1_;
			BindingManager.executeBindings(this,"contentContainer",this.contentContainer);
			return _loc1_;
		}
		
		private function _PreviewPlayer_Rect2_c() : Rect
		{
			var _loc1_:Rect = new Rect();
			_loc1_.left = 0;
			_loc1_.right = 0;
			_loc1_.top = 0;
			_loc1_.bottom = 0;
			_loc1_.fill = this._PreviewPlayer_SolidColor2_c();
			_loc1_.initialized(this,null);
			return _loc1_;
		}
		
		private function _PreviewPlayer_SolidColor2_c() : SolidColor
		{
			var _loc1_:SolidColor = new SolidColor();
			_loc1_.color = 16777215;
			return _loc1_;
		}
		
		private function _PreviewPlayer_Group5_i() : Group
		{
			var _loc1_:Group = new Group();
			_loc1_.width = 550;
			_loc1_.height = 354;
			_loc1_.clipAndEnableScrolling = true;
			_loc1_.id = "movieStage";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.movieStage = _loc1_;
			BindingManager.executeBindings(this,"movieStage",this.movieStage);
			return _loc1_;
		}
		
		private function _PreviewPlayer_PlayerWatermark1_i() : PlayerWatermark
		{
			var _loc1_:PlayerWatermark = new PlayerWatermark();
			_loc1_.id = "watermark";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.watermark = _loc1_;
			BindingManager.executeBindings(this,"watermark",this.watermark);
			return _loc1_;
		}
		
		private function _PreviewPlayer_PlayerStageAd1_i() : PlayerStageAd
		{
			var _loc1_:PlayerStageAd = new PlayerStageAd();
			_loc1_.top = 10;
			_loc1_.left = 10;
			_loc1_.right = 10;
			_loc1_.visible = false;
			_loc1_.id = "_stageAd";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this._stageAd = _loc1_;
			BindingManager.executeBindings(this,"_stageAd",this._stageAd);
			return _loc1_;
		}
		
		private function _PreviewPlayer_BufferingScreen1_i() : BufferingScreen
		{
			var _loc1_:BufferingScreen = new BufferingScreen();
			_loc1_.visible = false;
			_loc1_.includeInLayout = false;
			_loc1_.id = "buffering";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.buffering = _loc1_;
			BindingManager.executeBindings(this,"buffering",this.buffering);
			return _loc1_;
		}
		
		private function _PreviewPlayer_PlayerEndScreen1_i() : PlayerEndScreen
		{
			var _loc1_:PlayerEndScreen = new PlayerEndScreen();
			_loc1_.verticalCenter = 0;
			_loc1_.horizontalCenter = 0;
			_loc1_.visible = false;
			_loc1_.addEventListener("replayButtonClick",this.__endScreen_replayButtonClick);
			_loc1_.addEventListener("creditScreenTimeUp",this.__endScreen_creditScreenTimeUp);
			_loc1_.id = "endScreen";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.endScreen = _loc1_;
			BindingManager.executeBindings(this,"endScreen",this.endScreen);
			return _loc1_;
		}
		
		public function __endScreen_replayButtonClick(param1:PlayerEndScreenEvent) : void
		{
			this.onReplayButtonClick(param1);
		}
		
		public function __endScreen_creditScreenTimeUp(param1:PlayerEndScreenEvent) : void
		{
			this.onCreditScreenTimesUp(param1);
		}
		
		private function _PreviewPlayer_Label1_i() : Label
		{
			var _loc1_:Label = new Label();
			_loc1_.left = 20;
			_loc1_.right = 20;
			_loc1_.verticalCenter = 0;
			_loc1_.visible = false;
			_loc1_.mouseEnabled = false;
			_loc1_.setStyle("fontFamily","LatoRegular");
			_loc1_.setStyle("textAlign","center");
			_loc1_.setStyle("fontSize",14);
			_loc1_.setStyle("color",0);
			_loc1_.id = "alertText";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.alertText = _loc1_;
			BindingManager.executeBindings(this,"alertText",this.alertText);
			return _loc1_;
		}
		
		private function _PreviewPlayer_timeFrameSynchronizer1_i() : timeFrameSynchronizer
		{
			var _loc1_:timeFrameSynchronizer = new timeFrameSynchronizer();
			_loc1_.x = 249;
			_loc1_.y = 0;
			_loc1_.visible = false;
			_loc1_.id = "timeFrameSynchronizer";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.timeFrameSynchronizer = _loc1_;
			BindingManager.executeBindings(this,"timeFrameSynchronizer",this.timeFrameSynchronizer);
			return _loc1_;
		}
		
		private function _PreviewPlayer_LoadingScreen1_i() : LoadingScreen
		{
			var _loc1_:LoadingScreen = new LoadingScreen();
			_loc1_.top = 0;
			_loc1_.bottom = 0;
			_loc1_.left = 0;
			_loc1_.right = 0;
			_loc1_.id = "loadingScreen";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.loadingScreen = _loc1_;
			BindingManager.executeBindings(this,"loadingScreen",this.loadingScreen);
			return _loc1_;
		}
		
		private function _PreviewPlayer_PlayerControl1_i() : PlayerControl
		{
			var _loc1_:PlayerControl = new PlayerControl();
			_loc1_.bottom = 0;
			_loc1_.visible = false;
			_loc1_.addEventListener("onPlayButClicked",this.__playerControl_onPlayButClicked);
			_loc1_.addEventListener("onPauseButClicked",this.__playerControl_onPauseButClicked);
			_loc1_.addEventListener("onTimeLineDrag",this.__playerControl_onTimeLineDrag);
			_loc1_.addEventListener("onTimeLinePress",this.__playerControl_onTimeLinePress);
			_loc1_.addEventListener("onTimeLineRelease",this.__playerControl_onTimeLineRelease);
			_loc1_.id = "playerControl";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.playerControl = _loc1_;
			BindingManager.executeBindings(this,"playerControl",this.playerControl);
			return _loc1_;
		}
		
		public function __playerControl_onPlayButClicked(param1:Event) : void
		{
			this.onPlayButClick();
		}
		
		public function __playerControl_onPauseButClicked(param1:Event) : void
		{
			this.onPauseButClick();
		}
		
		public function __playerControl_onTimeLineDrag(param1:Event) : void
		{
			this.onTimeLineDrag(param1);
		}
		
		public function __playerControl_onTimeLinePress(param1:Event) : void
		{
			this.onTimeLinePress(param1);
		}
		
		public function __playerControl_onTimeLineRelease(param1:Event) : void
		{
			this.onTimeLineRelease(param1);
		}
		
		public function ___PreviewPlayer_Group1_creationComplete(param1:FlexEvent) : void
		{
			this.onCreationCompleted();
		}
		
		public function ___PreviewPlayer_Group1_mouseMove(param1:MouseEvent) : void
		{
			this.onMouseMove();
		}
		
		public function ___PreviewPlayer_Group1_rollOver(param1:MouseEvent) : void
		{
			this.onRollOver(param1);
		}
		
		public function ___PreviewPlayer_Group1_rollOut(param1:MouseEvent) : void
		{
			this.onRollOut(param1);
		}
		
		public function ___PreviewPlayer_Group1_resize(param1:ResizeEvent) : void
		{
			this.onResize(param1);
		}
		
		private function _PreviewPlayer_bindingsSetup() : Array
		{
			var result:Array = [];
			result[0] = new Binding(this,null,function(param1:*):void
			{
				playerControl.setStyle("showEffect",param1);
			},"playerControl.showEffect","fadeIn");
			result[1] = new Binding(this,null,function(param1:*):void
			{
				playerControl.setStyle("hideEffect",param1);
			},"playerControl.hideEffect","fadeOut");
			return result;
		}
		
		[Bindable(event="propertyChange")]
		public function get _stageAd() : PlayerStageAd
		{
			return this._460696194_stageAd;
		}
		
		public function set _stageAd(param1:PlayerStageAd) : void
		{
			var _loc2_:Object = this._460696194_stageAd;
			if(_loc2_ !== param1)
			{
				this._460696194_stageAd = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_stageAd",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get alertText() : Label
		{
			return this._1462422359alertText;
		}
		
		public function set alertText(param1:Label) : void
		{
			var _loc2_:Object = this._1462422359alertText;
			if(_loc2_ !== param1)
			{
				this._1462422359alertText = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"alertText",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get buffering() : BufferingScreen
		{
			return this._61512610buffering;
		}
		
		public function set buffering(param1:BufferingScreen) : void
		{
			var _loc2_:Object = this._61512610buffering;
			if(_loc2_ !== param1)
			{
				this._61512610buffering = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buffering",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get contentContainer() : Group
		{
			return this._1707945992contentContainer;
		}
		
		public function set contentContainer(param1:Group) : void
		{
			var _loc2_:Object = this._1707945992contentContainer;
			if(_loc2_ !== param1)
			{
				this._1707945992contentContainer = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentContainer",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get endScreen() : PlayerEndScreen
		{
			return this._1593500967endScreen;
		}
		
		public function set endScreen(param1:PlayerEndScreen) : void
		{
			var _loc2_:Object = this._1593500967endScreen;
			if(_loc2_ !== param1)
			{
				this._1593500967endScreen = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endScreen",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get fadeIn() : Fade
		{
			return this._1282133823fadeIn;
		}
		
		public function set fadeIn(param1:Fade) : void
		{
			var _loc2_:Object = this._1282133823fadeIn;
			if(_loc2_ !== param1)
			{
				this._1282133823fadeIn = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get fadeOut() : Fade
		{
			return this._1091436750fadeOut;
		}
		
		public function set fadeOut(param1:Fade) : void
		{
			var _loc2_:Object = this._1091436750fadeOut;
			if(_loc2_ !== param1)
			{
				this._1091436750fadeOut = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeOut",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get loadingScreen() : LoadingScreen
		{
			return this._459583688loadingScreen;
		}
		
		public function set loadingScreen(param1:LoadingScreen) : void
		{
			var _loc2_:Object = this._459583688loadingScreen;
			if(_loc2_ !== param1)
			{
				this._459583688loadingScreen = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"loadingScreen",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get movieStage() : Group
		{
			return this._1840541266movieStage;
		}
		
		public function set movieStage(param1:Group) : void
		{
			var _loc2_:Object = this._1840541266movieStage;
			if(_loc2_ !== param1)
			{
				this._1840541266movieStage = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"movieStage",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get playerControl() : PlayerControl
		{
			return this._690449604playerControl;
		}
		
		public function set playerControl(param1:PlayerControl) : void
		{
			var _loc2_:Object = this._690449604playerControl;
			if(_loc2_ !== param1)
			{
				this._690449604playerControl = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerControl",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get scaleContainer() : Group
		{
			return this._772093527scaleContainer;
		}
		
		public function set scaleContainer(param1:Group) : void
		{
			var _loc2_:Object = this._772093527scaleContainer;
			if(_loc2_ !== param1)
			{
				this._772093527scaleContainer = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"scaleContainer",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get screenContainer() : Group
		{
			return this._176252277screenContainer;
		}
		
		public function set screenContainer(param1:Group) : void
		{
			var _loc2_:Object = this._176252277screenContainer;
			if(_loc2_ !== param1)
			{
				this._176252277screenContainer = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"screenContainer",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get timeFrameSynchronizer() : timeFrameSynchronizer
		{
			return this._1523976162timeFrameSynchronizer;
		}
		
		public function set timeFrameSynchronizer(param1:timeFrameSynchronizer) : void
		{
			var _loc2_:Object = this._1523976162timeFrameSynchronizer;
			if(_loc2_ !== param1)
			{
				this._1523976162timeFrameSynchronizer = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeFrameSynchronizer",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get watermark() : PlayerWatermark
		{
			return this._213424028watermark;
		}
		
		public function set watermark(param1:PlayerWatermark) : void
		{
			var _loc2_:Object = this._213424028watermark;
			if(_loc2_ !== param1)
			{
				this._213424028watermark = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"watermark",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		private function get createYourOwnWidth() : Number
		{
			return this._1155998129createYourOwnWidth;
		}
		
		private function set createYourOwnWidth(param1:Number) : void
		{
			var _loc2_:Object = this._1155998129createYourOwnWidth;
			if(_loc2_ !== param1)
			{
				this._1155998129createYourOwnWidth = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createYourOwnWidth",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		private function get createYourOwnHeight() : Number
		{
			return this._1909198402createYourOwnHeight;
		}
		
		private function set createYourOwnHeight(param1:Number) : void
		{
			var _loc2_:Object = this._1909198402createYourOwnHeight;
			if(_loc2_ !== param1)
			{
				this._1909198402createYourOwnHeight = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createYourOwnHeight",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		private function get _screen_height() : Number
		{
			return this._420974171_screen_height;
		}
		
		private function set _screen_height(param1:Number) : void
		{
			var _loc2_:Object = this._420974171_screen_height;
			if(_loc2_ !== param1)
			{
				this._420974171_screen_height = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_screen_height",_loc2_,param1));
				}
			}
		}
	}
}
