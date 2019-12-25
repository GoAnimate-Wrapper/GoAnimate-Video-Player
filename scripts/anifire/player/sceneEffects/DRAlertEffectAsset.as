package anifire.player.sceneEffects
{
	import anifire.effect.EffectMgr;
	import anifire.player.playback.AnimeScene;
	import com.gskinner.geom.ColorMatrix;
	import flash.display.DisplayObjectContainer;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	public class DRAlertEffectAsset extends ProgramEffectAsset
	{
		 
		
		private var _originalPos:Point;
		
		private var _active:Boolean;
		
		public function DRAlertEffectAsset()
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
			this.effectee = param3;
			this.originalPos = new Point(this.effectee.x,this.effectee.y);
			this._sttime = param1["st"];
			this._edtime = param1["et"];
		}
		
		override public function initDependency(param1:Number, param2:Number, param3:Number) : void
		{
			_startFrame = param1;
			_length = param3;
		}
		
		override public function play(param1:Number) : void
		{
			var _loc5_:ColorTransform = null;
			var _loc2_:Boolean = true;
			var _loc3_:ColorMatrix = new ColorMatrix();
			var _loc4_:Number = param1 - this.startFrame;
			if(!(this._sttime == 0 && this._edtime == 0 || _loc4_ >= this._sttime && _loc4_ <= this._edtime))
			{
				_loc2_ = false;
			}
			if(param1 <= this.startFrame + this.length && _loc2_)
			{
				if(!this._active)
				{
					_loc5_ = new ColorTransform();
					_loc5_.redMultiplier = 1;
					_loc5_.greenMultiplier = -1;
					_loc5_.blueMultiplier = -1;
					this.effectee.transform.colorTransform = _loc5_;
					_loc3_.adjustColor(-50,50,-100,0);
					this.effectee.filters = [new ColorMatrixFilter(_loc3_)];
					this._active = true;
				}
			}
			else if(this._active)
			{
				this.effectee.transform.colorTransform = new ColorTransform();
				_loc3_.adjustColor(0,0,0,0);
				this.effectee.filters = [new ColorMatrixFilter(_loc3_)];
				this._active = false;
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
