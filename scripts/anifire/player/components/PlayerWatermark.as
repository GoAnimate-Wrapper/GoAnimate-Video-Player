package anifire.player.components
{
	import anifire.player.events.PlayerEvent;
	import flash.events.MouseEvent;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	import mx.binding.Binding;
	import mx.binding.BindingManager;
	import mx.binding.IBindingClient;
	import mx.binding.IWatcherSetupUtil2;
	import mx.controls.SWFLoader;
	import mx.core.DeferredInstanceFromFunction;
	import mx.core.IFlexModuleFactory;
	import mx.core.IStateClient2;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.states.AddItems;
	import mx.states.State;
	import spark.components.Group;
	
	use namespace mx_internal;
	
	public class PlayerWatermark extends Group implements IBindingClient, IStateClient2
	{
		
		public static const WATERMARK_ID_DEFAULT:String = "defaultWatermark";
		
		public static const WATERMARK_ID_TWO_LINES:String = "twoLinesWatermark";
		
		public static const WATERMARK_ID_FULL_SCREEN:String = "fullScreenWatermark";
		
		public static const WATERMARK_ID_FREE_TRIAL:String = "freeTrialWatermark";
		
		public static const WATERMARK_ID_G4S:String = "g4sWatermark";
		
		public static const WATERMARK_ID_CUSTOM:String = "customWatermark";
		
		private static var _watcherSetupUtil:IWatcherSetupUtil2;
		 
		
		public var _PlayerWatermark_SWFLoader4:SWFLoader;
		
		public var _PlayerWatermark_SWFLoader5:SWFLoader;
		
		private var _1732621325customWatermark:SWFLoader;
		
		private var _1597778723defaultWatermark:SWFLoader;
		
		private var _727922999fullScreenWatermark:Group;
		
		private var _92942512schoolWatermark:SWFLoader;
		
		private var _524437526twoRowWatermark:SWFLoader;
		
		private var __moduleFactoryInitialized:Boolean = false;
		
		private var _841372003_clickable:Boolean;
		
		private var _embed_mxml__styles_images_player_stage_watermark_fullScreen_swf_140049762:Class;
		
		private var _embed_mxml__styles_images_player_stage_watermark_2lines_swf_1703712638:Class;
		
		private var _embed_mxml__styles_images_player_stage_watermark_g4s_swf_1974057250:Class;
		
		private var _embed_mxml__styles_images_player_stage_watermark_free_trial_swf_207218482:Class;
		
		private var _embed_mxml__styles_images_player_stage_watermark_logo_swf_2102363582:Class;
		
		mx_internal var _bindings:Array;
		
		mx_internal var _watchers:Array;
		
		mx_internal var _bindingsByDestination:Object;
		
		mx_internal var _bindingsBeginWithWord:Object;
		
		public function PlayerWatermark()
		{
			var bindings:Array = null;
			var target:Object = null;
			var watcherSetupUtilClass:Object = null;
			this._embed_mxml__styles_images_player_stage_watermark_fullScreen_swf_140049762 = PlayerWatermark__embed_mxml__styles_images_player_stage_watermark_fullScreen_swf_140049762;
			this._embed_mxml__styles_images_player_stage_watermark_2lines_swf_1703712638 = PlayerWatermark__embed_mxml__styles_images_player_stage_watermark_2lines_swf_1703712638;
			this._embed_mxml__styles_images_player_stage_watermark_g4s_swf_1974057250 = PlayerWatermark__embed_mxml__styles_images_player_stage_watermark_g4s_swf_1974057250;
			this._embed_mxml__styles_images_player_stage_watermark_free_trial_swf_207218482 = PlayerWatermark__embed_mxml__styles_images_player_stage_watermark_free_trial_swf_207218482;
			this._embed_mxml__styles_images_player_stage_watermark_logo_swf_2102363582 = PlayerWatermark__embed_mxml__styles_images_player_stage_watermark_logo_swf_2102363582;
			this._bindings = [];
			this._watchers = [];
			this._bindingsByDestination = {};
			this._bindingsBeginWithWord = {};
			super();
			mx_internal::_document = this;
			bindings = this._PlayerWatermark_bindingsSetup();
			var watchers:Array = [];
			target = this;
			if(_watcherSetupUtil == null)
			{
				watcherSetupUtilClass = getDefinitionByName("_anifire_player_components_PlayerWatermarkWatcherSetupUtil");
				watcherSetupUtilClass["init"](null);
			}
			_watcherSetupUtil.setup(this,function(param1:String):*
			{
				return target[param1];
			},function(param1:String):*
			{
				return PlayerWatermark[param1];
			},bindings,watchers);
			mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
			mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
			this.width = 550;
			this.percentHeight = 100;
			this.mxmlContent = [this._PlayerWatermark_Group2_i()];
			this.currentState = "normal";
			this.addEventListener("creationComplete",this.___PlayerWatermark_Group1_creationComplete);
			var _PlayerWatermark_SWFLoader1_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._PlayerWatermark_SWFLoader1_i);
			var _PlayerWatermark_SWFLoader2_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._PlayerWatermark_SWFLoader2_i);
			var _PlayerWatermark_SWFLoader3_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._PlayerWatermark_SWFLoader3_i);
			var _PlayerWatermark_SWFLoader4_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._PlayerWatermark_SWFLoader4_i);
			var _PlayerWatermark_SWFLoader5_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._PlayerWatermark_SWFLoader5_i);
			var _PlayerWatermark_SWFLoader6_factory:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._PlayerWatermark_SWFLoader6_i);
			states = [new State({
				"name":"normal",
				"overrides":[]
			}),new State({
				"name":"basic",
				"overrides":[new AddItems().initializeFromObject({
					"itemsFactory":_PlayerWatermark_SWFLoader1_factory,
					"destination":null,
					"propertyName":"mxmlContent",
					"position":"first"
				})]
			}),new State({
				"name":"custom",
				"overrides":[new AddItems().initializeFromObject({
					"itemsFactory":_PlayerWatermark_SWFLoader6_factory,
					"destination":null,
					"propertyName":"mxmlContent",
					"position":"after",
					"relativeTo":["fullScreenWatermark"]
				})]
			}),new State({
				"name":"twoLines",
				"overrides":[new AddItems().initializeFromObject({
					"itemsFactory":_PlayerWatermark_SWFLoader2_factory,
					"destination":null,
					"propertyName":"mxmlContent",
					"position":"first"
				})]
			}),new State({
				"name":"fullScreen",
				"overrides":[new AddItems().initializeFromObject({
					"itemsFactory":_PlayerWatermark_SWFLoader4_factory,
					"destination":"fullScreenWatermark",
					"propertyName":"mxmlContent",
					"position":"first"
				})]
			}),new State({
				"name":"g4s",
				"overrides":[new AddItems().initializeFromObject({
					"itemsFactory":_PlayerWatermark_SWFLoader3_factory,
					"destination":null,
					"propertyName":"mxmlContent",
					"position":"first"
				})]
			}),new State({
				"name":"freeTrial",
				"overrides":[new AddItems().initializeFromObject({
					"itemsFactory":_PlayerWatermark_SWFLoader5_factory,
					"destination":null,
					"propertyName":"mxmlContent",
					"position":"after",
					"relativeTo":["fullScreenWatermark"]
				})]
			})];
			var i:uint = 0;
			while(i < bindings.length)
			{
				Binding(bindings[i]).execute();
				i++;
			}
		}
		
		public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
		{
			PlayerWatermark._watcherSetupUtil = param1;
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
		
		private function init() : void
		{
		}
		
		public function loadCustomWatermarkByUrl(param1:String) : void
		{
			this.currentState = "custom";
			this.customWatermark.source = param1;
			var _loc2_:LoaderContext = new LoaderContext(true);
			_loc2_.allowCodeImport = false;
			this.customWatermark.loaderContext = _loc2_;
		}
		
		public function set logoEnabled(param1:Boolean) : void
		{
			this._clickable = param1;
		}
		
		protected function defaultWatermark_clickHandler() : void
		{
			dispatchEvent(new PlayerEvent(PlayerEvent.LOGO_CLICK,null,true));
		}
		
		public function showWatermark(param1:String) : void
		{
			switch(param1)
			{
				case WATERMARK_ID_DEFAULT:
					this.currentState = "basic";
					break;
				case WATERMARK_ID_TWO_LINES:
					this.currentState = "twoLines";
					break;
				case WATERMARK_ID_G4S:
					this.currentState = "g4s";
					break;
				case WATERMARK_ID_FULL_SCREEN:
					this.currentState = "fullScreen";
					break;
				case WATERMARK_ID_FREE_TRIAL:
					this.currentState = "freeTrial";
			}
		}
		
		private function _PlayerWatermark_SWFLoader1_i() : SWFLoader
		{
			var _loc1_:SWFLoader = new SWFLoader();
			_loc1_.left = 5;
			_loc1_.bottom = 5;
			_loc1_.source = this._embed_mxml__styles_images_player_stage_watermark_logo_swf_2102363582;
			_loc1_.smoothBitmapContent = true;
			_loc1_.setStyle("verticalAlign","bottom");
			_loc1_.setStyle("horizontalAlign","left");
			_loc1_.addEventListener("click",this.__defaultWatermark_click);
			_loc1_.id = "defaultWatermark";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.defaultWatermark = _loc1_;
			BindingManager.executeBindings(this,"defaultWatermark",this.defaultWatermark);
			return _loc1_;
		}
		
		public function __defaultWatermark_click(param1:MouseEvent) : void
		{
			this.defaultWatermark_clickHandler();
		}
		
		private function _PlayerWatermark_SWFLoader2_i() : SWFLoader
		{
			var _loc1_:SWFLoader = new SWFLoader();
			_loc1_.left = 5;
			_loc1_.bottom = 5;
			_loc1_.source = this._embed_mxml__styles_images_player_stage_watermark_2lines_swf_1703712638;
			_loc1_.smoothBitmapContent = true;
			_loc1_.setStyle("verticalAlign","bottom");
			_loc1_.setStyle("horizontalAlign","left");
			_loc1_.id = "twoRowWatermark";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.twoRowWatermark = _loc1_;
			BindingManager.executeBindings(this,"twoRowWatermark",this.twoRowWatermark);
			return _loc1_;
		}
		
		private function _PlayerWatermark_SWFLoader3_i() : SWFLoader
		{
			var _loc1_:SWFLoader = new SWFLoader();
			_loc1_.left = 5;
			_loc1_.bottom = 5;
			_loc1_.source = this._embed_mxml__styles_images_player_stage_watermark_g4s_swf_1974057250;
			_loc1_.smoothBitmapContent = true;
			_loc1_.setStyle("verticalAlign","bottom");
			_loc1_.setStyle("horizontalAlign","left");
			_loc1_.id = "schoolWatermark";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.schoolWatermark = _loc1_;
			BindingManager.executeBindings(this,"schoolWatermark",this.schoolWatermark);
			return _loc1_;
		}
		
		private function _PlayerWatermark_Group2_i() : Group
		{
			var _loc1_:Group = new Group();
			_loc1_.alpha = 0.5;
			_loc1_.verticalCenter = 0;
			_loc1_.horizontalCenter = 0;
			_loc1_.mxmlContent = [];
			_loc1_.id = "fullScreenWatermark";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.fullScreenWatermark = _loc1_;
			BindingManager.executeBindings(this,"fullScreenWatermark",this.fullScreenWatermark);
			return _loc1_;
		}
		
		private function _PlayerWatermark_SWFLoader4_i() : SWFLoader
		{
			var _loc1_:SWFLoader = new SWFLoader();
			_loc1_.verticalCenter = 0;
			_loc1_.horizontalCenter = 0;
			_loc1_.source = this._embed_mxml__styles_images_player_stage_watermark_fullScreen_swf_140049762;
			_loc1_.smoothBitmapContent = true;
			_loc1_.id = "_PlayerWatermark_SWFLoader4";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this._PlayerWatermark_SWFLoader4 = _loc1_;
			BindingManager.executeBindings(this,"_PlayerWatermark_SWFLoader4",this._PlayerWatermark_SWFLoader4);
			return _loc1_;
		}
		
		private function _PlayerWatermark_SWFLoader5_i() : SWFLoader
		{
			var _loc1_:SWFLoader = new SWFLoader();
			_loc1_.verticalCenter = 0;
			_loc1_.horizontalCenter = 0;
			_loc1_.source = this._embed_mxml__styles_images_player_stage_watermark_free_trial_swf_207218482;
			_loc1_.smoothBitmapContent = true;
			_loc1_.id = "_PlayerWatermark_SWFLoader5";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this._PlayerWatermark_SWFLoader5 = _loc1_;
			BindingManager.executeBindings(this,"_PlayerWatermark_SWFLoader5",this._PlayerWatermark_SWFLoader5);
			return _loc1_;
		}
		
		private function _PlayerWatermark_SWFLoader6_i() : SWFLoader
		{
			var _loc1_:SWFLoader = new SWFLoader();
			_loc1_.left = 5;
			_loc1_.bottom = 5;
			_loc1_.maxHeight = 40;
			_loc1_.maxWidth = 100;
			_loc1_.maintainAspectRatio = true;
			_loc1_.smoothBitmapContent = true;
			_loc1_.setStyle("verticalAlign","bottom");
			_loc1_.setStyle("horizontalAlign","left");
			_loc1_.id = "customWatermark";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.customWatermark = _loc1_;
			BindingManager.executeBindings(this,"customWatermark",this.customWatermark);
			return _loc1_;
		}
		
		public function ___PlayerWatermark_Group1_creationComplete(param1:FlexEvent) : void
		{
			this.init();
		}
		
		private function _PlayerWatermark_bindingsSetup() : Array
		{
			var result:Array = [];
			result[0] = new Binding(this,function():Boolean
			{
				return _clickable;
			},null,"defaultWatermark.enabled");
			result[1] = new Binding(this,function():Boolean
			{
				return _clickable;
			},null,"defaultWatermark.buttonMode");
			return result;
		}
		
		[Bindable(event="propertyChange")]
		public function get customWatermark() : SWFLoader
		{
			return this._1732621325customWatermark;
		}
		
		public function set customWatermark(param1:SWFLoader) : void
		{
			var _loc2_:Object = this._1732621325customWatermark;
			if(_loc2_ !== param1)
			{
				this._1732621325customWatermark = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"customWatermark",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get defaultWatermark() : SWFLoader
		{
			return this._1597778723defaultWatermark;
		}
		
		public function set defaultWatermark(param1:SWFLoader) : void
		{
			var _loc2_:Object = this._1597778723defaultWatermark;
			if(_loc2_ !== param1)
			{
				this._1597778723defaultWatermark = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"defaultWatermark",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get fullScreenWatermark() : Group
		{
			return this._727922999fullScreenWatermark;
		}
		
		public function set fullScreenWatermark(param1:Group) : void
		{
			var _loc2_:Object = this._727922999fullScreenWatermark;
			if(_loc2_ !== param1)
			{
				this._727922999fullScreenWatermark = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fullScreenWatermark",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get schoolWatermark() : SWFLoader
		{
			return this._92942512schoolWatermark;
		}
		
		public function set schoolWatermark(param1:SWFLoader) : void
		{
			var _loc2_:Object = this._92942512schoolWatermark;
			if(_loc2_ !== param1)
			{
				this._92942512schoolWatermark = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"schoolWatermark",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get twoRowWatermark() : SWFLoader
		{
			return this._524437526twoRowWatermark;
		}
		
		public function set twoRowWatermark(param1:SWFLoader) : void
		{
			var _loc2_:Object = this._524437526twoRowWatermark;
			if(_loc2_ !== param1)
			{
				this._524437526twoRowWatermark = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"twoRowWatermark",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		private function get _clickable() : Boolean
		{
			return this._841372003_clickable;
		}
		
		private function set _clickable(param1:Boolean) : void
		{
			var _loc2_:Object = this._841372003_clickable;
			if(_loc2_ !== param1)
			{
				this._841372003_clickable = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_clickable",_loc2_,param1));
				}
			}
		}
	}
}
