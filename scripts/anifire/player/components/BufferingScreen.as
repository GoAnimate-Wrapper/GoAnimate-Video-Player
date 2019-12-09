package anifire.player.components
{
   import mx.controls.SWFLoader;
   import mx.core.IFlexModuleFactory;
   import mx.graphics.SolidColor;
   import spark.components.Group;
   import spark.primitives.Rect;
   
   public class BufferingScreen extends Group
   {
       
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _embed_mxml__styles_images_player_loading_loading_swf_2139030116:Class;
      
      public function BufferingScreen()
      {
         this._embed_mxml__styles_images_player_loading_loading_swf_2139030116 = BufferingScreen__embed_mxml__styles_images_player_loading_loading_swf_2139030116;
         super();
         mx_internal::_document = this;
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.mxmlContent = [this._BufferingScreen_Rect1_c(),this._BufferingScreen_SWFLoader1_c()];
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
      
      private function _BufferingScreen_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.fill = this._BufferingScreen_SolidColor1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _BufferingScreen_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.5;
         return _loc1_;
      }
      
      private function _BufferingScreen_SWFLoader1_c() : SWFLoader
      {
         var _loc1_:SWFLoader = new SWFLoader();
         _loc1_.source = this._embed_mxml__styles_images_player_loading_loading_swf_2139030116;
         _loc1_.horizontalCenter = 0;
         _loc1_.verticalCenter = 0;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
   }
}
