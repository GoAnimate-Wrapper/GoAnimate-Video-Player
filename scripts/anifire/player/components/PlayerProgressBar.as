package anifire.player.components
{
	import flash.utils.getDefinitionByName;
	import mx.binding.Binding;
	import mx.binding.BindingManager;
	import mx.binding.IBindingClient;
	import mx.binding.IWatcherSetupUtil2;
	import mx.core.IFlexModuleFactory;
	import mx.core.mx_internal;
	import mx.events.PropertyChangeEvent;
	import spark.components.Group;
	import spark.primitives.BitmapImage;
	
	use namespace mx_internal;
	
	public class PlayerProgressBar extends Group implements IBindingClient
	{
		
		private static var _watcherSetupUtil:IWatcherSetupUtil2;
		 
		
		public var _PlayerProgressBar_Group2:Group;
		
		private var __moduleFactoryInitialized:Boolean = false;
		
		private var _1269052185_progressPercent:Number = 0;
		
		private var _embed_mxml__styles_images_player_loading_loading_track_png_116277666:Class;
		
		private var _embed_mxml__styles_images_player_loading_loading_fill_png_40901168:Class;
		
		mx_internal var _bindings:Array;
		
		mx_internal var _watchers:Array;
		
		mx_internal var _bindingsByDestination:Object;
		
		mx_internal var _bindingsBeginWithWord:Object;
		
		public function PlayerProgressBar()
		{
			var target:Object = null;
			var watcherSetupUtilClass:Object = null;
			this._embed_mxml__styles_images_player_loading_loading_track_png_116277666 = PlayerProgressBar__embed_mxml__styles_images_player_loading_loading_track_png_116277666;
			this._embed_mxml__styles_images_player_loading_loading_fill_png_40901168 = PlayerProgressBar__embed_mxml__styles_images_player_loading_loading_fill_png_40901168;
			this._bindings = [];
			this._watchers = [];
			this._bindingsByDestination = {};
			this._bindingsBeginWithWord = {};
			super();
			mx_internal::_document = this;
			var bindings:Array = this._PlayerProgressBar_bindingsSetup();
			var watchers:Array = [];
			target = this;
			if(_watcherSetupUtil == null)
			{
				watcherSetupUtilClass = getDefinitionByName("_anifire_player_components_PlayerProgressBarWatcherSetupUtil");
				watcherSetupUtilClass["init"](null);
			}
			_watcherSetupUtil.setup(this,function(param1:String):*
			{
				return target[param1];
			},function(param1:String):*
			{
				return PlayerProgressBar[param1];
			},bindings,watchers);
			mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
			mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
			this.mxmlContent = [this._PlayerProgressBar_BitmapImage1_c(),this._PlayerProgressBar_Group2_i()];
			var i:uint = 0;
			while(i < bindings.length)
			{
				Binding(bindings[i]).execute();
				i++;
			}
		}
		
		public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
		{
			PlayerProgressBar._watcherSetupUtil = param1;
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
		
		public function setProgress(param1:Number) : void
		{
			this._progressPercent = param1;
		}
		
		private function _PlayerProgressBar_BitmapImage1_c() : BitmapImage
		{
			var _loc1_:BitmapImage = new BitmapImage();
			_loc1_.source = this._embed_mxml__styles_images_player_loading_loading_track_png_116277666;
			_loc1_.initialized(this,null);
			return _loc1_;
		}
		
		private function _PlayerProgressBar_Group2_i() : Group
		{
			var _loc1_:Group = new Group();
			_loc1_.x = 2;
			_loc1_.y = 2;
			_loc1_.clipAndEnableScrolling = true;
			_loc1_.mxmlContent = [this._PlayerProgressBar_BitmapImage2_c()];
			_loc1_.id = "_PlayerProgressBar_Group2";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this._PlayerProgressBar_Group2 = _loc1_;
			BindingManager.executeBindings(this,"_PlayerProgressBar_Group2",this._PlayerProgressBar_Group2);
			return _loc1_;
		}
		
		private function _PlayerProgressBar_BitmapImage2_c() : BitmapImage
		{
			var _loc1_:BitmapImage = new BitmapImage();
			_loc1_.source = this._embed_mxml__styles_images_player_loading_loading_fill_png_40901168;
			_loc1_.initialized(this,null);
			return _loc1_;
		}
		
		private function _PlayerProgressBar_bindingsSetup() : Array
		{
			var result:Array = [];
			result[0] = new Binding(this,function():Number
			{
				return _progressPercent * 175;
			},null,"_PlayerProgressBar_Group2.width");
			return result;
		}
		
		[Bindable(event="propertyChange")]
		private function get _progressPercent() : Number
		{
			return this._1269052185_progressPercent;
		}
		
		private function set _progressPercent(param1:Number) : void
		{
			var _loc2_:Object = this._1269052185_progressPercent;
			if(_loc2_ !== param1)
			{
				this._1269052185_progressPercent = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_progressPercent",_loc2_,param1));
				}
			}
		}
	}
}
