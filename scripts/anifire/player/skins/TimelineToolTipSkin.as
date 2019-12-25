package anifire.player.skins
{
	import anifire.player.components.TimelineToolTip;
	import mx.binding.BindingManager;
	import mx.core.IFlexModuleFactory;
	import mx.events.PropertyChangeEvent;
	import mx.graphics.SolidColor;
	import spark.components.Label;
	import spark.components.supportClasses.Skin;
	import spark.primitives.Path;
	import spark.primitives.Rect;
	
	public class TimelineToolTipSkin extends Skin
	{
		 
		
		private var _102727412label:Label;
		
		private var _1681226213timeTipArrow:Path;
		
		private var __moduleFactoryInitialized:Boolean = false;
		
		private var _213507019hostComponent:TimelineToolTip;
		
		public function TimelineToolTipSkin()
		{
			super();
			mx_internal::_document = this;
			this.mxmlContent = [this._TimelineToolTipSkin_Rect1_c(),this._TimelineToolTipSkin_Path1_i(),this._TimelineToolTipSkin_Label1_i()];
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
		
		private function _TimelineToolTipSkin_Rect1_c() : Rect
		{
			var _loc1_:Rect = new Rect();
			_loc1_.top = 0;
			_loc1_.left = 0;
			_loc1_.right = 0;
			_loc1_.bottom = 0;
			_loc1_.radiusX = 3;
			_loc1_.radiusY = 3;
			_loc1_.fill = this._TimelineToolTipSkin_SolidColor1_c();
			_loc1_.initialized(this,null);
			return _loc1_;
		}
		
		private function _TimelineToolTipSkin_SolidColor1_c() : SolidColor
		{
			var _loc1_:SolidColor = new SolidColor();
			_loc1_.color = 594708;
			_loc1_.alpha = 0.7;
			return _loc1_;
		}
		
		private function _TimelineToolTipSkin_Path1_i() : Path
		{
			var _loc1_:Path = new Path();
			_loc1_.bottom = -5;
			_loc1_.horizontalCenter = 0;
			_loc1_.data = "M 0 0 L 5 0 L 0 5 L -5 0 Z";
			_loc1_.fill = this._TimelineToolTipSkin_SolidColor2_c();
			_loc1_.initialized(this,"timeTipArrow");
			this.timeTipArrow = _loc1_;
			BindingManager.executeBindings(this,"timeTipArrow",this.timeTipArrow);
			return _loc1_;
		}
		
		private function _TimelineToolTipSkin_SolidColor2_c() : SolidColor
		{
			var _loc1_:SolidColor = new SolidColor();
			_loc1_.color = 594708;
			_loc1_.alpha = 0.7;
			return _loc1_;
		}
		
		private function _TimelineToolTipSkin_Label1_i() : Label
		{
			var _loc1_:Label = new Label();
			_loc1_.text = "";
			_loc1_.horizontalCenter = 0;
			_loc1_.verticalCenter = 1;
			_loc1_.left = 5;
			_loc1_.right = 5;
			_loc1_.top = 5;
			_loc1_.bottom = 5;
			_loc1_.setStyle("textAlign","center");
			_loc1_.setStyle("verticalAlign","middle");
			_loc1_.setStyle("fontWeight","normal");
			_loc1_.setStyle("color",16777215);
			_loc1_.setStyle("fontSize",11);
			_loc1_.id = "label";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.label = _loc1_;
			BindingManager.executeBindings(this,"label",this.label);
			return _loc1_;
		}
		
		[Bindable(event="propertyChange")]
		public function get label() : Label
		{
			return this._102727412label;
		}
		
		public function set label(param1:Label) : void
		{
			var _loc2_:Object = this._102727412label;
			if(_loc2_ !== param1)
			{
				this._102727412label = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"label",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get timeTipArrow() : Path
		{
			return this._1681226213timeTipArrow;
		}
		
		public function set timeTipArrow(param1:Path) : void
		{
			var _loc2_:Object = this._1681226213timeTipArrow;
			if(_loc2_ !== param1)
			{
				this._1681226213timeTipArrow = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeTipArrow",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get hostComponent() : TimelineToolTip
		{
			return this._213507019hostComponent;
		}
		
		public function set hostComponent(param1:TimelineToolTip) : void
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
