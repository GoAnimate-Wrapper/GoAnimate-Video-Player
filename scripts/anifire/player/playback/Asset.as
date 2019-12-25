package anifire.player.playback
{
	import anifire.assets.transition.AssetTransitionNode;
	import anifire.color.SelectedColor;
	import anifire.component.ProcessRegulator;
	import anifire.constant.AnimeConstants;
	import anifire.player.assetTransitions.models.AssetTransition;
	import anifire.player.assetTransitions.models.AssetTransitionCollection;
	import anifire.player.assetTransitions.models.AssetTransitionFactory;
	import anifire.player.events.PlayerEvent;
	import anifire.player.interfaces.IPlayback;
	import anifire.player.interfaces.IPlayerAssetView;
	import anifire.util.UtilColor;
	import anifire.util.UtilHashArray;
	import anifire.util.UtilHashSelectedColor;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	
	public class Asset implements IEventDispatcher
	{
		
		protected static var __screenRect:Rectangle = AnimeConstants.screenRect;
		 
		
		protected var _id:String;
		
		protected var _parentScene:AnimeScene;
		
		private var _data:ByteArray;
		
		protected var _bundle:DisplayObjectContainer;
		
		protected var _x:Number = 47;
		
		protected var _xs:Array;
		
		protected var _y:Number = 24;
		
		protected var _ys:Array;
		
		protected var _state:int;
		
		protected var _sttime:Number;
		
		protected var _edtime:Number;
		
		protected var _stzoom:Number;
		
		protected var _edzoom:Number;
		
		private var _zOrder:int;
		
		private var _eventDispatcher:EventDispatcher;
		
		private var _sound:Sound;
		
		private var _soundChannel:SoundChannel;
		
		private var _customColor:UtilHashSelectedColor;
		
		protected var _dataStock:PlayerDataStock;
		
		private var _raceCode:int = 0;
		
		private var _assetView:IPlayerAssetView;
		
		protected var _transitions:AssetTransitionCollection;
		
		private var _themeId:String;
		
		public var isPlaying:Boolean = false;
		
		private var _currSoundPos:Number = 0;
		
		public function Asset()
		{
			this._xs = new Array();
			this._ys = new Array();
			this._eventDispatcher = new EventDispatcher();
			super();
		}
		
		public static function reArrangeZorder(param1:Vector.<Asset>) : void
		{
			var assets:Vector.<Asset> = param1;
			var compareZorder:Function = function(param1:Asset, param2:Asset):int
			{
				if(param1.getZorder() < param2.getZorder())
				{
					return -1;
				}
				if(param1.getZorder() > param2.getZorder())
				{
					return 1;
				}
				return 0;
			};
			assets.sort(compareZorder);
			var length:int = assets.length;
			var i:int = 0;
			while(i < length)
			{
				assets[i].setZorder(i);
				i++;
			}
		}
		
		public function get assetView() : DisplayObject
		{
			return this._assetView as DisplayObject;
		}
		
		public function get raceCode() : int
		{
			return this._raceCode;
		}
		
		public function set raceCode(param1:int) : void
		{
			this._raceCode = param1;
		}
		
		public function addCustomColor(param1:String, param2:SelectedColor) : void
		{
			this._customColor.push(param1,param2);
		}
		
		public function get customColor() : UtilHashSelectedColor
		{
			return this._customColor;
		}
		
		public function set customColor(param1:UtilHashSelectedColor) : void
		{
			this._customColor = param1;
		}
		
		public function set stzoom(param1:Number) : void
		{
			this._stzoom = param1;
		}
		
		public function get stzoom() : Number
		{
			return this._stzoom;
		}
		
		public function set edzoom(param1:Number) : void
		{
			this._edzoom = param1;
		}
		
		public function get edzoom() : Number
		{
			return this._edzoom;
		}
		
		public function set sttime(param1:Number) : void
		{
			this._sttime = param1;
		}
		
		public function get sttime() : Number
		{
			return this._sttime;
		}
		
		public function set edtime(param1:Number) : void
		{
			this._edtime = param1;
		}
		
		public function get edtime() : Number
		{
			return this._edtime;
		}
		
		public function set sound(param1:Sound) : void
		{
			this._sound = param1;
		}
		
		public function get sound() : Sound
		{
			return this._sound;
		}
		
		public function get soundChannel() : SoundChannel
		{
			return this._soundChannel;
		}
		
		public function set soundChannel(param1:SoundChannel) : void
		{
			this._soundChannel = param1;
		}
		
		public function playMusic(param1:Number = 0, param2:int = 0, param3:SoundTransform = null) : void
		{
			var _loc4_:String = null;
			if(this.isPlaying == false)
			{
				if(this.sound != null)
				{
					if(param1 == this.sound.length || param1 < 0)
					{
						param1 = 0;
					}
					if(this is Character)
					{
						if((this as Character).state == 1)
						{
							_loc4_ = "action";
						}
						else if((this as Character).state == 2)
						{
							_loc4_ = "motion";
						}
					}
					this.isPlaying = true;
					this.soundChannel = this.sound.play(param1,param2,param3);
					if(!this.soundChannel.hasEventListener(Event.SOUND_COMPLETE))
					{
						this.soundChannel.addEventListener(Event.SOUND_COMPLETE,this.repeatMusic);
					}
				}
			}
		}
		
		private function repeatMusic(param1:Event) : void
		{
			if(this.soundChannel.hasEventListener(Event.SOUND_COMPLETE))
			{
				this.isPlaying = false;
				this.soundChannel.removeEventListener(Event.SOUND_COMPLETE,this.repeatMusic);
				this.playMusic(0,0,this.soundChannel.soundTransform);
			}
		}
		
		public function set currSoundPos(param1:Number) : void
		{
			this._currSoundPos = param1;
		}
		
		public function get currSoundPos() : Number
		{
			return this._currSoundPos;
		}
		
		public function stopMusic(param1:Boolean = false) : void
		{
			var _loc2_:String = null;
			if(this.soundChannel != null)
			{
				if(this.soundChannel.hasEventListener(Event.SOUND_COMPLETE))
				{
					this.soundChannel.removeEventListener(Event.SOUND_COMPLETE,this.repeatMusic);
				}
				this.soundChannel.stop();
				if(this is Character)
				{
					if((this as Character).state == 1)
					{
						_loc2_ = "action";
					}
					else if((this as Character).state == 2)
					{
						_loc2_ = "motion";
					}
				}
				this.isPlaying = false;
			}
			if(param1)
			{
				this.currSoundPos = 0;
				this.sound = null;
				this.soundChannel = null;
			}
		}
		
		public function getEventDispatcher() : EventDispatcher
		{
			return this._eventDispatcher;
		}
		
		public function get id() : String
		{
			return this._id;
		}
		
		public function set id(param1:String) : void
		{
			this._id = param1;
		}
		
		public function get parentScene() : AnimeScene
		{
			return this._parentScene;
		}
		
		public function set parentScene(param1:AnimeScene) : void
		{
			this._parentScene = param1;
		}
		
		public function get data() : ByteArray
		{
			return this._data;
		}
		
		public function set data(param1:ByteArray) : void
		{
			this._data = param1;
		}
		
		public function getBundle() : DisplayObjectContainer
		{
			return this._bundle;
		}
		
		protected function setBundle(param1:DisplayObjectContainer) : void
		{
			this._bundle = param1;
		}
		
		protected function setState(param1:int) : void
		{
			var _loc2_:int = 0;
			var _loc3_:UtilHashArray = null;
			var _loc4_:SelectedColor = null;
			this._state = param1;
			if(this.customColor != null && param1 != Character.STATE_NULL && param1 != Background.STATE_NULL)
			{
				_loc3_ = new UtilHashArray();
				_loc2_ = 0;
				while(_loc2_ < this.customColor.length)
				{
					_loc4_ = SelectedColor(this.customColor.getValueByIndex(_loc2_));
					UtilColor.setAssetPartColor(this._bundle,_loc4_.areaName,_loc4_.dstColor);
					_loc2_++;
				}
			}
		}
		
		public function get state() : int
		{
			return this._state;
		}
		
		public function getZorder() : int
		{
			return this._zOrder;
		}
		
		protected function setZorder(param1:int) : void
		{
			this._zOrder = param1;
		}
		
		public function addTransition(param1:AssetTransitionNode) : void
		{
			var _loc2_:AssetTransition = null;
			if(param1)
			{
				if(!this._transitions)
				{
					this._transitions = new AssetTransitionCollection();
				}
				_loc2_ = AssetTransitionFactory.createTransition(param1);
				this._transitions.push(_loc2_);
			}
		}
		
		public function initAllTransitions() : void
		{
			if(this._transitions && this._transitions.length > 0)
			{
				this._assetView = AssetViewFactory.createAssetView(this._transitions);
				this._assetView.asset = this;
				this._assetView.bundle = this._bundle;
				this._transitions.initDependency(this.parentScene.totalFrame);
			}
		}
		
		public function initAllTransitionsRemoteData() : void
		{
			var _loc1_:ProcessRegulator = null;
			var _loc2_:uint = 0;
			if(this._transitions && this._transitions.length > 0)
			{
				_loc1_ = new ProcessRegulator();
				_loc2_ = 0;
				while(_loc2_ < this._transitions.length)
				{
					_loc1_.addProcess(this._transitions.getTransitionAt(_loc2_).view,Event.COMPLETE);
					_loc2_++;
				}
				_loc1_.addEventListener(Event.COMPLETE,this.onAllTransitionRemoteDataReady);
				_loc1_.startProcess();
			}
			else
			{
				this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
			}
		}
		
		private function onAllTransitionRemoteDataReady(param1:Event) : void
		{
			IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,this.onAllTransitionRemoteDataReady);
			this.dispatchEvent(new PlayerEvent(PlayerEvent.INIT_REMOTE_DATA_COMPLETE));
		}
		
		public function playTransition(param1:uint, param2:uint) : void
		{
			if(this._transitions)
			{
				this._transitions.currentTransition = this._transitions.getDominantTransitionAtFrame(param1);
			}
			if(this.assetView is IPlayback)
			{
				IPlayback(this.assetView).playFrame(param1,param2);
			}
		}
		
		protected function initAsset(param1:String, param2:int, param3:AnimeScene) : void
		{
			this._id = param1;
			this._zOrder = param2;
			this._parentScene = param3;
			this._bundle = new Sprite();
			this._assetView = new AssetView();
			this._assetView.asset = this;
			this._assetView.bundle = this._bundle;
		}
		
		protected function initAssetDependency() : void
		{
			this._bundle.x = this._xs[0];
			this._bundle.y = this._ys[0];
		}
		
		public function propagateSceneState(param1:int) : void
		{
		}
		
		public function goToAndPause(param1:Number, param2:Number, param3:int, param4:Number) : void
		{
			PlayerConstant.goToAndStopFamily(this._bundle,param1);
		}
		
		public function goToAndPauseBundle(param1:uint) : void
		{
			PlayerConstant.goToAndStopFamily(this._bundle,param1);
		}
		
		public function goToAndPauseReset() : void
		{
			PlayerConstant.goToAndStopFamilyAt1(this._bundle);
		}
		
		public function pause() : void
		{
			if(this.assetView is IPlayback)
			{
				IPlayback(this.assetView).pause();
			}
			else
			{
				this.pauseBundle();
			}
		}
		
		public function pauseBundle() : void
		{
			PlayerConstant.stopFamily(this._bundle);
		}
		
		public function resume() : void
		{
			if(this.assetView is IPlayback)
			{
				IPlayback(this.assetView).resume();
			}
			else
			{
				this.resumeBundle();
			}
		}
		
		public function resumeBundle() : void
		{
			PlayerConstant.playFamily(this._bundle);
		}
		
		public function destroy(param1:Boolean = false) : void
		{
			this.pause();
			if(param1)
			{
				this.setBundle(null);
			}
			this.resetTransition();
		}
		
		protected function resetTransition() : void
		{
			if(this._transitions)
			{
				this._transitions.currentTransition = null;
			}
		}
		
		public function setVolume(param1:Number) : void
		{
		}
		
		public function get x() : Number
		{
			return this._xs[0];
		}
		
		public function get y() : Number
		{
			return this._ys[0];
		}
		
		public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
		{
			this._eventDispatcher.addEventListener(param1,param2,param3,param4,param5);
		}
		
		public function dispatchEvent(param1:Event) : Boolean
		{
			return this._eventDispatcher.dispatchEvent(param1);
		}
		
		public function hasEventListener(param1:String) : Boolean
		{
			return this._eventDispatcher.hasEventListener(param1);
		}
		
		public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
		{
			this._eventDispatcher.removeEventListener(param1,param2,param3);
		}
		
		public function willTrigger(param1:String) : Boolean
		{
			return this._eventDispatcher.willTrigger(param1);
		}
		
		public function invalidateWithTarget(param1:DisplayObject) : void
		{
			var _loc2_:Rectangle = null;
			if(this._bundle)
			{
				_loc2_ = this._bundle.getBounds(param1);
				this._bundle.visible = __screenRect.intersects(_loc2_);
			}
		}
		
		public function get themeId() : String
		{
			return this._themeId;
		}
		
		public function set themeId(param1:String) : void
		{
			this._themeId = param1;
		}
	}
}
