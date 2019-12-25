package anifire.player.components
{
	import anifire.player.events.PlayerEndScreenEvent;
	import anifire.player.skins.BigReplayButtonSkin;
	import anifire.util.UtilDict;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import mx.binding.Binding;
	import mx.binding.BindingManager;
	import mx.binding.IBindingClient;
	import mx.binding.IWatcherSetupUtil2;
	import mx.core.IFlexModuleFactory;
	import mx.core.mx_internal;
	import mx.events.PropertyChangeEvent;
	import mx.graphics.SolidColor;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.VGroup;
	import spark.primitives.BitmapImage;
	import spark.primitives.Rect;
	
	use namespace mx_internal;
	
	public class PlayerEndScreen extends Group implements IBindingClient
	{
		
		private static var _watcherSetupUtil:IWatcherSetupUtil2;
		 
		
		public var _PlayerEndScreen_Label1:Label;
		
		private var _1170704187creditScreen:Group;
		
		private var _564314170creditText:Label;
		
		private var _1212896764replay_btn:Button;
		
		private var __moduleFactoryInitialized:Boolean = false;
		
		private var _embed_mxml__styles_images_player_end_screen_img_credit_screen_png_421479420:Class;
		
		mx_internal var _bindings:Array;
		
		mx_internal var _watchers:Array;
		
		mx_internal var _bindingsByDestination:Object;
		
		mx_internal var _bindingsBeginWithWord:Object;
		
		public function PlayerEndScreen()
		{
			var target:Object = null;
			var watcherSetupUtilClass:Object = null;
			this._embed_mxml__styles_images_player_end_screen_img_credit_screen_png_421479420 = PlayerEndScreen__embed_mxml__styles_images_player_end_screen_img_credit_screen_png_421479420;
			this._bindings = [];
			this._watchers = [];
			this._bindingsByDestination = {};
			this._bindingsBeginWithWord = {};
			super();
			mx_internal::_document = this;
			var bindings:Array = this._PlayerEndScreen_bindingsSetup();
			var watchers:Array = [];
			target = this;
			if(_watcherSetupUtil == null)
			{
				watcherSetupUtilClass = getDefinitionByName("_anifire_player_components_PlayerEndScreenWatcherSetupUtil");
				watcherSetupUtilClass["init"](null);
			}
			_watcherSetupUtil.setup(this,function(param1:String):*
			{
				return target[param1];
			},function(param1:String):*
			{
				return PlayerEndScreen[param1];
			},bindings,watchers);
			mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
			mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
			this.width = 550;
			this.height = 354;
			this.mxmlContent = [this._PlayerEndScreen_Rect1_c(),this._PlayerEndScreen_Button1_i(),this._PlayerEndScreen_Group2_i()];
			var i:uint = 0;
			while(i < bindings.length)
			{
				Binding(bindings[i]).execute();
				i++;
			}
		}
		
		public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
		{
			PlayerEndScreen._watcherSetupUtil = param1;
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
		
		private function onBtnReplayClick(param1:Event) : void
		{
			var _loc2_:PlayerEndScreenEvent = new PlayerEndScreenEvent(PlayerEndScreenEvent.REPLAY_BUTTON_CLICK);
			dispatchEvent(_loc2_);
		}
		
		public function showCreditScreen(param1:String) : void
		{
			this.creditScreen.visible = true;
			this.creditText.text = param1;
			var _loc2_:int = 24;
			this.creditText.setStyle("fontSize",_loc2_);
			this.creditText.validateNow();
			while(this.creditText.isTruncated && _loc2_ > 10)
			{
				_loc2_--;
				this.creditText.setStyle("fontSize",_loc2_);
				this.creditText.validateNow();
			}
			var _loc3_:Timer = new Timer(5000,1);
			_loc3_.addEventListener(TimerEvent.TIMER_COMPLETE,this.onCreditScreenTimerComplete);
			_loc3_.start();
		}
		
		private function onCreditScreenTimerComplete(param1:TimerEvent) : void
		{
			this.creditScreen.visible = false;
			var _loc2_:PlayerEndScreenEvent = new PlayerEndScreenEvent(PlayerEndScreenEvent.CREDIT_SCREEN_TIME_UP);
			dispatchEvent(_loc2_);
		}
		
		private function _PlayerEndScreen_Rect1_c() : Rect
		{
			var _loc1_:Rect = new Rect();
			_loc1_.left = 0;
			_loc1_.right = 0;
			_loc1_.top = 0;
			_loc1_.bottom = 0;
			_loc1_.fill = this._PlayerEndScreen_SolidColor1_c();
			_loc1_.initialized(this,null);
			return _loc1_;
		}
		
		private function _PlayerEndScreen_SolidColor1_c() : SolidColor
		{
			var _loc1_:SolidColor = new SolidColor();
			_loc1_.color = 0;
			_loc1_.alpha = 0.5;
			return _loc1_;
		}
		
		private function _PlayerEndScreen_Button1_i() : Button
		{
			var _loc1_:Button = new Button();
			_loc1_.horizontalCenter = 0;
			_loc1_.verticalCenter = 0;
			_loc1_.buttonMode = true;
			_loc1_.scaleX = 0.8;
			_loc1_.scaleY = 0.8;
			_loc1_.setStyle("skinClass",BigReplayButtonSkin);
			_loc1_.addEventListener("click",this.__replay_btn_click);
			_loc1_.id = "replay_btn";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.replay_btn = _loc1_;
			BindingManager.executeBindings(this,"replay_btn",this.replay_btn);
			return _loc1_;
		}
		
		public function __replay_btn_click(param1:MouseEvent) : void
		{
			this.onBtnReplayClick(param1);
		}
		
		private function _PlayerEndScreen_Group2_i() : Group
		{
			var _loc1_:Group = new Group();
			_loc1_.percentWidth = 100;
			_loc1_.percentHeight = 100;
			_loc1_.visible = false;
			_loc1_.mxmlContent = [this._PlayerEndScreen_BitmapImage1_c(),this._PlayerEndScreen_VGroup1_c()];
			_loc1_.id = "creditScreen";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.creditScreen = _loc1_;
			BindingManager.executeBindings(this,"creditScreen",this.creditScreen);
			return _loc1_;
		}
		
		private function _PlayerEndScreen_BitmapImage1_c() : BitmapImage
		{
			var _loc1_:BitmapImage = new BitmapImage();
			_loc1_.source = this._embed_mxml__styles_images_player_end_screen_img_credit_screen_png_421479420;
			_loc1_.smooth = true;
			_loc1_.top = 10;
			_loc1_.horizontalCenter = 0;
			_loc1_.initialized(this,null);
			return _loc1_;
		}
		
		private function _PlayerEndScreen_VGroup1_c() : VGroup
		{
			var _loc1_:VGroup = new VGroup();
			_loc1_.percentWidth = 100;
			_loc1_.percentHeight = 100;
			_loc1_.paddingTop = 90;
			_loc1_.paddingBottom = 50;
			_loc1_.mxmlContent = [this._PlayerEndScreen_Label1_i(),this._PlayerEndScreen_Label2_i()];
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			return _loc1_;
		}
		
		private function _PlayerEndScreen_Label1_i() : Label
		{
			var _loc1_:Label = new Label();
			_loc1_.percentWidth = 100;
			_loc1_.setStyle("fontSize",16);
			_loc1_.setStyle("fontWeight","bold");
			_loc1_.setStyle("color",13421772);
			_loc1_.setStyle("textAlign","center");
			_loc1_.id = "_PlayerEndScreen_Label1";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this._PlayerEndScreen_Label1 = _loc1_;
			BindingManager.executeBindings(this,"_PlayerEndScreen_Label1",this._PlayerEndScreen_Label1);
			return _loc1_;
		}
		
		private function _PlayerEndScreen_Label2_i() : Label
		{
			var _loc1_:Label = new Label();
			_loc1_.percentWidth = 100;
			_loc1_.percentHeight = 100;
			_loc1_.maxDisplayedLines = -1;
			_loc1_.setStyle("color",13421772);
			_loc1_.setStyle("fontSize",24);
			_loc1_.setStyle("textAlign","center");
			_loc1_.id = "creditText";
			if(!_loc1_.document)
			{
				_loc1_.document = this;
			}
			this.creditText = _loc1_;
			BindingManager.executeBindings(this,"creditText",this.creditText);
			return _loc1_;
		}
		
		private function _PlayerEndScreen_bindingsSetup() : Array
		{
			var result:Array = [];
			result[0] = new Binding(this,function():String
			{
				var _loc1_:* = UtilDict.toDisplay("player","Music licensed under Creative Commons Share Alike:");
				return _loc1_ == undefined?null:String(_loc1_);
			},null,"_PlayerEndScreen_Label1.text");
			return result;
		}
		
		[Bindable(event="propertyChange")]
		public function get creditScreen() : Group
		{
			return this._1170704187creditScreen;
		}
		
		public function set creditScreen(param1:Group) : void
		{
			var _loc2_:Object = this._1170704187creditScreen;
			if(_loc2_ !== param1)
			{
				this._1170704187creditScreen = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"creditScreen",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get creditText() : Label
		{
			return this._564314170creditText;
		}
		
		public function set creditText(param1:Label) : void
		{
			var _loc2_:Object = this._564314170creditText;
			if(_loc2_ !== param1)
			{
				this._564314170creditText = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"creditText",_loc2_,param1));
				}
			}
		}
		
		[Bindable(event="propertyChange")]
		public function get replay_btn() : Button
		{
			return this._1212896764replay_btn;
		}
		
		public function set replay_btn(param1:Button) : void
		{
			var _loc2_:Object = this._1212896764replay_btn;
			if(_loc2_ !== param1)
			{
				this._1212896764replay_btn = param1;
				if(this.hasEventListener("propertyChange"))
				{
					this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"replay_btn",_loc2_,param1));
				}
			}
		}
	}
}
