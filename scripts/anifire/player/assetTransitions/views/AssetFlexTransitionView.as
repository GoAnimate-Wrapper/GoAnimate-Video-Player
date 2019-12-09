package anifire.player.assetTransitions.views
{
   import anifire.assets.transition.AssetTransitionConstants;
   import anifire.player.assetTransitions.interfaces.IDestination;
   import anifire.player.assetTransitions.interfaces.IShape;
   import anifire.player.assetTransitions.models.AssetTransition;
   import anifire.player.interfaces.IPlayerAssetView;
   import anifire.util.UtilEffect;
   import fl.transitions.TransitionManager;
   import flash.events.Event;
   
   public class AssetFlexTransitionView extends AssetTransitionView
   {
       
      
      private const ALL_TRANSITIONS_IN_DONE:String = "allTransitionsInDone";
      
      private const ALL_TRANSITIONS_OUT_DONE:String = "allTransitionsOutDone";
      
      private var _isTransitting:Boolean = false;
      
      private var _param:Object;
      
      public function AssetFlexTransitionView(param1:IPlayerAssetView)
      {
         super(param1);
      }
      
      override public function set transition(param1:AssetTransition) : void
      {
         super.transition = param1;
         this.initParam();
      }
      
      override public function playFrame(param1:uint, param2:uint) : void
      {
         var _loc3_:TransitionManager = null;
         super.playFrame(param1,param2);
         if(param1 == 1)
         {
            this._isTransitting = false;
         }
         if(param1 >= this.transition.startFrame + 1 && param1 <= this.transition.startFrame + 3)
         {
            if(!this._isTransitting)
            {
               this._isTransitting = true;
               this.alpha = 1;
               _loc3_ = new TransitionManager(this);
               _loc3_.addEventListener(this.ALL_TRANSITIONS_IN_DONE,this.onTransitionsInDone);
               _loc3_.addEventListener(this.ALL_TRANSITIONS_OUT_DONE,this.onTransitionsOutDone);
               _loc3_.startTransition(this._param);
            }
            this.assetView.visible = true;
         }
      }
      
      private function initParam() : void
      {
         if(!this._param)
         {
            this._param = new Object();
            this._param["type"] = UtilEffect.getTransitionByName(this.transition.type);
            if(this.transition.type == AssetTransitionConstants.TYPE_IRIS_CIRCLE)
            {
               this._param["type"] = UtilEffect.getTransitionByName(AssetTransitionConstants.TYPE_IRIS);
            }
            this._param["direction"] = this.transition.direction;
            this._param["duration"] = this.transition.duration#1 / 24;
            if(this.transition.type == AssetTransitionConstants.TYPE_ZOOM)
            {
               if(this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
               {
                  this._param["easing"] = UtilEffect.getEffectByName("easeOutElastic");
               }
               else
               {
                  this._param["easing"] = UtilEffect.getEffectByName("easeInElastic");
               }
            }
            if(this.transition is IDestination)
            {
               this._param["startPoint"] = IDestination(this.transition).destination;
            }
            if(this.transition is IShape)
            {
               this._param["shape"] = IShape(this.transition).shape;
            }
         }
      }
      
      private function onTransitionsInDone(param1:Event) : void
      {
         var _loc2_:TransitionManager = param1.target as TransitionManager;
         _loc2_.removeEventListener(this.ALL_TRANSITIONS_IN_DONE,this.onTransitionsInDone);
         _loc2_.removeEventListener(this.ALL_TRANSITIONS_OUT_DONE,this.onTransitionsOutDone);
         this._isTransitting = false;
      }
      
      private function onTransitionsOutDone(param1:Event) : void
      {
         var _loc2_:TransitionManager = param1.target as TransitionManager;
         _loc2_.removeEventListener(this.ALL_TRANSITIONS_IN_DONE,this.onTransitionsInDone);
         _loc2_.removeEventListener(this.ALL_TRANSITIONS_OUT_DONE,this.onTransitionsOutDone);
         if(this.state == STATE_AFTER_TRANSITION)
         {
            this.assetView.visible = false;
         }
         this._isTransitting = false;
      }
   }
}
