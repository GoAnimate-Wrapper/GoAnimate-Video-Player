package anifire.player.sceneEffects
{
	import anifire.constant.AnimeConstants;
	import anifire.effect.EarthquakeEffect;
	import anifire.effect.EffectMgr;
	import anifire.player.playback.AnimeScene;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	public class BumpyrideEffectAsset extends ProgramEffectAsset
	{
		 
		
		private var _originalPos:Point;
		
		private var _effectSeq:Array;
		
		public function BumpyrideEffectAsset()
		{
			super();
		}
		
		private function get originalPos() : Point
		{
			return this._originalPos;
		}
		
		private function set originalPos(param1:Point) : void
		{
			this._originalPos = param1;
		}
		
		public function init(param1:XML, param2:AnimeScene, param3:DisplayObjectContainer) : void
		{
			initAsset(param1.@id,param1.@index,param2);
			var _loc4_:XML = param1.child(EffectMgr.XML_NODE_TAG)[0];
			initEffectAsset(EffectMgr.getType(_loc4_));
			var _loc5_:EarthquakeEffect = EffectMgr.getEffectByXML(_loc4_) as EarthquakeEffect;
			this.effectee = param3;
			this.originalPos = new Point(this.effectee.x,this.effectee.y);
			this._sttime = param1["st"];
			this._edtime = param1["et"];
			var _loc6_:String = "0,2,4,3,2,1,0,0.75,1.5,2.25,3,2,1,0,-1,0.15,1.35,2.5,3.65,4.85,6,-0.65,-7.35,-14,-4,6,3.7,1.4,-0.85,-3.15,-5.45,-7.7,-10,-3.35,3.35,10,4.5,-1,0,1,2,3,4,1.5,-1,-3.5,-6,-4.75,-3.5,-2.25,-1,-3.85,-6.7,-9.55,-12.45,-15.3,-18.15,-21,-18.2,-15.4,-12.6,-9.8,-7,-8,-9,-10,-11,-12,-13,-12,-11,-10,-9,-8,-7,-8,-9,-10,-11,-12,-13,-10.45,-7.85,-5.3,-2.7,-0.15,2.45,5,2,-1,-4,-7,-10,-13,-13,-13,-13,-13,-2";
			this._effectSeq = _loc6_.split(",");
		}
		
		override public function play(param1:Number) : void
		{
			var _loc5_:Number = NaN;
			var _loc6_:Number = NaN;
			var _loc7_:Number = NaN;
			var _loc8_:Number = NaN;
			var _loc2_:Number = 20;
			var _loc3_:Boolean = true;
			var _loc4_:Number = param1 - this.startFrame;
			if(!(this._sttime == 0 && this._edtime == 0 || _loc4_ >= this._sttime && _loc4_ <= this._edtime))
			{
				_loc3_ = false;
			}
			if(param1 <= this.startFrame + this.length && _loc3_)
			{
				_loc5_ = 1.05;
				_loc6_ = (_loc5_ - 1) * AnimeConstants.SCREEN_HEIGHT / 2;
				_loc8_ = this._effectSeq[_loc4_ % this._effectSeq.length];
				if(Math.abs(_loc8_) >= _loc6_)
				{
					if(_loc8_ < 0)
					{
						_loc7_ = -_loc6_;
					}
					else
					{
						_loc7_ = _loc6_;
					}
				}
				else
				{
					_loc7_ = _loc8_;
				}
				this.effectee.y = _loc7_;
			}
			else
			{
				this.effectee.x = 0;
				this.effectee.y = 0;
				this.effectee.scaleX = 1;
				this.effectee.scaleY = 1;
			}
		}
		
		override public function goToAndPause(param1:Number, param2:Number, param3:int, param4:Number) : void
		{
			this.play(param2);
		}
		
		override public function pause() : void
		{
		}
		
		override public function resume() : void
		{
		}
		
		override public function destroy(param1:Boolean = false) : void
		{
		}
	}
}
