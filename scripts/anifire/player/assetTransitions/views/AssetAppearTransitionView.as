package anifire.player.assetTransitions.views
{
   import anifire.assets.transition.AssetTransitionConstants;
   import anifire.player.interfaces.IPlayerAssetView;
   
   public class AssetAppearTransitionView extends AssetTransitionView
   {
       
      
      public function AssetAppearTransitionView(param1:IPlayerAssetView)
      {
         super(param1);
      }
      
      override protected function doOnStateChange() : void
      {
         super.doOnStateChange();
         switch(this.state)
         {
            case STATE_BEFORE_TRANSITION:
               if(this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
               {
                  this.assetView.visible = false;
               }
               else
               {
                  this.assetView.visible = true;
               }
               break;
            case STATE_TRANSITION_START:
            case STATE_DURING_TRANSITION:
            case STATE_TRANSITION_END:
            case STATE_AFTER_TRANSITION:
               if(this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
               {
                  this.assetView.visible = true;
               }
               else
               {
                  this.assetView.visible = false;
               }
               break;
            case STATE_NOT_PLAYING:
               this.assetView.visible = true;
         }
      }
   }
}
