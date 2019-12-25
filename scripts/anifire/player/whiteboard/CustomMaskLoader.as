package anifire.player.whiteboard
{
	import anifire.constant.ServerConstants;
	import anifire.managers.AppConfigManager;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class CustomMaskLoader extends URLLoader
	{
		 
		
		private var _relativePath:String;
		
		public function CustomMaskLoader(param1:URLRequest = null)
		{
			super(param1);
		}
		
		public function loadCustomMask(param1:String) : void
		{
			if(this._relativePath)
			{
				return;
			}
			this._relativePath = param1;
			var _loc2_:RegExp = new RegExp(ServerConstants.FLASHVAR_STORE_PLACEHOLDER,"g");
			var _loc3_:String = AppConfigManager.instance.getValue(ServerConstants.FLASHVAR_STORE_PATH);
			_loc3_ = _loc3_.replace(_loc2_,param1);
			var _loc4_:URLRequest = new URLRequest(_loc3_);
			var _loc5_:URLLoader = new URLLoader();
			this.dataFormat = URLLoaderDataFormat.BINARY;
			this.load(_loc4_);
		}
		
		public function get id() : String
		{
			return this._relativePath;
		}
	}
}
