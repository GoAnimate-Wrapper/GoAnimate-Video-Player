package
{
	import mx.binding.IWatcherSetupUtil2;
	import mx.binding.PropertyWatcher;
	import mx.core.IFlexModuleFactory;
	
	public class _playerWatcherSetupUtil implements IWatcherSetupUtil2
	{
		 
		
		public function _playerWatcherSetupUtil()
		{
			super();
		}
		
		public static function init(param1:IFlexModuleFactory) : void
		{
			player.watcherSetupUtil = new _playerWatcherSetupUtil();
		}
		
		public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
		{
			param5[0] = new PropertyWatcher("_isEmbed",{"propertyChange":true},[param4[0],param4[1],param4[2],param4[3]],param2);
			param5[0].updateParent(param1);
		}
	}
}
