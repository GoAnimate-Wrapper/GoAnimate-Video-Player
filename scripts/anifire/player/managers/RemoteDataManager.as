package anifire.player.managers
{
	import anifire.event.LoadMgrEvent;
	import anifire.player.events.PlayerEvent;
	import anifire.player.playback.AnimeScene;
	import anifire.player.playback.Background;
	import anifire.player.playback.BubbleAsset;
	import anifire.player.playback.Character;
	import anifire.player.playback.EmbedSound;
	import anifire.player.playback.PlayerDataStock;
	import anifire.player.playback.Prop;
	import anifire.player.playback.Segment;
	import anifire.player.sceneEffects.EffectAsset;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.setTimeout;
	
	public class RemoteDataManager extends EventDispatcher
	{
		
		private static var _instance:RemoteDataManager;
		 
		
		private var _dataStock:PlayerDataStock;
		
		private var _assets:Array;
		
		private var _count:Number;
		
		private var _interval:Number = 0;
		
		private var _totalFrame:Number = 0;
		
		private var _loadedFrame:Number = 0;
		
		public function RemoteDataManager(param1:IEventDispatcher = null)
		{
			super(param1);
			this._assets = new Array();
		}
		
		public static function getInstance() : RemoteDataManager
		{
			if(!_instance)
			{
				_instance = new RemoteDataManager();
			}
			return _instance;
		}
		
		public function set interval(param1:Number) : void
		{
			this._interval = param1;
		}
		
		public function init(param1:PlayerDataStock, param2:Number = 0) : void
		{
			this._count = 0;
			this._dataStock = param1;
			this._assets = new Array();
			this._interval = param2;
			this._totalFrame = 0;
			this._loadedFrame = 0;
		}
		
		public function get progress() : Number
		{
			if(this._assets.length > 0)
			{
				return Math.round(100 * this._count / this._assets.length);
			}
			return 0;
		}
		
		public function addTask(param1:Object) : void
		{
			this._assets.push(param1);
			if(param1 is AnimeScene)
			{
				this._totalFrame = this._totalFrame + AnimeScene(param1).duration#1;
			}
		}
		
		public function commit() : void
		{
			this._count = 0;
			if(this._assets.length > 0)
			{
				this.initNextAsset();
			}
			else
			{
				this.onComplete();
			}
		}
		
		private function initNextAsset() : void
		{
			var _loc1_:Object = this._assets[this._count];
			if(_loc1_ is AnimeScene || _loc1_ is EmbedSound)
			{
				_loc1_.addEventListener(PlayerEvent.INIT_REMOTE_DATA_COMPLETE,this.onInitDone);
			}
			else
			{
				_loc1_.getEventDispatcher().addEventListener(PlayerEvent.INIT_REMOTE_DATA_COMPLETE,this.onInitDone);
			}
			if(_loc1_ is Character)
			{
				Character(_loc1_).initRemoteData(this._dataStock);
			}
			else if(_loc1_ is Prop)
			{
				Prop(_loc1_).initRemoteData(this._dataStock);
			}
			else if(_loc1_ is Background)
			{
				Background(_loc1_).initRemoteData(this._dataStock);
			}
			else if(_loc1_ is BubbleAsset)
			{
				BubbleAsset(_loc1_).initRemoteData();
			}
			else if(_loc1_ is EffectAsset)
			{
				EffectAsset(_loc1_).initRemoteData(this._dataStock);
			}
			else if(_loc1_ is Segment)
			{
				Segment(_loc1_).initRemoteData(this._dataStock);
			}
			else if(_loc1_ is AnimeScene)
			{
				AnimeScene(_loc1_).initRemoteData(this._dataStock);
			}
			else if(_loc1_ is EmbedSound)
			{
				EmbedSound(_loc1_).initRemoteData(this._dataStock);
			}
		}
		
		private function onInitDone(param1:Event) : void
		{
			IEventDispatcher(param1.target).removeEventListener(param1.type,this.onInitDone);
			this._count++;
			var _loc2_:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS,true);
			_loc2_.bytesLoaded = this._count;
			_loc2_.bytesTotal = this._assets.length;
			this.dispatchEvent(_loc2_);
			if(this._count < this._assets.length)
			{
				if(this._interval > 0)
				{
					setTimeout(this.initNextAsset,this._interval);
				}
				else
				{
					this.initNextAsset();
				}
			}
			else
			{
				this.onComplete();
			}
		}
		
		private function onComplete() : void
		{
			this.dispatchEvent(new LoadMgrEvent(LoadMgrEvent.ALL_COMPLETE));
		}
	}
}

class SingletonEnforcer
{
	 
	
	function SingletonEnforcer()
	{
		super();
	}
}
