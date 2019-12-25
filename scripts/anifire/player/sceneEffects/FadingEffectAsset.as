package anifire.player.sceneEffects
{
	import anifire.constant.AnimeConstants;
	import anifire.effect.EffectMgr;
	import anifire.player.playback.AnimeScene;
	import anifire.util.Util;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class FadingEffectAsset extends ProgramEffectAsset
	{
		 
		
		private var _effectContainer:Sprite;
		
		private var _black:Sprite;
		
		private var _isIn:Boolean = false;
		
		private var _isOut:Boolean = false;
		
		private var _alphaValues:Array;
		
		public function FadingEffectAsset()
		{
			super();
		}
		
		public function init(param1:XML, param2:AnimeScene, param3:DisplayObjectContainer) : void
		{
			initAsset(param1.@id,param1.@index,param2);
			var _loc4_:XML = param1.child(EffectMgr.XML_NODE_TAG)[0];
			initEffectAsset(EffectMgr.getType(_loc4_));
			var _loc5_:String = _loc4_.@isIn;
			if(_loc5_ == "true")
			{
				this._isIn = true;
			}
			var _loc6_:String = _loc4_.@isOut;
			if(_loc6_ == "true")
			{
				this._isOut = true;
			}
			this.effectee = param3;
			this._sttime = param1["st"];
			this._edtime = param1["et"];
			this._effectContainer = new Sprite();
			this._effectContainer.mouseEnabled = false;
			this._effectContainer.mouseChildren = false;
			this.effectee.addChild(this._effectContainer);
			this._black = new Sprite();
			this._effectContainer.addChild(this._black);
		}
		
		private function preCalculateAlphaValues() : void
		{
			var _loc1_:Number = NaN;
			this._alphaValues = new Array();
			var _loc2_:Number = 1;
			while(_loc2_ <= _length)
			{
				if(this._sttime != 0 || this._edtime != 0)
				{
					_loc1_ = Util.roundNum((_loc2_ - this._sttime) / (this._edtime - this._sttime),2);
				}
				else
				{
					_loc1_ = Util.roundNum((_loc2_ + 1) / (_length - 1),2);
				}
				if(this._isIn)
				{
					_loc1_ = 1 - _loc1_;
				}
				this._alphaValues.push(_loc1_);
				_loc2_++;
			}
		}
		
		override public function initDependency(param1:Number, param2:Number, param3:Number) : void
		{
			super.initDependency(param1,param2,param3);
			this.preCalculateAlphaValues();
		}
		
		override public function play(param1:Number) : void
		{
			var _loc2_:Boolean = true;
			var _loc3_:Number = param1 - this.startFrame + 1;
			if(!(this._sttime == 0 && this._edtime == 0 || _loc3_ >= this._sttime && _loc3_ <= this._edtime))
			{
				_loc2_ = false;
			}
			this._black.graphics.clear();
			if(_loc2_ && _loc3_ - 1 >= 0 && _loc3_ - 1 < this._alphaValues.length)
			{
				this._black.graphics.beginFill(0,this._alphaValues[_loc3_ - 1]);
				this._black.graphics.drawRect(AnimeConstants.SCREEN_X - 1,AnimeConstants.SCREEN_Y - 1,AnimeConstants.SCREEN_WIDTH + 2,AnimeConstants.SCREEN_HEIGHT + 2);
				this._black.graphics.endFill();
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
