package anifire.player.assetTransitions.views
{
   import anifire.assets.transition.AssetTransitionConstants;
   import anifire.constant.ServerConstants;
   import anifire.managers.AppConfigManager;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   
   public class HandClip extends Sprite
   {
      
      private static const HAND_OFFSET_X:Number = -10;
      
      private static const HAND_OFFSET_Y:Number = 150;
      
      private static const HAND_CLIP_PATH:String = "go/swf/player/hand.swf";
       
      
      private var _loader:Loader;
      
      public function HandClip()
      {
         super();
      }
      
      public function set destination(param1:uint) : void
      {
         switch(param1)
         {
            case AssetTransitionConstants.DEST_TL:
               this.rotation = 135;
               break;
            case AssetTransitionConstants.DEST_TOP:
               this.rotation = 180;
               break;
            case AssetTransitionConstants.DEST_TR:
               this.rotation = -135;
               break;
            case AssetTransitionConstants.DEST_LEFT:
               this.rotation = 90;
               break;
            case AssetTransitionConstants.DEST_RIGHT:
               this.rotation = -90;
               break;
            case AssetTransitionConstants.DEST_BL:
               this.rotation = 45;
               break;
            case AssetTransitionConstants.DEST_BOTTOM:
               this.rotation = 0;
               break;
            case AssetTransitionConstants.DEST_BR:
               this.rotation = -45;
         }
      }
      
      public function loadHand() : void
      {
         var _loc1_:RegExp = null;
         var _loc2_:String = null;
         var _loc3_:URLRequest = null;
         if(!this._loader)
         {
            this._loader = new Loader();
            this._loader.x = HAND_OFFSET_X;
            this._loader.y = HAND_OFFSET_Y;
            addChild(this._loader);
            _loc1_ = new RegExp(ServerConstants.FLASHVAR_CLIENT_THEME_PLACEHOLDER,"g");
            _loc2_ = AppConfigManager.instance.getValue(ServerConstants.FLASHVAR_CLIENT_THEME_PATH);
            _loc2_ = _loc2_.replace(_loc1_,HAND_CLIP_PATH);
            _loc3_ = new URLRequest(_loc2_);
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loader_completeHandler);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loader_errorHandler);
            this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_errorHandler);
            this._loader.load(_loc3_);
         }
      }
      
      private function loader_completeHandler(param1:Event) : void
      {
         this._loader.removeEventListener(Event.COMPLETE,this.loader_completeHandler);
         this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.loader_errorHandler);
         this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_errorHandler);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function loader_errorHandler(param1:Event) : void
      {
         this._loader.removeEventListener(Event.COMPLETE,this.loader_completeHandler);
         this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.loader_errorHandler);
         this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_errorHandler);
      }
   }
}
