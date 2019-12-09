package anifire.player.components
{
   import anifire.player.skins.TimelineToolTipSkin;
   import mx.core.IFlexModuleFactory;
   import spark.components.Label;
   import spark.components.supportClasses.SkinnableComponent;
   
   public class TimelineToolTip extends SkinnableComponent
   {
       
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      [SkinPart(required="true")]
      public var label:Label;
      
      public function TimelineToolTip()
      {
         super();
         this.minHeight = 24;
         this.minWidth = 40;
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
            this.skinClass = TimelineToolTipSkin;
         };
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      public function set text(param1:String) : void
      {
         this.label.text = param1;
      }
   }
}
