package anifire.player.playback
{
	import anifire.util.UtilHashArray;
	
	public class Motion extends Behaviour
	{
		
		public static const XML_TAG:String = "motion";
		 
		
		private var _isSlide:Boolean;
		
		private var _isBlink:Boolean;
		
		public function Motion()
		{
			super();
		}
		
		private function setIsSlide(param1:Boolean) : void
		{
			this._isSlide = param1;
		}
		
		public function getIsSlide() : Boolean
		{
			return this._isSlide;
		}
		
		private function setIsBlink(param1:Boolean) : void
		{
			this._isBlink = param1;
		}
		
		public function getIsBlink() : Boolean
		{
			return this._isBlink;
		}
		
		public function init(param1:XML, param2:UtilHashArray, param3:PlayerDataStock) : Boolean
		{
			var _loc4_:Boolean = param1.attribute("slide") == "true"?true:false;
			var _loc5_:Boolean = param1.attribute("blink") == "true"?true:false;
			var _loc6_:Boolean = super.initBehaviour(param1,XML_TAG,param2,param3);
			if(!_loc6_)
			{
				if(_loc4_ == true)
				{
					this.setIsSlide(true);
				}
				else if(_loc5_ == true)
				{
					this.setIsBlink(true);
				}
			}
			else
			{
				this.setIsSlide(_loc4_);
				this.setIsBlink(_loc5_);
			}
			return true;
		}
		
		public function initDependency(param1:Action, param2:Number, param3:Number, param4:Motion, param5:Number, param6:Action, param7:Number, param8:UtilHashArray) : void
		{
			if(this.getIsSlide() || this.getIsBlink())
			{
				this.pretendToBe(param1);
			}
			this.prevBehavior = param1;
			if(param1 != null && param2 > 0)
			{
				if(param1.getFile() == this.getFile())
				{
					this.setLocalStartFrame(param1.getLocalEndFrame() + 1);
					this.isFirstBehavior = false;
					this.firstBehavior = param1;
					param1.nextBehavior = this;
				}
				else
				{
					this.setLocalStartFrame(1);
					this.isFirstBehavior = true;
					this.firstBehavior = this;
				}
			}
			else if(param4 != null && param5 > 0)
			{
				if(param4.getFile() == this.getFile())
				{
					this.setLocalStartFrame(param4.getLocalEndFrame() + 1);
					this.isFirstBehavior = false;
					this.firstBehavior = param4;
					param4.nextBehavior = this;
				}
				else
				{
					this.setLocalStartFrame(1);
					this.isFirstBehavior = true;
					this.firstBehavior = this;
				}
			}
			else if(param6 != null && param7 > 0)
			{
				if(param6.getFile() == this.getFile())
				{
					this.setLocalStartFrame(param6.getLocalEndFrame() + 1);
					this.isFirstBehavior = false;
					this.firstBehavior = param6;
					param6.nextBehavior = this;
				}
				else
				{
					this.setLocalStartFrame(1);
					this.isFirstBehavior = true;
					this.firstBehavior = this;
				}
			}
			else
			{
				this.setLocalStartFrame(1);
				this.isFirstBehavior = true;
				this.firstBehavior = this;
			}
			this.setLocalEndFrame(this.getLocalStartFrame() + param3 - 1);
			this.initLoader(0);
		}
	}
}
