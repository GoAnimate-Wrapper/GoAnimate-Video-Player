package anifire.player.assetTransitions.views
{
	import anifire.assets.transition.AssetTransitionConstants;
	import anifire.constant.AnimeConstants;
	import anifire.player.assetTransitions.models.AssetSlideTransition;
	import anifire.player.assetTransitions.models.AssetTransition;
	import anifire.player.interfaces.IPlayerAssetView;
	import anifire.util.UtilEffect;
	import flash.geom.Point;
	
	public class AssetSlideTransitionView extends AssetTransitionView
	{
		 
		
		private var _pt:Point;
		
		public function AssetSlideTransitionView(param1:IPlayerAssetView)
		{
			super(param1);
		}
		
		override public function set transition(param1:AssetTransition) : void
		{
			var _loc2_:AssetSlideTransition = null;
			super.transition = param1;
			this._pt = new Point(0,-AnimeConstants.SCREEN_HEIGHT);
			if(this.transition is AssetSlideTransition)
			{
				_loc2_ = this.transition as AssetSlideTransition;
				switch(_loc2_.destination)
				{
					case AssetTransitionConstants.DEST_TL:
						this._pt.x = -AnimeConstants.SCREEN_WIDTH;
						this._pt.y = -AnimeConstants.SCREEN_HEIGHT;
						break;
					case AssetTransitionConstants.DEST_TOP:
						this._pt.x = 0;
						this._pt.y = -AnimeConstants.SCREEN_HEIGHT;
						break;
					case AssetTransitionConstants.DEST_TR:
						this._pt.x = AnimeConstants.SCREEN_WIDTH;
						this._pt.y = -AnimeConstants.SCREEN_HEIGHT;
						break;
					case AssetTransitionConstants.DEST_LEFT:
						this._pt.x = -AnimeConstants.SCREEN_WIDTH;
						this._pt.y = 0;
						break;
					case AssetTransitionConstants.DEST_RIGHT:
						this._pt.x = AnimeConstants.SCREEN_WIDTH;
						this._pt.y = 0;
						break;
					case AssetTransitionConstants.DEST_BL:
						this._pt.x = -AnimeConstants.SCREEN_WIDTH;
						this._pt.y = AnimeConstants.SCREEN_HEIGHT;
						break;
					case AssetTransitionConstants.DEST_BOTTOM:
						this._pt.x = 0;
						this._pt.y = AnimeConstants.SCREEN_HEIGHT;
						break;
					case AssetTransitionConstants.DEST_BR:
						this._pt.x = AnimeConstants.SCREEN_WIDTH;
						this._pt.y = AnimeConstants.SCREEN_HEIGHT;
				}
			}
			this._pt.x = this._pt.x * 1.5;
			this._pt.y = this._pt.y * 1.5;
		}
		
		override public function playFrame(param1:uint, param2:uint) : void
		{
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			super.playFrame(param1,param2);
			var _loc5_:Point = new Point();
			if(param1 >= this.transition.startFrame && param1 < this.transition.endFrame)
			{
				this.assetView.visible = true;
				_loc3_ = this._pt.x * (1 - this.getFactor(param1,param2));
				_loc4_ = this._pt.y * (1 - this.getFactor(param1,param2));
				this.assetView.x = _loc3_;
				this.assetView.y = _loc4_;
			}
			if(param1 == this.transition.endFrame)
			{
				if(this.transition.direction == AssetTransitionConstants.DIRECTION_OUT)
				{
					this.assetView.visible = false;
				}
				else
				{
					this.assetView.x = 0;
					this.assetView.y = 0;
				}
			}
		}
		
		override protected function getFactor(param1:uint, param2:uint) : Number
		{
			var _loc6_:Function = null;
			var _loc3_:Number = 0;
			var _loc4_:uint = this.transition.startFrame;
			var _loc5_:uint = this.transition.duration#1;
			if(param1 >= _loc4_)
			{
				_loc6_ = UtilEffect.getEffectByName("easeOutCubic");
				if(this.transition.direction == AssetTransitionConstants.DIRECTION_OUT)
				{
					_loc6_ = UtilEffect.getEffectByName("easeInCubic");
				}
				_loc3_ = _loc6_(param1 - _loc4_,0,1,_loc5_ - 1);
				_loc3_ = Math.min(_loc3_,1);
			}
			if(this.transition.direction == AssetTransitionConstants.DIRECTION_OUT)
			{
				_loc3_ = 1 - _loc3_;
			}
			return _loc3_;
		}
	}
}
