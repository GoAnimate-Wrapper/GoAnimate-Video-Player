package anifire.player.assetTransitions.models
{
	import anifire.assets.transition.AssetTransitionConstants;
	import anifire.assets.transition.AssetTransitionNode;
	import anifire.player.assetTransitions.views.AssetTransitionView;
	
	public class AssetTransition
	{
		 
		
		private var _type:String;
		
		private var _direction:int;
		
		private var _timing:AssetTransitionTiming;
		
		private var _hasSound:Boolean;
		
		private var _previousTransition:AssetTransition;
		
		private var _nextTransition:AssetTransition;
		
		private var _view:AssetTransitionView;
		
		public function AssetTransition()
		{
			this._timing = new AssetTransitionTiming();
			super();
		}
		
		public function init(param1:AssetTransitionNode) : void
		{
			this._type = String(param1.xml.@type);
			this._direction = uint(param1.xml.@direction);
			this._timing.startFrame = param1.startFrame;
			this._timing.duration#1 = param1.duration#1;
			if(param1.xml.hasOwnProperty(AssetTransitionConstants.TAG_NAME_TRANSITION_SOUND))
			{
				this._hasSound = true;
			}
		}
		
		public function get type() : String
		{
			return this._type;
		}
		
		public function get hasSound() : Boolean
		{
			return this._hasSound;
		}
		
		public function get direction() : uint
		{
			return this._direction;
		}
		
		public function get startFrame() : int
		{
			return this._timing.startFrame;
		}
		
		public function get duration#1() : int
		{
			return this._timing.duration#1;
		}
		
		public function get endFrame() : int
		{
			return this.startFrame + this.duration#1 - 1;
		}
		
		public function get previousTransition() : AssetTransition
		{
			return this._previousTransition;
		}
		
		public function set previousTransition(param1:AssetTransition) : void
		{
			this._previousTransition = param1;
		}
		
		public function get nextTransition() : AssetTransition
		{
			return this._nextTransition;
		}
		
		public function set nextTransition(param1:AssetTransition) : void
		{
			this._nextTransition = param1;
		}
		
		public function get view() : AssetTransitionView
		{
			return this._view;
		}
		
		public function set view(param1:AssetTransitionView) : void
		{
			this._view = param1;
		}
		
		public function set dominant(param1:Boolean) : void
		{
			if(this._view)
			{
				this._view.dominant = param1;
			}
		}
	}
}
