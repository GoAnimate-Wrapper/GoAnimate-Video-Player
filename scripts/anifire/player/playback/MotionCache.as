package anifire.player.playback
{
	import anifire.player.interfaces.IAssetMotion;
	import flash.geom.Point;
	
	public class MotionCache
	{
		 
		
		private var _position:Array;
		
		private var _scale:Array;
		
		private var _rotation:Array;
		
		private var _hFlipped:Array;
		
		public function MotionCache(param1:IAssetMotion, param2:int, param3:int = 1, param4:int = -1)
		{
			this._position = new Array();
			this._scale = new Array();
			this._rotation = new Array();
			this._hFlipped = new Array();
			super();
			this.init(param1,param2,param3,param4);
		}
		
		private function init(param1:IAssetMotion, param2:int, param3:int = 1, param4:int = -1) : void
		{
			if(param3 < 1)
			{
				param3 = 1;
			}
			if(param4 < 1 || param4 <= param3)
			{
				param4 = param2;
			}
			var _loc5_:Number = 0;
			var _loc6_:int = 1;
			while(_loc6_ <= param2)
			{
				if(_loc6_ <= param3)
				{
					_loc5_ = 0;
				}
				else if(_loc6_ >= param4)
				{
					_loc5_ = 1;
				}
				else
				{
					_loc5_ = (_loc6_ - param3) / (param4 - param3);
				}
				this._position.push(param1.getPosition(_loc5_));
				this._scale.push(param1.getScale(_loc5_));
				this._rotation.push(param1.getRotation(_loc5_));
				this._hFlipped.push(param1.getHFlipped(_loc5_));
				_loc6_++;
			}
		}
		
		public function getPosition(param1:uint) : Point
		{
			return this._position[param1 - 1];
		}
		
		public function getScale(param1:uint) : Point
		{
			return this._scale[param1 - 1];
		}
		
		public function getRotation(param1:uint) : Number
		{
			return this._rotation[param1 - 1];
		}
		
		public function getHFlipped(param1:uint) : Boolean
		{
			return this._hFlipped[param1 - 1];
		}
	}
}
