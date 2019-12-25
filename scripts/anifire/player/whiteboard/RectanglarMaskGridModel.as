package anifire.player.whiteboard
{
	import flash.geom.Rectangle;
	
	public class RectanglarMaskGridModel extends PlayerMaskGridModel
	{
		 
		
		private var _rect:Rectangle;
		
		public function RectanglarMaskGridModel()
		{
			super();
		}
		
		public function get rect() : Rectangle
		{
			return this._rect;
		}
		
		public function set rect(param1:Rectangle) : void
		{
			this._rect = param1;
		}
	}
}
