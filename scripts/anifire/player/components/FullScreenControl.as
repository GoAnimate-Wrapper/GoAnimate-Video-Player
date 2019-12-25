package anifire.player.components
{
	import anifire.constant.ServerConstants;
	import anifire.managers.AmplitudeAnalyticsManager;
	import anifire.managers.AppConfigManager;
	import anifire.player.skins.FullScreenToggleButtonSkin;
	import anifire.util.UtilErrorLogger;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import mx.binding.BindingManager;
	import mx.core.FlexGlobals;
	import mx.core.IFlexModuleFactory;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import spark.components.Group;
	import spark.components.ToggleButton;
	
	public class FullScreenControl extends Group
	{
		 
		
		private var _511269518fullBut:ToggleButton;
		
		private var __moduleFactoryInitialized:Boolean = false;
		
		public function FullScreenControl()
		{
			super();
			mx_internal::_document = this;
			this.mxmlContent = [this._FullScreenControl_ToggleButton1_i()];
			this.addEventListener("creationComplete",this.___FullScreenControl_Group1_creationComplete);
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
		
		private function onCreationCompleted(... rest) : void
		{
			FlexGlobals.topLevelApplication.addEventListener(FullScreenEvent.FULL_SCREEN,this.fullScreenHandler);
			try
			{
				if(FlexGlobals.topLevelApplication.stage.displayState == StageDisplayState.FULL_SCREEN)
				{
					this.fullBut.selected = true;
				}
				else
				{
					this.fullBut.selected = false;
				}
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		private function fullScreenHandler(param1:FullScreenEvent) : void
		{
			if(param1.fullScreen)
			{
				this.fullBut.selected = true;
			}
			else
			{
				this.fullBut.selected = false;
			}
		}
		
		protected function onButtonClick(param1:MouseEvent) : void
		{
			var event:MouseEvent = param1;
			if(this.fullBut.selected)
			{
				try
				{
					stage.displayState = StageDisplayState.FULL_SCREEN;
				}
				catch(e:Error)
				{
					UtilErrorLogger.getInstance().appendCustomError("FullScreenControl:switchToFull",e);
				}
			}
			else
			{
				try
				{
					stage.displayState = StageDisplayState.NORMAL;
				}
				catch(e:Error)
				{
					UtilErrorLogger.getInstance().appendCustomError("FullScreenControl:switchToNor",e);
				}
			}
			var eventProperties:Object = {};
			eventProperties[AmplitudeAnalyticsManager.EVENT_PROPERTIES_MOVIE_ID] = AppConfigManager.instance.getValue(ServerConstants.PARAM_MOVIE_ID);
			AmplitudeAnalyticsManager.instance.log(AmplitudeAnalyticsManager.EVENT_NAME_TOGGLE_FULLSCREEN,eventProperties);
		}
		
		private function _FullScreenControl_ToggleButton1_i() : ToggleButton
		{
			var _loc1_:ToggleButton = new ToggleButton();
			_loc1_.buttonMode = true;
			_loc1_.setStyle("skinClass",FullScreenToggleButtonSkin);
			_loc1_.addEventListener("click",this.__fullBut_click);
			_loc1_.id = "fullBut";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.fullBut = _loc1_;
			BindingManager.executeBindings(this,"fullBut",this.fullBut);
			return _loc1_;
		}
		
		public function __fullBut_click(param1:MouseEvent) : void
		{
			this.onButtonClick(param1);
		}
		
		public function ___FullScreenControl_Group1_creationComplete(param1:FlexEvent) : void
		{
			this.onCreationCompleted();
		}
		
		[Bindable(event="propertyChange")]
		public function get fullBut() : ToggleButton
		{
			return this._511269518fullBut;
		}
		
		public function set fullBut(param1:ToggleButton) : void
		{
			var _loc2_:Object = this._511269518fullBut;
			if(_loc2_ !== param1)
			{
				this._511269518fullBut = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fullBut",_loc2_,param1));
				}
			}
		}
	}
}
