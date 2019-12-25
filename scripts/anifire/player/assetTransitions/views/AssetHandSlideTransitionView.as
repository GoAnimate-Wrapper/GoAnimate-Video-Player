package anifire.player.assetTransitions.views
{
	import anifire.assets.transition.AssetTransitionConstants;
	import anifire.constant.AnimeConstants;
	import anifire.player.assetTransitions.models.AssetSlideTransition;
	import anifire.player.assetTransitions.models.AssetTransition;
	import anifire.player.interfaces.IPlayerAssetView;
	import anifire.util.UtilEffect;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class AssetHandSlideTransitionView extends AssetTransitionView
	{
		 
		
		private var _anchorPoint:Point;
		
		private var _handClip:HandClip;
		
		private var _offset:Point;
		
		public function AssetHandSlideTransitionView(param1:IPlayerAssetView)
		{
			this._handClip = new HandClip();
			super(param1);
		}
		
		override public function initRemoteData() : void
		{
			this.loadHandClip();
		}
		
		private function loadHandClip() : void
		{
			this._handClip.addEventListener(Event.COMPLETE,this.handClip_completeHandler);
			this._handClip.loadHand();
		}
		
		private function handClip_completeHandler(param1:Event) : void
		{
			IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,this.handClip_completeHandler);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		override public function set transition(param1:AssetTransition) : void
		{
			super.transition = param1;
			var _loc2_:AssetSlideTransition = this.transition as AssetSlideTransition;
			if(_loc2_)
			{
				this._anchorPoint = new Point(0,-AnimeConstants.SCREEN_HEIGHT);
				switch(_loc2_.destination)
				{
					case AssetTransitionConstants.DEST_TL:
						this._anchorPoint.x = -AnimeConstants.SCREEN_WIDTH;
						this._anchorPoint.y = -AnimeConstants.SCREEN_HEIGHT;
						break;
					case AssetTransitionConstants.DEST_TOP:
						this._anchorPoint.x = 0;
						this._anchorPoint.y = -AnimeConstants.SCREEN_HEIGHT;
						break;
					case AssetTransitionConstants.DEST_TR:
						this._anchorPoint.x = AnimeConstants.SCREEN_WIDTH;
						this._anchorPoint.y = -AnimeConstants.SCREEN_HEIGHT;
						break;
					case AssetTransitionConstants.DEST_LEFT:
						this._anchorPoint.x = -AnimeConstants.SCREEN_WIDTH;
						this._anchorPoint.y = 0;
						break;
					case AssetTransitionConstants.DEST_RIGHT:
						this._anchorPoint.x = AnimeConstants.SCREEN_WIDTH;
						this._anchorPoint.y = 0;
						break;
					case AssetTransitionConstants.DEST_BL:
						this._anchorPoint.x = -AnimeConstants.SCREEN_WIDTH;
						this._anchorPoint.y = AnimeConstants.SCREEN_HEIGHT;
						break;
					case AssetTransitionConstants.DEST_BOTTOM:
						this._anchorPoint.x = 0;
						this._anchorPoint.y = AnimeConstants.SCREEN_HEIGHT;
						break;
					case AssetTransitionConstants.DEST_BR:
						this._anchorPoint.x = AnimeConstants.SCREEN_WIDTH;
						this._anchorPoint.y = AnimeConstants.SCREEN_HEIGHT;
				}
				this._handClip.destination = _loc2_.destination;
				addChild(this._handClip);
			}
			this._anchorPoint.x = this._anchorPoint.x * 1.5;
			this._anchorPoint.y = this._anchorPoint.y * 1.5;
		}
		
		override public function playFrame(param1:uint, param2:uint) : void
		{
			var _loc3_:Number = NaN;
			var _loc6_:Function = null;
			var _loc8_:Number = NaN;
			var _loc9_:Number = NaN;
			var _loc11_:Rectangle = null;
			var _loc12_:Rectangle = null;
			var _loc13_:AssetSlideTransition = null;
			super.playFrame(param1,param2);
			if(!this._offset && this.bundle)
			{
				_loc11_ = this.bundle.getBounds(this.assetView);
				if(_loc11_.width > 0)
				{
					_loc12_ = new Rectangle(_loc11_.x + _loc11_.width / 3,_loc11_.y + _loc11_.height / 3,_loc11_.width / 3,_loc11_.height / 3);
					this._offset = new Point(_loc12_.x,_loc12_.y);
					_loc13_ = transition as AssetSlideTransition;
					if(_loc13_)
					{
						switch(_loc13_.destination)
						{
							case AssetTransitionConstants.DEST_TL:
								break;
							case AssetTransitionConstants.DEST_TOP:
								this._offset.offset(_loc12_.width / 2,0);
								break;
							case AssetTransitionConstants.DEST_TR:
								this._offset.offset(_loc12_.width,0);
								break;
							case AssetTransitionConstants.DEST_LEFT:
								this._offset.offset(0,_loc12_.height / 2);
								break;
							case AssetTransitionConstants.DEST_RIGHT:
								this._offset.offset(_loc12_.width,_loc12_.height / 2);
								break;
							case AssetTransitionConstants.DEST_BL:
								this._offset.offset(0,_loc12_.height);
								break;
							case AssetTransitionConstants.DEST_BOTTOM:
								this._offset.offset(_loc12_.width / 2,_loc12_.height);
								break;
							case AssetTransitionConstants.DEST_BR:
								this._offset.offset(_loc12_.width,_loc12_.height);
						}
					}
				}
			}
			this._handClip.visible = false;
			if(!this._offset)
			{
				return;
			}
			_loc3_ = 3;
			var _loc4_:Number = 9;
			var _loc5_:Number = 9;
			var _loc7_:Number = 0;
			var _loc10_:Number = 0;
			if(this.transition.direction == AssetTransitionConstants.DIRECTION_IN)
			{
				_loc10_ = this.transition.duration#1 - _loc3_ - _loc5_;
				if(param1 >= this.transition.startFrame && param1 < this.transition.startFrame + _loc10_)
				{
					this.assetView.visible = true;
					_loc6_ = UtilEffect.getEffectByName("easeOutBack");
					_loc7_ = _loc6_(param1 - this.transition.startFrame,0,1,_loc10_,0.7);
					_loc8_ = this._anchorPoint.x * (1 - _loc7_);
					_loc9_ = this._anchorPoint.y * (1 - _loc7_);
					this.assetView.x = _loc8_;
					this.assetView.y = _loc9_;
					this._handClip.visible = true;
					this._handClip.x = _loc8_ + this._offset.x;
					this._handClip.y = _loc9_ + this._offset.y;
				}
				else if(param1 >= this.transition.startFrame + _loc10_ && param1 < this.transition.startFrame + _loc10_ + _loc3_)
				{
					this.assetView.x = 0;
					this.assetView.y = 0;
					this._handClip.x = this._offset.x;
					this._handClip.y = this._offset.y;
					this._handClip.visible = true;
				}
				else if(param1 >= this.transition.startFrame + _loc10_ + _loc3_ && param1 < this.transition.endFrame)
				{
					_loc6_ = UtilEffect.getEffectByName("easeInQuad");
					_loc7_ = _loc6_(param1 - (this.transition.endFrame - _loc5_),0,1,_loc5_);
					_loc8_ = this._anchorPoint.x * _loc7_;
					_loc9_ = this._anchorPoint.y * _loc7_;
					this._handClip.x = _loc8_ + this._offset.x;
					this._handClip.y = _loc9_ + this._offset.y;
					this._handClip.visible = true;
				}
			}
			else
			{
				_loc10_ = this.transition.duration#1 - _loc3_ - _loc4_;
				if(param1 >= this.transition.startFrame && param1 < this.transition.startFrame + _loc4_)
				{
					_loc6_ = UtilEffect.getEffectByName("easeOutBack");
					_loc7_ = _loc6_(param1 - this.transition.startFrame,0,1,_loc4_,0.5);
					_loc8_ = this._anchorPoint.x * (1 - _loc7_);
					_loc9_ = this._anchorPoint.y * (1 - _loc7_);
					this._handClip.x = _loc8_ + this._offset.x;
					this._handClip.y = _loc9_ + this._offset.y;
					this._handClip.visible = true;
				}
				else if(param1 >= this.transition.startFrame + _loc4_ && param1 < this.transition.startFrame + _loc4_ + _loc3_)
				{
					this._handClip.x = this._offset.x;
					this._handClip.y = this._offset.y;
					this._handClip.visible = true;
				}
				else if(param1 >= this.transition.startFrame + _loc4_ + _loc3_ && param1 < this.transition.endFrame)
				{
					this.assetView.visible = true;
					_loc6_ = UtilEffect.getEffectByName("easeInQuad");
					_loc7_ = _loc6_(param1 - (this.transition.startFrame + _loc4_ + _loc3_),0,1,_loc10_);
					_loc8_ = this._anchorPoint.x * _loc7_;
					_loc9_ = this._anchorPoint.y * _loc7_;
					this.assetView.x = _loc8_;
					this.assetView.y = _loc9_;
					this._handClip.visible = true;
					this._handClip.x = _loc8_ + this._offset.x;
					this._handClip.y = _loc9_ + this._offset.y;
				}
				else if(param1 == this.transition.endFrame)
				{
					this.assetView.visible = false;
				}
			}
		}
		
		override protected function getFactor(param1:uint, param2:uint) : Number
		{
			var _loc7_:Function = null;
			var _loc3_:Number = 0;
			var _loc4_:uint = this.transition.startFrame;
			var _loc5_:uint = this.transition.duration#1;
			var _loc6_:uint = _loc4_ + _loc5_ - 1;
			if(param1 >= _loc4_)
			{
				if(this.transition.direction == AssetTransitionConstants.DIRECTION_OUT)
				{
					_loc7_ = UtilEffect.getEffectByName("easeInQuad");
					_loc3_ = _loc7_(param1 - _loc4_,0,1,_loc5_ - 1);
				}
				else
				{
					_loc7_ = UtilEffect.getEffectByName("easeOutBack");
					_loc3_ = _loc7_(param1 - _loc4_,0,1,_loc5_ - 1,0.7);
				}
			}
			if(param1 >= _loc6_)
			{
				_loc3_ = 1;
			}
			if(this.transition.direction == AssetTransitionConstants.DIRECTION_OUT)
			{
				_loc3_ = 1 - _loc3_;
			}
			return _loc3_;
		}
	}
}
