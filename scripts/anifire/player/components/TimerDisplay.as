package anifire.player.components
{
   import anifire.util.UtilString;
   import anifire.util.UtilUnitConvert;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.SolidColor;
   import mx.states.SetProperty;
   import mx.states.State;
   import spark.components.Group;
   import spark.components.Label;
   import spark.primitives.Rect;
   
   use namespace mx_internal;
   
   public class TimerDisplay extends Group implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _1440857536_TimerDisplay_Label1:Label;
      
      private var _529228163_TimerDisplay_SetProperty1:SetProperty;
      
      private var _529228162_TimerDisplay_SetProperty2:SetProperty;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _currentFrame:uint;
      
      private var _totalFrame:uint;
      
      private var _totalTimeString:String = "00:00";
      
      private var _91294636_time:String = "00:00/00:00";
      
      private var _981817656_message:String = "";
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function TimerDisplay()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._TimerDisplay_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_anifire_player_components_TimerDisplayWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return TimerDisplay[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 112;
         this.height = 26;
         this.mxmlContent = [this._TimerDisplay_Rect1_c(),this._TimerDisplay_Label1_i()];
         this.currentState = "timer";
         states = [new State({
            "name":"timer",
            "overrides":[this._TimerDisplay_SetProperty2 = SetProperty(new SetProperty().initializeFromObject({
               "target":"_TimerDisplay_Label1",
               "name":"text",
               "value":undefined
            }))]
         }),new State({
            "name":"message",
            "overrides":[this._TimerDisplay_SetProperty1 = SetProperty(new SetProperty().initializeFromObject({
               "target":"_TimerDisplay_Label1",
               "name":"text",
               "value":undefined
            }))]
         }),new State({
            "name":"disabled",
            "overrides":[]
         })];
         BindingManager.executeBindings(this,"_TimerDisplay_SetProperty2",this._TimerDisplay_SetProperty2);
         BindingManager.executeBindings(this,"_TimerDisplay_SetProperty1",this._TimerDisplay_SetProperty1);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         TimerDisplay._watcherSetupUtil = param1;
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
      
      public function set currentFrame(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         if(this._currentFrame != param1)
         {
            this._currentFrame = param1;
            _loc2_ = UtilUnitConvert.frameToTime(this._currentFrame,this._currentFrame < this._totalFrame);
            this._time = UtilString.secToTimeString(_loc2_,false) + " / " + this._totalTimeString;
         }
      }
      
      public function set totalFrame(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         if(this._totalFrame != param1)
         {
            this._totalFrame = param1;
            _loc2_ = UtilUnitConvert.frameToDuration(this._totalFrame);
            this._totalTimeString = UtilString.secToTimeString(_loc2_,false);
         }
      }
      
      public function set text(param1:String) : void
      {
         if(param1 && param1 != "")
         {
            this._message = param1;
            this.currentState = "message";
         }
         else
         {
            this.currentState = "timer";
         }
      }
      
      private function _TimerDisplay_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.radiusX = 3;
         _loc1_.radiusY = 3;
         _loc1_.fill = this._TimerDisplay_SolidColor1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _TimerDisplay_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         return _loc1_;
      }
      
      private function _TimerDisplay_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.horizontalCenter = 0;
         _loc1_.verticalCenter = 0;
         _loc1_.setStyle("fontSize",13);
         _loc1_.setStyle("fontFamily","LatoRegular");
         _loc1_.setStyle("color",16777215);
         _loc1_.id = "_TimerDisplay_Label1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._TimerDisplay_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_TimerDisplay_Label1",this._TimerDisplay_Label1);
         return _loc1_;
      }
      
      private function _TimerDisplay_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():*
         {
            return _message;
         },null,"_TimerDisplay_SetProperty1.value");
         result[1] = new Binding(this,function():*
         {
            return _time;
         },null,"_TimerDisplay_SetProperty2.value");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get _TimerDisplay_Label1() : Label
      {
         return this._1440857536_TimerDisplay_Label1;
      }
      
      public function set _TimerDisplay_Label1(param1:Label) : void
      {
         var _loc2_:Object = this._1440857536_TimerDisplay_Label1;
         if(_loc2_ !== param1)
         {
            this._1440857536_TimerDisplay_Label1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TimerDisplay_Label1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TimerDisplay_SetProperty1() : SetProperty
      {
         return this._529228163_TimerDisplay_SetProperty1;
      }
      
      public function set _TimerDisplay_SetProperty1(param1:SetProperty) : void
      {
         var _loc2_:Object = this._529228163_TimerDisplay_SetProperty1;
         if(_loc2_ !== param1)
         {
            this._529228163_TimerDisplay_SetProperty1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TimerDisplay_SetProperty1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TimerDisplay_SetProperty2() : SetProperty
      {
         return this._529228162_TimerDisplay_SetProperty2;
      }
      
      public function set _TimerDisplay_SetProperty2(param1:SetProperty) : void
      {
         var _loc2_:Object = this._529228162_TimerDisplay_SetProperty2;
         if(_loc2_ !== param1)
         {
            this._529228162_TimerDisplay_SetProperty2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TimerDisplay_SetProperty2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _time() : String
      {
         return this._91294636_time;
      }
      
      private function set _time(param1:String) : void
      {
         var _loc2_:Object = this._91294636_time;
         if(_loc2_ !== param1)
         {
            this._91294636_time = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_time",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _message() : String
      {
         return this._981817656_message;
      }
      
      private function set _message(param1:String) : void
      {
         var _loc2_:Object = this._981817656_message;
         if(_loc2_ !== param1)
         {
            this._981817656_message = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_message",_loc2_,param1));
            }
         }
      }
   }
}
