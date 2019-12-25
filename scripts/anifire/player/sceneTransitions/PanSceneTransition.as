package anifire.player.sceneTransitions
{
	import anifire.constant.AnimeConstants;
	import anifire.player.playback.AnimeScene;
	import anifire.player.playback.GoTransition;
	import anifire.player.playback.PlayerConstant;
	import anifire.util.UtilPlain;
	import caurina.transitions.Equations;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class PanSceneTransition extends GoTransition
	{
		 
		
		private var _pos:Point;
		
		private var _destinationPoint:Point;
		
		private var _moveBothScenes:Boolean;
		
		public function PanSceneTransition(param1:Boolean = true)
		{
			super();
			this._moveBothScenes = param1;
			_supportSeeking = true;
		}
		
		override public function init(param1:XML, param2:AnimeScene, param3:Sprite) : Boolean
		{
			var _loc4_:int = 0;
			if(super.init(param1,param2,param3))
			{
				if(param1.hasOwnProperty("fx"))
				{
					if(param1.fx.hasOwnProperty("@param"))
					{
						_loc4_ = int(param1.fx.@param);
						this._pos = new Point();
						this._destinationPoint = new Point();
						switch(_loc4_)
						{
							case 1:
								this._destinationPoint.x = -(AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2) + 1;
								this._destinationPoint.y = -(AnimeConstants.screenHeight + PlayerConstant.BLEED_MARGIN * 2) + 1;
								break;
							case 2:
								this._pos.y = AnimeConstants.screenHeight + PlayerConstant.BLEED_MARGIN * 2 - 1;
								this._destinationPoint.y = -(AnimeConstants.screenHeight + PlayerConstant.BLEED_MARGIN * 2) + 1;
								break;
							case 3:
								this._destinationPoint.x = AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2 - 1;
								this._destinationPoint.y = -(AnimeConstants.screenHeight + PlayerConstant.BLEED_MARGIN * 2) + 1;
								break;
							case 4:
								this._pos.x = AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2 - 1;
								this._destinationPoint.x = -(AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2) + 1;
								break;
							case 6:
								this._pos.x = -(AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2) + 1;
								this._destinationPoint.x = AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2 - 1;
								break;
							case 7:
								this._destinationPoint.x = -(AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2) + 1;
								this._destinationPoint.y = AnimeConstants.screenHeight + PlayerConstant.BLEED_MARGIN * 2 - 1;
								break;
							case 8:
								this._pos.y = -(AnimeConstants.screenHeight + PlayerConstant.BLEED_MARGIN * 2) + 1;
								this._destinationPoint.y = AnimeConstants.screenHeight + PlayerConstant.BLEED_MARGIN * 2 - 1;
								break;
							case 9:
								this._destinationPoint.x = AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2 - 1;
								this._destinationPoint.y = AnimeConstants.screenHeight + PlayerConstant.BLEED_MARGIN * 2 - 1;
								break;
							default:
								this._pos.x = AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2 - 1;
								this._destinationPoint.x = -(AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2) + 1;
						}
					}
				}
				return true;
			}
			return false;
		}
		
		override public function play(param1:Number, param2:Number, param3:Number) : void
		{
			var _loc5_:MovieClip = null;
			var _loc6_:Number = NaN;
			var _loc4_:Number = 1 + param3 - param1;
			if(param3 <= param1 + dur)
			{
				if(param1 <= param3 && this.getBundle().numChildren == 0)
				{
					if(prevScene)
					{
						prevSceneCapture.bitmapData = prevScene.endSceneCapture;
						prevSceneCapture.width = AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2;
						prevSceneCapture.height = AnimeConstants.screenHeight + PlayerConstant.BLEED_MARGIN * 2;
					}
					else
					{
						prevSceneCapture.bitmapData = new BitmapData(AnimeConstants.SCREEN_WIDTH + PlayerConstant.BLEED_MARGIN * 2,AnimeConstants.screenHeight + PlayerConstant.BLEED_MARGIN * 2,false,0);
					}
					_loc5_ = new MovieClip();
					if(this._moveBothScenes)
					{
						prevSceneCapture.x = AnimeConstants.SCREEN_X - PlayerConstant.BLEED_MARGIN - this._pos.x;
						prevSceneCapture.y = AnimeConstants.screenY - PlayerConstant.BLEED_MARGIN - this._pos.y;
					}
					else
					{
						prevSceneCapture.x = AnimeConstants.SCREEN_X - PlayerConstant.BLEED_MARGIN;
						prevSceneCapture.y = AnimeConstants.screenY - PlayerConstant.BLEED_MARGIN;
					}
					_loc5_.addChild(prevSceneCapture);
					if(!currSMC.contains(this.getBundle()))
					{
						currSMC.addChild(this.getBundle());
					}
					UtilPlain.removeAllSon(_bundle);
					this.getBundle().addChild(_loc5_);
					this.getBundle().x = 0;
					this.getBundle().y = 0;
					this.getBundle().alpha = 1;
				}
			}
			if(_loc4_ < dur)
			{
				if(this._moveBothScenes)
				{
					_loc6_ = 1 - (_loc4_ - 1) / (dur - 1);
					_loc6_ = Equations.easeInExpo(_loc6_,0,1,1);
					currSMC.x = this._pos.x * _loc6_;
					currSMC.y = this._pos.y * _loc6_;
				}
				else
				{
					_loc6_ = (_loc4_ - 1) / (dur - 1);
					_loc6_ = Equations.easeOutCirc(_loc6_,0,1,1);
					this.getBundle().x = this._destinationPoint.x * _loc6_;
					this.getBundle().y = this._destinationPoint.y * _loc6_;
				}
				prevSceneCapture.visible = true;
			}
			else
			{
				if(this._moveBothScenes)
				{
					currSMC.x = 0;
					currSMC.y = 0;
				}
				else
				{
					this.getBundle().x = this._destinationPoint.x;
					this.getBundle().y = this._destinationPoint.y;
				}
				prevSceneCapture.visible = false;
			}
		}
	}
}
