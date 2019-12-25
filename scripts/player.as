package
{
	import anifire.constant.AnimeConstants;
	import anifire.constant.ServerConstants;
	import anifire.managers.AmplitudeAnalyticsManager;
	import anifire.managers.AppConfigManager;
	import anifire.player.components.PreviewPlayer;
	import anifire.player.events.PlayerEvent;
	import anifire.player.managers.PlayerApiManager;
	import anifire.player.skins.BigPlayButtonSkin;
	import anifire.util.Util;
	import anifire.util.UtilErrorLogger;
	import anifire.util.UtilHashArray;
	import anifire.util.UtilNetwork;
	import anifire.util.UtilPreviewMovie;
	import anifire.utils.SecurityUtils;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getDefinitionByName;
	import mx.binding.Binding;
	import mx.binding.BindingManager;
	import mx.binding.IBindingClient;
	import mx.binding.IWatcherSetupUtil2;
	import mx.core.DeferredInstanceFromFunction;
	import mx.core.IFlexModuleFactory;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.graphics.SolidColor;
	import mx.styles.CSSCondition;
	import mx.styles.CSSSelector;
	import mx.styles.CSSStyleDeclaration;
	import spark.components.Application;
	import spark.components.Button;
	import spark.components.Group;
	import spark.primitives.BitmapImage;
	import spark.primitives.Rect;
	
	use namespace mx_internal;
	
	public class player extends Application implements IBindingClient
	{
		
		public static var CODE_VERSION:String = "a76d829cef09f7bb9bef739f686c0449acbaded8";
		
		private static var _watcherSetupUtil:IWatcherSetupUtil2;
		
		{
			SecurityUtils.init();
		}
		
		private var _737918605playerButton:Button;
		
		private var _269776073previewPlayer:PreviewPlayer;
		
		private var _1330532588thumbnail:BitmapImage;
		
		private var _1905040139thumbnailContainer:Group;
		
		private var __moduleFactoryInitialized:Boolean = false;
		
		private var _targetFrame:int;
		
		private var _configManager:AppConfigManager;
		
		private var _121283216_isEmbed:Boolean;
		
		protected var localFlashVars:Boolean;
		
		protected var skipLocale:Boolean;
		
		private var urlRequest:URLRequest;
		
		mx_internal var _player_StylesInit_done:Boolean = false;
		
		private var _embed__font_LatoRegular_bold_normal_1543885270:Class;
		
		private var _embed__font_LatoRegular_medium_normal_36925052:Class;
		
		mx_internal var _bindings:Array;
		
		mx_internal var _watchers:Array;
		
		mx_internal var _bindingsByDestination:Object;
		
		mx_internal var _bindingsBeginWithWord:Object;
		
		public function player()
		{
			var target:Object = null;
			var watcherSetupUtilClass:Object = null;
			this._embed__font_LatoRegular_bold_normal_1543885270 = player__embed__font_LatoRegular_bold_normal_1543885270;
			this._embed__font_LatoRegular_medium_normal_36925052 = player__embed__font_LatoRegular_medium_normal_36925052;
			this._bindings = [];
			this._watchers = [];
			this._bindingsByDestination = {};
			this._bindingsBeginWithWord = {};
			super();
			mx_internal::_document = this;
			var bindings:Array = this._player_bindingsSetup();
			var watchers:Array = [];
			target = this;
			if(_watcherSetupUtil == null)
			{
				watcherSetupUtilClass = getDefinitionByName("_playerWatcherSetupUtil");
				watcherSetupUtilClass["init"](null);
			}
			_watcherSetupUtil.setup(this,function(param1:String):*
			{
				return target[param1];
			},function(param1:String):*
			{
				return player[param1];
			},bindings,watchers);
			mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
			mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
			this.mxmlContentFactory = new DeferredInstanceFromFunction(this._player_Array1_c);
			this.addEventListener("preinitialize",this.___player_Application1_preinitialize);
			this.addEventListener("applicationComplete",this.___player_Application1_applicationComplete);
			var i:uint = 0;
			while(i < bindings.length)
			{
				Binding(bindings[i]).execute();
				i++;
			}
		}
		
		public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
		{
			player._watcherSetupUtil = param1;
		}
		
		override public function set moduleFactory(param1:IFlexModuleFactory) : void
		{
			var factory:IFlexModuleFactory = param1;
			super.moduleFactory = factory;
			if(this.__moduleFactoryInitialized)
			{
				return;
			}
			this.__moduleFactoryInitialized = true;
			if(!this.styleDeclaration)
			{
				this.styleDeclaration = new CSSStyleDeclaration(null,styleManager);
			}
			this.styleDeclaration.defaultFactory = function():void
			{
				this.backgroundColor = 2105376;
			};
			mx_internal::_player_StylesInit();
		}
		
		override public function initialize() : void
		{
			super.initialize();
		}
		
		private function onPreinitialize() : void
		{
			this._configManager = AppConfigManager.instance;
			PlayerApiManager.instance;
			if(this.skipLocale)
			{
				this.resourceComplete();
			}
			else
			{
				this.loadClientLocale();
			}
		}
		
		private function loadClientLocale() : void
		{
			Util.loadClientLocale("player",this.onClientLocaleComplete);
		}
		
		private function onClientLocaleComplete(param1:Event) : void
		{
			this.resourceComplete();
		}
		
		private function resourceComplete() : void
		{
			createDeferredContent();
		}
		
		private function loadSceneInternally(param1:Event) : void
		{
			this.previewPlayer.loadScenePreview(this._targetFrame);
		}
		
		public function embedMovie() : void
		{
			this.previewPlayer.pause();
		}
		
		public function pause() : void
		{
			this.previewPlayer.pause();
		}
		
		private function updateSize() : void
		{
			var _loc1_:Number = NaN;
			var _loc2_:Number = NaN;
			if(this._configManager.getValue(ServerConstants.FLASHVAR_IS_WIDE) == "1")
			{
				this.previewPlayer.switchToWideScreen();
			}
			else
			{
				this.previewPlayer.switchToNormalScreen();
			}
			if(Util.isVideoRecording())
			{
				this.previewPlayer.screenMode = PreviewPlayer.RECORDING_SCREEN_MODE;
				_loc1_ = Number(this._configManager.getValue(ServerConstants.FLASHVAR_CUSTOM_PLAYER_WIDTH));
				_loc2_ = Number(this._configManager.getValue(ServerConstants.FLASHVAR_CUSTOM_PLAYER_HEIGHT));
				if(_loc1_ <= 0 || _loc2_ <= 0)
				{
					_loc1_ = AnimeConstants.CONVERT_TO_AVI_WIDTH;
					_loc2_ = AnimeConstants.CONVERT_TO_AVI_HEIGHT;
				}
				this.width = _loc1_;
				this.height = _loc2_;
			}
		}
		
		private function onApplicationCompleted() : void
		{
			var _loc7_:Array = null;
			var _loc8_:String = null;
			var _loc9_:String = null;
			var _loc10_:Array = null;
			var _loc11_:UtilHashArray = null;
			var _loc12_:UtilHashArray = null;
			var _loc13_:XML = null;
			var _loc14_:ContextMenuItem = null;
			Util.initLog();
			UtilNetwork.loadS3crossDomainXml();
			UtilErrorLogger.getInstance().addEventListener(UtilErrorLogger.LOG_SENT_COMPLETE,this.onErrorLogSentComplete);
			UtilErrorLogger.getInstance().addEventListener(UtilErrorLogger.LOG_SENT_FAIL,this.onErrorLogSentFail);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.fullScreenHandler);
			var _loc1_:Array = new Array();
			this.urlRequest = UtilNetwork.getMovieRequest(this._configManager.getValue(ServerConstants.PARAM_MOVIE_ID));
			var _loc2_:String = this._configManager.getValue(ServerConstants.FLASHVAR_CHAIN_MOVIE_ID);
			if(_loc2_ != null && _loc2_ != "")
			{
				_loc7_ = _loc2_.split(",");
				for each(_loc8_ in _loc7_)
				{
					_loc1_.push(UtilNetwork.getMovieRequest(_loc8_));
				}
			}
			else
			{
				_loc1_.push(this.urlRequest);
			}
			this.updateSize();
			var _loc3_:* = this._configManager.getValue("isInitFromExternal") == "1";
			if(_loc3_)
			{
				if(ExternalInterface.available)
				{
					_loc9_ = ExternalInterface.call("retrievePreviewPlayerData");
					this._targetFrame = int(this._configManager.getValue("startFrame"));
					this.previewPlayer.loadScenePreview(this._targetFrame);
					_loc10_ = new Array();
					_loc11_ = new UtilHashArray();
					_loc12_ = new UtilHashArray();
					UtilPreviewMovie.deserializePreviewMovieData(_loc9_,_loc10_,_loc11_,_loc12_);
					_loc13_ = _loc10_[0] as XML;
					this.previewPlayer.initAndPreview(_loc13_,_loc11_,_loc12_);
				}
			}
			else
			{
				this.previewPlayer.init(this.urlRequest,_loc1_);
			}
			this.initEndScreen();
			var _loc4_:* = this._configManager.getValue(ServerConstants.FLASHVAR_AUTOSTART) == "1";
			this._isEmbed = this._configManager.getValue(ServerConstants.PARAM_ISEMBED_ID) == "1";
			if(!this._isEmbed)
			{
				this.previewPlayer.watermark.logoEnabled = false;
			}
			else
			{
				this.previewPlayer.watermark.logoEnabled = true;
			}
			if(_loc4_)
			{
				this.previewPlayer.play();
			}
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.uncaughtErrorHandler);
			var _loc5_:ContextMenu = new ContextMenu();
			_loc5_.hideBuiltInItems();
			var _loc6_:String = CODE_VERSION;
			if(_loc6_ && _loc6_.length > 0)
			{
				_loc14_ = new ContextMenuItem("Version: " + _loc6_);
				_loc14_.enabled = false;
				_loc14_.separatorBefore = true;
				_loc5_.customItems.push(_loc14_);
			}
			this.contextMenu = _loc5_;
			if(ExternalInterface.available)
			{
				ExternalInterface.addCallback("pause",this.pause);
			}
			if(!_loc3_)
			{
				this.loadThumbnail();
			}
		}
		
		private function fullScreenHandler(param1:FullScreenEvent) : void
		{
			if(param1.fullScreen)
			{
				this.previewPlayer.width = this.stage.fullScreenWidth;
				this.previewPlayer.height = this.stage.fullScreenHeight;
			}
			else
			{
				this.previewPlayer.width = this.width;
				this.previewPlayer.height = this.height;
			}
			dispatchEvent(param1);
		}
		
		private function doGoToMoviePage() : void
		{
			var _loc1_:URLVariables = null;
			var _loc2_:URLRequest = null;
			if(this._isEmbed)
			{
				_loc1_ = new URLVariables();
				_loc1_["utm_source"] = "embed-logo";
				_loc2_ = new URLRequest(ServerConstants.HOST_PATH);
				_loc2_.data = _loc1_;
				navigateToURL(_loc2_,"_top");
			}
		}
		
		private function loadThumbnail() : void
		{
			var _loc1_:String = Util.getMovieThumbnailUrl();
			if(_loc1_ && _loc1_ != "")
			{
				this.thumbnail.source = _loc1_;
			}
		}
		
		private function initEndScreen() : void
		{
			var _loc1_:* = this._configManager.getValue("isPreview") == "1";
			var _loc2_:* = this._configManager.getValue("isTemplate") == "1";
			if(_loc1_ || _loc2_)
			{
				this.previewPlayer.playerControl.disableFullScreen();
			}
		}
		
		private function deleteThumbnail() : void
		{
			this.thumbnailContainer.visible = false;
		}
		
		private function onPlayButtonClick(param1:Event) : void
		{
			this.playerButton.visible = false;
			this.deleteThumbnail();
			this.previewPlayer.play();
			var _loc2_:Object = {};
			_loc2_[AmplitudeAnalyticsManager.EVENT_PROPERTIES_MOVIE_ID] = this._configManager.getValue(ServerConstants.PARAM_MOVIE_ID);
			AmplitudeAnalyticsManager.instance.log(AmplitudeAnalyticsManager.EVENT_NAME_PLAY_VIDEO,_loc2_);
		}
		
		private function onPreviewPlayerStartPlay(param1:Event) : void
		{
			this.playerButton.visible = false;
			this.deleteThumbnail();
		}
		
		private function uncaughtErrorHandler(param1:UncaughtErrorEvent) : void
		{
			UtilErrorLogger.getInstance().fatal("uncaughtErrorHandler:" + new Error().getStackTrace());
		}
		
		private function onErrorLogSentComplete(param1:Event) : void
		{
		}
		
		private function onErrorLogSentFail(param1:Event) : void
		{
		}
		
		private function _player_Array1_c() : Array
		{
			var _loc1_:Array = [this._player_PreviewPlayer1_i(),this._player_Group1_i(),this._player_Button1_i()];
			return _loc1_;
		}
		
		private function _player_PreviewPlayer1_i() : PreviewPlayer
		{
			var _loc1_:PreviewPlayer = new PreviewPlayer();
			_loc1_.addEventListener("logoClick",this.__previewPlayer_logoClick);
			_loc1_.addEventListener("playhead_user_start_play",this.__previewPlayer_playhead_user_start_play);
			_loc1_.addEventListener("info_load_complete",this.__previewPlayer_info_load_complete);
			_loc1_.id = "previewPlayer";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.previewPlayer = _loc1_;
			BindingManager.executeBindings(this,"previewPlayer",this.previewPlayer);
			return _loc1_;
		}
		
		public function __previewPlayer_logoClick(param1:PlayerEvent) : void
		{
			this.doGoToMoviePage();
		}
		
		public function __previewPlayer_playhead_user_start_play(param1:PlayerEvent) : void
		{
			this.onPreviewPlayerStartPlay(param1);
		}
		
		public function __previewPlayer_info_load_complete(param1:Event) : void
		{
			this.loadSceneInternally(param1);
		}
		
		private function _player_Group1_i() : Group
		{
			var _loc1_:Group = new Group();
			_loc1_.percentWidth = 100;
			_loc1_.percentHeight = 100;
			_loc1_.mxmlContent = [this._player_Rect1_c(),this._player_BitmapImage1_i()];
			_loc1_.id = "thumbnailContainer";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.thumbnailContainer = _loc1_;
			BindingManager.executeBindings(this,"thumbnailContainer",this.thumbnailContainer);
			return _loc1_;
		}
		
		private function _player_Rect1_c() : Rect
		{
			var _loc1_:Rect = new Rect();
			_loc1_.percentHeight = 100;
			_loc1_.percentWidth = 100;
			_loc1_.fill = this._player_SolidColor1_c();
			_loc1_.initialized(this,null);
			return _loc1_;
		}
		
		private function _player_SolidColor1_c() : SolidColor
		{
			var _loc1_:SolidColor = new SolidColor();
			_loc1_.color = 0;
			return _loc1_;
		}
		
		private function _player_BitmapImage1_i() : BitmapImage
		{
			var _loc1_:BitmapImage = new BitmapImage();
			_loc1_.percentWidth = 100;
			_loc1_.percentHeight = 100;
			_loc1_.horizontalAlign = "center";
			_loc1_.verticalAlign = "middle";
			_loc1_.smooth = true;
			_loc1_.scaleMode = "letterbox";
			_loc1_.initialized(this,"thumbnail");
			this.thumbnail = _loc1_;
			BindingManager.executeBindings(this,"thumbnail",this.thumbnail);
			return _loc1_;
		}
		
		private function _player_Button1_i() : Button
		{
			var _loc1_:Button = new Button();
			_loc1_.buttonMode = true;
			_loc1_.horizontalCenter = 0;
			_loc1_.verticalCenter = 0;
			_loc1_.setStyle("skinClass",BigPlayButtonSkin);
			_loc1_.addEventListener("click",this.__playerButton_click);
			_loc1_.id = "playerButton";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.playerButton = _loc1_;
			BindingManager.executeBindings(this,"playerButton",this.playerButton);
			return _loc1_;
		}
		
		public function __playerButton_click(param1:MouseEvent) : void
		{
			this.onPlayButtonClick(param1);
		}
		
		public function ___player_Application1_preinitialize(param1:FlexEvent) : void
		{
			this.onPreinitialize();
		}
		
		public function ___player_Application1_applicationComplete(param1:FlexEvent) : void
		{
			this.onApplicationCompleted();
		}
		
		private function _player_bindingsSetup() : Array
		{
			var result:Array = [];
			result[0] = new Binding(this,function():Boolean
			{
				return _isEmbed;
			},null,"thumbnailContainer.visible");
			result[1] = new Binding(this,function():Boolean
			{
				return _isEmbed;
			},null,"thumbnailContainer.includeInLayout");
			result[2] = new Binding(this,function():Boolean
			{
				return _isEmbed;
			},null,"playerButton.visible");
			result[3] = new Binding(this,function():Boolean
			{
				return _isEmbed;
			},null,"playerButton.includeInLayout");
			return result;
		}
		
		mx_internal function _player_StylesInit() : void
		{
			var style:CSSStyleDeclaration = null;
			var effects:Array = null;
			var conditions:Array = null;
			var condition:CSSCondition = null;
			var selector:CSSSelector = null;
			if(mx_internal::_player_StylesInit_done)
			{
				return;
			}
			mx_internal::_player_StylesInit_done = true;
			selector = null;
			conditions = null;
			conditions = null;
			selector = new CSSSelector("spark.components.supportClasses.TextBase",conditions,selector);
			style = styleManager.getStyleDeclaration("spark.components.supportClasses.TextBase");
			if(!style)
			{
				style = new CSSStyleDeclaration(selector,styleManager);
			}
			if(style.factory == null)
			{
				style.factory = function():void
				{
					this.fontLookup = "embeddedCFF";
					this.fontStyle = "normal";
					this.fontFamily = "LatoRegular";
				};
			}
			styleManager.initProtoChainRoots();
		}
		
		[Bindable(event="propertyChange")]
		public function get playerButton() : Button
		{
			return this._737918605playerButton;
		}
		
		public function set playerButton(param1:Button) : void
		{
			var _loc2_:Object = this._737918605playerButton;
			if(_loc2_ !== param1)
			{
				this._737918605playerButton = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerButton",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get previewPlayer() : PreviewPlayer
		{
			return this._269776073previewPlayer;
		}
		
		public function set previewPlayer(param1:PreviewPlayer) : void
		{
			var _loc2_:Object = this._269776073previewPlayer;
			if(_loc2_ !== param1)
			{
				this._269776073previewPlayer = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"previewPlayer",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get thumbnail() : BitmapImage
		{
			return this._1330532588thumbnail;
		}
		
		public function set thumbnail(param1:BitmapImage) : void
		{
			var _loc2_:Object = this._1330532588thumbnail;
			if(_loc2_ !== param1)
			{
				this._1330532588thumbnail = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"thumbnail",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get thumbnailContainer() : Group
		{
			return this._1905040139thumbnailContainer;
		}
		
		public function set thumbnailContainer(param1:Group) : void
		{
			var _loc2_:Object = this._1905040139thumbnailContainer;
			if(_loc2_ !== param1)
			{
				this._1905040139thumbnailContainer = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"thumbnailContainer",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		private function get _isEmbed() : Boolean
		{
			return this._121283216_isEmbed;
		}
		
		private function set _isEmbed(param1:Boolean) : void
		{
			var _loc2_:Object = this._121283216_isEmbed;
			if(_loc2_ !== param1)
			{
				this._121283216_isEmbed = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_isEmbed",_loc2_,param1));
				}
			}
		}
	}
}
