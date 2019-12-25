package anifire.player.interfaces
{
	import flash.display.DisplayObject;
	
	public interface IPlayback
	{
		 
		
		function playFrame(param1:uint, param2:uint) : void;
		
		function invalidateWithTarget(param1:DisplayObject) : void;
		
		function resume() : void;
		
		function pause() : void;
		
		function goToAndPause(param1:Number, param2:Number, param3:int, param4:Number) : void;
	}
}
