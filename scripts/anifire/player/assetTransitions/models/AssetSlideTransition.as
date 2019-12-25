package anifire.player.assetTransitions.models
{
	import anifire.assets.transition.AssetTransitionConstants;
	import anifire.assets.transition.AssetTransitionNode;
	
	public class AssetSlideTransition extends AssetTransition
	{
		 
		
		private var _dest:uint = 1;
		
		public function AssetSlideTransition()
		{
			super();
		}
		
		override public function init(param1:AssetTransitionNode) : void
		{
			super.init(param1);
			if(param1.xml.hasOwnProperty(AssetTransitionConstants.TAG_NAME_TRANSITION_SETTING))
			{
				this._dest = uint(param1.xml.child(AssetTransitionConstants.TAG_NAME_TRANSITION_SETTING)[0].@dest);
			}
		}
		
		public function get destination() : uint
		{
			return this._dest;
		}
	}
}
