package anifire.player.components
{
	import mx.binding.BindingManager;
	import mx.core.IFlexModuleFactory;
	import mx.events.PropertyChangeEvent;
	import mx.graphics.SolidColor;
	import spark.components.Group;
	import spark.primitives.Rect;
	
	public class LoadingScreen extends Group
	{
		 
		
		private var _1131509414progressBar:PlayerProgressBar;
		
		private var __moduleFactoryInitialized:Boolean = false;
		
		public function LoadingScreen()
		{
			super();
			mx_internal::_document = this;
			this.mxmlContent = [this._LoadingScreen_Rect1_c(),this._LoadingScreen_PlayerProgressBar1_i()];
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
		
		public function showBranding() : void
		{
		}
		
		public function setDisclaimer(param1:String) : void
		{
		}
		
		public function setProgress(param1:Number) : void
		{
			this.progressBar.visible = true;
			this.progressBar.setProgress(param1);
		}
		
		public function init(param1:String) : void
		{
		}
		
		private function _LoadingScreen_Rect1_c() : Rect
		{
			var _loc1_:Rect = new Rect();
			_loc1_.top = 0;
			_loc1_.bottom = 0;
			_loc1_.left = 0;
			_loc1_.right = 0;
			_loc1_.fill = this._LoadingScreen_SolidColor1_c();
			_loc1_.initialized(this,null);
			return _loc1_;
		}
		
		private function _LoadingScreen_SolidColor1_c() : SolidColor
		{
			var _loc1_:SolidColor = new SolidColor();
			_loc1_.color = 0;
			return _loc1_;
		}
		
		private function _LoadingScreen_PlayerProgressBar1_i() : PlayerProgressBar
		{
			var _loc1_:PlayerProgressBar = new PlayerProgressBar();
			_loc1_.horizontalCenter = 0;
			_loc1_.verticalCenter = 0;
			_loc1_.visible = false;
			_loc1_.id = "progressBar";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.progressBar = _loc1_;
			BindingManager.executeBindings(this,"progressBar",this.progressBar);
			return _loc1_;
		}
		
		[Bindable(event="propertyChange")]
		public function get progressBar() : PlayerProgressBar
		{
			return this._1131509414progressBar;
		}
		
		public function set progressBar(param1:PlayerProgressBar) : void
		{
			var _loc2_:Object = this._1131509414progressBar;
			if(_loc2_ !== param1)
			{
				this._1131509414progressBar = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"progressBar",_loc2_,param1));
				}
			}
		}
	}
}
