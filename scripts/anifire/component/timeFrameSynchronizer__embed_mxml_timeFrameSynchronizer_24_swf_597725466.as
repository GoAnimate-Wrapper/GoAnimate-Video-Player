package anifire.component
{
	import flash.utils.ByteArray;
	import mx.core.MovieClipLoaderAsset;
	
	public class timeFrameSynchronizer__embed_mxml_timeFrameSynchronizer_24_swf_597725466 extends MovieClipLoaderAsset
	{
		
		private static var bytes:ByteArray = null;
		 
		
		public var dataClass:Class;
		
		public function timeFrameSynchronizer__embed_mxml_timeFrameSynchronizer_24_swf_597725466()
		{
			this.dataClass = timeFrameSynchronizer__embed_mxml_timeFrameSynchronizer_24_swf_597725466_dataClass;
			super();
			initialWidth = 11000 / 20;
			initialHeight = 8000 / 20;
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
