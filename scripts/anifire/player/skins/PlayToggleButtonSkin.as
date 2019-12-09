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
   
   public class PlayToggleButtonSkin extends SparkButtonSkin implements IStateClient2
   {
      
      private static const exclusions:Array = ["labelDisplay"];
       
      
      private var _1411814766_PlayToggleButtonSkin_BitmapImage1:BitmapImage;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var cornerRadius:Number = 2;
      
      private var _embed_mxml__styles_images_player_control_bar_btn_play_over_png_1109149740:Class;
      
      private var _embed_mxml__styles_images_player_control_bar_btn_pause_init_png_1977212402:Class;
      
      private var _embed_mxml__styles_images_player_control_bar_btn_pause_over_png_1784152718:Class;
      
      private var _embed_mxml__styles_images_player_control_bar_btn_play_init_png_1709286820:Class;
      
      public function PlayToggleButtonSkin()
      {
         this._embed_mxml__styles_images_player_control_bar_btn_play_over_png_1109149740 = PlayToggleButtonSkin__embed_mxml__styles_images_player_control_bar_btn_play_over_png_1109149740;
         this._embed_mxml__styles_images_player_control_bar_btn_pause_init_png_1977212402 = PlayToggleButtonSkin__embed_mxml__styles_images_player_control_bar_btn_pause_init_png_1977212402;
         this._embed_mxml__styles_images_player_control_bar_btn_pause_over_png_1784152718 = PlayToggleButtonSkin__embed_mxml__styles_images_player_control_bar_btn_pause_over_png_1784152718;
         this._embed_mxml__styles_images_player_control_bar_btn_play_init_png_1709286820 = PlayToggleButtonSkin__embed_mxml__styles_images_player_control_bar_btn_play_init_png_1709286820;
         super();
         mx_internal::_document = this;
         this.minWidth = 21;
         this.minHeight = 21;
         this.mxmlContent = [this._PlayToggleButtonSkin_BitmapImage1_i()];
         this.currentState = "up";
         states = [new State({
            "name":"up",
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_PlayToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_play_init_png_1709286820
            })]
         }),new State({
            "name":"over",
            "stateGroups":["overStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_PlayToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_play_over_png_1109149740
            })]
         }),new State({
            "name":"down",
            "stateGroups":["downStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_PlayToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_play_init_png_1709286820
            })]
         }),new State({
            "name":"disabled",
            "stateGroups":["disabledStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            }),new SetProperty().initializeFromObject({
               "target":"_PlayToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_play_init_png_1709286820
            })]
         }),new State({
            "name":"upAndSelected",
            "stateGroups":["selectedStates","selectedUpStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_PlayToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_pause_init_png_1977212402
            })]
         }),new State({
            "name":"overAndSelected",
            "stateGroups":["selectedStates","overStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_PlayToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_pause_over_png_1784152718
            })]
         }),new State({
            "name":"downAndSelected",
            "stateGroups":["selectedStates","downStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_PlayToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_pause_init_png_1977212402
            })]
         }),new State({
            "name":"disabledAndSelected",
            "stateGroups":["selectedStates","selectedUpStates","disabledStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            }),new SetProperty().initializeFromObject({
               "target":"_PlayToggleButtonSkin_BitmapImage1",
               "name":"source",
               "value":this._embed_mxml__styles_images_player_control_bar_btn_pause_init_png_1977212402
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
      
      private function _PlayToggleButtonSkin_BitmapImage1_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.source = this._embed_mxml__styles_images_player_control_bar_btn_play_init_png_1709286820;
         _loc1_.smooth = true;
         _loc1_.initialized(this,"_PlayToggleButtonSkin_BitmapImage1");
         this._PlayToggleButtonSkin_BitmapImage1 = _loc1_;
         BindingManager.executeBindings(this,"_PlayToggleButtonSkin_BitmapImage1",this._PlayToggleButtonSkin_BitmapImage1);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get _PlayToggleButtonSkin_BitmapImage1() : BitmapImage
      {
         return this._1411814766_PlayToggleButtonSkin_BitmapImage1;
      }
      
      public function set _PlayToggleButtonSkin_BitmapImage1(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._1411814766_PlayToggleButtonSkin_BitmapImage1;
         if(_loc2_ !== param1)
         {
            this._1411814766_PlayToggleButtonSkin_BitmapImage1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_PlayToggleButtonSkin_BitmapImage1",_loc2_,param1));
            }
         }
      }
   }
}
