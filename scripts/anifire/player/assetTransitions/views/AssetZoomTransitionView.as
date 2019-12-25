package anifire.player.assetTransitions.views
{
	import anifire.assets.transition.AssetTransitionConstants;
	import anifire.player.assetTransitions.models.AssetTransition;
	import anifire.player.interfaces.IPlayerAssetView;
	import anifire.util.UtilEffect;
	import mx.effects.Zoom;
	import mx.events.EffectEvent;
	
	public class AssetZoomTransitionView extends AssetTransitionView
	{
		 
		
		private var _effect:Zoom;
		
		private var _isTransitting:Boolean = false;
		
		public function AssetZoomTransitionView(param1:IPlayerAssetView)
		{
			this._effect = new Zoom();
			super(param1);
		}
		
		override public function set transition(param1:AssetTransition) : void
		{
			super.transition = param1;
			this._effect.duration#1 = 1000 * transition.duration#1 / 24;
			this._effect.easingFunction = UtilEffect.getEffectByName("easeInCubic");
		}
		
		override public function playFrame(param1:uint, param2:uint) : void
		{
			super.playFrame(param1,param2);
			if(param1 == 1)
			{
				this._isTransitting = false;
			}
			if(param1 >= this.transition.startFrame && param1 <= this.transition.startFrame + 2)
			{
				if(!this._isTransitting)
				{
					this._isTransitting = true;
					this._effect.addEventListener(EffectEvent.EFFECT_END,this.onEffectEnd);
					if(this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
					{
						this._effect.play([this],true);
					}
					else
					{
						this._effect.play([this]);
					}
				}
				this.assetView.visible = true;
			}
		}
		
		private function onEffectStart(param1:EffectEvent) : void
		{
			this._effect.removeEventListener(EffectEvent.EFFECT_START,this.onEffectStart);
			this.assetView.visible = true;
		}
		
		private function onEffectEnd(param1:EffectEvent) : void
		{
			this._effect.removeEventListener(EffectEvent.EFFECT_END,this.onEffectEnd);
			if(this.transition.direction == AssetTransitionConstants.DIRECTION_OUT)
			{
				this.assetView.visible = false;
				this._effect.play([this],true);
			}
			this._isTransitting = false;
		}
	}
}
