package anifire.player.assetTransitions.models
{
   import anifire.assets.transition.AssetTransitionConstants;
   import anifire.assets.transition.AssetTransitionNode;
   import anifire.constants.WhiteboardConstants;
   
   public class AssetHandDrawnTransition extends AssetTransition
   {
      
      public static const WHITEBOARD_HAND_ATTR:String = "wbHand";
      
      public static const WHITEBOARD_HAND_XML_ATTR:String = "@wbHand";
       
      
      protected var _whiteboardHandStyle:int = 1;
      
      public function AssetHandDrawnTransition()
      {
         super();
      }
      
      public function get whiteboardHandStyle() : int
      {
         return this._whiteboardHandStyle;
      }
      
      override public function init(param1:AssetTransitionNode) : void
      {
         var _loc2_:XML = null;
         super.init(param1);
         if(param1.xml.hasOwnProperty(AssetTransitionConstants.TAG_NAME_TRANSITION_SETTING))
         {
            _loc2_ = param1.xml.child(AssetTransitionConstants.TAG_NAME_TRANSITION_SETTING)[0];
            if(_loc2_.hasOwnProperty(WHITEBOARD_HAND_XML_ATTR))
            {
               this._whiteboardHandStyle = _loc2_[WHITEBOARD_HAND_ATTR];
            }
            else
            {
               this._whiteboardHandStyle = WhiteboardConstants.DEFAULT_HAND;
            }
         }
      }
   }
}
