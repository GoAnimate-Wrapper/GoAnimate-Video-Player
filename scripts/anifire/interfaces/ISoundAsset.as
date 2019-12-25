package anifire.interfaces
{
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	
	public interface ISoundAsset extends IEventDispatcher
	{
		 
		
		function load() : void;
		
		function close() : void;
		
		function get sound() : Sound;
	}
}
