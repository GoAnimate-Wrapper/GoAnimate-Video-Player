package anifire.player.assetTransitions.views
{
	import anifire.assets.transition.AssetTransitionConstants;
	import anifire.player.interfaces.IPlayerAssetView;
	import com.jumpeye.Events.FLASHEFFEvents;
	import com.jumpeye.flashEff2.core.interfaces.IFlashEffSymbolText;
	import flash.events.Event;
	
	public class AssetFlashEffSpriteTransitionView extends AssetTransitionView
	{
		 
		
		private var _isTransitting:Boolean = false;
		
		private var myEffect:FlashEff2Flex;
		
		public function AssetFlashEffSpriteTransitionView(param1:IPlayerAssetView)
		{
			this.myEffect = new FlashEff2Flex();
			super(param1);
			this.myEffect.target = this;
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
								_loc4_ = AssetTransitionConstants.flashEffPlusParamById(this.transition.type,this.transition.direction);
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
								_loc5_ = AssetTransitionConstants.flashEffPlusParamById(this.transition.type,this.transition.direction);
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
	}
}
