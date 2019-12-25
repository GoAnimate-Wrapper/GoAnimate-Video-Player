package anifire.player.assetTransitions.views
{
	import anifire.assets.transition.AssetTransitionConstants;
	import anifire.interfaces.IRegulatedProcess;
	import anifire.player.assetTransitions.models.AssetTransition;
	import anifire.player.assetTransitions.sound.TransitionSound;
	import anifire.player.interfaces.IPlayerAssetView;
	import anifire.player.playback.AbstractAssetViewDecorator;
	import flash.events.Event;
	
	public class AssetTransitionView extends AbstractAssetViewDecorator implements IRegulatedProcess
	{
		
		public static const STATE_BEFORE_TRANSITION:String = "STATE_BEFORE_TRANSITION";
		
		public static const STATE_TRANSITION_START:String = "STATE_TRANSITION_START";
		
		public static const STATE_DURING_TRANSITION:String = "STATE_DURING_TRANSITION";
		
		public static const STATE_TRANSITION_END:String = "STATE_TRANSITION_END";
		
		public static const STATE_AFTER_TRANSITION:String = "STATE_AFTER_TRANSITION";
		
		public static const STATE_NOT_PLAYING:String = "STATE_NOT_PLAYING";
		 
		
		private var _transition:AssetTransition;
		
		private var _startFrame:uint = 1;
		
		private var _totalFrame:uint;
		
		private var _endFrame:uint = 1;
		
		private var _direction:uint = 0;
		
		private var _sound:TransitionSound;
		
		private var _state:String = "STATE_NOT_PLAYING";
		
		private var _soundStartFrame:int;
		
		private var _dominant:Boolean;
		
		public function AssetTransitionView(param1:IPlayerAssetView)
		{
			super(param1);
		}
		
		public function get transition() : AssetTransition
		{
			return this._transition;
		}
		
		public function set transition(param1:AssetTransition) : void
		{
			if(param1 && this._transition != param1)
			{
				this._transition = param1;
				this._startFrame = param1.startFrame;
				this._totalFrame = param1.duration#1;
				this._endFrame = this._startFrame + this._totalFrame - 1;
				this._direction = param1.direction;
				param1.view = this;
				if(param1.hasSound)
				{
					this._sound = new TransitionSound();
					if(param1.direction == AssetTransitionConstants.DIRECTION_IN)
					{
						this._soundStartFrame = Math.max(this._soundStartFrame,param1.startFrame + param1.duration#1 - 12);
					}
					else
					{
						this._soundStartFrame = param1.startFrame;
					}
				}
			}
		}
		
		override public function playFrame(param1:uint, param2:uint) : void
		{
			super.playFrame(param1,param2);
			if(this._dominant)
			{
				if(param1 < this._startFrame)
				{
					this.state = STATE_BEFORE_TRANSITION;
				}
				else if(param1 == this._startFrame)
				{
					this.state = STATE_TRANSITION_START;
				}
				else if(param1 > this._startFrame && param1 < this._endFrame)
				{
					this.state = STATE_DURING_TRANSITION;
				}
				else if(param1 == this._endFrame)
				{
					this.state = STATE_TRANSITION_END;
				}
				else if(param1 > this._endFrame)
				{
					this.state = STATE_AFTER_TRANSITION;
				}
				if(this._sound && param1 == this._soundStartFrame)
				{
					this._sound.play();
				}
			}
		}
		
		protected function getFactor(param1:uint, param2:uint) : Number
		{
			var _loc3_:Number = 0;
			if(param1 >= this._endFrame)
			{
				_loc3_ = 1;
			}
			else if(param1 > this._startFrame)
			{
				_loc3_ = (param1 - this._startFrame) / this._totalFrame;
			}
			if(this._direction == AssetTransitionConstants.DIRECTION_OUT)
			{
				_loc3_ = 1 - _loc3_;
			}
			return _loc3_;
		}
		
		protected function get state() : String
		{
			return this._state;
		}
		
		protected function set state(param1:String) : void
		{
			if(param1 != this._state)
			{
				this._state = param1;
				this.doOnStateChange();
			}
		}
		
		protected function doOnStateChange() : void
		{
			switch(this._state)
			{
				case STATE_BEFORE_TRANSITION:
				case STATE_TRANSITION_START:
					if(this._direction == AssetTransitionConstants.DIRECTION_IN)
					{
						this.assetView.visible = false;
					}
					else if(this._direction == AssetTransitionConstants.DIRECTION_OUT)
					{
						this.assetView.visible = true;
					}
					break;
				case STATE_DURING_TRANSITION:
					this.assetView.visible = true;
					break;
				case STATE_TRANSITION_END:
				case STATE_AFTER_TRANSITION:
					if(this._direction == AssetTransitionConstants.DIRECTION_IN)
					{
						this.assetView.visible = true;
					}
					else if(this._direction == AssetTransitionConstants.DIRECTION_OUT)
					{
						this.assetView.visible = false;
					}
					break;
				case STATE_NOT_PLAYING:
					this.assetView.visible = true;
					this.assetView.x = 0;
					this.assetView.y = 0;
			}
		}
		
		protected function get startFrame() : uint
		{
			return this._startFrame;
		}
		
		protected function get totalFrame() : uint
		{
			return this._totalFrame;
		}
		
		protected function get endFrame() : uint
		{
			return this._endFrame;
		}
		
		protected function get direction() : uint
		{
			return this._direction;
		}
		
		public function get dominant() : Boolean
		{
			return this._dominant;
		}
		
		public function set dominant(param1:Boolean) : void
		{
			if(this._dominant != param1)
			{
				this._dominant = param1;
				if(!param1)
				{
					this.state = STATE_NOT_PLAYING;
				}
			}
		}
		
		public function initRemoteData() : void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function startProcess(param1:Boolean = false, param2:Number = 0) : void
		{
			this.initRemoteData();
		}
	}
}
