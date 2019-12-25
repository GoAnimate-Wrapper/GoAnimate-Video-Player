package
{
	import anifire.player.components.PreviewPlayer;
	import mx.binding.IWatcherSetupUtil2;
	import mx.binding.PropertyWatcher;
	import mx.core.IFlexModuleFactory;
	
	public class _anifire_player_components_PreviewPlayerWatcherSetupUtil implements IWatcherSetupUtil2
	{
		 
		
		public function _anifire_player_components_PreviewPlayerWatcherSetupUtil()
		{
			super();
		}
		
		public static function init(param1:IFlexModuleFactory) : void
		{
			PreviewPlayer.watcherSetupUtil = new _anifire_player_components_PreviewPlayerWatcherSetupUtil();
		}
		
		public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
		{
			param5[0] = new PropertyWatcher("fadeIn",{"propertyChange":true},[param4[0]],param2);
			param5[1] = new PropertyWatcher("fadeOut",{"propertyChange":true},[param4[1]],param2);
			param5[0].updateParent(param1);
			param5[1].updateParent(param1);
		}
	}
}
