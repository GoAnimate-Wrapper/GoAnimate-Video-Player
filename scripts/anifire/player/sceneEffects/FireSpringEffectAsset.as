package anifire.player.sceneEffects
{
	import anifire.constant.AnimeConstants;
	import anifire.effect.EffectMgr;
	import anifire.effect.FireSpring;
	import anifire.effect.FireSpringEffect;
	import anifire.player.playback.AnimeScene;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class FireSpringEffectAsset extends ProgramEffectAsset
	{
		 
		
		private var _originalPos:Point;
		
		private var _played:Boolean = false;
		
		public function FireSpringEffectAsset()
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
			var _loc5_:FireSpringEffect = EffectMgr.getEffectByXML(_loc4_) as FireSpringEffect;
			this.effectee = param3;
			this.originalPos = new Point(this.effectee.x,this.effectee.y);
			this._sttime = param1["st"];
			this._edtime = param1["et"];
		}
		
		override public function play(param1:Number) : void
		{
			var _loc4_:Number = NaN;
			var _loc5_:Number = NaN;
			var _loc6_:Number = NaN;
			var _loc7_:Point = null;
			var _loc8_:Number = NaN;
			var _loc9_:Number = NaN;
			var _loc10_:Number = NaN;
			var _loc11_:FireSpring = null;
			var _loc2_:Boolean = true;
			var _loc3_:Number = param1 - this.startFrame;
			if(!(this._sttime == 0 && this._edtime == 0 || _loc3_ >= this._sttime && _loc3_ <= this._edtime))
			{
				_loc2_ = false;
			}
			if(!this._played && _loc2_)
			{
				this._played = true;
				_loc4_ = int(this.length / AnimeConstants.FRAME_PER_SEC * 1000);
				_loc5_ = int(Math.random() * 2) + 4;
				_loc6_ = 0;
				while(_loc6_ < _loc5_)
				{
					_loc7_ = new Point((_loc6_ + 1) * (AnimeConstants.SCREEN_WIDTH / (_loc5_ + 1)) + AnimeConstants.SCREEN_X,AnimeConstants.SCREEN_HEIGHT + AnimeConstants.SCREEN_Y);
					_loc8_ = int(Math.random() * 2) + 5;
					_loc9_ = int(Math.random() * 3);
					_loc10_ = 0;
					while(_loc10_ < _loc8_)
					{
						_loc11_ = new FireSpring();
						_loc11_.init(_loc7_,_loc9_);
						_loc11_.show(Math.random() * 500 + _loc10_ * 100);
						this.effectee.addChild(_loc11_) as Sprite;
						_loc10_++;
					}
					_loc6_++;
				}
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
