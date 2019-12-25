package anifire.player.assetTransitions.models
{
	import anifire.assets.transition.AssetTransitionConstants;
	import anifire.assets.transition.AssetTransitionNode;
	
	public class AssetTransitionFactory
	{
		 
		
		public function AssetTransitionFactory()
		{
			super();
		}
		
		public static function createTransition(param1:AssetTransitionNode) : AssetTransition
		{
			var _loc2_:AssetTransition = null;
			switch(String(param1.xml.@type))
			{
				case AssetTransitionConstants.TYPE_HAND_DRAWN:
					_loc2_ = new AssetHandDrawnTransition();
					break;
				case AssetTransitionConstants.TYPE_HANDSLIDE:
				case AssetTransitionConstants.TYPE_SLIDE:
					_loc2_ = new AssetSlideTransition();
					break;
				case AssetTransitionConstants.TYPE_WIPE:
					_loc2_ = new AssetWipeTransition();
					break;
				case AssetTransitionConstants.TYPE_IRIS:
				case AssetTransitionConstants.TYPE_IRIS_CIRCLE:
					_loc2_ = new AssetIrisTransition();
					break;
				case AssetTransitionConstants.TYPE_TEXT_ALPHA:
				case AssetTransitionConstants.TYPE_TEXT_BLUR:
				case AssetTransitionConstants.TYPE_TEXT_GLOWNBURN:
					_loc2_ = new AssetTransition();
					break;
				default:
					_loc2_ = new AssetTransition();
			}
			if(_loc2_)
			{
				_loc2_.init(param1);
			}
			return _loc2_;
		}
	}
}
