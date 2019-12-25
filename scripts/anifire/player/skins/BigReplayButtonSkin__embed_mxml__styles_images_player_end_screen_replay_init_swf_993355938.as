package anifire.player.skins
{
	import flash.utils.ByteArray;
	import mx.core.MovieClipLoaderAsset;
	
	public class BigReplayButtonSkin__embed_mxml__styles_images_player_end_screen_replay_init_swf_993355938 extends MovieClipLoaderAsset
	{
		
		private static var bytes:ByteArray = null;
		 
		
		public var dataClass:Class;
		
		public function BigReplayButtonSkin__embed_mxml__styles_images_player_end_screen_replay_init_swf_993355938()
		{
			this.dataClass = BigReplayButtonSkin__embed_mxml__styles_images_player_end_screen_replay_init_swf_993355938_dataClass;
			super();
			initialWidth = 2000 / 20;
			initialHeight = 2000 / 20;
		}
		
		override public function get movieClipData() : ByteArray
		{
			if(bytes == null)
			{
				bytes = ByteArray(new this.dataClass());
			}
			return bytes;
		}
	}
}
