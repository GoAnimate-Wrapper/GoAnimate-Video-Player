package anifire.player.playback
{
	import anifire.player.interfaces.IPlayback;
	import flash.display.DisplayObject;
	
	public class AssetView extends AbstractAssetView implements IPlayback
	{
		 
		
		public function AssetView()
		{
			super();
		}
		
		public function playFrame(param1:uint, param2:uint) : void
		{
		}
		
		public function invalidateWithTarget(param1:DisplayObject) : void
		{
		}
		
		public function resume() : void
		{
			if(this.asset)
			{
				this.asset.resumeBundle();
			}
		}
		
		public function pause() : void
		{
			if(this.asset)
			{
				this.asset.pauseBundle();
			}
		}
		
		public function goToAndPause(param1:Number, param2:Number, param3:int, param4:Number) : void
		{
		}
	}
}
