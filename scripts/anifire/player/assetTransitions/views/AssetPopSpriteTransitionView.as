package anifire.player.assetTransitions.views
{
   import anifire.assets.transition.AssetTransitionConstants;
   import anifire.player.interfaces.IPlayerAssetView;
   import anifire.player.playback.PlayerConstant;
   import com.jumpeye.Events.FLASHEFFEvents;
   import com.jumpeye.flashEff2.core.interfaces.IFlashEffSymbolText;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class AssetPopSpriteTransitionView extends AssetTransitionView
   {
       
      
      private var SingleRingEnterImage:Class;
      
      private var SingleRingExitImage:Class;
      
      private var DotsEnterImage:Class;
      
      private var DotsExitImage:Class;
      
      private var RingsEnterImage:Class;
      
      private var RingsExitImage:Class;
      
      private var StarEnterImage:Class;
      
      private var StarExitImage:Class;
      
      private var _sprite:MovieClip;
      
      private var _isTransitting:Boolean = false;
      
      private var myEffect:FlashEff2Flex;
      
      public function AssetPopSpriteTransitionView(param1:IPlayerAssetView)
      {
         this.SingleRingEnterImage = AssetPopSpriteTransitionView_SingleRingEnterImage;
         this.SingleRingExitImage = AssetPopSpriteTransitionView_SingleRingExitImage;
         this.DotsEnterImage = AssetPopSpriteTransitionView_DotsEnterImage;
         this.DotsExitImage = AssetPopSpriteTransitionView_DotsExitImage;
         this.RingsEnterImage = AssetPopSpriteTransitionView_RingsEnterImage;
         this.RingsExitImage = AssetPopSpriteTransitionView_RingsExitImage;
         this.StarEnterImage = AssetPopSpriteTransitionView_StarEnterImage;
         this.StarExitImage = AssetPopSpriteTransitionView_StarExitImage;
         this.myEffect = new FlashEff2Flex();
         super(param1);
      }
      
      override public function playFrame(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:IFlashEffSymbolText = null;
         var _loc5_:IFlashEffSymbolText = null;
         super.playFrame(param1,param2);
         if(param1 == 1)
         {
            this._isTransitting = false;
            this.myEffect.targetVisibility = true;
         }
         if(param1 >= this.transition.startFrame + 1 && param1 <= this.transition.startFrame + 3)
         {
            if(!this._isTransitting)
            {
               this._isTransitting = true;
               this.myEffect.isTargetVisibleAtEnd = false;
               if(this.parent)
               {
                  if(this.parent && !this.myEffect.parent)
                  {
                     _loc3_ = this.parent.getChildIndex(this);
                     this.parent.addChildAt(this.myEffect,_loc3_);
                  }
                  if(this.transition.direction == 0)
                  {
                     if(this.myEffect.showTransition == null)
                     {
                        _loc4_ = AssetTransitionConstants.flashEffPlusParamById(AssetTransitionConstants.TYPE_SPRITE_SCALE,this.transition.direction);
                        _loc4_.tweenDuration = this.transition.duration#1 / 24;
                        this.myEffect.addEventListener(FLASHEFFEvents.TRANSITION_END,this.onTransitionsInDone);
                        this.myEffect.showTransition = _loc4_;
                        this.myEffect.showDelay = 0;
                     }
                     else
                     {
                        this.myEffect.show();
                     }
                  }
                  else if(this.transition.direction == 1)
                  {
                     if(this.myEffect.hideTransition == null)
                     {
                        _loc5_ = AssetTransitionConstants.flashEffPlusParamById(AssetTransitionConstants.TYPE_SPRITE_SCALE,this.transition.direction);
                        _loc5_.tweenDuration = this.transition.duration#1 / 24;
                        this.myEffect.addEventListener(FLASHEFFEvents.TRANSITION_END,this.onTransitionsOutDone);
                        this.myEffect.hideTransition = _loc5_;
                        this.myEffect.hideDelay = 0;
                     }
                     else
                     {
                        this.myEffect.hide();
                     }
                  }
               }
            }
            this.assetView.visible = true;
         }
         else if(param1 == param2)
         {
            this.myEffect.isTargetVisibleAtEnd = true;
         }
      }
      
      private function onTransitionsInDone(param1:Event) : void
      {
         this.myEffect.removeEventListener(FLASHEFFEvents.TRANSITION_END,this.onTransitionsInDone);
         this._isTransitting = false;
      }
      
      private function onTransitionsOutDone(param1:Event) : void
      {
         this.myEffect.removeEventListener(FLASHEFFEvents.TRANSITION_END,this.onTransitionsOutDone);
         this._isTransitting = false;
      }
      
      override protected function doOnStateChange() : void
      {
         super.doOnStateChange();
         switch(this.state)
         {
            case STATE_BEFORE_TRANSITION:
            case STATE_TRANSITION_START:
               this._sprite.visible = false;
               PlayerConstant.goToAndStopFamilyAt1(this._sprite);
               break;
            case STATE_DURING_TRANSITION:
               this._sprite.visible = true;
               PlayerConstant.goToAndStopFamilyAt1(this._sprite);
               PlayerConstant.playFamily(this._sprite);
               break;
            case STATE_TRANSITION_END:
            case STATE_AFTER_TRANSITION:
               this._sprite.visible = false;
               break;
            case STATE_NOT_PLAYING:
               this._sprite.visible = false;
               PlayerConstant.goToAndStopFamilyAt1(this._sprite);
         }
      }
      
      override public function initRemoteData() : void
      {
         switch(this.transition.type)
         {
            case AssetTransitionConstants.TYPE_SPRITE_POP_SINGLE_RING:
               if(this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
               {
                  this._sprite = new this.SingleRingEnterImage() as MovieClip;
               }
               else
               {
                  this._sprite = new this.SingleRingExitImage() as MovieClip;
               }
               break;
            case AssetTransitionConstants.TYPE_SPRITE_POP_RINGS:
               if(this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
               {
                  this._sprite = new this.RingsEnterImage() as MovieClip;
               }
               else
               {
                  this._sprite = new this.RingsExitImage() as MovieClip;
               }
               break;
            case AssetTransitionConstants.TYPE_SPRITE_POP_DOTS:
               if(this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
               {
                  this._sprite = new this.DotsEnterImage() as MovieClip;
               }
               else
               {
                  this._sprite = new this.DotsExitImage() as MovieClip;
               }
               break;
            case AssetTransitionConstants.TYPE_SPRITE_POP_STAR:
               if(this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
               {
                  this._sprite = new this.StarEnterImage() as MovieClip;
               }
               else
               {
                  this._sprite = new this.StarExitImage() as MovieClip;
               }
               break;
            default:
               if(this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
               {
                  this._sprite = new this.SingleRingEnterImage() as MovieClip;
               }
               else
               {
                  this._sprite = new this.SingleRingExitImage() as MovieClip;
               }
         }
         this._sprite.x = this.bundle.x;
         this._sprite.y = this.bundle.y;
         this._sprite.scaleX = this.bundle.scaleX;
         this._sprite.scaleY = this.bundle.scaleY;
         this._sprite.rotation = this.bundle.rotation;
         this._sprite.visible = false;
         this.addChild(this._sprite);
         this.myEffect.target = this.assetView;
         this.dispatchEvent(new Event(Event.COMPLETE));
      }
      
      override public function resume() : void
      {
         super.resume();
         PlayerConstant.playFamily(this._sprite);
      }
      
      override public function pause() : void
      {
         super.pause();
         PlayerConstant.stopFamily(this._sprite);
      }
      
      override public function goToAndPause(param1:Number, param2:Number, param3:int, param4:Number) : void
      {
         super.goToAndPause(param1,param2,param3,param4);
         var _loc5_:uint = 1;
         if(param1 > this.startFrame)
         {
            _loc5_ = param1 - this.startFrame;
         }
         PlayerConstant.goToAndStopFamily(this._sprite,_loc5_);
      }
   }
}
