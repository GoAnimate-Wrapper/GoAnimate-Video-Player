package anifire.player.events
{
	import flash.events.Event;
	
	public class SceneBufferEvent extends Event
	{
		
		public static const BUFFER_READY:String = "BUFFER_READY";
		
		public static const SCENE_BUFFERED:String = "SCENE_BUFFERED";
		 
		
		public var sceneIndex:Number = -1;
		
		public function SceneBufferEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
		{
			super(param1,param2,param3);
		}
	}
}
