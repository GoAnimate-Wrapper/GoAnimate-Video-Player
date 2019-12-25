package anifire.player.assetTransitions.views
{
	import anifire.assets.transition.AssetTransitionConstants;
	import anifire.bubble.Bubble;
	import anifire.player.interfaces.IPlayerAssetView;
	import com.jumpeye.Events.FLASHEFFEvents;
	import com.jumpeye.flashEff2.core.interfaces.IFlashEffSymbolText;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class AssetFlashEffTransitionView extends AssetTransitionView
	{
		 
		
		private var _isTransitting:Boolean = false;
		
		private var myEffect:FlashEff2Flex;
		
		public function AssetFlashEffTransitionView(param1:IPlayerAssetView)
		{
			this.myEffect = new FlashEff2Flex();
			super(param1);
		}
		
		override public function playFrame(param1:uint, param2:uint) : void
		{
			var _loc3_:TextField = null;
			var _loc4_:int = 0;
			var _loc5_:IFlashEffSymbolText = null;
			var _loc6_:IFlashEffSymbolText = null;
			super.playFrame(param1,param2);
			if(this.bubble && this.myEffect._targetInstanceName == "")
			{
				_loc3_ = Bubble(this.bubble).getLabel();
				this.myEffect.target = _loc3_;
			}
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
					if(this.bubble)
					{
						if(!Bubble(this.bubble).contains(this.myEffect) && Bubble(this.bubble).textEmbed)
						{
							_loc4_ = 0;
							while(_loc4_ < Bubble(this.bubble).numChildren)
							{
								if(Bubble(this.bubble).getChildAt(_loc4_) is FlashEff2Flex)
								{
									Bubble(this.bubble).removeChildAt(_loc4_);
								}
								_loc4_++;
							}
							Bubble(this.bubble).addChild(this.myEffect);
						}
						if(this.transition.direction == 0)
						{
							if(this.myEffect.showTransition == null)
							{
								_loc5_ = AssetTransitionConstants.flashEffPlusParamById(this.transition.type,this.transition.direction);
								_loc5_.tweenDuration = this.transition.duration#1 / 24;
								this.myEffect.addEventListener(FLASHEFFEvents.TRANSITION_END,this.onTransitionsInDone);
								this.myEffect.showTransition = _loc5_;
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
								_loc6_ = AssetTransitionConstants.flashEffPlusParamById(this.transition.type,this.transition.direction);
								_loc6_.tweenDuration = this.transition.duration#1 / 24;
								this.myEffect.addEventListener(FLASHEFFEvents.TRANSITION_END,this.onTransitionsOutDone);
								this.myEffect.hideTransition = _loc6_;
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
