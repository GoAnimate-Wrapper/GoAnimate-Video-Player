package anifire.player.playback
{
	import anifire.bubble.Bubble;
	import anifire.player.interfaces.IPlayback;
	import anifire.player.interfaces.IPlayerAssetView;
	import flash.display.DisplayObject;
	
	public class AbstractAssetViewDecorator extends AbstractAssetView implements IPlayback
	{
		 
		
		private var _decorated:IPlayerAssetView;
		
		public function AbstractAssetViewDecorator(param1:IPlayerAssetView)
		{
			super();
			this._decorated = param1;
			this.addChild(param1 as DisplayObject);
		}
		
		public function playFrame(param1:uint, param2:uint) : void
		{
			if(this.decorated is IPlayback)
			{
				IPlayback(this.decorated).playFrame(param1,param2);
			}
		}
		
		protected function get decorated() : IPlayerAssetView
		{
			return this._decorated;
		}
		
		override public function set asset(param1:Asset) : void
		{
			if(this._decorated)
			{
				this._decorated.asset = param1;
			}
		}
		
		override public function get asset() : Asset
		{
			if(this._decorated)
			{
				return this._decorated.asset;
			}
			return null;
		}
		
		override public function set bundle(param1:DisplayObject) : void
		{
			if(this._decorated)
			{
				this._decorated.bundle = param1;
			}
		}
		
		override public function get bundle() : DisplayObject
		{
			if(this._decorated)
			{
				return this._decorated.bundle;
			}
			return null;
		}
		
		override public function set bubble(param1:Bubble) : void
		{
			if(this._decorated)
			{
				this._decorated.bubble = param1;
			}
		}
		
		override public function get bubble() : Bubble
		{
			if(this._decorated)
			{
				return this._decorated.bubble;
			}
			return null;
		}
		
		override public function get assetView() : DisplayObject
		{
			if(this._decorated)
			{
				return this._decorated.assetView;
			}
			return null;
		}
		
		public function invalidateWithTarget(param1:DisplayObject) : void
		{
		}
		
		public function resume() : void
		{
			if(this.decorated is IPlayback)
			{
				IPlayback(this.decorated).resume();
			}
		}
		
		public function pause() : void
		{
			if(this.decorated is IPlayback)
			{
				IPlayback(this.decorated).pause();
			}
		}
		
		public function goToAndPause(param1:Number, param2:Number, param3:int, param4:Number) : void
		{
			if(this.decorated is IPlayback)
			{
				(this.decorated as IPlayback).goToAndPause(param1,param2,param3,param4);
			}
		}
	}
}
