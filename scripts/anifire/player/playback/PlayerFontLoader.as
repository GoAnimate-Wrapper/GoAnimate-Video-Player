package anifire.player.playback
{
	import anifire.util.FontManager;
	import anifire.util.UtilErrorLogger;
	import anifire.util.UtilNetwork;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	public class PlayerFontLoader extends EventDispatcher
	{
		 
		
		private var _dataStock:PlayerDataStock;
		
		private var _loader:Loader;
		
		public function PlayerFontLoader(param1:PlayerDataStock)
		{
			super();
			this._dataStock = param1;
		}
		
		public function loadFont(param1:String) : void
		{
			var _loc4_:String = null;
			this._loader = new Loader();
			this._loader.name = param1;
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderComplete);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
			var _loc2_:* = FontManager.getFontManager().nameToFileName(param1) + ".swf";
			var _loc3_:ByteArray = this._dataStock.getPlayerData(_loc2_) as ByteArray;
			if(_loc3_)
			{
				this._loader.loadBytes(_loc3_);
			}
			else
			{
				_loc4_ = UtilNetwork.getFont(_loc2_);
				this._loader.load(new URLRequest(_loc4_));
			}
		}
		
		private function onLoaderComplete(param1:Event) : void
		{
			this.removeEventListeners();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onLoaderError(param1:IOErrorEvent) : void
		{
			this.removeEventListeners();
			UtilErrorLogger.getInstance().appendCustomError("PlayerFontLoader:loadFontError: " + param1.text);
			dispatchEvent(param1.clone());
		}
		
		private function removeEventListeners() : void
		{
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaderComplete);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
		}
	}
}
