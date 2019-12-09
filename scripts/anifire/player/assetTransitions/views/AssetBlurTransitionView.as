package anifire.player.assetTransitions.views
{
   import anifire.assets.transition.AssetTransitionConstants;
   import anifire.player.assetTransitions.models.AssetTransition;
   import anifire.player.interfaces.IPlayerAssetView;
   import anifire.util.UtilEffect;
   import mx.effects.Blur;
   import mx.events.EffectEvent;
   
   public class AssetBlurTransitionView extends AssetTransitionView
   {
       
      
      private var _effect:Blur;
      
      private var _isTransitting:Boolean = false;
      
      public function AssetBlurTransitionView(param1:IPlayerAssetView)
      {
         this._effect = new Blur();
         super(param1);
      }
      
      override public function set transition(param1:AssetTransition) : void
      {
         super.transition = param1;
         this._effect.duration#1 = 1000 * transition.duration#1 / 24;
         this._effect.blurXFrom = 0;
         this._effect.blurYFrom = 0;
         this._effect.blurXTo = 55;
         this._effect.blurYTo = 55;
         this._effect.easingFunction = UtilEffect.getEffectByName("easeInCubic");
      }
      
      override public function playFrame(param1:uint, param2:uint) : void
      {
         super.playFrame(param1,param2);
         if(param1 >= this.transition.startFrame && param1 <= this.transition.startFrame + 2)
         {
            this.playEffect();
         }
      }
      
      private function playEffect() : void
      {
         if(!this._isTransitting)
         {
            this._isTransitting = true;
            this._effect.addEventListener(EffectEvent.EFFECT_END,this.onEffectEnd);
            this._effect.duration#1 = 1000 * this.transition.duration#1 / 24;
            if(this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
            {
               this._effect.play([this],true);
            }
            else
            {
               this._effect.play([this]);
            }
            this.assetView.visible = true;
         }
      }
      
      private function onEffectEnd(param1:EffectEvent) : void
      {
         this._effect.removeEventListener(EffectEvent.EFFECT_END,this.onEffectEnd);
         if(this.transition.direction == AssetTransitionConstants.DIRECTION_OUT)
         {
            this.assetView.visible = false;
            this._effect.duration#1 = 20;
            this._effect.play([this],true);
         }
         this._isTransitting = false;
      }
   }
}
