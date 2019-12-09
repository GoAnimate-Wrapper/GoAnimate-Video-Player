package anifire.player.skins
{
   import mx.binding.BindingManager;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.events.PropertyChangeEvent;
   import mx.states.SetProperty;
   import mx.states.State;
   import spark.primitives.BitmapImage;
   import spark.skins.SparkButtonSkin;
   
   public class MuteToggleButtonSkin extends SparkButtonSkin implements IStateClient2
   {
      
      private static const exclusions:Array = ["labelDisplay"];
       
      
      private var _605754537_MuteToggleButtonSkin_BitmapImage1:BitmapImage;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var cornerRadius:Number = 2;
      
      private var _embed_mxml__styles_images_player_control_bar_btn_volume_over_png_321155040:Class;
      
      private var _embed_mxml__styles_images_player_control_bar_btn_mute_init_png_100524510:Class;
      
      private var _embed_mxml__styles_images_player_control_bar_btn_mute_over_png_1694082526:Class;
      
      private var _embed_mxml__styles_images_player_control_bar_btn_volume_init_png_523354080:Class;
      
      public function MuteToggleButtonSkin()
      {
         this._embed_mxml__styles_images_player_control_bar_btn_volume_over_png_321155040 = MuteToggleButtonSkin__embed_mxml__styles_images_player_control_bar_btn_volume_over_png_321155040;
         this._embed_mxml__styles_images_player_control_bar_btn_mute_init_png_100524510 = MuteToggleButtonSkin__embed_mxml__styles_images_player_control_bar_btn_mute_init_png_100524510;
         this._embed_mxml__styles_images_player_control_bar_btn_mute_over_png_1694082526 = MuteToggleButtonSkin__embed_mxml__styles_images_player_control_bar_btn_mute_over_png_1694082526;
         this._embed_mxml__styles_images_player_control_bar_btn_volume_init_png_523354080 = MuteToggleButtonSkin__embed_mxml__styles_images_player_control_bar_btn_volume_init_png_523354080;
         super();
         mx_internal::_document = this;
         this.minWidth = 21;
         this.minHeight = 21;
         this.mxmlContent = [this._MuteToggleButtonSkin_BitmapImage1_i()];
         this.currentState = "up";
         states = [new State({
            "name":"up",
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_MuteToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_volume_init_png_523354080
            })]
         }),new State({
            "name":"over",
            "stateGroups":["overStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_MuteToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_volume_over_png_321155040
            })]
         }),new State({
            "name":"down",
            "stateGroups":["downStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_MuteToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_volume_init_png_523354080
            })]
         }),new State({
            "name":"disabled",
            "stateGroups":["disabledStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            }),new SetProperty().initializeFromObject({
               "target":"_MuteToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_volume_init_png_523354080
            })]
         }),new State({
            "name":"upAndSelected",
            "stateGroups":["selectedStates","selectedUpStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_MuteToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_mute_init_png_100524510
            })]
         }),new State({
            "name":"overAndSelected",
            "stateGroups":["selectedStates","overStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_MuteToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_mute_over_png_1694082526
            })]
         }),new State({
            "name":"downAndSelected",
            "stateGroups":["selectedStates","downStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_MuteToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_mute_init_png_100524510
            })]
         }),new State({
            "name":"disabledAndSelected",
            "stateGroups":["selectedStates","selectedUpStates","disabledStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            }),new SetProperty().initializeFromObject({
               "target":"_MuteToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_mute_init_png_100524510
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
      
      private function _MuteToggleButtonSkin_BitmapImage1_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.source = this._embed_mxml__styles_images_player_control_bar_btn_volume_init_png_523354080;
         _loc1_.smooth = true;
         _loc1_.initialized(this,"_MuteToggleButtonSkin_BitmapImage1");
         this._MuteToggleButtonSkin_BitmapImage1 = _loc1_;
         BindingManager.executeBindings(this,"_MuteToggleButtonSkin_BitmapImage1",this._MuteToggleButtonSkin_BitmapImage1);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get _MuteToggleButtonSkin_BitmapImage1() : BitmapImage
      {
         return this._605754537_MuteToggleButtonSkin_BitmapImage1;
      }
      
      public function set _MuteToggleButtonSkin_BitmapImage1(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._605754537_MuteToggleButtonSkin_BitmapImage1;
         if(_loc2_ !== param1)
         {
            this._605754537_MuteToggleButtonSkin_BitmapImage1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_MuteToggleButtonSkin_BitmapImage1",_loc2_,param1));
            }
         }
      }
   }
}
