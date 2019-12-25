package anifire.player.sceneTransitions
{
	import anifire.constant.AnimeConstants;
	import anifire.player.playback.AnimeScene;
	import anifire.player.playback.GoTransition;
	import anifire.util.UtilPlain;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class AnimateTransition extends GoTransition
	{
		 
		
		private var TransWipeHand:Class;
		
		private var TransCleanHand:Class;
		
		private var TransCleanBrush:Class;
		
		private var TransInfoBlinds:Class;
		
		private var TransInfoIris:Class;
		
		private var TransInfoSplit:Class;
		
		private var TransClass:Class;
		
		private var effectee:DisplayObject;
		
		private var _param:Array;
		
		private var _type:String;
		
		public function AnimateTransition()
		{
			this.TransWipeHand = AnimateTransition_TransWipeHand;
			this.TransCleanHand = AnimateTransition_TransCleanHand;
			this.TransCleanBrush = AnimateTransition_TransCleanBrush;
			this.TransInfoBlinds = AnimateTransition_TransInfoBlinds;
			this.TransInfoIris = AnimateTransition_TransInfoIris;
			this.TransInfoSplit = AnimateTransition_TransInfoSplit;
			super();
		}
		
		override public function init(param1:XML, param2:AnimeScene, param3:Sprite) : Boolean
		{
			var _loc4_:Array = null;
			if(super.init(param1,param2,param3))
			{
				_loc4_ = String(param1.fx.@type).split(".");
				this._type = _loc4_[1];
				switch(this._type)
				{
					case "WipeHand":
						this.TransClass = this.TransWipeHand;
						break;
					case "CleanHand":
						this.TransClass = this.TransCleanHand;
						break;
					case "CleanBrush":
						this.TransClass = this.TransCleanBrush;
						break;
					case "InfoBlinds":
						this.TransClass = this.TransInfoBlinds;
						break;
					case "InfoIris":
						this.TransClass = this.TransInfoIris;
						break;
					case "InfoSplit":
						this.TransClass = this.TransInfoSplit;
						break;
					default:
						this.TransClass = this.TransWipeHand;
				}
				this._param = String(param1.fx.@param).split(",");
				return true;
			}
			return false;
		}
		
		override public function play(param1:Number, param2:Number, param3:Number) : void
		{
			var _loc4_:MovieClip = null;
			var _loc5_:DisplayObjectContainer = null;
			if(param3 <= param1 + dur)
			{
				if(param1 <= param3 && this.getBundle().numChildren == 0)
				{
					_loc4_ = new this.TransClass();
					if(prevScene)
					{
						prevSceneCapture.bitmapData = prevScene.endSceneCapture;
						prevSceneCapture.scaleX = prevSceneCapture.scaleY = !!prevScene.endSceneCapture?Number(AnimeConstants.SCREEN_WIDTH / prevScene.endSceneCapture.width):Number(1);
					}
					else
					{
						prevSceneCapture.bitmapData = new BitmapData(AnimeConstants.SCREEN_WIDTH,AnimeConstants.screenHeight,false,0);
					}
					prevSceneCapture.x = 0;
					prevSceneCapture.y = 0;
					if(!currSMC.contains(this.getBundle()))
					{
						currSMC.addChild(this.getBundle());
					}
					if(_loc4_)
					{
						this.getBundle().addChild(_loc4_);
						_loc5_ = UtilPlain.getInstance(this.getBundle(),"mcScreenCap");
						if(_loc5_)
						{
							_loc5_.addChild(prevSceneCapture);
						}
					}
					this.getBundle().x = AnimeConstants.SCREEN_X;
					this.getBundle().y = AnimeConstants.screenY;
					this.getBundle().alpha = 1;
				}
				else if(param3 >= param1 + dur)
				{
					if(param3 == param1 + dur)
					{
						UtilPlain.removeAllSon(_bundle);
					}
				}
			}
		}
	}
}
