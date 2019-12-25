package anifire.player.managers
{
	import anifire.event.CoreEvent;
	import anifire.event.LoadMgrEvent;
	import anifire.player.playback.PlayerDataStock;
	import anifire.player.playback.PlayerFontLoader;
	import anifire.util.FontManager;
	import anifire.util.UtilLoadMgr;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class PlayerFontManager extends EventDispatcher
	{
		
		private static var __instance:PlayerFontManager;
		 
		
		private var _fonts:Object;
		
		private var _cffFonts:Object;
		
		private var _fontQueue:Array;
		
		private var _cffFontList:Vector.<String>;
		
		private var _loadingCffFontName:String;
		
		private var _fontManager:FontManager;
		
		public var dataStock:PlayerDataStock;
		
		public function PlayerFontManager()
		{
			super();
			this._fonts = {};
			this._cffFonts = {};
		}
		
		public static function get instance() : PlayerFontManager
		{
			if(!__instance)
			{
				__instance = new PlayerFontManager();
			}
			return __instance;
		}
		
		public function addFont(param1:String) : void
		{
			if(param1)
			{
				this._fonts[param1] = true;
			}
		}
		
		public function addCffFont(param1:String) : void
		{
			if(param1)
			{
				this._cffFonts[param1] = true;
			}
		}
		
		public function loadAllFonts() : void
		{
			var _loc1_:* = null;
			var _loc2_:UtilLoadMgr = null;
			var _loc3_:PlayerFontLoader = null;
			var _loc4_:int = 0;
			var _loc5_:int = 0;
			var _loc6_:Object = null;
			this._fontManager = FontManager.getFontManager();
			this._fontQueue = [];
			for(_loc1_ in this._fonts)
			{
				this._fontQueue.push(_loc1_);
			}
			if(this._fontQueue.length > 0)
			{
				_loc2_ = new UtilLoadMgr();
				_loc2_.addEventListener(LoadMgrEvent.ALL_COMPLETE,this.onFontsLoaded);
				_loc4_ = this._fontQueue.length;
				_loc5_ = 0;
				while(_loc5_ < _loc4_)
				{
					_loc6_ = FontManager.CUSTOM_FONT_ID_REGEXP.exec(this._fontQueue[_loc5_]);
					if(_loc6_)
					{
						_loc2_.addEventDispatcher(this._fontManager,CoreEvent.FONT_LOADED);
						this._fontManager.loadFont(this._fontQueue[_loc5_]);
					}
					else
					{
						_loc3_ = new PlayerFontLoader(this.dataStock);
						_loc2_.addEventDispatcher(_loc3_,Event.COMPLETE);
						_loc3_.loadFont(this._fontQueue[_loc5_]);
					}
					_loc5_++;
				}
				_loc2_.commit();
			}
			else
			{
				this.loadCffFonts();
			}
		}
		
		private function loadCffFonts() : void
		{
			var _loc1_:* = null;
			this._cffFontList = new Vector.<String>();
			for(_loc1_ in this._cffFonts)
			{
				this._cffFontList.push(_loc1_);
			}
			this._fontManager.addEventListener(CoreEvent.CFF_FONT_LIST_LOADED,this.onCffFontsLoaded);
			this._fontManager.loadCffFontList(this._cffFontList);
		}
		
		private function onFontsLoaded(param1:Event) : void
		{
			IEventDispatcher(param1.target).removeEventListener(param1.type,this.onFontsLoaded);
			this.loadCffFonts();
		}
		
		private function onCffFontsLoaded(param1:Event) : void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
