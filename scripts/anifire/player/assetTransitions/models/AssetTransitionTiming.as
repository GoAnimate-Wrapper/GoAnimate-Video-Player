package anifire.player.assetTransitions.models
{
	public class AssetTransitionTiming
	{
		 
		
		private var _startFrame:int = 0;
		
		private var _duration:int = 24;
		
		public function AssetTransitionTiming()
		{
			super();
		}
		
		public function get startFrame() : int
		{
			return this._startFrame;
		}
		
		public function get duration#1() : int
		{
			return this._duration;
		}
		
		public function set startFrame(param1:int) : void
		{
			this._startFrame = param1;
		}
		
		public function set duration#1(param1:int) : void
		{
			this._duration = param1;
		}
	}
}
