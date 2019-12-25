package anifire.player.interfaces
{
	import flash.geom.Point;
	
	public interface IAssetMotion
	{
		 
		
		function getPosition(param1:Number) : Point;
		
		function getScale(param1:Number) : Point;
		
		function getRotation(param1:Number) : Number;
		
		function getHFlipped(param1:Number) : Boolean;
		
		function get pathOriented() : Boolean;
	}
}
