package anifire.player.components
{
   import anifire.player.playback.PlainPlayer;
   import anifire.player.skins.TimelineHSliderSkin;
   import flash.events.MouseEvent;
   import mx.core.IFlexModuleFactory;
   import spark.components.HSlider;
   import spark.events.TrackBaseEvent;
   
   public class TimelineControl extends HSlider
   {
       
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      [SkinPart(required="true")]
      public var sceneBufferProgressBar:SceneBufferProgressBar;
      
      public function TimelineControl()
      {
         super();
         this.percentWidth = 100;
         this.buttonMode = true;
         this.minimum = 0;
         this.snapInterval = 0.05;
         this.showDataTip = false;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         var factory:IFlexModuleFactory = param1;
         super.moduleFactory = factory;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration(null,styleManager);
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.slideDuration = 0;
            this.skinClass = TimelineHSliderSkin;
         };
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override protected function track_mouseDownHandler(param1:MouseEvent) : void
      {
         super.track_mouseDownHandler(param1);
         this.stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp);
      }
      
      private function onStageMouseUp(param1:MouseEvent) : void
      {
         this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp);
         this.dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_RELEASE));
      }
      
      public function set plainPlayer(param1:PlainPlayer) : void
      {
         if(this.sceneBufferProgressBar)
         {
            this.sceneBufferProgressBar.plainPlayer = param1;
         }
      }
   }
}
