package anifire.player.assetTransitions.views
{
	import anifire.constant.ServerConstants;
	import anifire.managers.AppConfigManager;
	import anifire.player.managers.WhiteboardHandManager;
	import anifire.util.UtilString;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	public class WhiteboardHandLoader extends Loader
	{
		
		public static const WHITEBOARD_CLIP_PATH_PREFIX:String = "go/swf/player/wbhand/";
		
		public static const HAND_CLIP_PREFIX:String = "hand_";
		
		public static const ERASER_CLIP_PREFIX:String = "eraser_";
		
		public static const CLIP_SUFFIX:String = ".swf";
		
		private static var __pathPattern:RegExp;
		
		private static var __baseUrl:String;
		 
		
		private var _whiteboardHandStyle:int = 0;
		
		private var _isHand:Boolean = true;
		
		private var _loaded:Boolean;
		
		private var _loading:Boolean;
		
		public function WhiteboardHandLoader(param1:int, param2:Boolean = true)
		{
			super();
			this._whiteboardHandStyle = param1;
			this._isHand = param2;
			if(!__pathPattern)
			{
				__pathPattern = new RegExp(ServerConstants.FLASHVAR_CLIENT_THEME_PLACEHOLDER,"g");
				__baseUrl = AppConfigManager.instance.getValue(ServerConstants.FLASHVAR_CLIENT_THEME_PATH);
			}
		}
		
		public function get loaded() : Boolean
		{
			return this._loaded;
		}
		
		public function loadClip() : void
		{
			if(this._loading)
			{
				return;
			}
			var _loc1_:String = !!this._isHand?HAND_CLIP_PREFIX:ERASER_CLIP_PREFIX;
			var _loc2_:String = _loc1_ + UtilString.leftPad(String(this._whiteboardHandStyle),"0",2);
			_loc2_.substr(_loc2_.length - 2);
			var _loc3_:String = WHITEBOARD_CLIP_PATH_PREFIX + _loc2_ + CLIP_SUFFIX;
			var _loc4_:String = __baseUrl.replace(__pathPattern,_loc3_);
			var _loc5_:URLRequest = new URLRequest(_loc4_);
			contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadClip_completeHander);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loadClip_errorHandler);
			contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadClip_errorHandler);
			load(_loc5_);
			this._loading = true;
		}
		
		protected function loadClip_completeHander(param1:Event) : void
		{
			contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loadClip_completeHander);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.loadClip_errorHandler);
			contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadClip_errorHandler);
			this._loaded = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function loadClip_errorHandler(param1:Event) : void
		{
			this._loaded = true;
			dispatchEvent(new Event(Event.CANCEL));
		}
		
		public function get whiteboardHandId() : String
		{
			return (!!this._isHand?WhiteboardHandManager.HAND_CLIP_PREFIX:WhiteboardHandManager.ERASER_CLIP_PREFIX) + this._whiteboardHandStyle;
		}
	}
}
