package anifire.player.assetTransitions.views
{
   import anifire.assets.transition.AssetTransitionConstants;
   import anifire.component.widgets.WidgetMaker;
   import anifire.player.interfaces.IPlayerAssetView;
   import anifire.player.playback.Widget;
   import flash.events.Event;
   
   public class WidgetTransitionView extends AssetTransitionView
   {
       
      
      private var _widgetMaker:WidgetMaker;
      
      public function WidgetTransitionView(param1:IPlayerAssetView)
      {
         super(param1);
      }
      
      override public function playFrame(param1:uint, param2:uint) : void
      {
         super.playFrame(param1,param2);
         switch(this.state)
         {
            case STATE_DURING_TRANSITION:
               if(this._widgetMaker)
               {
                  this._widgetMaker.animate(getFactor(param1,param1));
               }
         }
      }
      
      override protected function doOnStateChange() : void
      {
         super.doOnStateChange();
         if(this._widgetMaker)
         {
            switch(this.state)
            {
               case STATE_BEFORE_TRANSITION:
               case STATE_TRANSITION_START:
                  this._widgetMaker.animate(this.transition.direction == AssetTransitionConstants.DIRECTION_IN?Number(0):Number(1));
                  break;
               case STATE_TRANSITION_END:
               case STATE_AFTER_TRANSITION:
                  this._widgetMaker.animate(this.transition.direction == AssetTransitionConstants.DIRECTION_IN?Number(1):Number(0));
                  break;
               case STATE_NOT_PLAYING:
                  this._widgetMaker.animate(1);
            }
         }
      }
      
      override public function initRemoteData() : void
      {
         if(this.asset is Widget)
         {
            this._widgetMaker = (this.asset as Widget).widgetMaker;
         }
         this.dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
