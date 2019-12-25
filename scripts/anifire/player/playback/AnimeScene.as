package anifire.player.playback
{
	import anifire.assets.AssetImageLibrary;
	import anifire.assets.transition.AssetTransitionConstants;
	import anifire.assets.transition.AssetTransitionNode;
	import anifire.assets.transition.NarrationNode;
	import anifire.cc.view.CcImageLibrary;
	import anifire.component.ProcessRegulator;
	import anifire.constant.AnimeConstants;
	import anifire.effect.EffectMgr;
	import anifire.event.LoadMgrEvent;
	import anifire.interfaces.IIterator;
	import anifire.interfaces.IPlayable;
	import anifire.interfaces.IRegulatedProcess;
	import anifire.iterators.TreeNode;
	import anifire.player.assetTransitions.views.WhiteboardHand;
	import anifire.player.events.PlayerEvent;
	import anifire.player.managers.DownloadManager;
	import anifire.player.managers.SceneBufferManager;
	import anifire.player.sceneEffects.AnimeEffectAsset;
	import anifire.player.sceneEffects.BumpyrideEffectAsset;
	import anifire.player.sceneEffects.DRAlertEffectAsset;
	import anifire.player.sceneEffects.EarthquakeEffectAsset;
	import anifire.player.sceneEffects.EffectAsset;
	import anifire.player.sceneEffects.FadingEffectAsset;
	import anifire.player.sceneEffects.FireSpringEffectAsset;
	import anifire.player.sceneEffects.FireworkEffectAsset;
	import anifire.player.sceneEffects.GrayScaleEffectAsset;
	import anifire.player.sceneEffects.HoveringEffectAsset;
	import anifire.player.sceneEffects.ProgramEffectAsset;
	import anifire.player.sceneEffects.SepiaEffectAsset;
	import anifire.player.sceneEffects.UpsideDownEffectAsset;
	import anifire.player.sceneEffects.ZoomEffectAsset;
	import anifire.player.sceneTransitions.AnimateTransition;
	import anifire.player.sceneTransitions.FadeOutInTransition;
	import anifire.player.sceneTransitions.FlashEffTransition;
	import anifire.player.sceneTransitions.FlashTransition;
	import anifire.player.sceneTransitions.PanSceneTransition;
	import anifire.util.UtilHashArray;
	import anifire.util.UtilLoadMgr;
	import anifire.util.UtilMath;
	import anifire.util.UtilPlain;
	import anifire.util.UtilUnitConvert;
	import anifire.util.UtilUser;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class AnimeScene extends EventDispatcher implements IPlayable, IRegulatedProcess
	{
		
		public static const XML_TAG:String = "scene";
		
		protected static const TRANSITION_PACKAGE_ANIFIRE:String = "anifire";
		
		protected static const TRANSITION_PACKAGE_ANIMATED:String = "animated";
		
		protected static const TRANSITION_PACKAGE_FL:String = "fl";
		
		protected static const TRANSITION_PACKAGE_FLASHEFF:String = "flashEff";
		
		protected static const TRANSITION_TYPE_PAN:String = "Pan";
		
		public static const TRANSITION_TYPE_FLY:String = "Fly";
		
		protected static const ZOOM_DUMMY:String = "dummy";
		
		protected static const XML_ATTRIBUTE_ID:String = "id";
		
		protected static const XML_ATTRIBUTE_INDEX:String = "index";
		
		protected static const XML_ATTRIBUTE_ADELAY:String = "adelay";
		
		protected static const XML_ATTRIBUTE_MDELAY:String = "mdelay";
		
		protected static const XML_PROPERTY_COLOR:String = "@color";
		
		protected static const XML_PROPERTY_GUID:String = "@guid";
		
		public static const STATE_NULL:int = 0;
		
		public static const STATE_BUFFER_INITIALIZING:int = 1;
		
		public static const STATE_ACTION:int = 2;
		
		public static const STATE_MOTION:int = 3;
		
		public static const DEFAULT_BASE_COLOR:int = 16777215;
		 
		
		private var _visibleAssets:Vector.<Asset>;
		
		private var _assetIndice:Object;
		
		private var _characters:Vector.<Character>;
		
		private var _characterIndice:Object;
		
		private var _props:Vector.<Prop>;
		
		private var _propIndice:Object;
		
		private var _bubbles:Vector.<BubbleAsset>;
		
		private var _bubbleIndice:Object;
		
		private var _backgrounds:Vector.<Background>;
		
		private var _backgroundIndice:Object;
		
		private var _segments:Vector.<Segment>;
		
		private var _segmentIndice:Object;
		
		private var _effects:Vector.<EffectAsset>;
		
		private var _effectIndice:Object;
		
		private var _effectTypeIndice:Object;
		
		private var _transitions:Vector.<GoTransition>;
		
		private var _transitionIndice:Object;
		
		private var _actionDuration:Number;
		
		private var _motionDuration:Number;
		
		private var _duration:Number;
		
		private var _parentAnime:Anime;
		
		private var _startFrame:Number;
		
		private var _endFrame:Number;
		
		private var _sceneContainer:DisplayObjectContainer;
		
		private var _sceneMasterContainer:DisplayObjectContainer;
		
		private var _nextScene:AnimeScene;
		
		private var _prevScene:AnimeScene;
		
		private var _state:int;
		
		private var _zOrder:int;
		
		private var _bufferProgress:Number = 0;
		
		private var _isRemoteDataIniting:Boolean;
		
		private var _movieId:String;
		
		private var _id:String;
		
		private var _isPreview:Boolean;
		
		private var _endSceneCapture:BitmapData;
		
		private var _sizingAssetRect:Rectangle;
		
		private var _narration:AnimeSound;
		
		private var _mver:Number = 0;
		
		private var _extraData:Object;
		
		private var _handDrawnEffect:WhiteboardHand;
		
		private var _handDrawnEffectLayer:Sprite;
		
		private var _camera:ZoomEffectAsset;
		
		private var _baseColor:int = 16777215;
		
		private var _baseColorSprite:Sprite;
		
		private var _assetsHavingTransitions:Vector.<Asset>;
		
		private var _whiteboardMaskReloaded:Boolean;
		
		private var _guid:String;
		
		private var _xml:XML;
		
		private var _assetRegulator:ProcessRegulator;
		
		private var _dataStock:PlayerDataStock;
		
		private var _readyToPlay:Boolean;
		
		public function AnimeScene()
		{
			this._visibleAssets = new Vector.<Asset>();
			this._assetIndice = {};
			this._characters = new Vector.<Character>();
			this._characterIndice = {};
			this._props = new Vector.<Prop>();
			this._propIndice = {};
			this._bubbles = new Vector.<BubbleAsset>();
			this._bubbleIndice = {};
			this._backgrounds = new Vector.<Background>();
			this._backgroundIndice = {};
			this._segments = new Vector.<Segment>();
			this._segmentIndice = {};
			this._effects = new Vector.<EffectAsset>();
			this._effectIndice = {};
			this._effectTypeIndice = {};
			this._transitions = new Vector.<GoTransition>();
			this._transitionIndice = {};
			this._assetRegulator = new ProcessRegulator();
			super();
		}
		
		public static function compareSceneXmlZorder(param1:XML, param2:XML) : int
		{
			var _loc3_:Number = Number(param1.attribute(XML_ATTRIBUTE_INDEX));
			var _loc4_:Number = Number(param2.attribute(XML_ATTRIBUTE_INDEX));
			if(_loc3_ < _loc4_)
			{
				return -1;
			}
			if(_loc3_ > _loc4_)
			{
				return 1;
			}
			return 0;
		}
		
		public function get baseColor() : int
		{
			return this._baseColor;
		}
		
		public function set baseColor(param1:int) : void
		{
			if(param1 != this._baseColor)
			{
				this._baseColor = param1;
				if(this._baseColorSprite)
				{
					this._baseColorSprite.graphics.beginFill(this._baseColor);
					this._baseColorSprite.graphics.drawRect(AnimeConstants.SCREEN_X - PlayerConstant.BLEED_MARGIN,AnimeConstants.screenY - PlayerConstant.BLEED_MARGIN,AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2,AnimeConstants.screenHeight + PlayerConstant.BLEED_MARGIN * 2);
					this._baseColorSprite.cacheAsBitmap = true;
				}
			}
		}
		
		public function get guid() : String
		{
			return this._guid;
		}
		
		public function set narration(param1:AnimeSound) : void
		{
			this._narration = param1;
		}
		
		public function get sizingAssetRect() : Rectangle
		{
			return this._sizingAssetRect;
		}
		
		public function set sizingAssetRect(param1:Rectangle) : void
		{
			this._sizingAssetRect = param1;
		}
		
		public function get endSceneCapture() : BitmapData
		{
			return this._endSceneCapture;
		}
		
		public function set endSceneCapture(param1:BitmapData) : void
		{
			this._endSceneCapture = param1;
		}
		
		public function get movieId() : String
		{
			return this._movieId;
		}
		
		public function get movieInfo() : Object
		{
			return this._parentAnime.movieInfo;
		}
		
		public function get motionDuration() : Number
		{
			return this._motionDuration;
		}
		
		public function set motionDuration(param1:Number) : void
		{
			this._motionDuration = 0;
		}
		
		public function get totalFrame() : Number
		{
			return this._actionDuration;
		}
		
		public function get actionDuration() : Number
		{
			return this._actionDuration;
		}
		
		public function get duration#1() : Number
		{
			return this._duration;
		}
		
		public function get durationInSecond() : Number
		{
			return UtilUnitConvert.frameToSec(this._duration);
		}
		
		public function get id() : String
		{
			return this._id;
		}
		
		public function set id(param1:String) : void
		{
			this._id = param1;
		}
		
		public function get startFrame() : Number
		{
			return this._startFrame;
		}
		
		public function get endFrame() : Number
		{
			return this._endFrame;
		}
		
		public function getLastActionFrame() : Number
		{
			return this._startFrame + this._actionDuration;
		}
		
		public function get zOrder() : int
		{
			return this._zOrder;
		}
		
		public function set extraData(param1:Object) : void
		{
			this._extraData = param1;
		}
		
		public function get extraData() : Object
		{
			return this._extraData;
		}
		
		private function refreshSceneContainer(... rest) : void
		{
			UtilPlain.removeAllSon(this._sceneContainer);
			this.reArrangeVisibleAsset();
			var _loc2_:int = this._visibleAssets.length;
			var _loc3_:int = 0;
			while(_loc3_ < _loc2_)
			{
				this._sceneContainer.addChild(this._visibleAssets[_loc3_].assetView);
				_loc3_++;
			}
		}
		
		public function getSceneContainer() : DisplayObjectContainer
		{
			return this._sceneContainer;
		}
		
		public function getSceneMasterContainer() : DisplayObjectContainer
		{
			return this._sceneMasterContainer;
		}
		
		private function reArrangeVisibleAsset() : void
		{
			Asset.reArrangeZorder(this._visibleAssets);
			this.rebuildAssetIndice();
		}
		
		private function rebuildAssetIndice() : void
		{
			var _loc2_:Asset = null;
			this._assetIndice = {};
			var _loc1_:int = this._visibleAssets.length;
			var _loc3_:int = 0;
			while(_loc3_ < _loc1_)
			{
				_loc2_ = this._visibleAssets[_loc3_];
				this._assetIndice[_loc2_.id] = _loc3_;
				_loc3_++;
			}
		}
		
		private function getNumVisibleAsset() : int
		{
			return this._visibleAssets.length;
		}
		
		private function addVisibleAsset(param1:Asset) : void
		{
			this._assetIndice[param1.id] = this._visibleAssets.push(param1) - 1;
		}
		
		private function getVisibleAssetByIndex(param1:int) : Asset
		{
			return this._visibleAssets[param1];
		}
		
		private function getAssetById(param1:String) : Asset
		{
			if(this._assetIndice[param1] != null)
			{
				return this._visibleAssets[this._assetIndice[param1]];
			}
			return null;
		}
		
		private function addChar(param1:Character) : void
		{
			this._characterIndice[param1.id] = this._characters.push(param1) - 1;
			this.addVisibleAsset(param1);
		}
		
		public function getCharByIndex(param1:int) : Character
		{
			return this._characters[param1];
		}
		
		public function getCharByID(param1:String) : Character
		{
			if(this._characterIndice[param1] != null)
			{
				return this._characters[this._characterIndice[param1]];
			}
			return null;
		}
		
		public function getNumChar() : int
		{
			return this._characters.length;
		}
		
		private function isCharExist(param1:String) : Boolean
		{
			return this._characterIndice[param1];
		}
		
		private function addBubble(param1:BubbleAsset) : void
		{
			this._bubbleIndice[param1.id] = this._bubbles.push(param1) - 1;
			this.addVisibleAsset(param1);
		}
		
		private function getBubByIndex(param1:int) : BubbleAsset
		{
			return this._bubbles[param1];
		}
		
		private function getBubByID(param1:String) : BubbleAsset
		{
			if(this._bubbleIndice[param1] != null)
			{
				return this._bubbles[this._bubbleIndice[param1]];
			}
			return null;
		}
		
		public function getNumBub() : int
		{
			return this._bubbles.length;
		}
		
		private function isBubExist(param1:String) : Boolean
		{
			return this._bubbleIndice[param1];
		}
		
		public function getBgByIndex(param1:int) : Background
		{
			return this._backgrounds[param1];
		}
		
		public function getBgByID(param1:String) : Background
		{
			if(this._backgroundIndice[param1] != null)
			{
				return this._backgrounds[this._backgroundIndice[param1]];
			}
			return null;
		}
		
		private function addBg(param1:Background) : void
		{
			this._backgroundIndice[param1.id] = this._backgrounds.push(param1) - 1;
			this.addVisibleAsset(param1);
		}
		
		public function getNumBg() : int
		{
			return this._backgrounds.length;
		}
		
		public function addTransition(param1:GoTransition) : void
		{
			this._transitions.push(param1);
		}
		
		public function getTransitionNum() : Number
		{
			return this._transitions.length;
		}
		
		public function hasTransition() : Boolean
		{
			return this._transitions.length > 0;
		}
		
		public function get doTransitionSupportSeeking() : Boolean
		{
			if(this._transitions.length > 0)
			{
				return this._transitions[0].supportSeeking;
			}
			return false;
		}
		
		public function getTransitionFrameNum() : Number
		{
			if(this.hasTransition())
			{
				return this._transitions[0].dur;
			}
			return 0;
		}
		
		public function isTransitionBleed() : Boolean
		{
			if(this.hasTransition())
			{
				if(!(this._transitions[0] is AnimateTransition))
				{
					return true;
				}
			}
			return false;
		}
		
		public function getSegmentByIndex(param1:int) : Segment
		{
			return this._segments[param1];
		}
		
		public function getSegmentByID(param1:String) : Segment
		{
			if(this._segmentIndice[param1] != null)
			{
				return this._segments[this._segmentIndice[param1]];
			}
			return null;
		}
		
		private function addSegment(param1:Segment) : void
		{
			this._segmentIndice[param1.id] = this._segments.push(param1) - 1;
			this.addVisibleAsset(param1);
		}
		
		private function isSegmentExist(param1:String) : Boolean
		{
			return this._segmentIndice[param1];
		}
		
		public function getNumSegment() : int
		{
			return this._segments.length;
		}
		
		private function addProp(param1:Prop) : void
		{
			this._propIndice[param1.id] = this._props.push(param1) - 1;
			this.addVisibleAsset(param1);
		}
		
		public function getPropByIndex(param1:int) : Prop
		{
			return this._props[param1];
		}
		
		public function getPropById(param1:String) : Prop
		{
			if(this._propIndice[param1] != null)
			{
				return this._props[this._propIndice[param1]];
			}
			return null;
		}
		
		private function isPropExist(param1:String) : Boolean
		{
			return this._propIndice[param1];
		}
		
		public function getNumProp() : int
		{
			return this._props.length;
		}
		
		private function addEffect(param1:EffectAsset) : void
		{
			this._effectIndice[param1.id] = this._effects.push(param1) - 1;
			if(!(param1 is ProgramEffectAsset))
			{
				this.addVisibleAsset(param1);
			}
			var _loc2_:String = param1.getType();
			var _loc3_:Vector.<EffectAsset> = this._effectTypeIndice[_loc2_];
			if(!_loc3_)
			{
				_loc3_ = new Vector.<EffectAsset>();
				this._effectTypeIndice[_loc2_] = _loc3_;
			}
			_loc3_.push(param1);
		}
		
		public function getEffectById(param1:String) : EffectAsset
		{
			if(this._effectIndice[param1])
			{
				return this._effects[this._effectIndice[param1]];
			}
			return null;
		}
		
		public function getEffectByIndex(param1:int) : EffectAsset
		{
			return this._effects[param1];
		}
		
		private function getEffectsByType(param1:String) : Vector.<EffectAsset>
		{
			return this._effectTypeIndice[param1];
		}
		
		private function isEffectExist(param1:String) : Boolean
		{
			return this._effectIndice[param1];
		}
		
		public function getNumEffect() : int
		{
			return this._effects.length;
		}
		
		public function getBufferProgress() : Number
		{
			return this._bufferProgress;
		}
		
		public function getState() : int
		{
			return this._state;
		}
		
		public function setState(param1:int) : void
		{
			var _loc2_:int = 0;
			var _loc3_:int = 0;
			var _loc4_:GoTransition = null;
			this._state = param1;
			_loc2_ = this._characters.length;
			_loc3_ = 0;
			while(_loc3_ < _loc2_)
			{
				this._characters[_loc3_].propagateSceneState(this._state);
				_loc3_++;
			}
			_loc2_ = this._backgrounds.length;
			_loc3_ = 0;
			while(_loc3_ < _loc2_)
			{
				this._backgrounds[_loc3_].propagateSceneState(this._state);
				_loc3_++;
			}
			_loc2_ = this._bubbles.length;
			_loc3_ = 0;
			while(_loc3_ < _loc2_)
			{
				this._bubbles[_loc3_].propagateSceneState(this._state);
				_loc3_++;
			}
			_loc2_ = this._props.length;
			_loc3_ = 0;
			while(_loc3_ < _loc2_)
			{
				this._props[_loc3_].propagateSceneState(this._state);
				_loc3_++;
			}
			_loc2_ = this._effects.length;
			_loc3_ = 0;
			while(_loc3_ < _loc2_)
			{
				this._effects[_loc3_].propagateSceneState(this._state);
				_loc3_++;
			}
			_loc2_ = this._segments.length;
			_loc3_ = 0;
			while(_loc3_ < _loc2_)
			{
				this._segments[_loc3_].propagateSceneState(this._state);
				_loc3_++;
			}
			_loc2_ = this._transitions.length;
			_loc3_ = 0;
			while(_loc3_ < _loc2_)
			{
				_loc4_ = this._transitions[_loc3_];
				_loc4_.prevScene = this.prevScene;
				_loc4_.propagateSceneState(this._state);
				_loc3_++;
			}
		}
		
		public function init(param1:XML, param2:Anime, param3:UtilHashArray, param4:PlayerDataStock, param5:Number, param6:String, param7:Boolean) : void
		{
			var _loc8_:int = 0;
			var _loc9_:Background = null;
			var _loc10_:XML = null;
			var _loc11_:Segment = null;
			var _loc12_:XML = null;
			var _loc13_:Character = null;
			var _loc14_:XML = null;
			var _loc15_:BubbleAsset = null;
			var _loc16_:XML = null;
			var _loc17_:Prop = null;
			var _loc18_:XML = null;
			var _loc19_:Widget = null;
			var _loc20_:XML = null;
			var _loc21_:FlowFrame = null;
			var _loc22_:XML = null;
			var _loc23_:XML = null;
			var _loc24_:Sprite = null;
			var _loc25_:String = null;
			var _loc26_:EffectAsset = null;
			var _loc27_:Boolean = false;
			var _loc28_:ZoomEffectAsset = null;
			var _loc29_:EarthquakeEffectAsset = null;
			var _loc30_:HoveringEffectAsset = null;
			var _loc31_:BumpyrideEffectAsset = null;
			var _loc32_:UpsideDownEffectAsset = null;
			var _loc33_:Sprite = null;
			var _loc34_:GoTransition = null;
			var _loc35_:XML = null;
			var _loc36_:FireworkEffectAsset = null;
			var _loc37_:FireSpringEffectAsset = null;
			var _loc38_:AnimeEffectAsset = null;
			var _loc39_:GrayScaleEffectAsset = null;
			var _loc40_:DRAlertEffectAsset = null;
			var _loc41_:SepiaEffectAsset = null;
			var _loc42_:FadingEffectAsset = null;
			var _loc43_:Array = null;
			var _loc44_:String = null;
			var _loc45_:String = null;
			var _loc46_:Sprite = null;
			this._dataStock = param4;
			this._mver = param5;
			this._id = param1.attribute(XML_ATTRIBUTE_ID).toString();
			this._zOrder = param1.attribute(XML_ATTRIBUTE_INDEX);
			this._actionDuration = param1.attribute(XML_ATTRIBUTE_ADELAY);
			this.motionDuration = param1.attribute(XML_ATTRIBUTE_MDELAY);
			this._parentAnime = param2;
			this._baseColorSprite = new Sprite();
			this._sceneMasterContainer = new Sprite();
			this._sceneContainer = new Sprite();
			this._sceneMasterContainer.addChild(this._baseColorSprite);
			this._sceneMasterContainer.addChild(this.getSceneContainer());
			this._movieId = param6;
			this._isPreview = param7;
			if(param1.hasOwnProperty(XML_PROPERTY_COLOR))
			{
				this.baseColor = param1.@color;
			}
			else
			{
				this.baseColor = DEFAULT_BASE_COLOR;
			}
			if(param1.hasOwnProperty(XML_PROPERTY_GUID))
			{
				this._guid = param1.@guid;
			}
			for each(_loc10_ in param1.child(Background.XML_TAG))
			{
				_loc9_ = new Background();
				if(_loc9_.init(_loc10_,this,param4))
				{
					this.addBg(_loc9_);
				}
			}
			for each(_loc12_ in param1.child(Segment.XML_TAG))
			{
				_loc11_ = new Segment();
				if(_loc11_.init(_loc12_,this,param4))
				{
					this.addSegment(_loc11_);
				}
			}
			for each(_loc14_ in param1.child(Character.XML_TAG))
			{
				_loc13_ = new Character();
				if(_loc13_.init(_loc14_,this,param3,param4))
				{
					this.addChar(_loc13_);
				}
			}
			for each(_loc16_ in param1.child(BubbleAsset.XML_TAG))
			{
				_loc15_ = new BubbleAsset();
				if(_loc15_.init(_loc16_,this,param5,param7))
				{
					this.addBubble(_loc15_);
				}
			}
			for each(_loc18_ in param1.child(Prop.XML_TAG))
			{
				_loc17_ = new Prop();
				if(_loc17_.init(_loc18_,this,param4))
				{
					this.addProp(_loc17_);
				}
			}
			for each(_loc20_ in param1.child(Widget.XML_TAG))
			{
				_loc19_ = new Widget();
				if(_loc19_.init(_loc20_,this,param4))
				{
					this.addProp(_loc19_);
				}
			}
			for each(_loc22_ in param1.child(FlowFrame.XML_TAG))
			{
				_loc21_ = new FlowFrame();
				if(_loc21_.init(_loc22_,this,param4))
				{
					this.addProp(_loc21_);
				}
			}
			for each(_loc23_ in param1.child(EffectAsset.XML_TAG))
			{
				_loc25_ = EffectAsset.getEffectType(_loc23_);
				if(param5 > 2)
				{
					switch(_loc25_)
					{
						case EffectMgr.TYPE_ZOOM:
						case EffectMgr.TYPE_EARTHQUAKE:
						case EffectMgr.TYPE_HOVERING:
						case EffectMgr.TYPE_BUMPYRIDE:
						case EffectMgr.TYPE_UPSIDEDOWN:
							_loc24_ = new Sprite();
							_loc33_ = new Sprite();
							UtilPlain.switchParent(this.getSceneMasterContainer(),_loc24_);
							_loc33_.addChild(_loc24_);
							this.getSceneMasterContainer().addChild(_loc33_);
					}
					switch(_loc25_)
					{
						case EffectMgr.TYPE_ZOOM:
							_loc28_ = new ZoomEffectAsset();
							_loc26_ = _loc28_;
							_loc28_.init(_loc23_,this,_loc24_,param5);
							this.sizingAssetRect = _loc28_.targetRect;
							this._camera = _loc28_;
							break;
						case EffectMgr.TYPE_EARTHQUAKE:
							_loc29_ = new EarthquakeEffectAsset();
							_loc26_ = _loc29_;
							_loc29_.init(_loc23_,this,_loc24_);
							break;
						case EffectMgr.TYPE_HOVERING:
							_loc30_ = new HoveringEffectAsset();
							_loc26_ = _loc30_;
							_loc30_.init(_loc23_,this,_loc24_);
							break;
						case EffectMgr.TYPE_BUMPYRIDE:
							_loc31_ = new BumpyrideEffectAsset();
							_loc26_ = _loc31_;
							_loc31_.init(_loc23_,this,_loc24_);
							break;
						case EffectMgr.TYPE_UPSIDEDOWN:
							_loc32_ = new UpsideDownEffectAsset();
							_loc26_ = _loc32_;
							_loc32_.init(_loc23_,this,_loc24_);
					}
					switch(_loc25_)
					{
						case EffectMgr.TYPE_ZOOM:
						case EffectMgr.TYPE_EARTHQUAKE:
						case EffectMgr.TYPE_HOVERING:
						case EffectMgr.TYPE_BUMPYRIDE:
						case EffectMgr.TYPE_UPSIDEDOWN:
							this.addEffect(_loc26_);
							continue;
						default:
							continue;
					}
				}
				else
				{
					continue;
				}
			}
			for each(_loc23_ in param1.child(EffectAsset.XML_TAG))
			{
				_loc25_ = EffectAsset.getEffectType(_loc23_);
				_loc27_ = false;
				_loc24_ = new Sprite();
				switch(_loc25_)
				{
					case EffectMgr.TYPE_FIREWORK:
					case EffectMgr.TYPE_FIRESPRING:
					case EffectMgr.TYPE_ANIME:
						_loc33_ = new Sprite();
						UtilPlain.switchParent(this.getSceneMasterContainer(),_loc24_);
						_loc33_.addChild(_loc24_);
						this.getSceneMasterContainer().addChild(_loc33_);
				}
				if(_loc25_ == EffectMgr.TYPE_FIREWORK)
				{
					_loc36_ = new FireworkEffectAsset();
					_loc26_ = _loc36_;
					_loc36_.init(_loc23_,this,_loc24_);
					_loc27_ = true;
				}
				else if(_loc25_ == EffectMgr.TYPE_FIRESPRING)
				{
					_loc37_ = new FireSpringEffectAsset();
					_loc26_ = _loc37_;
					_loc37_.init(_loc23_,this,_loc24_);
					_loc27_ = true;
				}
				else if(_loc25_ == EffectMgr.TYPE_ANIME)
				{
					_loc38_ = new AnimeEffectAsset();
					_loc26_ = _loc38_;
					_loc27_ = _loc38_.init(_loc23_,this,param4,_loc24_);
				}
				if(_loc27_)
				{
					this.addEffect(_loc26_);
				}
			}
			for each(_loc23_ in param1.child(EffectAsset.XML_TAG))
			{
				_loc25_ = EffectAsset.getEffectType(_loc23_);
				if(param5 <= 2)
				{
					switch(_loc25_)
					{
						case EffectMgr.TYPE_ZOOM:
						case EffectMgr.TYPE_EARTHQUAKE:
						case EffectMgr.TYPE_HOVERING:
						case EffectMgr.TYPE_BUMPYRIDE:
						case EffectMgr.TYPE_UPSIDEDOWN:
							_loc24_ = new Sprite();
							_loc33_ = new Sprite();
							UtilPlain.switchParent(this.getSceneMasterContainer(),_loc24_);
							_loc33_.addChild(_loc24_);
							this.getSceneMasterContainer().addChild(_loc33_);
					}
					switch(_loc25_)
					{
						case EffectMgr.TYPE_ZOOM:
							_loc28_ = new ZoomEffectAsset();
							_loc26_ = _loc28_;
							_loc28_.init(_loc23_,this,_loc24_,param5);
							break;
						case EffectMgr.TYPE_EARTHQUAKE:
							_loc29_ = new EarthquakeEffectAsset();
							_loc26_ = _loc29_;
							_loc29_.init(_loc23_,this,_loc24_);
							break;
						case EffectMgr.TYPE_HOVERING:
							_loc30_ = new HoveringEffectAsset();
							_loc26_ = _loc30_;
							_loc30_.init(_loc23_,this,_loc24_);
							break;
						case EffectMgr.TYPE_BUMPYRIDE:
							_loc31_ = new BumpyrideEffectAsset();
							_loc26_ = _loc31_;
							_loc31_.init(_loc23_,this,_loc24_);
							break;
						case EffectMgr.TYPE_UPSIDEDOWN:
							_loc32_ = new UpsideDownEffectAsset();
							_loc26_ = _loc32_;
							_loc32_.init(_loc23_,this,_loc24_);
					}
					switch(_loc25_)
					{
						case EffectMgr.TYPE_ZOOM:
						case EffectMgr.TYPE_EARTHQUAKE:
						case EffectMgr.TYPE_HOVERING:
						case EffectMgr.TYPE_BUMPYRIDE:
						case EffectMgr.TYPE_UPSIDEDOWN:
							this.addEffect(_loc26_);
							continue;
						default:
							continue;
					}
				}
				else
				{
					continue;
				}
			}
			for each(_loc23_ in param1.child(EffectAsset.XML_TAG))
			{
				_loc25_ = EffectAsset.getEffectType(_loc23_);
				switch(_loc25_)
				{
					case EffectMgr.TYPE_GRAYSCALE:
					case EffectMgr.TYPE_DRALERT:
					case EffectMgr.TYPE_SEPIA:
					case EffectMgr.TYPE_FADING:
						_loc24_ = new Sprite();
						_loc33_ = new Sprite();
						UtilPlain.switchParent(this.getSceneMasterContainer(),_loc24_);
						_loc33_.addChild(_loc24_);
						this.getSceneMasterContainer().addChild(_loc33_);
				}
				switch(_loc25_)
				{
					case EffectMgr.TYPE_GRAYSCALE:
						_loc39_ = new GrayScaleEffectAsset();
						_loc26_ = _loc39_;
						_loc39_.init(_loc23_,this,_loc24_);
						break;
					case EffectMgr.TYPE_DRALERT:
						_loc40_ = new DRAlertEffectAsset();
						_loc26_ = _loc40_;
						_loc40_.init(_loc23_,this,_loc24_);
						break;
					case EffectMgr.TYPE_SEPIA:
						_loc41_ = new SepiaEffectAsset();
						_loc26_ = _loc41_;
						_loc41_.init(_loc23_,this,_loc24_);
						break;
					case EffectMgr.TYPE_FADING:
						_loc42_ = new FadingEffectAsset();
						_loc26_ = _loc42_;
						_loc42_.init(_loc23_,this,_loc24_);
				}
				switch(_loc25_)
				{
					case EffectMgr.TYPE_GRAYSCALE:
					case EffectMgr.TYPE_DRALERT:
					case EffectMgr.TYPE_SEPIA:
					case EffectMgr.TYPE_FADING:
						this.addEffect(_loc26_);
						continue;
					default:
						continue;
				}
			}
			for each(_loc35_ in param1.child(GoTransition.XML_TAG))
			{
				_loc43_ = String(_loc35_.fx.@type).split(".");
				_loc44_ = _loc43_[0];
				_loc45_ = _loc43_[1];
				switch(_loc44_)
				{
					case TRANSITION_PACKAGE_ANIFIRE:
						if(_loc45_ == TRANSITION_TYPE_PAN)
						{
							_loc34_ = new PanSceneTransition();
						}
						else
						{
							_loc34_ = new FadeOutInTransition();
						}
						break;
					case TRANSITION_PACKAGE_ANIMATED:
						_loc34_ = new AnimateTransition();
						break;
					case TRANSITION_PACKAGE_FL:
						if(_loc45_ == TRANSITION_TYPE_FLY)
						{
							_loc34_ = new PanSceneTransition(false);
						}
						else
						{
							_loc34_ = new FlashTransition();
						}
						break;
					case TRANSITION_PACKAGE_FLASHEFF:
						_loc34_ = new FlashEffTransition();
				}
				if(_loc33_)
				{
					_loc46_ = _loc33_;
				}
				else
				{
					_loc46_ = this.getSceneContainer() as Sprite;
				}
				if(_loc34_.init(_loc35_,this,_loc46_))
				{
					_loc46_.x = _loc34_.initPos.x;
					_loc46_.y = _loc34_.initPos.y;
					this.addTransition(_loc34_);
				}
			}
			this._xml = param1;
			this._duration = this._actionDuration + this._motionDuration;
			this.setState(AnimeScene.STATE_NULL);
		}
		
		private function initAssetTransitions(param1:XML) : void
		{
			var _loc2_:TreeNode = null;
			var _loc3_:NarrationNode = null;
			var _loc4_:XML = null;
			var _loc5_:IIterator = null;
			var _loc6_:AssetTransitionNode = null;
			var _loc7_:Asset = null;
			var _loc8_:Vector.<Asset> = null;
			if(this._narration)
			{
				_loc3_ = new NarrationNode();
				_loc3_.init(0,this._narration.getActualEndFrame() - this._narration.getStartFrame() + 1);
			}
			if(param1.hasOwnProperty(AssetTransitionConstants.TAG_NAME_TRANSITION_LIST))
			{
				_loc4_ = param1.child(AssetTransitionConstants.TAG_NAME_TRANSITION_LIST)[0];
				_loc2_ = AssetTransitionNode.getTreeFromXml(_loc4_,_loc3_);
				_loc5_ = _loc2_.iterator();
				_loc8_ = new Vector.<Asset>();
				while(_loc5_.hasNext)
				{
					_loc6_ = _loc5_.next as AssetTransitionNode;
					if(_loc6_)
					{
						_loc7_ = this.getAssetById(_loc6_.assetId);
						if(_loc7_)
						{
							_loc7_.addTransition(_loc6_);
							if(_loc8_.indexOf(_loc7_) == -1)
							{
								_loc8_.push(_loc7_);
							}
						}
					}
				}
				for each(_loc7_ in _loc8_)
				{
					_loc7_.initAllTransitions();
				}
				this._assetsHavingTransitions = _loc8_;
			}
		}
		
		public function initRemoteData(param1:PlayerDataStock) : void
		{
			var _loc2_:UtilLoadMgr = null;
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			var _loc5_:EffectAsset = null;
			if(this.getBufferProgress() >= 100)
			{
				this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
				return;
			}
			if(this._state != AnimeScene.STATE_BUFFER_INITIALIZING)
			{
				_loc2_ = new UtilLoadMgr();
				_loc2_.addEventListener(LoadMgrEvent.ALL_COMPLETE,this.onInitRemoteDataCompleted,false,0,true);
				_loc3_ = this._effects.length;
				_loc4_ = 0;
				while(_loc4_ < _loc3_)
				{
					_loc5_ = this._effects[_loc4_];
					_loc2_.addEventDispatcher(_loc5_.getEventDispatcher(),PlayerEvent.INIT_REMOTE_DATA_COMPLETE);
					_loc5_.initRemoteData(param1);
					_loc4_++;
				}
				this.setState(AnimeScene.STATE_BUFFER_INITIALIZING);
				_loc2_.commit();
			}
		}
		
		public function startProcess(param1:Boolean = false, param2:Number = 0) : void
		{
			this.buildScene(this._dataStock);
		}
		
		public function buildScene(param1:PlayerDataStock) : void
		{
			var _loc2_:int = 0;
			var _loc3_:int = 0;
			if(this._readyToPlay)
			{
				this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
				return;
			}
			if(this._state != AnimeScene.STATE_BUFFER_INITIALIZING)
			{
				this.setState(AnimeScene.STATE_BUFFER_INITIALIZING);
				this._assetRegulator.reset();
				this._assetRegulator.addEventListener(Event.COMPLETE,this.onInitCcRemoteDataCompleted);
				_loc2_ = 0;
				_loc3_ = this._backgrounds.length;
				_loc2_ = 0;
				while(_loc2_ < _loc3_)
				{
					this._assetRegulator.addProcess(this._backgrounds[_loc2_],PlayerEvent.INIT_REMOTE_DATA_COMPLETE);
					_loc2_++;
				}
				_loc3_ = this._segments.length;
				_loc2_ = 0;
				while(_loc2_ < _loc3_)
				{
					this._assetRegulator.addProcess(this._segments[_loc2_],PlayerEvent.INIT_REMOTE_DATA_COMPLETE);
					_loc2_++;
				}
				_loc3_ = this._characters.length;
				_loc2_ = 0;
				while(_loc2_ < _loc3_)
				{
					this._assetRegulator.addProcess(this._characters[_loc2_],PlayerEvent.INIT_REMOTE_DATA_COMPLETE);
					_loc2_++;
				}
				_loc3_ = this._props.length;
				_loc2_ = 0;
				while(_loc2_ < _loc3_)
				{
					this._assetRegulator.addProcess(this._props[_loc2_],PlayerEvent.INIT_REMOTE_DATA_COMPLETE);
					_loc2_++;
				}
				_loc3_ = this._bubbles.length;
				_loc2_ = 0;
				while(_loc2_ < _loc3_)
				{
					this._assetRegulator.addProcess(this._bubbles[_loc2_],PlayerEvent.INIT_REMOTE_DATA_COMPLETE);
					_loc2_++;
				}
				this._assetRegulator.startProcess(!SceneBufferManager.highSpeedMode);
			}
		}
		
		public function get readyToPlay() : Boolean
		{
			return this._readyToPlay;
		}
		
		private function onInitRemoteDataCompleted(param1:Event) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onInitRemoteDataCompleted);
			this._bufferProgress = 100;
			this.refreshSceneContainer();
			this.setState(AnimeScene.STATE_NULL);
			this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
		}
		
		private function onInitCcRemoteDataCompleted(param1:Event) : void
		{
			(param1.target as IEventDispatcher).removeEventListener(param1.type,this.onInitCcRemoteDataCompleted);
			this._readyToPlay = true;
			this._bufferProgress = 100;
			this.setState(AnimeScene.STATE_NULL);
			this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
		}
		
		public function advanceCharacterActionsToNextFrame() : Array
		{
			var resumeChars:Array = null;
			var char:Character = null;
			var length:int = 0;
			var i:int = 0;
			var charActionLoader:DisplayObjectContainer = null;
			try
			{
				resumeChars = [];
				length = this._characters.length;
				i = 0;
				while(i < length)
				{
					char = this._characters[i];
					charActionLoader = char.action.getLoader();
					if(UtilPlain.advanceFamilyToNextFrame(charActionLoader))
					{
						resumeChars.push(char);
					}
					i++;
				}
				return resumeChars;
			}
			catch(e:Error)
			{
			}
			return null;
		}
		
		public function resumeCharacterActions(param1:Array) : void
		{
			var char:Character = null;
			var chars:Array = param1;
			var length:int = chars.length;
			var i:int = 0;
			while(i < length)
			{
				char = chars[i];
				try
				{
					char.resume();
				}
				catch(e:Error)
				{
				}
				i++;
			}
		}
		
		public function prepareImage() : void
		{
			var i:int = 0;
			var length:int = 0;
			var prop:Prop = null;
			var bg:Background = null;
			var char:Character = null;
			if(!this.readyToPlay)
			{
				return;
			}
			try
			{
				AssetImageLibrary.instance.updateTimeStamp();
				CcImageLibrary.library.updateTimeStamp();
				length = this._props.length;
				i = 0;
				while(i < length)
				{
					prop = this._props[i];
					if(!prop.isFirstProp)
					{
						prop.prepareImage();
					}
					i++;
				}
				i = 0;
				while(i < length)
				{
					prop = this._props[i];
					if(prop.isFirstProp)
					{
						prop.prepareImage();
					}
					i++;
				}
				length = this._backgrounds.length;
				i = 0;
				while(i < length)
				{
					bg = this._backgrounds[i];
					if(!bg.isFirstBg)
					{
						bg.prepareImage();
					}
					i++;
				}
				i = 0;
				while(i < length)
				{
					bg = this._backgrounds[i];
					if(bg.isFirstBg)
					{
						bg.prepareImage();
					}
					i++;
				}
				length = this._characters.length;
				i = 0;
				while(i < length)
				{
					char = this._characters[i];
					if(char.charInPrevScene && !char.action.isFirstBehavior)
					{
						char.prepareImage();
					}
					i++;
				}
				i = 0;
				while(i < length)
				{
					char = this._characters[i];
					if(char.charInPrevScene && char.action.isFirstBehavior)
					{
						char.prepareImage();
					}
					i++;
				}
				i = 0;
				while(i < length)
				{
					char = this._characters[i];
					if(!char.charInPrevScene)
					{
						char.prepareImage();
					}
					i++;
				}
				length = this._effects.length;
				i = 0;
				while(i < length)
				{
					this._effects[i].prepareImage();
					i++;
				}
			}
			catch(e:Error)
			{
			}
			this._handDrawnEffect = this._parentAnime.handDrawnEffect;
			if(this._handDrawnEffect)
			{
				if(!this._handDrawnEffectLayer)
				{
					this._handDrawnEffectLayer = new Sprite();
					this.getSceneMasterContainer().addChild(this._handDrawnEffectLayer);
				}
				this._handDrawnEffect.visible = false;
				this._handDrawnEffectLayer.addChild(this._handDrawnEffect);
			}
		}
		
		public function get nextScene() : AnimeScene
		{
			return this._nextScene;
		}
		
		public function get prevScene() : AnimeScene
		{
			return this._prevScene;
		}
		
		public function initDependency(param1:AnimeScene, param2:AnimeScene, param3:Number, param4:DownloadManager, param5:UtilHashArray) : void
		{
			var _loc6_:int = 0;
			var _loc7_:int = 0;
			var _loc8_:ZoomEffectAsset = null;
			var _loc9_:ZoomEffectAsset = null;
			var _loc10_:ZoomEffectAsset = null;
			var _loc11_:Vector.<EffectAsset> = null;
			var _loc12_:int = 0;
			var _loc15_:Number = NaN;
			var _loc16_:Number = NaN;
			var _loc17_:Background = null;
			var _loc18_:Background = null;
			var _loc19_:Number = NaN;
			var _loc20_:EffectAsset = null;
			var _loc21_:String = null;
			var _loc22_:ZoomEffectAsset = null;
			var _loc23_:Number = NaN;
			var _loc24_:Number = NaN;
			var _loc25_:Number = NaN;
			var _loc26_:ZoomEffectAsset = null;
			var _loc27_:Vector.<EffectAsset> = null;
			var _loc28_:int = 0;
			this._prevScene = param2;
			this._nextScene = param1;
			this._startFrame = param3;
			this._endFrame = this._startFrame + this._duration;
			Character.connectCharacters(this._characters,!!param1?param1._characters:null);
			_loc7_ = this._characters.length;
			_loc6_ = 0;
			while(_loc6_ < _loc7_)
			{
				_loc15_ = !!param2?Number(param2.actionDuration):Number(0);
				_loc16_ = !!param2?Number(param2.motionDuration):Number(0);
				this._characters[_loc6_].initDependency(this._actionDuration,this._motionDuration,_loc15_,_loc16_,param5);
				_loc6_++;
			}
			BubbleAsset.connectBubblesBetweenScenes(this._bubbles,!!param1?param1._bubbles:null);
			_loc7_ = this._bubbles.length;
			_loc6_ = 0;
			while(_loc6_ < _loc7_)
			{
				this._bubbles[_loc6_].initDependency();
				_loc6_++;
			}
			Segment.connectSegment(this._segments,!!param1?param1._segments:null);
			_loc7_ = this._segments.length;
			_loc6_ = 0;
			while(_loc6_ < _loc7_)
			{
				this._segments[_loc6_].initDependency();
				_loc6_++;
			}
			_loc7_ = this._backgrounds.length;
			_loc6_ = 0;
			while(_loc6_ < _loc7_)
			{
				_loc17_ = this._backgrounds[_loc6_];
				_loc19_ = 0;
				if(this._prevScene != null)
				{
					_loc18_ = this._prevScene.getBgByID(_loc17_.id);
					_loc19_ = this._prevScene.duration#1;
				}
				else
				{
					_loc18_ = null;
				}
				_loc17_.initDependency(_loc18_,_loc19_);
				_loc6_++;
			}
			_loc7_ = this._transitions.length;
			_loc6_ = 0;
			while(_loc6_ < _loc7_)
			{
				this._transitions[_loc6_].initDependency(param2,this);
				_loc6_++;
			}
			Prop.connectPropsBetweenScenes(this._props,!!param1?param1._props:null);
			_loc7_ = this._props.length;
			_loc6_ = 0;
			while(_loc6_ < _loc7_)
			{
				this._props[_loc6_].initDependency(param4,param5);
				_loc6_++;
			}
			_loc11_ = this.getEffectsByType(EffectMgr.TYPE_ZOOM);
			if(_loc11_)
			{
				_loc7_ = _loc11_.length;
				_loc12_ = 0;
				while(_loc12_ < _loc7_)
				{
					_loc10_ = _loc11_[_loc12_] as ZoomEffectAsset;
					if(_loc10_.id.indexOf(ZOOM_DUMMY) == -1)
					{
						_loc8_ = _loc10_;
					}
					_loc12_++;
				}
			}
			if(param2 != null)
			{
				_loc11_ = param2.getEffectsByType(EffectMgr.TYPE_ZOOM);
				if(_loc11_)
				{
					_loc7_ = _loc11_.length;
					_loc12_ = 0;
					while(_loc12_ < _loc7_)
					{
						_loc10_ = _loc11_[_loc12_] as ZoomEffectAsset;
						if(_loc10_.id.indexOf(ZOOM_DUMMY) == -1)
						{
							_loc9_ = _loc10_;
						}
						_loc12_++;
					}
				}
			}
			var _loc13_:Sprite = new Sprite();
			var _loc14_:ZoomEffectAsset = new ZoomEffectAsset();
			if(ZoomEffectAsset.isDummyZoomNeededForCurrentZoom(_loc8_,this._mver))
			{
				_loc14_ = new ZoomEffectAsset();
				_loc14_.initDummyZoom(this,_loc8_.effectee,null,_loc8_,_loc14_.MODE_EXT);
				this.addEffect(_loc14_);
			}
			AnimeEffectAsset.connectEffectsBetweenScenes(this.getEffectsByType(EffectMgr.TYPE_ANIME),!!param1?param1.getEffectsByType(EffectMgr.TYPE_ANIME):null);
			_loc7_ = this._effects.length;
			_loc6_ = 0;
			while(_loc6_ < _loc7_)
			{
				_loc20_ = this._effects[_loc6_];
				_loc21_ = _loc20_.getType();
				if(_loc21_ == EffectMgr.TYPE_ZOOM)
				{
					_loc22_ = _loc20_ as ZoomEffectAsset;
					if(_loc22_.mode == _loc22_.MODE_NOR)
					{
						if(_loc22_.sttime == 0 && _loc22_.edtime == 0)
						{
							_loc23_ = this._startFrame;
							_loc25_ = AnimeConstants.DEFAULT_CAMERA_ZOOM_DURATION;
							if(this._duration < _loc25_)
							{
								_loc25_ = this._duration - 1;
							}
							_loc24_ = _loc23_ + _loc25_;
							if(_loc22_.pan)
							{
								_loc25_ = this._duration - 1;
								_loc24_ = _loc23_ + _loc25_;
							}
						}
						else
						{
							_loc23_ = _loc22_.sttime + this._startFrame - 1;
							_loc25_ = UtilUnitConvert.durationToFrame(_loc22_.stzoom);
							if(_loc23_ + _loc25_ > this._duration + this._startFrame)
							{
								_loc25_ = this._duration + this._startFrame - _loc23_ - 1;
							}
							if(_loc22_.pan && this._mver <= 3)
							{
								_loc25_ = _loc22_.edtime - _loc22_.sttime - 1;
							}
							_loc24_ = _loc23_ + _loc25_;
						}
					}
					else if(_loc22_.mode == _loc22_.MODE_EXT)
					{
						if(_loc22_.refZoom.sttime == 0 && _loc22_.refZoom.edtime == 0)
						{
							_loc25_ = AnimeConstants.DEFAULT_CAMERA_ZOOM_DURATION;
							_loc23_ = this._duration + this._startFrame - _loc25_;
						}
						else
						{
							_loc23_ = _loc22_.refZoom.edtime + this._startFrame;
							_loc25_ = UtilUnitConvert.durationToFrame(_loc22_.edzoom);
							if(_loc23_ + _loc25_ > this._duration + this._startFrame)
							{
								_loc25_ = this._duration + this._startFrame - _loc23_;
							}
						}
						_loc24_ = _loc23_ + _loc25_;
					}
					if(param2 != null)
					{
						_loc27_ = param2.getEffectsByType(_loc22_.getType());
						if(_loc27_)
						{
							_loc28_ = _loc27_.length;
							_loc12_ = 0;
							while(_loc12_ < _loc28_)
							{
								_loc10_ = _loc27_[_loc12_] as ZoomEffectAsset;
								if(_loc10_.id.indexOf(ZOOM_DUMMY) == -1)
								{
									_loc26_ = _loc10_;
								}
								_loc12_++;
							}
						}
					}
					_loc22_.initDependencyWithPrevZoom(_loc23_,_loc24_,_loc26_);
				}
				else
				{
					_loc20_.initDependency(this._startFrame,this._endFrame,this._actionDuration + this._motionDuration);
				}
				_loc6_++;
			}
			this.reArrangeVisibleAsset();
			this.initAssetTransitions(this._xml);
		}
		
		public function setVolume(param1:Number) : void
		{
			var _loc2_:int = this._props.length;
			var _loc3_:int = 0;
			while(_loc3_ < _loc2_)
			{
				this._props[_loc3_].setVolume(param1);
				_loc3_++;
			}
		}
		
		public function restoreEffects() : void
		{
			var _loc2_:EffectAsset = null;
			var _loc1_:int = this._effects.length;
			var _loc3_:int = 0;
			while(_loc3_ < _loc1_)
			{
				this._effects[_loc3_].restore();
				_loc3_++;
			}
		}
		
		public function play(param1:Number, param2:Boolean = false) : void
		{
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			var _loc8_:Character = null;
			var _loc9_:Prop = null;
			var _loc10_:BubbleAsset = null;
			if(!this.readyToPlay)
			{
				return;
			}
			var _loc5_:Number = this.movieToSceneFrame(param1);
			var _loc6_:uint = _loc5_;
			var _loc7_:Boolean = UtilUser.hasBetaFeatures() || !UtilUser.hasBusinessFeatures;
			if(param1 < this.getLastActionFrame() || this._nextScene == null)
			{
				if(this._state != AnimeScene.STATE_ACTION)
				{
					this.setState(AnimeScene.STATE_ACTION);
				}
				if(!param2)
				{
					_loc4_ = this._bubbles.length;
					_loc3_ = 0;
					while(_loc3_ < _loc4_)
					{
						_loc10_ = this._bubbles[_loc3_];
						_loc10_.playFrame(_loc5_,this._actionDuration);
						_loc10_.playTransition(_loc6_,this._actionDuration);
						if(_loc7_)
						{
							_loc10_.invalidateWithTarget(this._sceneContainer);
						}
						_loc3_++;
					}
				}
				_loc4_ = this._characters.length;
				_loc3_ = 0;
				while(_loc3_ < _loc4_)
				{
					_loc8_ = this._characters[_loc3_];
					_loc8_.playFrame(_loc5_,this._actionDuration);
					_loc8_.playTransition(_loc6_,this._actionDuration);
					if(_loc7_)
					{
						_loc8_.invalidateWithTarget(this._sceneContainer);
					}
					_loc3_++;
				}
				_loc4_ = this._props.length;
				_loc3_ = 0;
				while(_loc3_ < _loc4_)
				{
					_loc9_ = this._props[_loc3_];
					_loc9_.playFrame(_loc5_,this._actionDuration);
					_loc9_.playTransition(_loc6_,this._actionDuration);
					if(_loc7_)
					{
						_loc9_.invalidateWithTarget(this._sceneContainer);
					}
					_loc3_++;
				}
			}
			_loc4_ = this._effects.length;
			_loc3_ = 0;
			while(_loc3_ < _loc4_)
			{
				this._effects[_loc3_].play(param1);
				_loc3_++;
			}
			_loc4_ = this._transitions.length;
			_loc3_ = 0;
			while(_loc3_ < _loc4_)
			{
				this._transitions[_loc3_].play(this._startFrame,this._endFrame,param1);
				_loc3_++;
			}
		}
		
		public function movieToSceneFrame(param1:Number) : Number
		{
			return param1 - this._startFrame + 1;
		}
		
		public function goToAndPause(param1:Number) : void
		{
			var _loc2_:int = 0;
			var _loc3_:int = 0;
			var _loc5_:Number = NaN;
			var _loc4_:Number = this.movieToSceneFrame(param1);
			this.play(param1);
			if(this._state == AnimeScene.STATE_ACTION)
			{
				_loc5_ = 1;
			}
			if(this._state == AnimeScene.STATE_MOTION)
			{
				_loc5_ = this._actionDuration;
			}
			else
			{
				_loc5_ = 1;
			}
			_loc3_ = this._characters.length;
			_loc2_ = 0;
			while(_loc2_ < _loc3_)
			{
				this._characters[_loc2_].goToAndPause(_loc4_,param1,this._state,_loc5_);
				_loc2_++;
			}
			_loc3_ = this._backgrounds.length;
			_loc2_ = 0;
			while(_loc2_ < _loc3_)
			{
				this._backgrounds[_loc2_].goToAndPause(_loc4_,param1,this._state,_loc5_);
				_loc2_++;
			}
			_loc3_ = this._bubbles.length;
			_loc2_ = 0;
			while(_loc2_ < _loc3_)
			{
				this._bubbles[_loc2_].goToAndPause(_loc4_,param1,this._state,_loc5_);
				_loc2_++;
			}
			_loc3_ = this._props.length;
			_loc2_ = 0;
			while(_loc2_ < _loc3_)
			{
				this._props[_loc2_].goToAndPause(_loc4_,param1,this._state,_loc5_);
				_loc2_++;
			}
			_loc3_ = this._segments.length;
			_loc2_ = 0;
			while(_loc2_ < _loc3_)
			{
				this._segments[_loc2_].goToAndPause(_loc4_,param1,this._state,_loc5_);
				_loc2_++;
			}
			_loc3_ = this._effects.length;
			_loc2_ = 0;
			while(_loc2_ < _loc3_)
			{
				this._effects[_loc2_].goToAndPause(_loc4_,param1,this._state,_loc5_);
				_loc2_++;
			}
			_loc3_ = this._transitions.length;
			_loc2_ = 0;
			while(_loc2_ < _loc3_)
			{
				this._transitions[_loc2_].goToAndPause(_loc4_,param1,this._state,_loc5_);
				_loc2_++;
			}
		}
		
		public function goToAndPauseReset() : void
		{
			var _loc1_:int = 0;
			var _loc2_:int = 0;
			var _loc3_:int = this._startFrame;
			this.play(_loc3_,true);
			_loc2_ = this._characters.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._characters[_loc1_].goToAndPauseReset();
				_loc1_++;
			}
			_loc2_ = this._backgrounds.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._backgrounds[_loc1_].goToAndPauseReset();
				_loc1_++;
			}
			_loc2_ = this._bubbles.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._bubbles[_loc1_].goToAndPauseReset();
				_loc1_++;
			}
			_loc2_ = this._props.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._props[_loc1_].goToAndPauseReset();
				_loc1_++;
			}
			_loc2_ = this._effects.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._effects[_loc1_].goToAndPauseReset();
				_loc1_++;
			}
			_loc2_ = this._segments.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._segments[_loc1_].goToAndPauseReset();
				_loc1_++;
			}
			this.setState(STATE_NULL);
		}
		
		public function pause() : void
		{
			var _loc1_:int = 0;
			var _loc2_:int = 0;
			_loc2_ = this._characters.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._characters[_loc1_].pause();
				_loc1_++;
			}
			_loc2_ = this._backgrounds.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._backgrounds[_loc1_].pause();
				_loc1_++;
			}
			_loc2_ = this._segments.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._segments[_loc1_].pause();
				_loc1_++;
			}
			_loc2_ = this._bubbles.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._bubbles[_loc1_].pause();
				_loc1_++;
			}
			_loc2_ = this._props.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._props[_loc1_].pause();
				_loc1_++;
			}
			_loc2_ = this._effects.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._effects[_loc1_].pause();
				_loc1_++;
			}
			_loc2_ = this._transitions.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._transitions[_loc1_].pause();
				_loc1_++;
			}
			if(this._handDrawnEffect)
			{
				this._handDrawnEffect.pause();
			}
		}
		
		public function resume() : void
		{
			var _loc1_:int = 0;
			var _loc2_:int = 0;
			_loc2_ = this._characters.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._characters[_loc1_].resume();
				_loc1_++;
			}
			_loc2_ = this._backgrounds.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._backgrounds[_loc1_].resume();
				_loc1_++;
			}
			_loc2_ = this._segments.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._segments[_loc1_].resume();
				_loc1_++;
			}
			_loc2_ = this._bubbles.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._bubbles[_loc1_].resume();
				_loc1_++;
			}
			_loc2_ = this._props.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._props[_loc1_].resume();
				_loc1_++;
			}
			_loc2_ = this._effects.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._effects[_loc1_].resume();
				_loc1_++;
			}
			_loc2_ = this._transitions.length;
			_loc1_ = 0;
			while(_loc1_ < _loc2_)
			{
				this._transitions[_loc1_].resume();
				_loc1_++;
			}
			if(this._handDrawnEffect)
			{
				this._handDrawnEffect.resume();
			}
		}
		
		public function startPlay() : void
		{
			this.setState(AnimeScene.STATE_NULL);
			PlayerConstant.goToAndStopFamilyAt1(this.getSceneContainer());
			PlayerConstant.playFamily(this.getSceneContainer());
		}
		
		public function destroy(param1:Boolean = false) : void
		{
			var _loc2_:int = 0;
			var _loc3_:int = 0;
			this.setState(AnimeScene.STATE_NULL);
			_loc3_ = this._characters.length;
			_loc2_ = 0;
			while(_loc2_ < _loc3_)
			{
				this._characters[_loc2_].destroy(param1);
				_loc2_++;
			}
			_loc3_ = this._backgrounds.length;
			_loc2_ = 0;
			while(_loc2_ < _loc3_)
			{
				this._backgrounds[_loc2_].destroy(param1);
				_loc2_++;
			}
			_loc3_ = this._bubbles.length;
			_loc2_ = 0;
			while(_loc2_ < _loc3_)
			{
				this._bubbles[_loc2_].destroy(param1);
				_loc2_++;
			}
			_loc3_ = this._props.length;
			_loc2_ = 0;
			while(_loc2_ < _loc3_)
			{
				this._props[_loc2_].destroy(param1);
				_loc2_++;
			}
			_loc3_ = this._segments.length;
			_loc2_ = 0;
			while(_loc2_ < _loc3_)
			{
				this._segments[_loc2_].destroy(param1);
				_loc2_++;
			}
			_loc3_ = this._effects.length;
			_loc2_ = 0;
			while(_loc2_ < _loc3_)
			{
				this._effects[_loc2_].destroy();
				_loc2_++;
			}
			_loc3_ = this._transitions.length;
			_loc2_ = 0;
			while(_loc2_ < _loc3_)
			{
				this._transitions[_loc2_].destroy();
				_loc2_++;
			}
		}
		
		public function initHandDrawnEffect() : void
		{
			this._parentAnime.initHandDrawnEffect();
		}
		
		public function get handDrawnEffect() : WhiteboardHand
		{
			return this._parentAnime.handDrawnEffect;
		}
		
		public function moveHand(param1:Number, param2:Number) : void
		{
			var _loc3_:Point = null;
			if(this._handDrawnEffect)
			{
				_loc3_ = new Point(param1,param2);
				if(this._camera && this._camera.effectee)
				{
					_loc3_ = UtilMath.scalePoint(_loc3_,this._camera.effectee.scaleX,this._camera.effectee.scaleY);
					_loc3_.offset(this._camera.effectee.x,this._camera.effectee.y);
				}
				this._handDrawnEffect.x = _loc3_.x;
				this._handDrawnEffect.y = _loc3_.y;
				if(!this._handDrawnEffect.visible)
				{
					this._handDrawnEffect.visible = true;
				}
			}
		}
		
		public function reloadWhiteboardMask() : void
		{
			var _loc1_:BubbleAsset = null;
			var _loc2_:int = 0;
			var _loc3_:int = 0;
			if(this._whiteboardMaskReloaded)
			{
				return;
			}
			this._whiteboardMaskReloaded = true;
			if(this._assetsHavingTransitions)
			{
				_loc2_ = this._assetsHavingTransitions.length;
				_loc3_ = 0;
				while(_loc3_ < _loc2_)
				{
					_loc1_ = this._assetsHavingTransitions[_loc3_] as BubbleAsset;
					if(_loc1_)
					{
						_loc1_.reloadWhiteboardMask();
					}
					_loc3_++;
				}
			}
		}
	}
}
