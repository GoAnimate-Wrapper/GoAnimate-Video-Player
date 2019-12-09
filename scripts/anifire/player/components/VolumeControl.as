package anifire.player.components
{
   import anifire.constant.AnimeConstants;
   import anifire.player.skins.MuteToggleButtonSkin;
   import anifire.player.skins.VolumeHSliderSkin;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.net.SharedObject;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import spark.components.Group;
   import spark.components.HSlider;
   import spark.components.ToggleButton;
   import spark.layouts.HorizontalLayout;
   
   use namespace mx_internal;
   
   public class VolumeControl extends Group implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _1413468584muteBut:ToggleButton;
      
      private var _1698099045volumeSlider:HSlider;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _1897587769_volume:Number;
      
      private var _volumeBeforeMute:Number;
      
      private var _91097848_mute:Boolean;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function VolumeControl()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._VolumeControl_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_anifire_player_components_VolumeControlWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return VolumeControl[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.layout = this._VolumeControl_HorizontalLayout1_c();
         this.mxmlContent = [this._VolumeControl_ToggleButton1_i(),this._VolumeControl_HSlider1_i()];
         this.addEventListener("creationComplete",this.___VolumeControl_Group1_creationComplete);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         VolumeControl._watcherSetupUtil = param1;
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
      
      private function get volume() : Number
      {
         return this._volume;
      }
      
      private function set volume(param1:Number) : void
      {
         if(this._volume != param1 && param1 >= 0 && param1 <= 1)
         {
            this._volume = param1;
            this._mute = this._volume == 0;
            SoundMixer.soundTransform = new SoundTransform(this._volume);
         }
      }
      
      private function onVolumeSliderChange(param1:Event) : void
      {
         this.volume = this.volumeSlider.value;
      }
      
      private function onCreationCompleted() : void
      {
         this._volumeBeforeMute = AnimeConstants.DEFAULT_VOLUME;
         this.volume = AnimeConstants.DEFAULT_VOLUME;
         var _loc1_:SharedObject = this.getPlayerPreferences();
         if(_loc1_)
         {
            this.volume = _loc1_.data.volume;
         }
      }
      
      protected function getPlayerPreferences() : SharedObject
      {
         var preferences:SharedObject = null;
         try
         {
            preferences = SharedObject.getLocal("playerPreferences");
         }
         catch(e:Error)
         {
            preferences = null;
         }
         return preferences;
      }
      
      protected function onMuteButtonClick(param1:MouseEvent) : void
      {
         this._mute = this.muteBut.selected;
         if(this._mute)
         {
            this._volumeBeforeMute = this._volume;
            this.volume = 0;
         }
         else
         {
            this.volume = this._volumeBeforeMute;
         }
         this.saveVolume();
      }
      
      private function saveVolume() : void
      {
         var _loc1_:SharedObject = this.getPlayerPreferences();
         if(_loc1_)
         {
            _loc1_.data.volume = this.volume;
            _loc1_.flush();
         }
      }
      
      private function _VolumeControl_HorizontalLayout1_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.verticalAlign = "middle";
         _loc1_.gap = 5;
         return _loc1_;
      }
      
      private function _VolumeControl_ToggleButton1_i() : ToggleButton
      {
         var _loc1_:ToggleButton = new ToggleButton();
         _loc1_.buttonMode = true;
         _loc1_.setStyle("skinClass",MuteToggleButtonSkin);
         _loc1_.addEventListener("click",this.__muteBut_click);
         _loc1_.id = "muteBut";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.muteBut = _loc1_;
         BindingManager.executeBindings(this,"muteBut",this.muteBut);
         return _loc1_;
      }
      
      public function __muteBut_click(param1:MouseEvent) : void
      {
         this.onMuteButtonClick(param1);
      }
      
      private function _VolumeControl_HSlider1_i() : HSlider
      {
         var _loc1_:HSlider = new HSlider();
         _loc1_.width = 60;
         _loc1_.buttonMode = true;
         _loc1_.snapInterval = 0.01;
         _loc1_.maximum = 1;
         _loc1_.minimum = 0;
         _loc1_.showDataTip = false;
         _loc1_.setStyle("liveDragging",true);
         _loc1_.setStyle("skinClass",VolumeHSliderSkin);
         _loc1_.addEventListener("change",this.__volumeSlider_change);
         _loc1_.id = "volumeSlider";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.volumeSlider = _loc1_;
         BindingManager.executeBindings(this,"volumeSlider",this.volumeSlider);
         return _loc1_;
      }
      
      public function __volumeSlider_change(param1:Event) : void
      {
         this.onVolumeSliderChange(param1);
      }
      
      public function ___VolumeControl_Group1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationCompleted();
      }
      
      private function _VolumeControl_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Boolean
         {
            return _mute;
         },null,"muteBut.selected");
         result[1] = new Binding(this,function():Number
         {
            return _volume;
         },null,"volumeSlider.value");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get muteBut() : ToggleButton
      {
         return this._1413468584muteBut;
      }
      
      public function set muteBut(param1:ToggleButton) : void
      {
         var _loc2_:Object = this._1413468584muteBut;
         if(_loc2_ !== param1)
         {
            this._1413468584muteBut = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"muteBut",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get volumeSlider() : HSlider
      {
         return this._1698099045volumeSlider;
      }
      
      public function set volumeSlider(param1:HSlider) : void
      {
         var _loc2_:Object = this._1698099045volumeSlider;
         if(_loc2_ !== param1)
         {
            this._1698099045volumeSlider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"volumeSlider",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _volume() : Number
      {
         return this._1897587769_volume;
      }
      
      private function set _volume(param1:Number) : void
      {
         var _loc2_:Object = this._1897587769_volume;
         if(_loc2_ !== param1)
         {
            this._1897587769_volume = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_volume",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _mute() : Boolean
      {
         return this._91097848_mute;
      }
      
      private function set _mute(param1:Boolean) : void
      {
         var _loc2_:Object = this._91097848_mute;
         if(_loc2_ !== param1)
         {
            this._91097848_mute = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_mute",_loc2_,param1));
            }
         }
      }
   }
}
