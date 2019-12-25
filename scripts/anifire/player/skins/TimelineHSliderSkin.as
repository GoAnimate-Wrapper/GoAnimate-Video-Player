package anifire.player.skins
{
	import anifire.player.components.SceneBufferProgressBar;
	import anifire.player.components.TimelineToolTip;
	import anifire.util.UtilString;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import mx.binding.Binding;
	import mx.binding.BindingManager;
	import mx.binding.IBindingClient;
	import mx.binding.IWatcherSetupUtil2;
	import mx.core.ClassFactory;
	import mx.core.IFlexModuleFactory;
	import mx.core.IStateClient2;
	import mx.core.mx_internal;
	import mx.events.PropertyChangeEvent;
	import mx.graphics.SolidColor;
	import mx.states.SetProperty;
	import mx.states.State;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HSlider;
	import spark.primitives.Rect;
	import spark.skins.SparkSkin;
	
	use namespace mx_internal;
	
	public class TimelineHSliderSkin extends SparkSkin implements IBindingClient, IStateClient2
	{
		
		private static const exclusions:Array = ["track","thumb"];
		
		private static var _watcherSetupUtil:IWatcherSetupUtil2;
		 
		
		public var _TimelineHSliderSkin_Rect1:Rect;
		
		private var _1443184785dataTip:ClassFactory;
		
		private var _2042639130sceneBufferProgressBar:SceneBufferProgressBar;
		
		private var _110342614thumb:Button;
		
		private var _1313937778timeTip:TimelineToolTip;
		
		private var _110621003track:Button;
		
		private var _729599703trackMask:Group;
		
		private var __moduleFactoryInitialized:Boolean = false;
		
		mx_internal var _bindings:Array;
		
		mx_internal var _watchers:Array;
		
		mx_internal var _bindingsByDestination:Object;
		
		mx_internal var _bindingsBeginWithWord:Object;
		
		private var _213507019hostComponent:HSlider;
		
		public function TimelineHSliderSkin()
		{
			var target:Object = null;
			var watcherSetupUtilClass:Object = null;
			this._bindings = [];
			this._watchers = [];
			this._bindingsByDestination = {};
			this._bindingsBeginWithWord = {};
			super();
			mx_internal::_document = this;
			var bindings:Array = this._TimelineHSliderSkin_bindingsSetup();
			var watchers:Array = [];
			target = this;
			if(_watcherSetupUtil == null)
			{
				watcherSetupUtilClass = getDefinitionByName("_anifire_player_skins_TimelineHSliderSkinWatcherSetupUtil");
				watcherSetupUtilClass["init"](null);
			}
			_watcherSetupUtil.setup(this,function(param1:String):*
			{
				return target[param1];
			},function(param1:String):*
			{
				return TimelineHSliderSkin[param1];
			},bindings,watchers);
			mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
			mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
			this.minHeight = 22;
			this.percentWidth = 100;
			this.mxmlContent = [this._TimelineHSliderSkin_Button1_i(),this._TimelineHSliderSkin_SceneBufferProgressBar1_i(),this._TimelineHSliderSkin_Rect1_i(),this._TimelineHSliderSkin_Group1_i(),this._TimelineHSliderSkin_Button2_i(),this._TimelineHSliderSkin_TimelineToolTip1_i()];
			this.currentState = "normal";
			this._TimelineHSliderSkin_ClassFactory1_i();
			this.addEventListener("rollOver",this.___TimelineHSliderSkin_SparkSkin1_rollOver);
			this.addEventListener("rollOut",this.___TimelineHSliderSkin_SparkSkin1_rollOut);
			this.addEventListener("mouseMove",this.___TimelineHSliderSkin_SparkSkin1_mouseMove);
			states = [new State({
				"name":"normal",
				"overrides":[]
			}),new State({
				"name":"disabled",
				"overrides":[new SetProperty().initializeFromObject({
					"name":"alpha",
					"value":0.5
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
			TimelineHSliderSkin._watcherSetupUtil = param1;
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
		
		override protected function measure() : void
		{
			var _loc1_:Number = this.thumb.getLayoutBoundsX();
			this.thumb.setLayoutBoundsPosition(0,this.thumb.getLayoutBoundsY());
			super.measure();
			this.thumb.setLayoutBoundsPosition(_loc1_,this.thumb.getLayoutBoundsY());
		}
		
		protected function onTrackMouseMove(param1:MouseEvent) : void
		{
			var _loc3_:Number = NaN;
			var _loc2_:Number = this.hostComponent.maximum * (this.track.mouseX - 7) / (this.track.width - 14);
			_loc2_ = Math.max(_loc2_,0);
			_loc2_ = Math.min(_loc2_,this.hostComponent.maximum);
			this.timeTip.text = UtilString.convertSecToTimeString(_loc2_);
			if(this.track.mouseX >= 7 && this.track.mouseX <= this.track.width - 7)
			{
				_loc3_ = this.mouseX - this.timeTip.width / 2;
				_loc3_ = Math.min(_loc3_,this.track.width - this.timeTip.width);
				this.timeTip.x = _loc3_;
			}
		}
		
		protected function onTrackRollOver(param1:MouseEvent) : void
		{
			this.timeTip.visible = true;
		}
		
		protected function onTrackRollOut(param1:MouseEvent) : void
		{
			this.timeTip.visible = false;
		}
		
		private function _TimelineHSliderSkin_ClassFactory1_i() : ClassFactory
		{
			var _loc1_:ClassFactory = new ClassFactory();
			_loc1_.generator = TimelineHSliderSkinInnerClass0;
			_loc1_.properties = {"outerDocument":this};
			this.dataTip = _loc1_;
			BindingManager.executeBindings(this,"dataTip",this.dataTip);
			return _loc1_;
		}
		
		private function _TimelineHSliderSkin_Button1_i() : Button
		{
			var _loc1_:Button = new Button();
			_loc1_.left = 0;
			_loc1_.right = 0;
			_loc1_.top = 0;
			_loc1_.bottom = 0;
			_loc1_.minWidth = 33;
			_loc1_.width = 100;
			_loc1_.tabEnabled = false;
			_loc1_.setStyle("skinClass",TimelineHSliderTrackSkin);
			_loc1_.id = "track";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.track = _loc1_;
			BindingManager.executeBindings(this,"track",this.track);
			return _loc1_;
		}
		
		private function _TimelineHSliderSkin_SceneBufferProgressBar1_i() : SceneBufferProgressBar
		{
			var _loc1_:SceneBufferProgressBar = new SceneBufferProgressBar();
			_loc1_.left = 7;
			_loc1_.right = 7;
			_loc1_.verticalCenter = 0;
			_loc1_.id = "sceneBufferProgressBar";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.sceneBufferProgressBar = _loc1_;
			BindingManager.executeBindings(this,"sceneBufferProgressBar",this.sceneBufferProgressBar);
			return _loc1_;
		}
		
		private function _TimelineHSliderSkin_Rect1_i() : Rect
		{
			var _loc1_:Rect = new Rect();
			_loc1_.left = 7;
			_loc1_.right = 7;
			_loc1_.verticalCenter = 0;
			_loc1_.radiusX = 2;
			_loc1_.radiusY = 2;
			_loc1_.height = 5;
			_loc1_.fill = this._TimelineHSliderSkin_SolidColor1_c();
			_loc1_.initialized(this,"_TimelineHSliderSkin_Rect1");
			this._TimelineHSliderSkin_Rect1 = _loc1_;
			BindingManager.executeBindings(this,"_TimelineHSliderSkin_Rect1",this._TimelineHSliderSkin_Rect1);
			return _loc1_;
		}
		
		private function _TimelineHSliderSkin_SolidColor1_c() : SolidColor
		{
			var _loc1_:SolidColor = new SolidColor();
			_loc1_.color = 1808298;
			return _loc1_;
		}
		
		private function _TimelineHSliderSkin_Group1_i() : Group
		{
			var _loc1_:Group = new Group();
			_loc1_.left = 0;
			_loc1_.top = 0;
			_loc1_.bottom = 0;
			_loc1_.mxmlContent = [this._TimelineHSliderSkin_Rect2_c()];
			_loc1_.id = "trackMask";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.trackMask = _loc1_;
			BindingManager.executeBindings(this,"trackMask",this.trackMask);
			return _loc1_;
		}
		
		private function _TimelineHSliderSkin_Rect2_c() : Rect
		{
			var _loc1_:Rect = new Rect();
			_loc1_.left = 0;
			_loc1_.right = 0;
			_loc1_.top = 0;
			_loc1_.bottom = 0;
			_loc1_.fill = this._TimelineHSliderSkin_SolidColor2_c();
			_loc1_.initialized(this,null);
			return _loc1_;
		}
		
		private function _TimelineHSliderSkin_SolidColor2_c() : SolidColor
		{
			var _loc1_:SolidColor = new SolidColor();
			_loc1_.color = 16711680;
			_loc1_.alpha = 0.5;
			return _loc1_;
		}
		
		private function _TimelineHSliderSkin_Button2_i() : Button
		{
			var _loc1_:Button = new Button();
			_loc1_.top = 0;
			_loc1_.bottom = 0;
			_loc1_.width = 20;
			_loc1_.tabEnabled = false;
			_loc1_.setStyle("skinClass",TimelineHSliderThumbSkin);
			_loc1_.id = "thumb";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.thumb = _loc1_;
			BindingManager.executeBindings(this,"thumb",this.thumb);
			return _loc1_;
		}
		
		private function _TimelineHSliderSkin_TimelineToolTip1_i() : TimelineToolTip
		{
			var _loc1_:TimelineToolTip = new TimelineToolTip();
			_loc1_.y = -37;
			_loc1_.visible = false;
			_loc1_.id = "timeTip";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.timeTip = _loc1_;
			BindingManager.executeBindings(this,"timeTip",this.timeTip);
			return _loc1_;
		}
		
		public function ___TimelineHSliderSkin_SparkSkin1_rollOver(param1:MouseEvent) : void
		{
			this.onTrackRollOver(param1);
		}
		
		public function ___TimelineHSliderSkin_SparkSkin1_rollOut(param1:MouseEvent) : void
		{
			this.onTrackRollOut(param1);
		}
		
		public function ___TimelineHSliderSkin_SparkSkin1_mouseMove(param1:MouseEvent) : void
		{
			this.onTrackMouseMove(param1);
		}
		
		private function _TimelineHSliderSkin_bindingsSetup() : Array
		{
			var result:Array = [];
			result[0] = new Binding(this,null,null,"_TimelineHSliderSkin_Rect1.mask","trackMask");
			result[1] = new Binding(this,function():Number
			{
				return thumb.x + thumb.width / 2;
			},null,"trackMask.width");
			return result;
		}
		
		[Bindable(event="propertyChange")]
		public function get dataTip() : ClassFactory
		{
			return this._1443184785dataTip;
		}
		
		public function set dataTip(param1:ClassFactory) : void
		{
			var _loc2_:Object = this._1443184785dataTip;
			if(_loc2_ !== param1)
			{
				this._1443184785dataTip = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dataTip",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get sceneBufferProgressBar() : SceneBufferProgressBar
		{
			return this._2042639130sceneBufferProgressBar;
		}
		
		public function set sceneBufferProgressBar(param1:SceneBufferProgressBar) : void
		{
			var _loc2_:Object = this._2042639130sceneBufferProgressBar;
			if(_loc2_ !== param1)
			{
				this._2042639130sceneBufferProgressBar = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sceneBufferProgressBar",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get thumb() : Button
		{
			return this._110342614thumb;
		}
		
		public function set thumb(param1:Button) : void
		{
			var _loc2_:Object = this._110342614thumb;
			if(_loc2_ !== param1)
			{
				this._110342614thumb = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"thumb",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get timeTip() : TimelineToolTip
		{
			return this._1313937778timeTip;
		}
		
		public function set timeTip(param1:TimelineToolTip) : void
		{
			var _loc2_:Object = this._1313937778timeTip;
			if(_loc2_ !== param1)
			{
				this._1313937778timeTip = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeTip",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get track() : Button
		{
			return this._110621003track;
		}
		
		public function set track(param1:Button) : void
		{
			var _loc2_:Object = this._110621003track;
			if(_loc2_ !== param1)
			{
				this._110621003track = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"track",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get trackMask() : Group
		{
			return this._729599703trackMask;
		}
		
		public function set trackMask(param1:Group) : void
		{
			var _loc2_:Object = this._729599703trackMask;
			if(_loc2_ !== param1)
			{
				this._729599703trackMask = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"trackMask",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get hostComponent() : HSlider
		{
			return this._213507019hostComponent;
		}
		
		public function set hostComponent(param1:HSlider) : void
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
