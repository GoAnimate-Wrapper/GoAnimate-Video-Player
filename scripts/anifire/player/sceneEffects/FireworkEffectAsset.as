package anifire.player.sceneEffects
{
	import anifire.effect.EffectMgr;
	import anifire.effect.Firework;
	import anifire.effect.FireworkEffect;
	import anifire.player.playback.AnimeScene;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class FireworkEffectAsset extends ProgramEffectAsset
	{
		 
		
		private var _originalPos:Point;
		
		public function FireworkEffectAsset()
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
			var _loc5_:FireworkEffect = EffectMgr.getEffectByXML(_loc4_) as FireworkEffect;
			this.effectee = param3;
			this.originalPos = new Point(this.effectee.x,this.effectee.y);
			this._sttime = param1["st"];
			this._edtime = param1["et"];
		}
		
		override public function play(param1:Number) : void
		{
			var _loc4_:Number = NaN;
			var _loc5_:Number = NaN;
			var _loc6_:Firework = null;
			var _loc2_:Boolean = true;
			var _loc3_:Number = param1 - this.startFrame;
			if(!(this._sttime == 0 && this._edtime == 0 || _loc3_ >= this._sttime && _loc3_ <= this._edtime))
			{
				_loc2_ = false;
			}
			if(param1 % 6 == 0 && _loc2_)
			{
				_loc4_ = 1;
				_loc5_ = 0;
				while(_loc5_ < _loc4_)
				{
					_loc6_ = new Firework();
					_loc6_.init();
					_loc6_.show(Math.random() * 200 + 100);
					this.effectee.addChild(_loc6_) as Sprite;
					_loc5_++;
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
