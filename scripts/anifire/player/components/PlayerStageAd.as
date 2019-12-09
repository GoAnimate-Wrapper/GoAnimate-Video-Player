package anifire.player.components
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.binding.BindingManager;
   import mx.core.IFlexModuleFactory;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.SolidColor;
   import spark.components.Group;
   import spark.components.Label;
   import spark.effects.Fade;
   import spark.primitives.Rect;
   
   public class PlayerStageAd extends Group
   {
       
      
      private var _1282133823fadeIn:Fade;
      
      private var _1091436750fadeOut:Fade;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function PlayerStageAd()
      {
         super();
         mx_internal::_document = this;
         this.mxmlContent = [this._PlayerStageAd_Group2_c()];
         this._PlayerStageAd_Fade1_i();
         this._PlayerStageAd_Fade2_i();
         this.addEventListener("creationComplete",this.___PlayerStageAd_Group1_creationComplete);
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
      
      protected function onCreationComplete(param1:FlexEvent) : void
      {
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this.visible = !this.visible;
      }
      
      public function turnOn() : void
      {
         var _loc1_:Timer = new Timer(3000);
         _loc1_.addEventListener(TimerEvent.TIMER,this.onTimer);
         _loc1_.start();
      }
      
      private function _PlayerStageAd_Fade1_i() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.duration#1 = 500;
         this.fadeIn = _loc1_;
         BindingManager.executeBindings(this,"fadeIn",this.fadeIn);
         return _loc1_;
      }
      
      private function _PlayerStageAd_Fade2_i() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.alphaFrom = 1;
         _loc1_.alphaTo = 0;
         _loc1_.duration#1 = 500;
         this.fadeOut = _loc1_;
         BindingManager.executeBindings(this,"fadeOut",this.fadeOut);
         return _loc1_;
      }
      
      private function _PlayerStageAd_Group2_c() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._PlayerStageAd_Rect1_c(),this._PlayerStageAd_Label1_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _PlayerStageAd_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.fill = this._PlayerStageAd_SolidColor1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _PlayerStageAd_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.6;
         return _loc1_;
      }
      
      private function _PlayerStageAd_Label1_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "This video has been made using a business exclusive theme. To publish this video, please upgrade to a Business plan.";
         _loc1_.top = 10;
         _loc1_.left = 10;
         _loc1_.right = 10;
         _loc1_.bottom = 10;
         _loc1_.percentWidth = 100;
         _loc1_.setStyle("fontSize",12);
         _loc1_.setStyle("fontFamily","LatoRegular");
         _loc1_.setStyle("color",16777215);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___PlayerStageAd_Group1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn() : Fade
      {
         return this._1282133823fadeIn;
      }
      
      public function set fadeIn(param1:Fade) : void
      {
         var _loc2_:Object = this._1282133823fadeIn;
         if(_loc2_ !== param1)
         {
            this._1282133823fadeIn = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeOut() : Fade
      {
         return this._1091436750fadeOut;
      }
      
      public function set fadeOut(param1:Fade) : void
      {
         var _loc2_:Object = this._1091436750fadeOut;
         if(_loc2_ !== param1)
         {
            this._1091436750fadeOut = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeOut",_loc2_,param1));
            }
         }
      }
   }
}
