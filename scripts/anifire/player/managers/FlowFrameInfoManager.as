package anifire.player.managers
{
	import anifire.util.UtilHashArray;
	
	public class FlowFrameInfoManager
	{
		
		private static var __instance:FlowFrameInfoManager;
		 
		
		private var _flowFrameLookup:Object;
		
		private var _parsedTheme:Object;
		
		public function FlowFrameInfoManager()
		{
			super();
			this.init();
		}
		
		public static function get instance() : FlowFrameInfoManager
		{
			if(!__instance)
			{
				__instance = new FlowFrameInfoManager();
			}
			return __instance;
		}
		
		private function init() : void
		{
			this._flowFrameLookup = {};
			this._parsedTheme = {};
		}
		
		public function getFlowFrameXml(param1:String, param2:UtilHashArray) : XML
		{
			var _loc3_:int = param1.indexOf(".");
			var _loc4_:String = param1.substring(0,_loc3_);
			if(!this._parsedTheme[_loc4_])
			{
				this.parseThemeXml(_loc4_,param2.getValueByKey(_loc4_));
			}
			return this._flowFrameLookup[param1];
		}
		
		private function parseThemeXml(param1:String, param2:XML) : void
		{
			var _loc3_:XMLList = null;
			var _loc4_:int = 0;
			var _loc5_:int = 0;
			var _loc6_:XML = null;
			if(param2)
			{
				_loc3_ = param2.child("flow");
				_loc4_ = _loc3_.length();
				_loc5_ = 0;
				while(_loc5_ < _loc4_)
				{
					_loc6_ = _loc3_[_loc5_];
					this._flowFrameLookup[param1 + "." + _loc6_.@id] = _loc6_;
					_loc5_++;
				}
			}
		}
	}
}
