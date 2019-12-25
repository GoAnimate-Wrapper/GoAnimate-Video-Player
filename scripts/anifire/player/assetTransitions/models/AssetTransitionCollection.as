package anifire.player.assetTransitions.models
{
	public class AssetTransitionCollection
	{
		 
		
		private var _transitions:Vector.<AssetTransition>;
		
		private var _transitionAtFrame:Vector.<AssetTransition>;
		
		private var _currentTransition:AssetTransition;
		
		public function AssetTransitionCollection()
		{
			this._transitions = new Vector.<AssetTransition>();
			super();
		}
		
		public function push(param1:AssetTransition) : void
		{
			if(param1)
			{
				this._transitions.push(param1);
			}
		}
		
		public function getTransitionAt(param1:int) : AssetTransition
		{
			if(param1 >= 0 && param1 < this._transitions.length)
			{
				return this._transitions[param1];
			}
			return null;
		}
		
		public function get length() : int
		{
			return this._transitions.length;
		}
		
		private function compareStartFrame(param1:AssetTransition, param2:AssetTransition) : Number
		{
			if(param1 && param2)
			{
				if(param1.startFrame > param2.startFrame)
				{
					return 1;
				}
				if(param1.startFrame < param2.startFrame)
				{
					return -1;
				}
			}
			return 0;
		}
		
		public function initDependency(param1:uint) : void
		{
			var _loc2_:AssetTransition = null;
			var _loc3_:int = 0;
			if(this._transitions.length >= 2)
			{
				this._transitions = this._transitions.sort(this.compareStartFrame);
				this._transitionAtFrame = new Vector.<AssetTransition>(param1);
				_loc3_ = 0;
				while(_loc3_ < this._transitions.length)
				{
					_loc2_ = this._transitions[_loc3_];
					if(_loc3_ == 0)
					{
						_loc2_.previousTransition = null;
					}
					else
					{
						_loc2_.previousTransition = this._transitions[_loc3_ - 1];
					}
					if(_loc3_ == this._transitions.length - 1)
					{
						_loc2_.nextTransition = null;
					}
					else
					{
						_loc2_.nextTransition = this._transitions[_loc3_ + 1];
					}
					_loc3_++;
				}
				_loc3_ = 0;
				_loc2_ = this._transitions[0];
				while(_loc3_ < param1)
				{
					if(_loc2_.nextTransition && _loc3_ + 1 >= _loc2_.nextTransition.startFrame)
					{
						_loc2_ = _loc2_.nextTransition;
					}
					this._transitionAtFrame[_loc3_] = _loc2_;
					_loc3_++;
				}
			}
		}
		
		public function getDominantTransitionAtFrame(param1:uint) : AssetTransition
		{
			if(this._transitions.length == 1)
			{
				return this._transitions[0];
			}
			if(this._transitions.length >= 2)
			{
				if(param1 - 1 >= 0 && param1 - 1 < this._transitionAtFrame.length)
				{
					return this._transitionAtFrame[param1 - 1];
				}
			}
			return null;
		}
		
		public function set currentTransition(param1:AssetTransition) : void
		{
			if(param1 != this._currentTransition)
			{
				if(this._currentTransition)
				{
					this._currentTransition.dominant = false;
				}
				this._currentTransition = param1;
				if(this._currentTransition)
				{
					this._currentTransition.dominant = true;
				}
			}
		}
	}
}
