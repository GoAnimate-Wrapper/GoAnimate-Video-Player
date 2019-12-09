package anifire.player.components
{
   import anifire.player.playback.PlainPlayer;
   import anifire.player.skins.PlayToggleButtonSkin;
   import anifire.util.Util;
   import anifire.util.UtilUnitConvert;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.SolidColor;
   import spark.components.Group;
   import spark.components.ToggleButton;
   import spark.events.TrackBaseEvent;
   import spark.layouts.HorizontalLayout;
   import spark.primitives.Rect;
   
   use namespace mx_internal;
   
   public class PlayerControl extends Group implements IBindingClient
   {
      
      private static const ON_PLAY_BUT_CLICK:String = "onPlayButClicked";
      
      private static const ON_PAUSE_BUT_CLICK:String = "onPauseButClicked";
      
      private static const ON_TIMELINE_DRAG:String = "onTimeLineDrag";
      
      private static const ON_TIMELINE_PRESS:String = "onTimeLinePress";
      
      private static const ON_TIMELINE_RELEASE:String = "onTimeLineRelease";
      
      public static const STATE_PLAY:int = 1;
      
      public static const STATE_PAUSE:int = 2;
      
      public static const STATE_NULL:int = 0;
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _206106544btnPlay:ToggleButton;
      
      private var _673913090fullScreenControl:FullScreenControl;
      
      private var _2077603743timeLine:TimelineControl;
      
      private var _431284669timerDisplay:TimerDisplay;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _625660012_curFrame:int = 1;
      
      private var _359767592_totalFrame:int = 1;
      
      private var _isTimeLineDragging:Boolean = false;
      
      private var _state:int;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function PlayerControl()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._PlayerControl_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_anifire_player_components_PlayerControlWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return PlayerControl[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.height = 37;
         this.mxmlContent = [this._PlayerControl_Rect1_c(),this._PlayerControl_Group2_c()];
         this.addEventListener("creationComplete",this.___PlayerControl_Group1_creationComplete);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         PlayerControl._watcherSetupUtil = param1;
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
      
      private function onCreationCompleted() : void
      {
         Util.initLog();
      }
      
      private function onTimeLineDragging(param1:Event) : void
      {
         this.curFrame = UtilUnitConvert.timeToFrame(this.timeLine.value);
         this.dispatchEvent(new Event(PlayerControl.ON_TIMELINE_DRAG));
      }
      
      public function get curFrame() : int
      {
         return this._curFrame;
      }
      
      public function set curFrame(param1:int) : void
      {
         if(param1 != this._curFrame && param1 >= 1 && param1 <= this._totalFrame)
         {
            this._curFrame = param1;
         }
      }
      
      public function timeChangeListener(param1:Number) : void
      {
         if(!this._isTimeLineDragging)
         {
            this.curFrame = param1;
            if(this._curFrame < this._totalFrame)
            {
               this.timeLine.value = this.timeLine.maximum * (this._curFrame - 1) / this._totalFrame;
            }
            else
            {
               this.timeLine.value = this.timeLine.maximum;
            }
         }
      }
      
      public function playListener() : void
      {
         this.btnPlay.selected = true;
      }
      
      public function pauseListener() : void
      {
         this.btnPlay.selected = false;
      }
      
      public function init(param1:int) : void
      {
         this._totalFrame = param1;
         this.timeLine.maximum = UtilUnitConvert.frameToDuration(this._totalFrame);
      }
      
      public function enableTimeLine(param1:Boolean = true) : void
      {
         this.timeLine.enabled = param1;
      }
      
      private function onTimeLinePress(param1:Event) : void
      {
         this._isTimeLineDragging = true;
         this.dispatchEvent(new Event(PlayerControl.ON_TIMELINE_PRESS));
      }
      
      private function onTimeLineRelease(param1:Event) : void
      {
         this._isTimeLineDragging = false;
         this.dispatchEvent(new Event(PlayerControl.ON_TIMELINE_RELEASE));
      }
      
      protected function onPlayButton(param1:MouseEvent) : void
      {
         if(this.btnPlay.selected)
         {
            dispatchEvent(new MouseEvent(PlayerControl.ON_PLAY_BUT_CLICK));
         }
         else
         {
            dispatchEvent(new MouseEvent(PlayerControl.ON_PAUSE_BUT_CLICK));
         }
      }
      
      public function disableFullScreen() : void
      {
         this.fullScreenControl.visible = this.fullScreenControl.includeInLayout = false;
      }
      
      public function set plainPlayer(param1:PlainPlayer) : void
      {
         this.timeLine.plainPlayer = param1;
      }
      
      private function _PlayerControl_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.fill = this._PlayerControl_SolidColor1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _PlayerControl_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 594708;
         _loc1_.alpha = 0.7;
         return _loc1_;
      }
      
      private function _PlayerControl_Group2_c() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.layout = this._PlayerControl_HorizontalLayout1_c();
         _loc1_.mxmlContent = [this._PlayerControl_Group3_c(),this._PlayerControl_TimerDisplay1_i(),this._PlayerControl_VolumeControl1_c(),this._PlayerControl_FullScreenControl1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _PlayerControl_HorizontalLayout1_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.verticalAlign = "middle";
         _loc1_.paddingLeft = 5;
         _loc1_.paddingRight = 5;
         _loc1_.gap = 5;
         return _loc1_;
      }
      
      private function _PlayerControl_Group3_c() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._PlayerControl_Group4_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _PlayerControl_Group4_c() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.layout = this._PlayerControl_HorizontalLayout2_c();
         _loc1_.mxmlContent = [this._PlayerControl_ToggleButton1_i(),this._PlayerControl_TimelineControl1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _PlayerControl_HorizontalLayout2_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.verticalAlign = "middle";
         return _loc1_;
      }
      
      private function _PlayerControl_ToggleButton1_i() : ToggleButton
      {
         var _loc1_:ToggleButton = new ToggleButton();
         _loc1_.buttonMode = true;
         _loc1_.setStyle("skinClass",PlayToggleButtonSkin);
         _loc1_.addEventListener("click",this.__btnPlay_click);
         _loc1_.id = "btnPlay";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnPlay = _loc1_;
         BindingManager.executeBindings(this,"btnPlay",this.btnPlay);
         return _loc1_;
      }
      
      public function __btnPlay_click(param1:MouseEvent) : void
      {
         this.onPlayButton(param1);
      }
      
      private function _PlayerControl_TimelineControl1_i() : TimelineControl
      {
         var _loc1_:TimelineControl = new TimelineControl();
         _loc1_.enabled = false;
         _loc1_.addEventListener("change",this.__timeLine_change);
         _loc1_.addEventListener("thumbPress",this.__timeLine_thumbPress);
         _loc1_.addEventListener("thumbRelease",this.__timeLine_thumbRelease);
         _loc1_.id = "timeLine";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.timeLine = _loc1_;
         BindingManager.executeBindings(this,"timeLine",this.timeLine);
         return _loc1_;
      }
      
      public function __timeLine_change(param1:Event) : void
      {
         this.onTimeLineDragging(param1);
      }
      
      public function __timeLine_thumbPress(param1:TrackBaseEvent) : void
      {
         this.onTimeLinePress(param1);
      }
      
      public function __timeLine_thumbRelease(param1:TrackBaseEvent) : void
      {
         this.onTimeLineRelease(param1);
      }
      
      private function _PlayerControl_TimerDisplay1_i() : TimerDisplay
      {
         var _loc1_:TimerDisplay = new TimerDisplay();
         _loc1_.id = "timerDisplay";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.timerDisplay = _loc1_;
         BindingManager.executeBindings(this,"timerDisplay",this.timerDisplay);
         return _loc1_;
      }
      
      private function _PlayerControl_VolumeControl1_c() : VolumeControl
      {
         var _loc1_:VolumeControl = new VolumeControl();
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _PlayerControl_FullScreenControl1_i() : FullScreenControl
      {
         var _loc1_:FullScreenControl = new FullScreenControl();
         _loc1_.id = "fullScreenControl";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.fullScreenControl = _loc1_;
         BindingManager.executeBindings(this,"fullScreenControl",this.fullScreenControl);
         return _loc1_;
      }
      
      public function ___PlayerControl_Group1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationCompleted();
      }
      
      private function _PlayerControl_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():uint
         {
            return _curFrame;
         },null,"timerDisplay.currentFrame");
         result[1] = new Binding(this,function():uint
         {
            return _totalFrame;
         },null,"timerDisplay.totalFrame");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get btnPlay() : ToggleButton
      {
         return this._206106544btnPlay;
      }
      
      public function set btnPlay(param1:ToggleButton) : void
      {
         var _loc2_:Object = this._206106544btnPlay;
         if(_loc2_ !== param1)
         {
            this._206106544btnPlay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnPlay",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fullScreenControl() : FullScreenControl
      {
         return this._673913090fullScreenControl;
      }
      
      public function set fullScreenControl(param1:FullScreenControl) : void
      {
         var _loc2_:Object = this._673913090fullScreenControl;
         if(_loc2_ !== param1)
         {
            this._673913090fullScreenControl = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fullScreenControl",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get timeLine() : TimelineControl
      {
         return this._2077603743timeLine;
      }
      
      public function set timeLine(param1:TimelineControl) : void
      {
         var _loc2_:Object = this._2077603743timeLine;
         if(_loc2_ !== param1)
         {
            this._2077603743timeLine = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeLine",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get timerDisplay() : TimerDisplay
      {
         return this._431284669timerDisplay;
      }
      
      public function set timerDisplay(param1:TimerDisplay) : void
      {
         var _loc2_:Object = this._431284669timerDisplay;
         if(_loc2_ !== param1)
         {
            this._431284669timerDisplay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timerDisplay",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _curFrame() : int
      {
         return this._625660012_curFrame;
      }
      
      private function set _curFrame(param1:int) : void
      {
         var _loc2_:Object = this._625660012_curFrame;
         if(_loc2_ !== param1)
         {
            this._625660012_curFrame = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_curFrame",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _totalFrame() : int
      {
         return this._359767592_totalFrame;
      }
      
      private function set _totalFrame(param1:int) : void
      {
         var _loc2_:Object = this._359767592_totalFrame;
         if(_loc2_ !== param1)
         {
            this._359767592_totalFrame = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_totalFrame",_loc2_,param1));
            }
         }
      }
   }
}
