package anifire.player.skins
{
	import mx.binding.BindingManager;
	import mx.controls.SWFLoader;
	import mx.core.IFlexModuleFactory;
	import mx.core.IStateClient2;
	import mx.events.PropertyChangeEvent;
	import mx.states.SetProperty;
	import mx.states.State;
	import spark.skins.SparkButtonSkin;
	
	public class BigPlayButtonSkin extends SparkButtonSkin implements IStateClient2
	{
		
		private static const exclusions:Array = ["labelDisplay"];
		 
		
		private var _1514595273_BigPlayButtonSkin_SWFLoader1:SWFLoader;
		
		private var __moduleFactoryInitialized:Boolean = false;
		
		private var cornerRadius:Number = 2;
		
		private var _embed_mxml__styles_images_player_stage_play_init_swf_1937767806:Class;
		
		public function BigPlayButtonSkin()
		{
			this._embed_mxml__styles_images_player_stage_play_init_swf_1937767806 = BigPlayButtonSkin__embed_mxml__styles_images_player_stage_play_init_swf_1937767806;
			super();
			mx_internal::_document = this;
			this.minWidth = 21;
			this.minHeight = 21;
			this.mxmlContent = [this._BigPlayButtonSkin_SWFLoader1_i()];
			this.currentState = "up";
			states = [new State({
				"name":"up",
				"overrides":[new SetProperty().initializeFromObject({
					"target":"_BigPlayButtonSkin_SWFLoader1",
					"name":"alpha",
					"value":0.7
				})]
			}),new State({
				"name":"over",
				"overrides":[new SetProperty().initializeFromObject({
					"target":"_BigPlayButtonSkin_SWFLoader1",
					"name":"alpha",
					"value":1
				})]
			}),new State({
				"name":"down",
				"overrides":[new SetProperty().initializeFromObject({
					"target":"_BigPlayButtonSkin_SWFLoader1",
					"name":"alpha",
					"value":0.7
				})]
			}),new State({
				"name":"disabled",
				"overrides":[new SetProperty().initializeFromObject({
					"name":"alpha",
					"value":0.5
				})]
			})];
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
		
		override public function get colorizeExclusions() : Array
		{
			return exclusions;
		}
		
		override protected function initializationComplete() : void
		{
			useChromeColor = true;
			super.initializationComplete();
		}
		
		override protected function updateDisplayList(param1:Number, param2:Number) : void
		{
			var _loc3_:Number = getStyle("cornerRadius");
			if(this.cornerRadius != _loc3_)
			{
				this.cornerRadius = _loc3_;
			}
			super.updateDisplayList(param1,param2);
		}
		
		private function _BigPlayButtonSkin_SWFLoader1_i() : SWFLoader
		{
			var _loc1_:SWFLoader = new SWFLoader();
			_loc1_.percentWidth = 100;
			_loc1_.percentHeight = 100;
			_loc1_.source = this._embed_mxml__styles_images_player_stage_play_init_swf_1937767806;
			_loc1_.id = "_BigPlayButtonSkin_SWFLoader1";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this._BigPlayButtonSkin_SWFLoader1 = _loc1_;
			BindingManager.executeBindings(this,"_BigPlayButtonSkin_SWFLoader1",this._BigPlayButtonSkin_SWFLoader1);
			return _loc1_;
		}
		
		[Bindable(event="propertyChange")]
		public function get _BigPlayButtonSkin_SWFLoader1() : SWFLoader
		{
			return this._1514595273_BigPlayButtonSkin_SWFLoader1;
		}
		
		public function set _BigPlayButtonSkin_SWFLoader1(param1:SWFLoader) : void
		{
			var _loc2_:Object = this._1514595273_BigPlayButtonSkin_SWFLoader1;
			if(_loc2_ !== param1)
			{
				this._1514595273_BigPlayButtonSkin_SWFLoader1 = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_BigPlayButtonSkin_SWFLoader1",_loc2_,param1));
				}
			}
		}
	}
}
