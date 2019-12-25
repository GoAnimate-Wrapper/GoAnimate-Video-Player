package anifire.player.skins
{
	import mx.core.IFlexModuleFactory;
	import mx.core.IStateClient2;
	import mx.events.PropertyChangeEvent;
	import mx.graphics.SolidColor;
	import mx.states.State;
	import spark.components.Button;
	import spark.primitives.Rect;
	import spark.skins.SparkSkin;
	
	public class TimelineHSliderTrackSkin extends SparkSkin implements IStateClient2
	{
		 
		
		private var __moduleFactoryInitialized:Boolean = false;
		
		private var _213507019hostComponent:Button;
		
		public function TimelineHSliderTrackSkin()
		{
			super();
			mx_internal::_document = this;
			this.mxmlContent = [this._TimelineHSliderTrackSkin_Rect1_c(),this._TimelineHSliderTrackSkin_Rect2_c()];
			this.currentState = "up";
			states = [new State({
				"name":"up",
				"overrides":[]
			}),new State({
				"name":"down",
				"overrides":[]
			}),new State({
				"name":"over",
				"overrides":[]
			}),new State({
				"name":"disabled",
				"overrides":[]
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
		
		override protected function initializationComplete() : void
		{
			useChromeColor = true;
			super.initializationComplete();
		}
		
		private function _TimelineHSliderTrackSkin_Rect1_c() : Rect
		{
			var _loc1_:Rect = new Rect();
			_loc1_.left = 7;
			_loc1_.right = 7;
			_loc1_.verticalCenter = 0;
			_loc1_.radiusX = 2;
			_loc1_.radiusY = 2;
			_loc1_.height = 5;
			_loc1_.fill = this._TimelineHSliderTrackSkin_SolidColor1_c();
			_loc1_.initialized(this,null);
			return _loc1_;
		}
		
		private function _TimelineHSliderTrackSkin_SolidColor1_c() : SolidColor
		{
			var _loc1_:SolidColor = new SolidColor();
			_loc1_.color = 0;
			return _loc1_;
		}
		
		private function _TimelineHSliderTrackSkin_Rect2_c() : Rect
		{
			var _loc1_:Rect = new Rect();
			_loc1_.left = 0;
			_loc1_.right = 0;
			_loc1_.top = 0;
			_loc1_.bottom = 0;
			_loc1_.fill = this._TimelineHSliderTrackSkin_SolidColor2_c();
			_loc1_.initialized(this,null);
			return _loc1_;
		}
		
		private function _TimelineHSliderTrackSkin_SolidColor2_c() : SolidColor
		{
			var _loc1_:SolidColor = new SolidColor();
			_loc1_.alpha = 0;
			return _loc1_;
		}
		
		[Bindable(event="propertyChange")]
		public function get hostComponent() : Button
		{
			return this._213507019hostComponent;
		}
		
		public function set hostComponent(param1:Button) : void
		{
			var _loc2_:Object = this._213507019hostComponent;
			if(_loc2_ !== param1)
			{
				this._213507019hostComponent = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hostComponent",_loc2_,param1));
				}
			}
		}
	}
}
