package anifire.player.managers
{
	import anifire.managers.AppConfigManager;
	import anifire.models.ApiEventModel;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	public class PlayerApiManager extends EventDispatcher
	{
		
		private static var __instance:PlayerApiManager;
		 
		
		private var _events:Vector.<ApiEventModel>;
		
		public function PlayerApiManager()
		{
			super();
			this.init();
		}
		
		public static function get instance() : PlayerApiManager
		{
			if(!__instance)
			{
				__instance = new PlayerApiManager();
			}
			return __instance;
		}
		
		private function init() : void
		{
			var _loc1_:AppConfigManager = null;
			var _loc2_:String = null;
			this._events = new Vector.<ApiEventModel>();
			if(ExternalInterface.available)
			{
				ExternalInterface.addCallback("bind",this.bind);
				ExternalInterface.addCallback("unbind",this.unbind);
				_loc1_ = AppConfigManager.instance;
				_loc2_ = _loc1_.getValue("initcb");
				if(_loc2_)
				{
					ExternalInterface.call(_loc2_);
				}
			}
		}
		
		public function bind(param1:String, param2:String) : void
		{
			this._events.push(new ApiEventModel(param1,param2));
		}
		
		public function unbind(param1:String, param2:String) : void
		{
			var _loc5_:ApiEventModel = null;
			var _loc3_:int = this._events.length;
			var _loc4_:int = _loc3_;
			while(_loc4_ >= 0)
			{
				_loc5_ = this._events[_loc4_];
				if(_loc5_.eventName == param1 && _loc5_.callback == param2)
				{
					this._events.splice(_loc4_,1);
				}
				_loc4_--;
			}
		}
		
		public function notifyEvent(param1:String, param2:Object = null) : void
		{
			var _loc5_:ApiEventModel = null;
			if(!ExternalInterface.available)
			{
				return;
			}
			if(!param2)
			{
				param2 = {};
			}
			var _loc3_:int = this._events.length;
			var _loc4_:int = 0;
			while(_loc4_ < _loc3_)
			{
				_loc5_ = this._events[_loc4_];
				if(_loc5_.eventName == param1)
				{
					ExternalInterface.call(_loc5_.callback,param1,param2);
				}
				_loc4_++;
			}
		}
	}
}
