package anifire.player.playback
{
	import Singularity.Geom.BezierSpline;
	import anifire.assets.motion.BezierSplineController;
	import anifire.player.interfaces.IAssetMotion;
	import anifire.util.UtilMath;
	import flash.geom.Point;
	
	public class SlideMotion implements IAssetMotion
	{
		
		public static const XML_TAG_NAME:String = "assetMotion";
		 
		
		private var _xs:Array;
		
		private var _ys:Array;
		
		private var _scaleXs:Array;
		
		private var _scaleYs:Array;
		
		private var _rotations:Array;
		
		private var _pathOriented:Boolean = false;
		
		private var _spline:BezierSpline;
		
		private var _splineController:BezierSplineController;
		
		private var _version:String = "1";
		
		public function SlideMotion()
		{
			super();
		}
		
		public function init(param1:Array, param2:Array, param3:Array, param4:Array, param5:Array) : void
		{
			var _loc6_:uint = 0;
			this._xs = param1.concat();
			this._ys = param2.concat();
			this._scaleXs = param3.concat();
			this._scaleYs = param4.concat();
			this._rotations = param5.concat();
			if(this._xs.length >= 3)
			{
				this._spline = new BezierSpline();
				_loc6_ = 0;
				while(_loc6_ < this._xs.length)
				{
					this._spline.addControlPoint(this._xs[_loc6_],this._ys[_loc6_]);
					_loc6_++;
				}
				this._splineController = new BezierSplineController(this._spline);
			}
		}
		
		public function convertFromXml(param1:XML) : Boolean
		{
			if(param1)
			{
				if(param1.hasOwnProperty("@pathOriented"))
				{
					if(String(param1.@pathOriented) == "1")
					{
						this._pathOriented = true;
					}
				}
				if(param1.hasOwnProperty("@ver"))
				{
					this._version = String(param1.@ver);
				}
			}
			return true;
		}
		
		public function getPosition(param1:Number) : Point
		{
			var _loc2_:Point = new Point(Number(this._xs[0]),Number(this._ys[0]));
			if(this._xs.length >= 3)
			{
				_loc2_ = this._splineController.getPosition(param1,this._version == "2");
			}
			else if(this._xs.length == 2)
			{
				_loc2_.x = UtilMath.linearInterpolation(Number(this._xs[0]),Number(this._xs[1]),param1);
				_loc2_.y = UtilMath.linearInterpolation(Number(this._ys[0]),Number(this._ys[1]),param1);
			}
			return _loc2_;
		}
		
		public function getScale(param1:Number) : Point
		{
			var _loc2_:Point = new Point(Number(this._scaleXs[0]),Number(this._scaleYs[0]));
			_loc2_.x = UtilMath.linearInterpolation(Number(this._scaleXs[0]),Number(this._scaleXs[1]),param1);
			_loc2_.y = UtilMath.linearInterpolation(Number(this._scaleYs[0]),Number(this._scaleYs[1]),param1);
			return _loc2_;
		}
		
		public function getRotation(param1:Number) : Number
		{
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			var _loc5_:Point = null;
			var _loc6_:Point = null;
			var _loc7_:Number = NaN;
			var _loc2_:Number = Number(this._rotations[0]);
			if(this._pathOriented)
			{
				if(this._xs.length >= 3)
				{
					_loc3_ = 100;
					_loc4_ = 0;
					_loc5_ = this._splineController.getPosition(0,this._version == "2");
					_loc6_ = this._splineController.getPosition(1 / _loc3_,this._version == "2");
					if(Number(this._xs[1]) > Number(this._xs[0]))
					{
						_loc4_ = Math.atan2(_loc6_.y - _loc5_.y,_loc6_.x - _loc5_.x) * 180 / Math.PI;
					}
					else
					{
						_loc4_ = Math.atan2(-_loc6_.y + _loc5_.y,-_loc6_.x + _loc5_.x) * 180 / Math.PI;
					}
					_loc7_ = 0;
					_loc5_ = this._splineController.getPosition(Math.max(0,param1 - 1 / _loc3_),this._version == "2");
					_loc6_ = this._splineController.getPosition(Math.min(1,param1 + 1 / _loc3_),this._version == "2");
					if(Number(this._xs[1]) > Number(this._xs[0]))
					{
						_loc7_ = Math.atan2(_loc6_.y - _loc5_.y,_loc6_.x - _loc5_.x) * 180 / Math.PI;
					}
					else
					{
						_loc7_ = Math.atan2(-_loc6_.y + _loc5_.y,-_loc6_.x + _loc5_.x) * 180 / Math.PI;
					}
					_loc2_ = _loc2_ + (_loc7_ - _loc4_);
				}
			}
			else
			{
				_loc2_ = UtilMath.linearInterpolation(Number(this._rotations[0]),Number(this._rotations[1]),param1);
			}
			return _loc2_;
		}
		
		public function get pathOriented() : Boolean
		{
			return this._pathOriented;
		}
		
		public function getHFlipped(param1:Number) : Boolean
		{
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			if(this._xs.length >= 3)
			{
				_loc2_ = 100;
				_loc3_ = this._splineController.getPosition(1 / _loc2_,this._version == "2").x - this._splineController.getPosition(0,this._version == "2").x;
				_loc4_ = this._splineController.getPosition(Math.min(1,param1 + 1 / _loc2_),this._version == "2").x - this._splineController.getPosition(Math.max(0,param1 - 1 / _loc2_),this._version == "2").x;
				return _loc3_ * _loc4_ < 0;
			}
			return false;
		}
	}
}
