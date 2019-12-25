package anifire.player.sceneEffects
{
	import anifire.constant.AnimeConstants;
	import anifire.effect.EffectMgr;
	import anifire.effect.UpsideDownEffect;
	import anifire.player.playback.AnimeScene;
	import flash.display.DisplayObjectContainer;
	
	public class UpsideDownEffectAsset extends ProgramEffectAsset
	{
		 
		
		public function UpsideDownEffectAsset()
		{
			super();
		}
		
		public function init(param1:XML, param2:AnimeScene, param3:DisplayObjectContainer) : void
		{
			initAsset(param1.@id,param1.@index,param2);
			var _loc4_:XML = param1.child(EffectMgr.XML_NODE_TAG)[0];
			initEffectAsset(EffectMgr.getType(_loc4_));
			var _loc5_:UpsideDownEffect = EffectMgr.getEffectByXML(_loc4_) as UpsideDownEffect;
			this.effectee = param3;
			this._sttime = param1["st"];
			this._edtime = param1["et"];
		}
		
		override public function play(param1:Number) : void
		{
			var _loc2_:Boolean = true;
			var _loc3_:Number = param1 - _startFrame;
			if(!(this._sttime == 0 && this._edtime == 0 || _loc3_ >= this._sttime && _loc3_ <= this._edtime))
			{
				_loc2_ = false;
			}
			if(param1 <= _endFrame && param1 >= _startFrame && _loc2_)
			{
				this.effectee.scaleY = -1;
				this.effectee.y = 2 * AnimeConstants.SCREEN_Y + AnimeConstants.SCREEN_HEIGHT;
			}
			else
			{
				this.effectee.scaleY = 1;
				this.effectee.y = 0;
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
