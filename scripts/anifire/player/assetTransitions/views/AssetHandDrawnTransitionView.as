package anifire.player.assetTransitions.views
{
   import anifire.assets.transition.AssetTransitionConstants;
   import anifire.constant.ThemeConstants;
   import anifire.player.assetTransitions.models.AssetHandDrawnTransition;
   import anifire.player.assetTransitions.models.AssetTransition;
   import anifire.player.interfaces.IPlayerAssetView;
   import anifire.player.managers.WhiteboardHandManager;
   import anifire.player.playback.AnimeScene;
   import anifire.player.playback.Asset;
   import anifire.player.playback.BubbleAsset;
   import anifire.player.playback.Character;
   import anifire.player.playback.Prop;
   import anifire.player.whiteboard.PlayerMaskGridModel;
   import anifire.player.whiteboard.WhiteboardLoader;
   import anifire.player.whiteboard.WhiteboardMask;
   import anifire.util.UtilMath;
   import anifire.whiteboard.models.MaskGridModel;
   import flash.display.Shader;
   import flash.events.Event;
   import flash.filters.ShaderFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class AssetHandDrawnTransitionView extends AssetTransitionView
   {
       
      
      private var _mask:WhiteboardMask;
      
      private var _hand:WhiteboardHand;
      
      private var _sequence:Vector.<MaskGridModel>;
      
      private var _bundleBounds:Rectangle;
      
      private var _isGenericMask:Boolean;
      
      private var _origin:Point;
      
      private var ShaderKernel:Class;
      
      private var _shaderFilter:ShaderFilter;
      
      private var _assetThemeId:String;
      
      private var _whiteboardHandStyle:int = 1;
      
      private var _isHand:Boolean = true;
      
      private var _loader:WhiteboardHandLoader;
      
      private var _scene:AnimeScene;
      
      public function AssetHandDrawnTransitionView(param1:IPlayerAssetView)
      {
         this._mask = new WhiteboardMask();
         this.ShaderKernel = AssetHandDrawnTransitionView_ShaderKernel;
         super(param1);
      }
      
      override public function set asset(param1:Asset) : void
      {
         super.asset = param1;
      }
      
      override public function initRemoteData() : void
      {
         this.loadHandClip();
      }
      
      private function loadHandClip() : void
      {
         this._scene = asset.parentScene;
         this._scene.initHandDrawnEffect();
         this._hand = this._scene.handDrawnEffect;
         this._loader = WhiteboardHandManager.instance.getClipLoader(this._whiteboardHandStyle,this._isHand);
         if(this._loader)
         {
            if(this._loader.loaded)
            {
               this.loadMaskData();
            }
            else
            {
               this._loader.addEventListener(Event.COMPLETE,this.whiteboardHandLoader_completeHandler);
               this._loader.addEventListener(Event.CANCEL,this.whiteboardHandLoader_cancelHandler);
               this._loader.loadClip();
            }
         }
         else
         {
            this.loadMaskData();
         }
      }
      
      private function whiteboardHandLoader_completeHandler(param1:Event) : void
      {
         this._loader.removeEventListener(Event.COMPLETE,this.whiteboardHandLoader_completeHandler);
         this._loader.removeEventListener(Event.CANCEL,this.whiteboardHandLoader_cancelHandler);
         this.loadMaskData();
      }
      
      private function whiteboardHandLoader_cancelHandler(param1:Event) : void
      {
         this._loader.removeEventListener(Event.COMPLETE,this.whiteboardHandLoader_completeHandler);
         this._loader.removeEventListener(Event.CANCEL,this.whiteboardHandLoader_cancelHandler);
         this.loadMaskData();
      }
      
      private function loadMaskData() : void
      {
         var _loc2_:String = null;
         var _loc4_:Array = null;
         var _loc1_:Asset = this.asset;
         this._assetThemeId = _loc1_.themeId;
         if(this._assetThemeId == ThemeConstants.WHITEBOARD_THEME_ID && this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
         {
            if(_loc1_ is Prop)
            {
               _loc2_ = (_loc1_ as Prop).file;
               _loc2_ = _loc2_.replace(/\.swf$/,"");
               _loc4_ = _loc2_.split(".");
               _loc2_ = _loc4_.join("/") + WhiteboardLoader.MASK_FILE_EXT;
            }
            else if(_loc1_ is Character)
            {
               _loc2_ = (_loc1_ as Character).action.getFile();
               _loc4_ = _loc2_.split(".");
               _loc2_ = "cc_store/whiteboard/freeaction/" + (_loc1_ as Character).action.freeactionFolderName + "/" + _loc4_[_loc4_.length - 2] + WhiteboardLoader.MASK_FILE_EXT;
            }
         }
         var _loc3_:WhiteboardLoader = new WhiteboardLoader();
         _loc3_.addEventListener(Event.COMPLETE,this.onMaskDataReady);
         if(_loc1_ is BubbleAsset && this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
         {
            _loc3_.loadBubbleMask((_loc1_ as BubbleAsset).getBubble());
         }
         else if(_loc2_)
         {
            _loc3_.loadCustomMask(_loc2_);
         }
         else
         {
            _loc3_.loadGenericMask();
         }
      }
      
      private function onMaskDataReady(param1:Event) : void
      {
         var _loc2_:WhiteboardLoader = param1.target as WhiteboardLoader;
         if(_loc2_)
         {
            _loc2_.removeEventListener(Event.COMPLETE,this.onMaskDataReady);
            this._sequence = _loc2_.sequence;
            this._mask.sequence = this._sequence;
            this._isGenericMask = _loc2_.isGenericMask;
         }
         this.dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function reloadWhiteboardMask() : void
      {
         var _loc1_:WhiteboardLoader = new WhiteboardLoader();
         _loc1_.addEventListener(Event.COMPLETE,this.onMaskDataReady);
         if(asset is BubbleAsset && this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
         {
            _loc1_.loadBubbleMask((asset as BubbleAsset).getBubble());
         }
      }
      
      override public function set transition(param1:AssetTransition) : void
      {
         super.transition = param1;
         var _loc2_:AssetHandDrawnTransition = param1 as AssetHandDrawnTransition;
         if(_loc2_)
         {
            this._isHand = _loc2_.direction == AssetTransitionConstants.DIRECTION_IN;
            this._whiteboardHandStyle = _loc2_.whiteboardHandStyle;
         }
      }
      
      override public function playFrame(param1:uint, param2:uint) : void
      {
         super.playFrame(param1,param2);
         if(this.state == STATE_DURING_TRANSITION)
         {
            if(this._sequence && this._sequence.length > 0)
            {
               this.updateMask(param1,param2);
               this.updateHand(param1,param2);
            }
         }
      }
      
      override protected function doOnStateChange() : void
      {
         var _loc1_:Shader = null;
         var _loc2_:Rectangle = null;
         super.doOnStateChange();
         if(this._sequence && this._sequence.length > 0)
         {
            if(!this._bundleBounds)
            {
               this._bundleBounds = this.bundle.getBounds(this.bundle);
               if(this._assetThemeId == ThemeConstants.WHITEBOARD_THEME_ID && this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
               {
                  _loc1_ = new Shader(new this.ShaderKernel());
                  this._shaderFilter = new ShaderFilter(_loc1_);
               }
               this.addChild(this._mask);
            }
            if(!this._origin)
            {
               this._origin = new Point();
               if(this.asset is Prop && !this._isGenericMask)
               {
                  _loc2_ = (this.asset as Prop).boundBeforeCenterAlign;
                  if(_loc2_)
                  {
                     this._origin = UtilMath.getCenter(_loc2_);
                  }
               }
               else if(this.asset is Character && this._isGenericMask)
               {
                  this._origin = UtilMath.getCenter(this._bundleBounds);
                  this._origin = UtilMath.scalePoint(this._origin,-1,-1);
               }
            }
            switch(this.state)
            {
               case STATE_BEFORE_TRANSITION:
               case STATE_TRANSITION_START:
                  this.removeMask();
                  if(this.transition.direction == AssetTransitionConstants.DIRECTION_OUT)
                  {
                     this.asset.resumeBundle();
                  }
                  break;
               case STATE_DURING_TRANSITION:
                  this.asset.goToAndPauseBundle(1);
                  this.showMask();
                  break;
               case STATE_TRANSITION_END:
               case STATE_AFTER_TRANSITION:
                  this.removeMask();
                  if(this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
                  {
                     this.asset.resumeBundle();
                  }
                  break;
               case STATE_NOT_PLAYING:
                  this.removeMask();
            }
         }
      }
      
      private function showMask() : void
      {
         if(this._hand)
         {
            this._hand.switchHand(this._whiteboardHandStyle,this._isHand);
            this._hand.visible = true;
         }
         this._mask.visible = true;
         if(this.asset is BubbleAsset && this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
         {
            (this.asset as BubbleAsset).getBubble().setLabelMask(this._mask);
         }
         else
         {
            this.assetView.mask = this._mask;
         }
         if(this._shaderFilter)
         {
            this.assetView.filters = [this._shaderFilter];
         }
      }
      
      private function removeMask() : void
      {
         this._mask.visible = false;
         if(this.asset is BubbleAsset && this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
         {
            (this.asset as BubbleAsset).getBubble().setLabelMask(null);
         }
         else
         {
            this.assetView.mask = null;
         }
         this.assetView.filters = null;
         if(this._hand)
         {
            this._hand.visible = false;
         }
      }
      
      private function updateMask(param1:uint, param2:uint) : void
      {
         var _loc3_:Point = null;
         if(this._mask.visible)
         {
            this._mask.scaleX = this.bundle.scaleX;
            this._mask.scaleY = this.bundle.scaleY;
            if(this._isGenericMask)
            {
               this._mask.scaleX = this._mask.scaleX * (this._bundleBounds.width / WhiteboardMask.GENERIC_MASK_SIZE);
               this._mask.scaleY = this._mask.scaleY * (this._bundleBounds.height / WhiteboardMask.GENERIC_MASK_SIZE);
            }
            if(this.asset is Prop && (this.asset as Prop).isFlipped)
            {
               this._mask.scaleX = this._mask.scaleX * -1;
            }
            if(this.asset is Character)
            {
               if(!this._isGenericMask)
               {
                  this._mask.scaleX = this._mask.scaleX * (this.asset as Character).bodyScale;
                  this._mask.scaleY = this._mask.scaleY * (this.asset as Character).bodyScale;
               }
               if((this.asset as Character).isFlipped)
               {
                  this._mask.scaleX = this._mask.scaleX * -1;
               }
            }
            this._mask.rotation = this.bundle.rotation;
            _loc3_ = new Point(-this._origin.x,-this._origin.y);
            _loc3_ = UtilMath.scalePoint(_loc3_,this._mask.scaleX,this._mask.scaleY);
            _loc3_ = UtilMath.rotatePoint(_loc3_,this._mask.rotation);
            _loc3_.offset(this.bundle.x,this.bundle.y);
            this._mask.x = _loc3_.x;
            this._mask.y = _loc3_.y;
            this._mask.playMask(this.getFactor(param1,param2));
         }
      }
      
      private function updateHand(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:PlayerMaskGridModel = null;
         var _loc5_:Point = null;
         if(this._sequence && this._sequence.length > 0)
         {
            _loc3_ = int(Math.round(this.getFactor(param1,param2) * (this._sequence.length - 1)));
            _loc4_ = this._sequence[_loc3_] as PlayerMaskGridModel;
            if(_loc4_)
            {
               _loc5_ = new Point(_loc4_.drawingX - this._origin.x,_loc4_.drawingY - this._origin.y);
               _loc5_ = UtilMath.scalePoint(_loc5_,this._mask.scaleX,this._mask.scaleY);
               _loc5_ = UtilMath.rotatePoint(_loc5_,this._mask.rotation);
               _loc5_.offset(this.bundle.x,this.bundle.y);
               this._scene.moveHand(_loc5_.x,_loc5_.y);
            }
         }
      }
      
      override public function resume() : void
      {
         if(this.dominant && this._sequence && this._sequence.length > 0)
         {
            switch(this.state)
            {
               case STATE_BEFORE_TRANSITION:
               case STATE_TRANSITION_START:
                  if(this.transition.direction == AssetTransitionConstants.DIRECTION_OUT)
                  {
                     this.asset.resumeBundle();
                  }
                  break;
               case STATE_TRANSITION_END:
               case STATE_AFTER_TRANSITION:
                  if(this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
                  {
                     this.asset.resumeBundle();
                  }
            }
         }
         else
         {
            super.resume();
         }
      }
      
      override public function goToAndPause(param1:Number, param2:Number, param3:int, param4:Number) : void
      {
         if(this.dominant && this._sequence && this._sequence.length > 0)
         {
            switch(this.state)
            {
               case STATE_DURING_TRANSITION:
                  this.asset.goToAndPauseBundle(1);
            }
         }
         else
         {
            super.goToAndPause(param1,param2,param3,param4);
         }
      }
   }
}
